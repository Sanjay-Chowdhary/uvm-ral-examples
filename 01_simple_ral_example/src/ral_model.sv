// ====================================
// UVM RAL Register Model
// ====================================

package ral_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // ============ CONTROL REGISTER ============
    class control_reg extends uvm_reg;
        rand uvm_reg_field enable_field;

        `uvm_object_utils(control_reg)

        function new(string name="control_reg");
            super.new(name, 8, UVM_NO_COVERAGE);
        endfunction

        virtual function void build();
            enable_field = uvm_reg_field::type_id::create("enable_field",, get_full_name());
            enable_field.configure(this, 1, 0, "RW", 0, 8'h0, 1, 0);
        endfunction

        virtual function string convert2string();
            return $sformatf("CONTROL_REG: enable=%b", enable_field.get());
        endfunction
    endclass

    // ============ STATUS REGISTER ============
    class status_reg extends uvm_reg;
        rand uvm_reg_field status_field;

        `uvm_object_utils(status_reg)

        function new(string name="status_reg");
            super.new(name, 8, UVM_NO_COVERAGE);
        endfunction

        virtual function void build();
            status_field = uvm_reg_field::type_id::create("status_field",, get_full_name());
            status_field.configure(this, 1, 0, "RO", 0, 8'h0, 1, 0);
        endfunction

        virtual function string convert2string();
            return $sformatf("STATUS_REG: status=%b", status_field.get());
        endfunction
    endclass

    // ============ DATA REGISTER ============
    class data_reg extends uvm_reg;
        rand uvm_reg_field data_field;

        `uvm_object_utils(data_reg)

        function new(string name="data_reg");
            super.new(name, 8, UVM_NO_COVERAGE);
        endfunction

        virtual function void build();
            data_field = uvm_reg_field::type_id::create("data_field",, get_full_name());
            data_field.configure(this, 8, 0, "RW", 0, 8'h0, 1, 0);
        endfunction

        virtual function string convert2string();
            return $sformatf("DATA_REG: data=0x%02h", data_field.get());
        endfunction
    endclass

    // ============ REGISTER BLOCK ============
    class simple_reg_block extends uvm_reg_block;
        control_reg ctrl_reg;
        status_reg  stat_reg;
        data_reg    data_reg_inst;

        `uvm_object_utils(simple_reg_block)

        function new(string name="simple_reg_block");
            super.new(name, UVM_NO_COVERAGE);
        endfunction

        virtual function void build();
            // Create default address map
            default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);

            // CONTROL Register at address 0x0
            ctrl_reg = control_reg::type_id::create("ctrl_reg");
            ctrl_reg.build();
            ctrl_reg.configure(this, null, "");
            default_map.add_reg(ctrl_reg, 8'h0, "RW");

            // STATUS Register at address 0x1
            stat_reg = status_reg::type_id::create("stat_reg");
            stat_reg.build();
            stat_reg.configure(this, null, "");
            default_map.add_reg(stat_reg, 8'h1, "RO");

            // DATA Register at address 0x2
            data_reg_inst = data_reg::type_id::create("data_reg_inst");
            data_reg_inst.build();
            data_reg_inst.configure(this, null, "");
            default_map.add_reg(data_reg_inst, 8'h2, "RW");

            lock_model();
        endfunction
    endclass

endpackage

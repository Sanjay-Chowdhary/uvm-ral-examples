// ====================================
// UVM RAL Register Model
// ====================================

package ral_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // ============ CONTROL REGISTER ============
    class control_reg extends uvm_reg;
        rand uvm_reg_field enable;
        rand uvm_reg_field flags;

        `uvm_object_utils(control_reg)

        function new(string name="control_reg");
            super.new(name, 32, UVM_NO_COVERAGE);
        endfunction

        virtual function void build();
            enable = uvm_reg_field::type_id::create("enable",,get_full_name());
            enable.configure(this, 1, 0, "RW", 0, 1'b0, 1, 0);

            flags = uvm_reg_field::type_id::create("flags",,get_full_name());
            flags.configure(this, 7, 1, "RW", 0, 7'b0, 1, 0);
        endfunction
    endclass

    // ============ STATUS REGISTER ============
    class status_reg extends uvm_reg;
        rand uvm_reg_field status_enable;
        rand uvm_reg_field status_flags;

        `uvm_object_utils(status_reg)

        function new(string name="status_reg");
            super.new(name, 32, UVM_NO_COVERAGE);
        endfunction

        virtual function void build();
            status_enable = uvm_reg_field::type_id::create("status_enable",,get_full_name());
            status_enable.configure(this, 1, 0, "RO", 0, 1'b0, 1, 0);

            status_flags = uvm_reg_field::type_id::create("status_flags",,get_full_name());
            status_flags.configure(this, 31, 1, "RO", 0, 31'b0, 1, 0);
        endfunction
    endclass

    // ============ DATA REGISTER ============
    class data_reg extends uvm_reg;
        rand uvm_reg_field data;

        `uvm_object_utils(data_reg)

        function new(string name="data_reg");
            super.new(name, 32, UVM_NO_COVERAGE);
        endfunction

        virtual function void build();
            data = uvm_reg_field::type_id::create("data",,get_full_name());
            data.configure(this, 32, 0, "RW", 0, 32'b0, 1, 0);
        endfunction
    endclass

    // ============ CONFIG REGISTER ============
    class config_reg extends uvm_reg;
        rand uvm_reg_field config_data;

        `uvm_object_utils(config_reg)

        function new(string name="config_reg");
            super.new(name, 32, UVM_NO_COVERAGE);
        endfunction

        virtual function void build();
            config_data = uvm_reg_field::type_id::create("config_data",,get_full_name());
            config_data.configure(this, 32, 0, "RW", 0, 32'hDEAD_BEEF, 1, 0);
        endfunction
    endclass

    // ============ REGISTER BLOCK ============
    class reg_block extends uvm_reg_block;
        control_reg ctrl_reg;
        status_reg  stat_reg;
        data_reg    data_reg_inst;
        config_reg  config_reg_inst;

        `uvm_object_utils(reg_block)

        function new(string name="reg_block");
            super.new(name, UVM_NO_COVERAGE);
        endfunction

        virtual function void build();
            default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);

            ctrl_reg = control_reg::type_id::create("ctrl_reg");
            ctrl_reg.build();
            ctrl_reg.configure(this, null, "");
            default_map.add_reg(ctrl_reg, 32'h0, "RW");

            stat_reg = status_reg::type_id::create("stat_reg");
            stat_reg.build();
            stat_reg.configure(this, null, "");
            default_map.add_reg(stat_reg, 32'h4, "RO");

            data_reg_inst = data_reg::type_id::create("data_reg_inst");
            data_reg_inst.build();
            data_reg_inst.configure(this, null, "");
            default_map.add_reg(data_reg_inst, 32'h8, "RW");

            config_reg_inst = config_reg::type_id::create("config_reg_inst");
            config_reg_inst.build();
            config_reg_inst.configure(this, null, "");
            default_map.add_reg(config_reg_inst, 32'hC, "RW");

            lock_model();
        endfunction
    endclass

endpackage

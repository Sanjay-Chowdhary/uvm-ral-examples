// ====================================
// Base Test Class
// ====================================

package test_pkg;
    import uvm_pkg::*;
    import ral_pkg::*;
    `include "uvm_macros.svh"

    class base_test extends uvm_test;
        `uvm_component_utils(base_test)

        uvm_env env;
        reg_block regmodel;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            
            // Create environment
            env = uvm_env::type_id::create("env", this);
            
            // Create register model
            regmodel = reg_block::type_id::create("regmodel", this);
            regmodel.build();
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
        endfunction

        virtual task run_phase(uvm_phase phase);
            phase.raise_objection(this);
            #100ns;
            phase.drop_objection(this);
        endtask

        // Helper methods
        protected task write_reg(uvm_reg reg, uvm_reg_data_t value);
            uvm_status_e status;
            reg.write(status, value);
            `uvm_info("BASE_TEST", $sformatf("Write: %s = 0x%08h", reg.get_name(), value), UVM_LOW)
        endtask

        protected task read_reg(uvm_reg reg, output uvm_reg_data_t value);
            uvm_status_e status;
            reg.read(status, value);
            `uvm_info("BASE_TEST", $sformatf("Read: %s = 0x%08h", reg.get_name(), value), UVM_LOW)
        endtask

        protected function void check_value(string name, uvm_reg_data_t expected, uvm_reg_data_t actual);
            if (expected == actual) begin
                `uvm_info("BASE_TEST", $sformatf("✓ CHECK PASS: %s = 0x%08h", name, actual), UVM_LOW)
            end else begin
                `uvm_error("BASE_TEST", $sformatf("✗ CHECK FAIL: %s Expected 0x%08h, got 0x%08h", name, expected, actual))
            end
        endfunction
    endclass

endpackage

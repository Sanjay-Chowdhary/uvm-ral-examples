// ====================================
// Simple Test Cases
// ====================================

package test_pkg;
    import uvm_pkg::*;
    import ral_pkg::*;
    import apb_agent_pkg::*;
    import apb_adapter_pkg::*;
    import test_env_pkg::*;
    `include "uvm_macros.svh"

    // ============ TEST 1: FRONTDOOR WRITE & READ ============
    class test_frontdoor_write_read extends uvm_test;
        `uvm_component_utils(test_frontdoor_write_read)

        simple_test_env env;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = simple_test_env::type_id::create("env", this);
        endfunction

        virtual task run_phase(uvm_phase phase);
            uvm_status_e status;
            uvm_reg_data_t wdata, rdata;

            phase.raise_objection(this);

            #100ns;

            `uvm_info("TEST", "╔════════════════════════════════════════╗", UVM_LOW)
            `uvm_info("TEST", "║ TEST 1: Frontdoor Write & Read         ║", UVM_LOW)
            `uvm_info("TEST", "╚════════════════════════════════════════╝", UVM_LOW)

            #50ns;

            // Write DATA register via frontdoor
            wdata = 8'hAB;
            `uvm_info("TEST", $sformatf("Writing DATA register = 0x%02h", wdata), UVM_LOW)
            env.regmodel.data_reg_inst.write(status, wdata);
            #50ns;

            // Read DATA register via frontdoor
            env.regmodel.data_reg_inst.read(status, rdata);
            #50ns;

            // Check if values match
            if (rdata == wdata) begin
                `uvm_info("TEST", $sformatf("✓ PASS: Write=0x%02h, Read=0x%02h (Match!)", wdata, rdata), UVM_LOW)
            end
            else begin
                `uvm_error("TEST", $sformatf("✗ FAIL: Write=0x%02h, Read=0x%02h (Mismatch!)", wdata, rdata))
            end

            #50ns;
            phase.drop_objection(this);
        endtask
    endclass

    // ============ TEST 2: BACKDOOR ACCESS ============
    class test_backdoor_access extends uvm_test;
        `uvm_component_utils(test_backdoor_access)

        simple_test_env env;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = simple_test_env::type_id::create("env", this);
        endfunction

        virtual task run_phase(uvm_phase phase);
            uvm_status_e status;
            uvm_reg_data_t wdata, rdata;

            phase.raise_objection(this);

            #100ns;

            `uvm_info("TEST", "╔════════════════════════════════════════╗", UVM_LOW)
            `uvm_info("TEST", "║ TEST 2: Backdoor Access               ║", UVM_LOW)
            `uvm_info("TEST", "╚════════════════════════════════════════╝", UVM_LOW)

            #50ns;

            // Backdoor write to DATA register
            wdata = 8'hCD;
            `uvm_info("TEST", $sformatf("Backdoor write DATA register = 0x%02h", wdata), UVM_LOW)
            uvm_hdl_deposit("tb_top.dut_inst.data_reg", wdata);
            
            // Update RAL mirror after backdoor write
            env.regmodel.data_reg_inst.predict(wdata, .path(UVM_BACKDOOR));
            #50ns;

            // Backdoor read from DATA register
            `uvm_info("TEST", "Backdoor read DATA register", UVM_LOW)
            if (uvm_hdl_read("tb_top.dut_inst.data_reg", rdata)) begin
                `uvm_info("TEST", $sformatf("Backdoor read = 0x%02h", rdata), UVM_LOW)
                
                if (rdata == wdata) begin
                    `uvm_info("TEST", $sformatf("✓ PASS: Backdoor Write=0x%02h, Read=0x%02h (Match!)", wdata, rdata), UVM_LOW)
                end
                else begin
                    `uvm_error("TEST", $sformatf("✗ FAIL: Backdoor Write=0x%02h, Read=0x%02h (Mismatch!)", wdata, rdata))
                end
            end
            else begin
                `uvm_error("TEST", "Failed to read from backdoor")
            end

            #50ns;
            phase.drop_objection(this);
        endtask
    endclass

    // ============ TEST 3: FRONTDOOR vs BACKDOOR ============
    class test_compare_frontdoor_backdoor extends uvm_test;
        `uvm_component_utils(test_compare_frontdoor_backdoor)

        simple_test_env env;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = simple_test_env::type_id::create("env", this);
        endfunction

        virtual task run_phase(uvm_phase phase);
            uvm_status_e status;
            uvm_reg_data_t wdata_fd, rdata_fd, rdata_bd;

            phase.raise_objection(this);

            #100ns;

            `uvm_info("TEST", "╔════════════════════════════════════════════════════╗", UVM_LOW)
            `uvm_info("TEST", "║ TEST 3: Frontdoor vs Backdoor Access              ║", UVM_LOW)
            `uvm_info("TEST", "╚════════════════════════════════════════════════════╝", UVM_LOW)

            #50ns;

            // Step 1: Write via frontdoor
            wdata_fd = 8'h55;
            `uvm_info("TEST", $sformatf("Step 1: Frontdoor write DATA = 0x%02h", wdata_fd), UVM_LOW)
            env.regmodel.data_reg_inst.write(status, wdata_fd);
            #50ns;

            // Step 2: Read via frontdoor
            env.regmodel.data_reg_inst.read(status, rdata_fd);
            `uvm_info("TEST", $sformatf("Step 2: Frontdoor read DATA = 0x%02h", rdata_fd), UVM_LOW)
            #50ns;

            // Step 3: Read via backdoor
            `uvm_info("TEST", "Step 3: Backdoor read DATA", UVM_LOW)
            uvm_hdl_read("tb_top.dut_inst.data_reg", rdata_bd);
            `uvm_info("TEST", $sformatf("Backdoor read DATA = 0x%02h", rdata_bd), UVM_LOW)
            #50ns;

            // Step 4: Compare
            `uvm_info("TEST", "Step 4: Comparison", UVM_LOW)
            if (rdata_fd == rdata_bd) begin
                `uvm_info("TEST", $sformatf("✓ PASS: Frontdoor=0x%02h, Backdoor=0x%02h (Match!)", rdata_fd, rdata_bd), UVM_LOW)
            end
            else begin
                `uvm_error("TEST", $sformatf("✗ FAIL: Frontdoor=0x%02h, Backdoor=0x%02h (Mismatch!)", rdata_fd, rdata_bd))
            end

            #50ns;

            // Step 5: CONTROL register (check STATUS is updated)
            `uvm_info("TEST", "Step 5: Control register test", UVM_LOW)
            env.regmodel.ctrl_reg.write(status, 8'h01);  // Enable = 1
            #50ns;
            
            env.regmodel.stat_reg.read(status, rdata_fd);
            `uvm_info("TEST", $sformatf("STATUS register = 0x%02h (should have bit 0 = 1)", rdata_fd), UVM_LOW)
            
            if (rdata_fd[0] == 1'b1) begin
                `uvm_info("TEST", "✓ PASS: STATUS bit 0 = 1 (Control.enable reflected)", UVM_LOW)
            end
            else begin
                `uvm_error("TEST", "✗ FAIL: STATUS bit 0 should be 1")
            end

            #50ns;
            phase.drop_objection(this);
        endtask
    endclass

endpackage

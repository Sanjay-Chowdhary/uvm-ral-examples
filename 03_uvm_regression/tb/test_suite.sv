// ====================================
// Regression Test Suite
// ====================================

package test_suite_pkg;
    import uvm_pkg::*;
    import ral_pkg::*;
    import test_pkg::*;
    `include "uvm_macros.svh"

    // ====== TEST 1: RAL WRITE READ ======
    class test_ral_write_read extends base_test;
        `uvm_component_utils(test_ral_write_read)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            uvm_reg_data_t rdata;
            phase.raise_objection(this);

            `uvm_info("TEST", "┌─────────────────────────────────┐", UVM_LOW)
            `uvm_info("TEST", "│  TEST 1: RAL Write/Read         │", UVM_LOW)
            `uvm_info("TEST", "└─────────────────────────────────┘", UVM_LOW)

            #100ns;

            // Test 1: CONTROL write/read
            write_reg(regmodel.ctrl_reg, 32'h0000_0055);
            #50ns;
            read_reg(regmodel.ctrl_reg, rdata);
            #50ns;
            check_value("CONTROL_REG", 32'h0000_0055, rdata);

            #50ns;

            // Test 2: DATA write/read
            write_reg(regmodel.data_reg_inst, 32'hCAFE_BABE);
            #50ns;
            read_reg(regmodel.data_reg_inst, rdata);
            #50ns;
            check_value("DATA_REG", 32'hCAFE_BABE, rdata);

            #50ns;

            // Test 3: STATUS read (should reflect CONTROL)
            read_reg(regmodel.stat_reg, rdata);
            #50ns;
            `uvm_info("TEST", $sformatf("STATUS register: 0x%08h (reflects CONTROL)", rdata), UVM_LOW)

            #50ns;
            phase.drop_objection(this);
        endtask
    endclass

    // ====== TEST 2: RAL BACKDOOR ======
    class test_ral_backdoor extends base_test;
        `uvm_component_utils(test_ral_backdoor)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            uvm_reg_data_t rdata;
            phase.raise_objection(this);

            `uvm_info("TEST", "┌─────────────────────────────────┐", UVM_LOW)
            `uvm_info("TEST", "│  TEST 2: Backdoor Access       │", UVM_LOW)
            `uvm_info("TEST", "└─────────────────────────────────┘", UVM_LOW)

            #100ns;

            // Backdoor write
            `uvm_info("TEST", "Backdoor writing DATA_REG = 0xDEAD_BEEF", UVM_LOW)
            uvm_hdl_deposit("tb_top.dut_inst.data_reg", 32'hDEAD_BEEF);
            regmodel.data_reg_inst.predict(32'hDEAD_BEEF, .path(UVM_BACKDOOR));
            #50ns;

            // Backdoor read
            `uvm_info("TEST", "Backdoor reading DATA_REG", UVM_LOW)
            if (uvm_hdl_read("tb_top.dut_inst.data_reg", rdata)) begin
                check_value("DATA_REG_BACKDOOR", 32'hDEAD_BEEF, rdata);
            end
            #50ns;

            // Mirror check
            read_reg(regmodel.data_reg_inst, rdata);
            #50ns;
            check_value("DATA_REG_MIRROR", 32'hDEAD_BEEF, rdata);

            #50ns;
            phase.drop_objection(this);
        endtask
    endclass

    // ====== TEST 3: COVERAGE ======
    class test_ral_coverage extends base_test;
        `uvm_component_utils(test_ral_coverage)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            phase.raise_objection(this);

            `uvm_info("TEST", "┌─────────────────────────────────┐", UVM_LOW)
            `uvm_info("TEST", "│  TEST 3: Coverage Collection   │", UVM_LOW)
            `uvm_info("TEST", "└─────────────────────────────────┘", UVM_LOW)

            #100ns;

            // Write to all registers
            for (int i = 0; i < 10; i++) begin
                write_reg(regmodel.ctrl_reg, $urandom());
                #10ns;
                write_reg(regmodel.data_reg_inst, $urandom());
                #10ns;
                write_reg(regmodel.config_reg_inst, $urandom());
                #10ns;
            end

            `uvm_info("TEST", "Coverage points exercised: 30 stimulus points", UVM_LOW)

            #50ns;
            phase.drop_objection(this);
        endtask
    endclass

    // ====== TEST 4: STRESS ======
    class test_ral_stress extends base_test;
        `uvm_component_utils(test_ral_stress)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            uvm_reg_data_t wdata, rdata;
            int errors = 0;
            phase.raise_objection(this);

            `uvm_info("TEST", "┌─────────────────────────────────┐", UVM_LOW)
            `uvm_info("TEST", "│  TEST 4: Stress Testing        │", UVM_LOW)
            `uvm_info("TEST", "└─────────────────────────────────┘", UVM_LOW)

            #100ns;

            // Random operations
            for (int i = 0; i < 100; i++) begin
                wdata = $urandom();
                write_reg(regmodel.ctrl_reg, wdata);
                #5ns;
                read_reg(regmodel.ctrl_reg, rdata);
                #5ns;

                if (rdata != wdata) begin
                    errors++;
                    `uvm_error("TEST", $sformatf("Iteration %d: Expected 0x%08h, got 0x%08h", i, wdata, rdata))
                end
            end

            `uvm_info("TEST", $sformatf("Stress test completed with %d errors", errors), UVM_LOW)

            #50ns;
            phase.drop_objection(this);
        endtask
    endclass

    // ====== TEST 5: ADVANCED ======
    class test_ral_advanced extends base_test;
        `uvm_component_utils(test_ral_advanced)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            uvm_reg_data_t rdata;
            phase.raise_objection(this);

            `uvm_info("TEST", "┌─────────────────────────────────┐", UVM_LOW)
            `uvm_info("TEST", "│  TEST 5: Advanced Operations   │", UVM_LOW)
            `uvm_info("TEST", "└─────────────────────────────────┘", UVM_LOW)

            #100ns;

            // Test: CONTROL affects STATUS
            write_reg(regmodel.ctrl_reg, 32'h0000_00FF);
            #50ns;
            read_reg(regmodel.stat_reg, rdata);
            #50ns;
            
            if ((rdata & 32'h0000_00FF) == 32'h0000_00FF) begin
                `uvm_info("TEST", "✓ STATUS correctly reflects CONTROL register", UVM_LOW)
            end else begin
                `uvm_error("TEST", $sformatf("STATUS not reflecting CONTROL: got 0x%08h", rdata))
            end

            #50ns;

            // Test: Field isolation
            write_reg(regmodel.config_reg_inst, 32'h1234_5678);
            #50ns;
            read_reg(regmodel.data_reg_inst, rdata);
            #50ns;
            
            if (rdata != 32'hCAFE_BABE) begin
                `uvm_error("TEST", "Writing CONFIG affected DATA register")
            end else begin
                `uvm_info("TEST", "✓ Register fields are properly isolated", UVM_LOW)
            end

            #50ns;
            phase.drop_objection(this);
        endtask
    endclass

endpackage

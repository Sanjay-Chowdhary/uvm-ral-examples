// ====================================
// Top-Level Testbench
// ====================================

module tb_top;
    import uvm_pkg::*;
    import ral_pkg::*;
    import apb_agent_pkg::*;
    import apb_adapter_pkg::*;
    import test_env_pkg::*;
    import test_pkg::*;
    `include "uvm_macros.svh"

    logic clk = 0;
    logic rst_n = 0;

    // APB Interface instance
    apb_if apb_interface(clk);

    // ============ DUT INSTANTIATION ============
    simple_dut dut_inst (
        .clk        (clk),
        .rst_n      (rst_n),
        .apb_psel   (apb_interface.psel),
        .apb_penable(apb_interface.penable),
        .apb_paddr  (apb_interface.paddr),
        .apb_pwrite (apb_interface.pwrite),
        .apb_pwdata (apb_interface.pwdata),
        .apb_prdata (apb_interface.prdata),
        .apb_pready (apb_interface.pready)
    );

    // ============ CLOCK GENERATION ============
    initial begin
        clk = 0;
        forever #5ns clk = ~clk;
    end

    // ============ RESET GENERATION ============
    initial begin
        rst_n = 0;
        repeat (5) @(posedge clk);
        rst_n = 1;
        `uvm_info("TB", "Reset released", UVM_LOW)
    end

    // ============ UVM CONFIGURATION ============
    initial begin
        // Pass APB interface to UVM config database
        uvm_config_db #(virtual apb_if)::set(null, "*", "apb_vif", apb_interface);
        
        // Run test
        run_test();
    end

    // ============ WAVEFORM DUMP ============
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_top);
    end

    // ============ TIMEOUT ============
    initial begin
        #1us;
        `uvm_error("TB", "Test timeout!")
        $finish;
    end

endmodule

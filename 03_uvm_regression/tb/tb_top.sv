// ====================================
// Top-Level Testbench
// ====================================

module tb_top;
    import uvm_pkg::*;
    import ral_pkg::*;
    import test_pkg::*;
    import test_suite_pkg::*;
    `include "uvm_macros.svh"

    logic clk = 0;
    logic rst_n = 0;

    apb_if apb_interface(clk);

    // DUT Instance
    register_block dut_inst (
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

    // Clock generation
    initial begin
        clk = 0;
        forever #5ns clk = ~clk;
    end

    // Reset generation
    initial begin
        rst_n = 0;
        repeat (5) @(posedge clk);
        rst_n = 1;
    end

    // UVM configuration and run
    initial begin
        uvm_config_db #(virtual apb_if)::set(null, "*", "apb_vif", apb_interface);
        run_test();
    end

    // Waveform dump
    initial begin
        $dumpfile("sim.vcd");
        $dumpvars(0, tb_top);
    end

    // Timeout
    initial begin
        #10us;
        `uvm_error("TB", "Simulation timeout!")
        $finish;
    end

endmodule

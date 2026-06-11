// ====================================
// APB Interface Definition
// ====================================

interface apb_if (input logic clk);
    logic        psel;
    logic        penable;
    logic [7:0]  paddr;
    logic        pwrite;
    logic [7:0]  pwdata;
    logic [7:0]  prdata;
    logic        pready;

    // Clocking block for synchronization
    clocking cb @(posedge clk);
        output psel, penable, paddr, pwrite, pwdata;
        input  prdata, pready;
    endclocking

    modport master (clocking cb);
    modport slave (input clk, psel, penable, paddr, pwrite, pwdata,
                   output prdata, pready);

endinterface

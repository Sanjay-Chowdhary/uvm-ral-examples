// APB Interface Definition

interface apb_if (input logic clk);
    logic        psel;
    logic        penable;
    logic [7:0]  paddr;
    logic        pwrite;
    logic [31:0] pwdata;
    logic [31:0] prdata;
    logic        pready;

    clocking cb @(posedge clk);
        output psel, penable, paddr, pwrite, pwdata;
        input  prdata, pready;
    endclocking

    modport master (clocking cb);
    modport slave (input clk, psel, penable, paddr, pwrite, pwdata,
                   output prdata, pready);

endinterface

// ====================================
// Simple DUT with 3 Registers
// ====================================
// Registers:
//  - CONTROL (0x0): Read/Write, 8-bit
//  - STATUS  (0x1): Read-only, 8-bit
//  - DATA    (0x2): Read/Write, 8-bit

module simple_dut (
    input  logic clk,
    input  logic rst_n,
    
    // APB Slave Interface
    input  logic        apb_psel,
    input  logic        apb_penable,
    input  logic [7:0]  apb_paddr,
    input  logic        apb_pwrite,
    input  logic [7:0]  apb_pwdata,
    output logic [7:0]  apb_prdata,
    output logic        apb_pready
);

    // ============ REGISTERS ============
    // These are the actual RTL registers that can be accessed
    // Both via frontdoor (APB) and backdoor (direct access)
    logic [7:0] control_reg;  // Address 0x0
    logic [7:0] status_reg;   // Address 0x1 (Read-only)
    logic [7:0] data_reg;     // Address 0x2

    // ============ WRITE LOGIC ============
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            control_reg <= 8'h00;
            data_reg    <= 8'h00;
        end
        else if (apb_psel && apb_penable && apb_pwrite) begin
            case (apb_paddr)
                8'h0: control_reg <= apb_pwdata;
                8'h1: begin
                    // STATUS is read-only, ignore write
                    $display("[DUT] Attempted write to read-only STATUS register");
                end
                8'h2: data_reg <= apb_pwdata;
                default: begin
                    $display("[DUT] Write to unknown address: 0x%02h", apb_paddr);
                end
            endcase
        end
    end

    // ============ READ LOGIC ============
    always_comb begin
        case (apb_paddr)
            8'h0: apb_prdata = control_reg;
            8'h1: apb_prdata = status_reg;
            8'h2: apb_prdata = data_reg;
            default: apb_prdata = 8'h00;
        endcase
    end

    // ============ STATUS LOGIC ============
    // STATUS register bit 0 = CONTROL register bit 0 (enable)
    always_comb begin
        status_reg[0] = control_reg[0];
        status_reg[7:1] = 7'h00;
    end

    // ============ APB HANDSHAKE ============
    // Simple ready signal - always ready for simplicity
    assign apb_pready = apb_psel & apb_penable;

endmodule

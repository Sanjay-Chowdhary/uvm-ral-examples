# RTL Design Under Test (DUT) - Register Block

module register_block (
    input  logic clk,
    input  logic rst_n,
    
    // APB Slave Interface
    input  logic        apb_psel,
    input  logic        apb_penable,
    input  logic [7:0]  apb_paddr,
    input  logic        apb_pwrite,
    input  logic [31:0] apb_pwdata,
    output logic [31:0] apb_prdata,
    output logic        apb_pready
);

    // ============ REGISTERS ============
    // Backdoor accessible registers for testing
    logic [31:0] control_reg;   // Address 0x0 - RW
    logic [31:0] status_reg;    // Address 0x4 - RO
    logic [31:0] data_reg;      // Address 0x8 - RW
    logic [31:0] config_reg;    // Address 0xC - RW

    // ============ WRITE LOGIC ============
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            control_reg <= 32'h0000_0000;
            data_reg    <= 32'h0000_0000;
            config_reg  <= 32'hDEAD_BEEF;
        end
        else if (apb_psel && apb_penable && apb_pwrite) begin
            case (apb_paddr[7:0])
                8'h00: control_reg <= apb_pwdata;
                8'h04: begin
                    // STATUS is read-only
                    $display("[DUT] Attempted write to read-only STATUS register");
                end
                8'h08: data_reg <= apb_pwdata;
                8'h0C: config_reg <= apb_pwdata;
                default: $display("[DUT] Write to unknown address: 0x%02h", apb_paddr);
            endcase
        end
    end

    // ============ READ LOGIC ============
    always_comb begin
        case (apb_paddr[7:0])
            8'h00: apb_prdata = control_reg;
            8'h04: apb_prdata = status_reg;
            8'h08: apb_prdata = data_reg;
            8'h0C: apb_prdata = config_reg;
            default: apb_prdata = 32'h0000_0000;
        endcase
    end

    // ============ STATUS LOGIC ============
    // STATUS[0] = CONTROL[0] (enable)
    // STATUS[7:1] = CONTROL[7:1] (flags)
    always_comb begin
        status_reg[7:0] = control_reg[7:0];
        status_reg[31:8] = {24{control_reg[7]}};
    end

    // ============ APB HANDSHAKE ============
    assign apb_pready = apb_psel & apb_penable;

endmodule

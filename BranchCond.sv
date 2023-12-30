module BranchCond (
    input logic [2:0] funct3,
    input logic [6:0] instr_opcode,
    input logic [31:0] operand_A, operand_B,
    output logic branch_taken
);

parameter [2:0] BEQ  = 3'b000;
parameter [2:0] BNE  = 3'b001;
parameter [2:0] BLT  = 3'b100;
parameter [2:0] BGE  = 3'b101;
parameter [2:0] BLTU = 3'b110;
parameter [2:0] BGEU = 3'b111;

logic [32:0] comparison_output;
logic [31:0] comparison_operand_1, comparison_operand_2;
logic        comparison_not_zero, comparison_negative, comparison_overflow;

assign comparison_operand_1 = operand_A;
assign comparison_operand_2 = operand_B;
assign comparison_output    = {1'b0, comparison_operand_1} - {1'b0, comparison_operand_2};
assign comparison_not_zero  = |comparison_output [31:0];
assign comparison_negative  = comparison_output [31];
assign comparison_overflow  = (comparison_negative & ~comparison_operand_1[31] & comparison_operand_2[31]) |
                              (~comparison_negative & comparison_operand_1[31] & ~comparison_operand_2[31]);

always_comb begin
    case (instr_opcode)
        7'b1100011 :begin  // B Type 
            case(funct3) 
                BEQ    : branch_taken = ~comparison_not_zero;
                BNE    : branch_taken = comparison_not_zero; 
                BLT    : branch_taken = (comparison_negative ^ comparison_overflow);
                BLTU   : branch_taken = comparison_output[32];
                BGE    : branch_taken = ~(comparison_negative ^ comparison_overflow); 
                BGEU   : branch_taken = ~comparison_output[32];
                default: branch_taken = 1'b0;
            endcase
        end
        7'b1101111 , 7'b1100111: branch_taken = 1'b1; // JAL and JALR Type  
        default   : branch_taken = 1'b0;
    endcase
end

endmodule

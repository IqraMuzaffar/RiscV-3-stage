module Controller (
    input logic br_taken,
    input logic [31:0] instruction,
    output logic PC_src, reg_write, select_A, select_B,
    output logic [1:0] write_back_select,
    output logic [2:0] immediate_source, function_code,
    output logic [4:0] alu_operation,
    output logic [6:0] instruction_opcode
);

logic B_type;
logic [6:0] funct7;

parameter [4:0] ADD  = 5'b00000;
parameter [4:0] SUB  = 5'b00001;
parameter [4:0] SLL  = 5'b00010;
parameter [4:0] SLT  = 5'b00011;
parameter [4:0] SLTU = 5'b00100;
parameter [4:0] XOR  = 5'b00101;
parameter [4:0] SRL  = 5'b00110;
parameter [4:0] SRA  = 5'b00111;
parameter [4:0] OR   = 5'b01000;
parameter [4:0] AND  = 5'b01001;
parameter [4:0] LUI  = 5'b01010;

assign instruction_opcode = instruction[6:0];
assign funct7 = instruction[31:25];

always_comb begin
    case(instruction_opcode)
        7'b0110011: // R-Type
            begin
                reg_write = 1'b1;
                select_A = 1'b1;
                select_B = 1'b0;
                write_back_select = 2'b01;
                B_type = 1'b0;
                immediate_source = 3'bxxx;

                case (function_code)
                    3'b000: 
                        begin
                            case (funct7)
                                7'b0000000: alu_operation = ADD;
                                7'b0100000: alu_operation = SUB;
                            endcase
                        end
                    3'b001: alu_operation = SLL;
                    3'b010: alu_operation = SLT;
                    3'b011: alu_operation = SLTU;
                    3'b100: alu_operation = XOR;
                    3'b101: 
                        begin
                            case (funct7)
                                7'b0000000: alu_operation = SRL;
                                7'b0100000: alu_operation = SRA;
                            endcase
                        end
                    3'b110: alu_operation = OR;
                    3'b111: alu_operation = AND;
                endcase
            end

        7'b0010011: // I-Type Without load
            begin
                reg_write = 1'b1;
                select_A = 1'b1;
                select_B = 1'b1;
                write_back_select = 2'b01;
                B_type = 1'b0;
                immediate_source = 3'b000;

                case (function_code)
                    3'b000: alu_operation = ADD;
                    3'b001: alu_operation = SLL;
                    3'b010: alu_operation = SLT;
                    3'b011: alu_operation = SLTU;
                    3'b100: alu_operation = XOR;
                    3'b101: 
                        begin
                            case (funct7)
                                7'b0000000: alu_operation = SRL;
                                7'b0100000: alu_operation = SRA;
                            endcase
                        end
                    3'b110: alu_operation = OR;
                    3'b111: alu_operation = AND;
                endcase
            end

        7'b0000011: // Load I-Type
            begin
                reg_write = 1'b1;
                select_A = 1'b1;
                select_B = 1'b1;
                write_back_select = 2'b10;
                B_type = 1'b0;
                immediate_source = 3'b000;
                alu_operation = ADD;
            end

        7'b0100011: // S-Type
            begin
                reg_write = 1'b0;
                select_A = 1'b1;
                select_B = 1'b1;
                write_back_select = 2'bx;
                B_type = 1'b0;
                immediate_source = 3'b001;
                alu_operation = ADD;
            end

        7'b0110111: // U-Type LUI
            begin
                reg_write = 1'b1;
                select_B = 1'b1;
                select_A = 1'bx;
                write_back_select = 2'b01;
                B_type = 1'b0;
                immediate_source = 3'b100;
                alu_operation = LUI;
            end

        7'b0010111: // U-Type AUIPC
            begin
                reg_write = 1'b1;
                select_B = 1'b1;
                select_A = 1'b0;
                write_back_select = 2'b01;
                B_type = 1'b0;
                immediate_source = 3'b100;
                alu_operation = ADD;
            end

        7'b1100011: // B type
            begin
                B_type = 1'b1;
 

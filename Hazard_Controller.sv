module HazardController (
    input  logic        clk, rst, reg_write, stall_memory_write,
    input  logic [1:0]  writeback_select,
    input  logic [31:0] fetched_instruction,
    output logic        memory_write_enable,
    output logic [1:0]  writeback_select_memory_write,
    output logic [2:0]  funct3_memory_write,
    output logic [6:0]  opcode_memory_write
);

    always_ff @(posedge clk) begin 
        if (rst) begin
            funct3_memory_write <= 3'b0;
            opcode_memory_write <= 7'b0;
            writeback_select_memory_write <= 2'bx;
            memory_write_enable <= 1'b0;  
        end
        else if (stall_memory_write) begin
            funct3_memory_write <= funct3_memory_write;
            opcode_memory_write <= opcode_memory_write;
            writeback_select_memory_write <= writeback_select_memory_write; 
            memory_write_enable <= memory_write_enable;        
        end
        else begin
            funct3_memory_write <= fetched_instruction[14:12];
            opcode_memory_write <= fetched_instruction[6:0];
            writeback_select_memory_write <= writeback_select;
            memory_write_enable <= reg_write;
        end
    end

endmodule

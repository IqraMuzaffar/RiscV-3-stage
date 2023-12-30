module HazardUnit (
    input  logic       memory_write_enable, PC_source, instruction_valid,
    input  logic [1:0] writeback_select_memory_write,
    input  logic [4:0] read_address_1, read_address_2, write_address_memory_write,
    output logic       forward_A, forward_B, stall, stall_memory_write, flush
);

    // Check the validity of the source operands from the EXE stage
    logic source1_valid;
    logic source2_valid;
    assign source1_valid = |read_address_1;
    assign source2_valid = |read_address_2;

    // Hazard detection for forwarding
    always_comb begin
        if (((read_address_1 == write_address_memory_write) & (memory_write_enable)) & (source1_valid)  & (instruction_valid == 0)) begin
            forward_A = 1'b0;
        end
        else begin
            forward_A = 1'b1;
        end
    end

    always_comb begin
        if (((read_address_2 == write_address_memory_write) & (memory_write_enable)) & (source2_valid) & (instruction_valid == 0) ) begin
            forward_B = 1'b0;
        end
        else begin
            forward_B = 1'b1;
        end
    end

    // Hazard detection for stalling
    logic load_stall;
    assign load_stall = (writeback_select_memory_write[1] & ((read_address_1 == write_address_memory_write) | (read_address_2 == write_address_memory_write)) & (instruction_valid == 0) & (memory_write_enable));
    assign stall = load_stall;
    assign stall_memory_write = load_stall;  

    // Flush when a branch is taken or a load introduces a bubble
    always_comb begin
        if (PC_source)
            flush = 1'b1;
    end

endmodule

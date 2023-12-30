module InstructionFetch (
    input logic [31:0] instruction_fetch,
    output logic [4:0] read_address_1, read_address_2, write_address
);

    always_comb begin
        read_address_1 = instruction_fetch[19:15];
        read_address_2 = instruction_fetch[24:20];
        write_address = instruction_fetch[11:7];
    end

endmodule

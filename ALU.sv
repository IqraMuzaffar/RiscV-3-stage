module ALU (
    input logic [4:0] operation_code,
    input logic [31:0] input_A, input_B,
    output logic [31:0] output
);

always_comb begin
    case (operation_code)
        5'b00000: output = input_A + input_B;                             // Addition
        5'b00001: output = input_A - input_B;                             // Subtraction
        5'b00010: output = input_A << input_B[4:0];                      // Shift Left Logical
        5'b00011: output = ($signed(input_A) < $signed(input_B)) ? 1 : 0; // Set Less than
        5'b00100: output = (input_A < input_B) ? 1 : 0;                  // Set Less than unsigned
        5'b00101: output = input_A ^ input_B;                            // Logical XOR
        5'b00110: output = input_A >> input_B;                           // Shift Right Logical
        5'b00111: output = input_A >>> input_B[4:0];                     // Shift Right Arithmetic
        5'b01000: output = input_A | input_B;                            // Logical OR
        5'b01001: output = input_A & input_B;                            // Logical AND
        5'b01010: output = input_B;                                      // Load Upper Immediate
        default: output = input_A + input_B;
    endcase
end

endmodule

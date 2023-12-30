module forward_mux2(
  input  logic [31:0] rdata2, ALUResult_MW,
  input  logic For_B,
  output logic [31:0] SrcBE
);
always_comb begin
    case (For_B)
        1'b0 : SrcBE = ALUResult_MW;
        1'b1 : SrcBE = rdata2;
    default  : SrcBE = rdata2;
    endcase
end

endmodule
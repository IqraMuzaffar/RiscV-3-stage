module SecondRegister (
    input  logic         clock, reset, stallMW,    
    input  logic  [4:0]  writeAddress,
    input  logic  [31:0] readAddressF, aluResult, sourceBE,
  
    output logic  [4:0]  writeAddressMW,
    output logic  [31:0] readAddressMW, aluResultMW, readData2MW
);

always_ff @( posedge clock ) begin

    if (reset) begin
        readAddressMW  <= 32'b0;
        aluResultMW    <= 32'b0;
        readData2MW    <= 32'b0;
        writeAddressMW <= 5'b0;
    end 

    else if (stallMW) begin
        readAddressMW  <= readAddressMW;
        aluResultMW    <= aluResultMW;
        readData2MW    <= readData2MW;
        writeAddressMW <= writeAddressMW;         
    end 

    else begin
        readAddressMW  <= readAddressF;
        aluResultMW    <= aluResult;
        readData2MW    <= sourceBE;
        writeAddressMW <= writeAddress;                        
    end
end
endmodule

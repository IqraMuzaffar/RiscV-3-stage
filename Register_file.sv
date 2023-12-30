module RegisterFile (
     input logic         clock, reset, writeEnableMW,
     input logic  [4:0]  readAddress1, readAddress2, writeAddressMW,
     input logic  [31:0] writeData,
     output logic [31:0] readData1, readData2
);
    logic [31:0] registers[31:0];

// Asynchronous Read 
    always_comb begin
        readData1 = (|readAddress1) ? registers[readAddress1] : '0 ;
        readData2 = (|readAddress2) ? registers[readAddress2] : '0 ;
    end

// Synchronous Write
  always_ff @(negedge clock) begin
    if (writeEnableMW && (|writeAddressMW)) begin
        registers[writeAddressMW] <= writeData;
    end 
  end

endmodule

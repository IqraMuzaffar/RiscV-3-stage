module MuxResult (
    input logic  [1:0]  wb_selMW, //From controller
    input logic  [31:0] ALUResult_MW,rdata,AddrPlus4,
    output logic [31:0] wdata
);

always_comb begin 
    case (wb_selMW)
       2'b00 : wdata = AddrPlus4;
       2'b01 : wdata = ALUResult_MW;
       2'b10 : wdata = rdata;
    endcase
    end
endmodule

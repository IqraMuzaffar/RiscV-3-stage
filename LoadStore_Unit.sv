module LoadStoreUnit (
    input  logic        stallMemoryWrite, validDataMemory,
    input  logic [2:0]  opcodeMemoryWriteFunct3,
    input  logic [6:0]  opcodeMemoryWrite,
    input  logic [31:0] dataMemoryRead,      // From Data Memory in case of Load Instruction
	input  logic [31:0] readData2MemoryWrite,        
    input  logic [31:0] aluResultMemoryWrite,    
    output logic        chipSelect, writeEnable, stallMemoryWriteDataMemory, valid, 
    output logic [3:0]  writeMask,
    output logic [31:0] address, dataMemoryWrite,  // Address >> ALUResult and dataMemoryWrite >> readData2MemoryWrite
	output logic [31:0] readData          // Data to be loaded back to the destination Register 
);

parameter Byte              = 3'b000; 
parameter HalfWord          = 3'b001;
parameter Word              = 3'b010;
parameter ByteUnsigned     = 3'b100;
parameter HalfWordUnsigned = 3'b101;
assign address              = aluResultMemoryWrite;
assign stallMemoryWriteDataMemory          = stallMemoryWrite;
assign valid                = validDataMemory;

always_comb begin
    writeEnable = 1;
    case (opcodeMemoryWrite)
        7'b0000011: begin 
            writeEnable = 1;
            chipSelect  = 0;  // Load
        end
        7'b0100011: begin 
            writeEnable = 0; 
            chipSelect  = 0;  // Store
        end
    endcase
end

logic [7:0]  readDataByte;
logic [15:0] readDataHalfWord;
logic [31:0] readDataWord;

always_comb begin
    readDataByte  = '0;
    readDataHalfWord = '0;
    readDataWord  = '0;
    case (opcodeMemoryWrite) 
        7'b0000011: begin // Load
            case (opcodeMemoryWriteFunct3)
                Byte , ByteUnsigned: case( address[1:0] )
                        2'b00 : readDataByte = dataMemoryRead [7:0];
                        2'b01 : readDataByte = dataMemoryRead [15:8];     
                        2'b10 : readDataByte = dataMemoryRead [23:16];
                        2'b11 : readDataByte = dataMemoryRead [31:24]; 
                    endcase     
                HalfWord , HalfWordUnsigned: case( address[1] )
                        1'b0 : readDataHalfWord = dataMemoryRead [15:0];       
                        1'b1 : readDataHalfWord = dataMemoryRead [31:16];
                    endcase
                Word: readDataWord = dataMemoryRead; 
            endcase
        end
    endcase
end

always_comb begin
    case (opcodeMemoryWriteFunct3)
        Byte              : readData = {{24{readDataByte[7]}},   readDataByte}; 
        ByteUnsigned     : readData = {24'b0,                 readDataByte};
        HalfWord          : readData = {{16{readDataHalfWord[15]}}, readDataHalfWord}; 
        HalfWordUnsigned : readData = {16'b0,                 readDataHalfWord};
        Word              : readData = {                       readDataWord};
        default           : readData = '0;        
    endcase 
end

// Prepare the data and mask for store
always_comb begin
    dataMemoryWrite = '0;
    writeMask       = '0;
    case (opcodeMemoryWrite)
       7'b0100011 : begin // Store  
            case (opcodeMemoryWriteFunct3)
                Byte :  begin
                    case (address[1:0])
                        2'b00 : begin
                            dataMemoryWrite[7:0] = readData2MemoryWrite[7:0];
                            writeMask           = 4'b0001;
                        end
                        2'b01: begin
                            dataMemoryWrite [15:8] = readData2MemoryWrite [15:8];
                            writeMask           = 4'b0010;
                        end
                        2'b10: begin
                            dataMemoryWrite[23:16]  = readData2MemoryWrite [23:16];
                            writeMask           = 4'b0100;
                        end
                        2'b11:begin
                            dataMemoryWrite[31:24] = readData2MemoryWrite[31:24];
                            writeMask           = 4'b1000;
                        end
                        default: begin
                        end
                    endcase
                end
                HalfWord: begin
                    case(address[1]) 
                        1'b0 : begin dataMemoryWrite [15:0]  = readData2MemoryWrite[15:0];
                                writeMask                         = 4'b0011;
                            end
                        1'b1 : begin dataMemoryWrite [31:16] = readData2MemoryWrite [31:16];
                                writeMask                         = 4'b1100;
                            end
                    endcase
                end
                Word: begin 
                    dataMemoryWrite = readData2MemoryWrite;
                    writeMask       = 4'b1111;
                end 		
            endcase
        end 
    endcase
end
endmodule

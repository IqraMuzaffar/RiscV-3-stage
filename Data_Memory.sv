module CustomDataMemory( 
    input  logic         clk, rst,
    input  logic         chip_select, write_enable, stall_MW_DM, 
    input  logic [3:0]   write_mask,
    input  logic [31:0]  address, data_write,
    output logic         is_valid_DM,
    output logic [31:0]  data_read
);
    logic [31:0] memory_data [1023:0]; 

    // Valid bit for stalling 
    always_ff @(posedge clk) begin
        if (stall_MW_DM) begin
            is_valid_DM <= 1'b1;
        end
        else begin
            is_valid_DM <= 1'b0;
        end
    end
    
    // Asynchronous Data Memory Read for Load Operation
    assign data_read = ((~chip_select) & (write_enable)) ? memory_data[address] : '0;

    // Synchronous write 
    always_ff @(negedge clk) begin 
        if (chip_select == 0 && write_enable == 0) begin
            if (write_mask[0])  memory_data[address][7:0]   = data_write[7:0];
            if (write_mask[1])  memory_data[address][15:8]  = data_write[15:8];
            if (write_mask[2])  memory_data[address][23:16] = data_write[23:16];    
            if (write_mask[3])  memory_data[address][31:24] = data_write[31:24];
        end     
    end
endmodule

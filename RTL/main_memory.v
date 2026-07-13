 `timescale 1ns / 1ps

module main_memory(
    input clk,

    input mem_read,
    input mem_write,

    input [ADDR_WIDTH-1:0] address,

    input [15:0] block_in,

    output reg [15:0] block_data
);
parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 8;
    parameter MEM_SIZE   = 256;

reg [DATA_WIDTH-1:0] memory [0:MEM_SIZE-1];

integer i;

initial
begin
    for(i=0;i<MEM_SIZE;i=i+1)
        memory[i] = i;
end

always @(posedge clk)
begin

    if(mem_write)
    begin

        memory[{address[7:1],1'b0}]     <= block_in[7:0];
        memory[{address[7:1],1'b0}+1]   <= block_in[15:8];

    end

    if(mem_read)
    begin

        block_data[7:0]  <= memory[{address[7:1],1'b0}];
        block_data[15:8] <= memory[{address[7:1],1'b0}+1];

    end

end

endmodule
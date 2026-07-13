 `timescale 1ns / 1ps

module cache_controller(

    input clk,
    input reset,

    input cpu_read,
    input cpu_write,
    input [7:0] cpu_address,
    input [7:0] cpu_write_data,

    output reg [7:0] cpu_data,

    output ready,
    output hit,
    output miss,

    output memory_read_enable,
    output memory_write_enable,
    output cache_write_enable,

    output [3:0] state,

    output dirty_out,

    output [4:0] tag,
    output [4:0] cache_tag,

    output [1:0] index,
    output offset,

    output [15:0] block_data,
    output [15:0] block_out,

    output  [7:0] writeback_address,

    output reg request_read,
    output reg request_write,
    output reg [7:0] request_address

);

wire cache_valid;

wire [7:0] cache_data;

wire [7:0] memory_address;

reg [7:0] request_write_data;

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin

        request_read       <= 1'b0;
        request_write      <= 1'b0;

        request_address    <= 8'd0;
        request_write_data <= 8'd0;

    end

    else if(cpu_read || cpu_write)
    begin

        request_read       <= cpu_read;
        request_write      <= cpu_write;

        request_address    <= cpu_address;
        request_write_data <= cpu_write_data;

    end

    else if(ready)
    begin

        request_read  <= 1'b0;
        request_write <= 1'b0;

    end

end

address_decoder decoder(

    .address(request_address),

    .tag(tag),
    .index(index),
    .offset(offset)

);

cache_memory cache(

    .clk(clk),
    .reset(reset),

    .cache_write_enable(cache_write_enable),
    .request_write(request_write),

    .index(index),
    .tag_in(tag),
    .offset(offset),

    .cpu_write_data(request_write_data),

    .data_byte0(block_data[7:0]),
    .data_byte1(block_data[15:8]),

    .tag_out(cache_tag),
    .data_out(cache_data),

    .valid_out(cache_valid),
    .dirty_out(dirty_out),

    .block_out(block_out)

);
hit_miss_detector hitmiss(

    .tag_in(tag),
    .tag_out(cache_tag),

    .valid_out(cache_valid),

    .hit(hit),
    .miss(miss)

);

assign writeback_address = {cache_tag,index,1'b0};

assign memory_address =(memory_write_enable) ?writeback_address :request_address;

main_memory memory(

    .clk(clk),

    .mem_read(memory_read_enable),
    .mem_write(memory_write_enable),

    .address(memory_address),

    .block_in(block_out),

    .block_data(block_data)

);

fsm_controller fsm(

    .clk(clk),
    .reset(reset),

    .cpu_read(request_read),
    .cpu_write(request_write),

    .hit(hit),
    .miss(miss),

    .dirty(dirty_out),

    .cache_read_enable(),

    .cache_write_enable(cache_write_enable),

    .memory_read_enable(memory_read_enable),
    .memory_write_enable(memory_write_enable),

    .ready(ready),

    .state(state)

);

always @(*)
begin

    if(hit)
    begin
        cpu_data = cache_data;
    end

    else
    begin
        if(offset)
            cpu_data = block_data[15:8];
        else
            cpu_data = block_data[7:0];
    end

end

endmodule
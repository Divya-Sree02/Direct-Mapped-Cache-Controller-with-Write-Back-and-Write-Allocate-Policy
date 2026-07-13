 `timescale 1ns / 1ps

module tb_cache_controller;

reg clk;
reg reset;

reg cpu_read;
reg cpu_write;

reg [7:0] cpu_address;
reg [7:0] cpu_write_data;

wire [7:0] cpu_data;

wire ready;
wire hit;
wire miss;

wire memory_read_enable;
wire memory_write_enable;
wire cache_write_enable;

cache_controller DUT
(
    .clk(clk),
    .reset(reset),

    .cpu_read(cpu_read),
    .cpu_write(cpu_write),

    .cpu_address(cpu_address),
    .cpu_write_data(cpu_write_data),

    .cpu_data(cpu_data),

    .ready(ready),
    .hit(hit),
    .miss(miss),

    .memory_read_enable(memory_read_enable),
    .memory_write_enable(memory_write_enable),
    .cache_write_enable(cache_write_enable)
);

initial
    clk = 0;

always #5 clk = ~clk;

initial
begin

$monitor(

"\nTime=%0t | State=%0d | CPU_RD=%b | CPU_WR=%b | Req_RD=%b | Req_WR=%b | Addr=%0d |  WR_Data=%0d | RD_Data=%0d | Tag=%b | CacheTag=%b |\n Index=%b | Offset=%b | Hit=%b | Miss=%b | Dirty=%b | Cache_WR=%b | Mem_RD=%b | Mem_WR=%b | Ready=%b | WB_Addr=%0d | Block=%h",

$time,

DUT.fsm.state,

cpu_read,
cpu_write,

DUT.request_read,
DUT.request_write,

cpu_address,

cpu_write_data,

cpu_data,

DUT.tag,
DUT.cache_tag,

DUT.index,
DUT.offset,

hit,
miss,

DUT.dirty_out,

cache_write_enable,

memory_read_enable,
memory_write_enable,

ready,

DUT.writeback_address,

DUT.block_out

);

end

initial
begin

reset = 1;

cpu_read = 0;
cpu_write = 0;

cpu_address = 0;
cpu_write_data = 0;

#20;
reset = 0;

#20;

 
// TEST-1 : Read Miss
 
$display("\nTEST-1 : READ MISS (20)");

cpu_address = 8'd20;
cpu_read = 1;

#10;

cpu_read = 0;

#60;
 
// TEST-2 : Read Hit

 $display("\nTEST-2 : READ HIT (20)");

cpu_address = 8'd20;
cpu_read = 1;

#10;

cpu_read = 0;

#60;

// TEST-3 : Write Hit
 

$display("\nTEST-3 : WRITE HIT (20 = 200)");

cpu_address = 8'd20;
cpu_write_data = 8'd200;
cpu_write = 1;

#10;

cpu_write = 0;

#60;

 
// TEST-4 : Read Updated Data
 
$display("\nTEST-4 : READ UPDATED DATA (20)");

cpu_address = 8'd20;
cpu_read = 1;

#10;

cpu_read = 0;

#60;

// TEST-5 : Read Miss

$display("\nTEST-5 : READ MISS (28)");

cpu_address = 8'd28;
cpu_read = 1;

#10;

cpu_read = 0;

#60;

// TEST-6 : Write Miss
 
$display("\nTEST-6 : WRITE MISS (100 = 150)");

cpu_address = 8'd100;
cpu_write_data = 8'd150;
cpu_write = 1;

#10;

cpu_write = 0;

#100;

// TEST-7 : Read Hit

$display("\nTEST-7 : READ HIT (100)");

cpu_address = 8'd100;
cpu_read = 1;

#10;

cpu_read = 0;

#80;

// TEST-8 : Replacement

$display("\nTEST-8 : REPLACEMENT");

cpu_address = 8'd36;
cpu_read = 1;

#10;

cpu_read = 0;

#100;

// TEST-9 : Read Address 20 Again

$display("\nTEST-9 : READ ADDRESS 20");

cpu_address = 8'd20;
cpu_read = 1;

#10;

cpu_read = 0;

#120;

$finish;

end

endmodule
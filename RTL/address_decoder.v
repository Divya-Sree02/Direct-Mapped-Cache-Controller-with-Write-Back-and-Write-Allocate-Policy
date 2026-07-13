 `timescale 1ns / 1ps

module address_decoder(
    input  [ADDR_WIDTH-1:0] address,
    output [TAG_WIDTH-1:0] tag,
    output [INDEX_WIDTH-1:0] index,
    output offset
);
 parameter ADDR_WIDTH  = 8;
   parameter TAG_WIDTH   = 5;
   parameter INDEX_WIDTH = 2;
    assign tag    = address[7:3];

    assign index  = address[2:1];

    assign offset = address[0];

endmodule
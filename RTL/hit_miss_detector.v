 `timescale 1ns / 1ps

module hit_miss_detector(

    input  [4:0] tag_in,
    input  [4:0] tag_out,
    input        valid_out,

    output reg hit,
    output reg miss

);

always @(*)
begin

    if(valid_out && (tag_in == tag_out))
    begin
        hit  = 1'b1;
        miss = 1'b0;
    end
    else
    begin
        hit  = 1'b0;
        miss = 1'b1;
    end

end

endmodule
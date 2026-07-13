 `timescale 1ns / 1ps

module fsm_controller(

input clk,
input reset,

input cpu_read,
input cpu_write,

input hit,
input miss,
input dirty,

output reg cache_read_enable,
output reg cache_write_enable,
output reg memory_read_enable,
output reg memory_write_enable,

output reg ready,

output reg [3:0] state

);

parameter IDLE         = 4'd0;
parameter COMPARE_TAG  = 4'd1;
parameter CACHE_READ   = 4'd2;
parameter CACHE_WRITE  = 4'd3;
parameter CHECK_DIRTY  = 4'd4;
parameter WRITE_BACK   = 4'd5;
parameter MEMORY_READ  = 4'd6;
parameter CACHE_UPDATE = 4'd7;
parameter DATA_RETURN  = 4'd8;

always @(posedge clk or posedge reset)
begin

    if(reset)
        state <= IDLE;

    else
    begin

        case(state)

        IDLE:
        begin
            if(cpu_read || cpu_write)
                state <= COMPARE_TAG;
            else
                state <= IDLE;
        end

        COMPARE_TAG:
        begin

            if(hit)
            begin

                if(cpu_read)
                    state <= CACHE_READ;

                else if(cpu_write)
                    state <= CACHE_WRITE;

            end

            else if(miss)
            begin

                state <= CHECK_DIRTY;

            end

        end

        CHECK_DIRTY:
        begin

            if(dirty)
                state <= WRITE_BACK;
            else
                state <= MEMORY_READ;

        end

        WRITE_BACK:
        begin
            state <= MEMORY_READ;
        end

        MEMORY_READ:
        begin
            state <= CACHE_UPDATE;
        end

        CACHE_UPDATE:
        begin

            if(cpu_write)
                state <= CACHE_WRITE;
            else
                state <= DATA_RETURN;

        end

        CACHE_READ:
        begin
            state <= DATA_RETURN;
        end

        CACHE_WRITE:
        begin
            state <= DATA_RETURN;
        end

        DATA_RETURN:
        begin
            state <= IDLE;
        end

        default:
            state <= IDLE;

        endcase

    end

end

always @(*)
begin

    cache_read_enable   = 0;
    cache_write_enable  = 0;
    memory_read_enable  = 0;
    memory_write_enable = 0;
    ready               = 0;

    case(state)

    CACHE_READ:
    begin
        cache_read_enable = 1;
    end

    CACHE_WRITE:
    begin
        cache_write_enable = 1;
    end

    WRITE_BACK:
    begin
        memory_write_enable = 1;
    end

    MEMORY_READ:
    begin
        memory_read_enable = 1;
    end

    CACHE_UPDATE:
    begin
        cache_write_enable = 1;
    end

    DATA_RETURN:
    begin
        ready = 1;
    end

    endcase

end

endmodule
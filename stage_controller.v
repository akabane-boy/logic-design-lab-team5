`timescale 1ns / 1ps

module stage_controller #(
    parameter FLY_COUNT = 4,
    parameter MOSQUITO_COUNT = 12
)(
    input clk25,
    input [FLY_COUNT-1:0] fly_alive,          // condition of each fly
    input [MOSQUITO_COUNT-1:0] mosquito_alive, // condition of each mosquito
    input spider_alive, // condition of BOSS

    output reg [1:0] stage_state,
    output reg reset_all
);

// Define stage state
parameter STAGE_INIT   = 2'b00;
parameter STAGE_NORMAL = 2'b01;
parameter STAGE_BOSS   = 2'b10;
parameter STAGE_CLEAR   = 2'b11;

initial stage_state = STAGE_INIT;

reg [25:0] clear_counter; // 50_000_000 tick, ~2 secs wait
reg spider_started; // for 1 tick delay at entering STAGE_BOSS

always @(posedge clk25) begin
    case (stage_state)
        STAGE_INIT: begin
            // do nothing -> go to STAGE_NORMAL
            stage_state <= STAGE_NORMAL;
            spider_started <= 0; // reset delay variable
            reset_all <= 0;
        end

        STAGE_NORMAL: begin
            // all flies and mosquitoes die -> STAGE_BOSS
            if (fly_alive == {FLY_COUNT{1'b0}} && mosquito_alive == {MOSQUITO_COUNT{1'b0}})
                stage_state <= STAGE_BOSS;
        end

        STAGE_BOSS: begin
            // if this code doesn't have delay, stage changes to STAGE_CLEAR before spider spawns
            if (!spider_started) begin
                spider_started <= 1; // wait for 1 tick 
            end else if (!spider_alive) begin
                stage_state <= STAGE_CLEAR;
                clear_counter <= 0;
            end
        end

        STAGE_CLEAR: begin
            clear_counter <= clear_counter + 1;
            if (clear_counter >= 50_000_000) begin // ~2 secs
                stage_state <= STAGE_INIT;
                reset_all <= 1;
            end
        end

        default: stage_state <= STAGE_INIT;
    endcase
end

endmodule

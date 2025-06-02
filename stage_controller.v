`timescale 1ns / 1ps

module stage_controller #(
    parameter FLY_COUNT = 4,
    parameter MOSQUITO_COUNT = 12
)(
    input clk25,
    input [FLY_COUNT-1:0] fly_alive,          // condition of each fly
    input [MOSQUITO_COUNT-1:0] mosquito_alive, // condition of each mosquito

    output reg [1:0] stage_state
);

// Define stage state
parameter STAGE_INIT   = 2'b00;
parameter STAGE_NORMAL = 2'b01;
parameter STAGE_BOSS   = 2'b10;

initial stage_state = STAGE_INIT;

always @(posedge clk25) begin
    case (stage_state)
        STAGE_INIT: begin
            // do nothing -> go to STAGE_NORMAL
            stage_state <= STAGE_NORMAL;
        end

        STAGE_NORMAL: begin
            // all flies and mosquitoes die -> STAGE_BOSS
            if (fly_alive == {FLY_COUNT{1'b0}} && mosquito_alive == {MOSQUITO_COUNT{1'b0}})
                stage_state <= STAGE_BOSS;
        end

        STAGE_BOSS: begin
            // TODO: implement stage clear
            stage_state <= STAGE_BOSS;
        end

        default: stage_state <= STAGE_INIT;
    endcase
end

endmodule

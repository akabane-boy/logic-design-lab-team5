`timescale 1ns / 1ps

module stage_controller #(
    parameter ENEMY_COUNT = 23
)(
    input clk25,
    input global_reset,

    input [ENEMY_COUNT-1:0] enemy_alive_out, // from enemy_controller

    output reg [ENEMY_COUNT-1:0] enemy_alive_in, // to enemy_controller
    output reg reset_fly,
    output reg reset_spider,
    output reg reset_mosquito
);

    reg [27:0] counter;
    integer i;

    always @(posedge clk25 or posedge global_reset) begin
        if (global_reset) begin
            counter <= 0;
            reset_fly <= 0;
            reset_spider <= 0;
            reset_mosquito <= 0;
            enemy_alive_in <= 0;
        end else begin
            counter <= counter + 1;

            // update enemy state
            for (i = 0; i < ENEMY_COUNT; i = i + 1)
                enemy_alive_in[i] <= enemy_alive_out[i];

          // fly reset (0sec)
            if (counter == 1) begin
                reset_fly <= 1;
                for (i = 0; i <= 16; i = i + 1)
                    enemy_alive_in[i] <= 1;
            end else begin
                reset_fly <= 0;
            end

          // spider reset (10sec)
            if (counter == 250_000_000) begin
                reset_spider <= 1;
                for (i = 17; i <= 20; i = i + 1)
                    enemy_alive_in[i] <= 1;
            end else begin
                reset_spider <= 0;
            end

          // mosquito reset (20sec)
            if (counter == 500_000_000) begin
                reset_mosquito <= 1;
                for (i = 21; i <= 22; i = i + 1)
                    enemy_alive_in[i] <= 1;
            end else begin
                reset_mosquito <= 0;
            end
        end
    end

endmodule

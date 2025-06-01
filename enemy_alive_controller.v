`timescale 1ns / 1ps

module enemy_controller #(
    parameter ENEMY_COUNT = 23,
    parameter BULLET_COUNT = 8
)(
    input clk25,

    input reset_fly,
    input reset_spider,
    input reset_mosquito,

    // BULLET INPUT (flattened)
    input  [10*BULLET_COUNT-1:0] bullet_x_flat,
    input  [10*BULLET_COUNT-1:0] bullet_y_flat,
    input  [BULLET_COUNT-1:0]    bullet_active_flat,
    output reg [BULLET_COUNT-1:0] bullet_hit,

    // ENEMY POSITION + ALIVE (flattened)
    input  [10*ENEMY_COUNT-1:0]  enemy_x_flat,
    input  [10*ENEMY_COUNT-1:0]  enemy_y_flat,
    input  [ENEMY_COUNT-1:0]     enemy_alive_in_flat,
    output reg [ENEMY_COUNT-1:0] enemy_alive_out_flat
);
    reg [9:0] bullet_x [0:BULLET_COUNT-1];
    reg [9:0] bullet_y [0:BULLET_COUNT-1];
    reg       bullet_active [0:BULLET_COUNT-1];

    reg [9:0] enemy_x_in [0:ENEMY_COUNT-1];
    reg [9:0] enemy_y_in [0:ENEMY_COUNT-1];
    reg       enemy_alive_in [0:ENEMY_COUNT-1];
    reg       enemy_alive_out [0:ENEMY_COUNT-1];

    integer i, j;

    always @(*) begin
        for (i = 0; i < BULLET_COUNT; i = i + 1) begin
            bullet_x[i] = bullet_x_flat[i*10 +: 10];
            bullet_y[i] = bullet_y_flat[i*10 +: 10];
            bullet_active[i] = bullet_active_flat[i];
        end

        for (i = 0; i < ENEMY_COUNT; i = i + 1) begin
            enemy_x_in[i] = enemy_x_flat[i*10 +: 10];
            enemy_y_in[i] = enemy_y_flat[i*10 +: 10];
            enemy_alive_in[i] = enemy_alive_in_flat[i];
            enemy_alive_out_flat[i] = enemy_alive_out[i];
        end
    end
    always @(posedge clk25) begin
        // reset bullet hit
        for (j = 0; j < BULLET_COUNT; j = j + 1)
            bullet_hit[j] <= 0;

        // enemy hit detection
        for (i = 0; i < ENEMY_COUNT; i = i + 1) begin
            enemy_alive_out[i] <= enemy_alive_in[i];

            if (enemy_alive_in[i]) begin
                for (j = 0; j < BULLET_COUNT; j = j + 1) begin
                    if (bullet_active[j] &&
                        bullet_x[j] >= enemy_x_in[i] &&
                        bullet_x[j] <  enemy_x_in[i] + 32 &&
                        bullet_y[j] >= enemy_y_in[i] &&
                        bullet_y[j] <  enemy_y_in[i] + 32) begin
                            enemy_alive_out[i] <= 0;
                            bullet_hit[j] <= 1;
                    end
                end
            end
        end

        if (reset_fly)
            for (i = 0; i <= 16; i = i + 1)
                enemy_alive_out[i] <= 1;
        if (reset_spider)
            for (i = 17; i <= 20; i = i + 1)
                enemy_alive_out[i] <= 1;
        if (reset_mosquito)
            for (i = 21; i <= 22; i = i + 1)
                enemy_alive_out[i] <= 1;
    end
endmodule
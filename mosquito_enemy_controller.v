`timescale 1ns / 1ps

module mosquito_enemy_controller #(
    parameter MOSQUITO_COUNT = 4,
    parameter BULLET_COUNT = 8
)(
    input clk25,
    input [10*8-1:0] bullet_x_flat,
    input [10*8-1:0] bullet_y_flat,
    input [7:0] bullet_active_flat,

    output reg [10*MOSQUITO_COUNT-1:0] mosquito_x_flat,
    output reg [10*MOSQUITO_COUNT-1:0] mosquito_y_flat,
    output reg [MOSQUITO_COUNT-1:0] mosquito_alive,
    output reg [BULLET_COUNT-1:0] bullet_hit
);

    integer i, j;
    reg [9:0] mosquito_x [0:MOSQUITO_COUNT-1];
    reg [9:0] mosquito_y [0:MOSQUITO_COUNT-1];
    reg mosquito_dir [0:MOSQUITO_COUNT-1]; // 0: left, 1: right

    reg [9:0] bullet_x[0:7], bullet_y[0:7];
    reg bullet_active[0:7];

    reg [19:0] move_counter = 0;
    reg initialized = 0;

    always @(*) begin
        for (j = 0; j < 8; j = j + 1) begin
            bullet_x[j] = bullet_x_flat[j*10 +: 10];
            bullet_y[j] = bullet_y_flat[j*10 +: 10];
            bullet_active[j] = bullet_active_flat[j];
        end
    end

    always @(posedge clk25) begin
        bullet_hit <= 0;
        if (!initialized) begin
            for (i = 0; i < MOSQUITO_COUNT; i = i + 1) begin
                mosquito_x[i] <= 60 + i * 120;
                mosquito_y[i] <= 100;
                mosquito_alive[i] <= 1;
                mosquito_dir[i] <= 1; // start moving right
            end
            initialized <= 1;
        end else begin
            move_counter <= move_counter + 1;
            if (move_counter == 500_000) begin
                move_counter <= 0;
                for (i = 0; i < MOSQUITO_COUNT; i = i + 1) begin
                    if (mosquito_alive[i]) begin
                        // move left/right
                        if (mosquito_dir[i])
                            mosquito_x[i] <= mosquito_x[i] + 2;
                        else
                            mosquito_x[i] <= mosquito_x[i] - 2;

                        // reverse direction at edge
                        if (mosquito_x[i] <= 10)
                            mosquito_dir[i] <= 1;
                        else if (mosquito_x[i] >= 640 - 32 - 10)
                            mosquito_dir[i] <= 0;

                        // collision check
                        for (j = 0; j < 8; j = j + 1) begin
                            if (bullet_active[j] &&
                                bullet_x[j] + 8 >= mosquito_x[i] &&
                                bullet_x[j] <= mosquito_x[i] + 31 &&
                                bullet_y[j] + 8 >= mosquito_y[i] &&
                                bullet_y[j] <= mosquito_y[i] + 31) begin
                                mosquito_alive[i] <= 0;
                                bullet_hit[j] <= 1;
                            end
                        end
                    end
                end
            end
        end
    end

    // Flatten output
    always @(*) begin
        for (i = 0; i < MOSQUITO_COUNT; i = i + 1) begin
            mosquito_x_flat[i*10 +: 10] = mosquito_x[i];
            mosquito_y_flat[i*10 +: 10] = mosquito_y[i];
        end
    end

endmodule

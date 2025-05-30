`timescale 1ns / 1ps

module enemy_controller #(
    parameter ENEMY_COUNT = 23,
    parameter BULLET_COUNT = 8
)(
    input clk25,
    
    input reset_fly,
    input reset_spider,
    input reset_mosquito,

    input [9:0] bullet_x [0:BULLET_COUNT-1],
    input [9:0] bullet_y [0:BULLET_COUNT-1],
    input       bullet_active [0:BULLET_COUNT-1],

    output reg  bullet_hit [0:BULLET_COUNT-1],

    input [9:0] enemy_x_in [0:ENEMY_COUNT-1],
    input [9:0] enemy_y_in [0:ENEMY_COUNT-1],
    input       enemy_alive_in [0:ENEMY_COUNT-1],

    output reg  enemy_alive_out [0:ENEMY_COUNT-1]
);

    integer i, j;

    always @(posedge clk25) begin
        // 총알 히트 초기화
        for (j = 0; j < BULLET_COUNT; j = j + 1)
            bullet_hit[j] <= 0;

        // 적군 히트 판정
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

        // 개별 리셋 처리
        if (reset_fly) begin
            for (i = 0; i <= 16; i = i + 1)
                enemy_alive_out[i] <= 1;
        end
        if (reset_spider) begin
            for (i = 17; i <= 20; i = i + 1)
                enemy_alive_out[i] <= 1;
        end
        if (reset_mosquito) begin
            for (i = 21; i <= 22; i = i + 1)
                enemy_alive_out[i] <= 1;
        end
    end

endmodule


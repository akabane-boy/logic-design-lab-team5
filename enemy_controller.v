`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 10:19:44 PM
// Design Name: 
// Module Name: enemy_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module enemy_controller #(
    parameter ENEMY_COUNT = 4,
    parameter BULLET_COUNT = 8
)(
    input clk25,
    input reset_enemy,
    input [9:0] bullet_x0, input [9:0] bullet_y0, input bullet_active0,
    input [9:0] bullet_x1, input [9:0] bullet_y1, input bullet_active1,
    input [9:0] bullet_x2, input [9:0] bullet_y2, input bullet_active2,
    input [9:0] bullet_x3, input [9:0] bullet_y3, input bullet_active3,
    input [9:0] bullet_x4, input [9:0] bullet_y4, input bullet_active4,
    input [9:0] bullet_x5, input [9:0] bullet_y5, input bullet_active5,
    input [9:0] bullet_x6, input [9:0] bullet_y6, input bullet_active6,
    input [9:0] bullet_x7, input [9:0] bullet_y7, input bullet_active7,
    
    output reg [BULLET_COUNT-1:0] bullet_hit,

    output reg [9:0] enemy_x0, output reg [9:0] enemy_y0, output reg enemy_alive0,
    output reg [9:0] enemy_x1, output reg [9:0] enemy_y1, output reg enemy_alive1,
    output reg [9:0] enemy_x2, output reg [9:0] enemy_y2, output reg enemy_alive2,
    output reg [9:0] enemy_x3, output reg [9:0] enemy_y3, output reg enemy_alive3
);

    wire [9:0] bullet_x [0:BULLET_COUNT - 1];
    wire [9:0] bullet_y [0:BULLET_COUNT - 1];
    wire bullet_active [0:BULLET_COUNT - 1];
    reg [9:0] enemy_x [0:ENEMY_COUNT - 1];
    reg [9:0] enemy_y [0:ENEMY_COUNT - 1];
    reg enemy_alive [0:ENEMY_COUNT - 1];
    reg [19:0] enemy_timer = 0; // for moving logic

    integer i, j;

    assign bullet_x[0] = bullet_x0; assign bullet_y[0] = bullet_y0; assign bullet_active[0] = bullet_active0;
    assign bullet_x[1] = bullet_x1; assign bullet_y[1] = bullet_y1; assign bullet_active[1] = bullet_active1;
    assign bullet_x[2] = bullet_x2; assign bullet_y[2] = bullet_y2; assign bullet_active[2] = bullet_active2;
    assign bullet_x[3] = bullet_x3; assign bullet_y[3] = bullet_y3; assign bullet_active[3] = bullet_active3;
    assign bullet_x[4] = bullet_x4; assign bullet_y[4] = bullet_y4; assign bullet_active[4] = bullet_active4;
    assign bullet_x[5] = bullet_x5; assign bullet_y[5] = bullet_y5; assign bullet_active[5] = bullet_active5;
    assign bullet_x[6] = bullet_x6; assign bullet_y[6] = bullet_y6; assign bullet_active[6] = bullet_active6;
    assign bullet_x[7] = bullet_x7; assign bullet_y[7] = bullet_y7; assign bullet_active[7] = bullet_active7;

    initial begin
        enemy_x[0] = 80; enemy_y[0] = 80; enemy_alive[0] = 1;
        enemy_x[1] = 240; enemy_y[1] = 80; enemy_alive[1] = 1;
        enemy_x[2] = 400; enemy_y[2] = 80; enemy_alive[2] = 1;
        enemy_x[3] = 560; enemy_y[3] = 80; enemy_alive[3] = 1;
    end

    always @(posedge clk25) begin
        bullet_hit <= 0;

        // moving logic
        enemy_timer <= enemy_timer + 1;
        if (enemy_timer[19]) begin
            enemy_timer <= 0;
            for (i = 0; i < ENEMY_COUNT; i = i + 1) begin
                if (enemy_alive[i]) begin
                    enemy_y[i] <= enemy_y[i] + 1; // move downward
                end
                if (enemy_y[i] > 479 - 32) begin
                    //enemy_alive[i] <= 0; // delete
                    enemy_y[i] <= 0; // start again
                end
            end
        end

        if (reset_enemy) begin
            for (i = 0; i < ENEMY_COUNT; i = i + 1)
                enemy_alive[i] <= 1;
        end else begin
            for (i = 0; i < ENEMY_COUNT; i = i + 1) begin
                if (enemy_alive[i]) begin
                    for (j = 0; j < BULLET_COUNT; j = j + 1) begin
                        if (bullet_active[j] &&
                            bullet_x[j] >= enemy_x[i] &&
                            bullet_x[j] <  enemy_x[i] + 32 &&
                            bullet_y[j] >= enemy_y[i] &&
                            bullet_y[j] <  enemy_y[i] + 32) begin
                                enemy_alive[i] <= 0;
                                bullet_hit[j] <= 1;
                        end
                    end
                end
            end
        end
        
        
        // Assign internal arrays to outputs
        enemy_x0 <= enemy_x[0]; enemy_y0 <= enemy_y[0]; enemy_alive0 <= enemy_alive[0];
        enemy_x1 <= enemy_x[1]; enemy_y1 <= enemy_y[1]; enemy_alive1 <= enemy_alive[1];
        enemy_x2 <= enemy_x[2]; enemy_y2 <= enemy_y[2]; enemy_alive2 <= enemy_alive[2];
        enemy_x3 <= enemy_x[3]; enemy_y3 <= enemy_y[3]; enemy_alive3 <= enemy_alive[3];
    end

endmodule

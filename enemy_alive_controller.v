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


`timescale 1ns / 1ps

module enemy_controller #(
    parameter ENEMY_COUNT = 17,
    parameter BULLET_COUNT = 8
)(
    input clk25,
    input reset_enemy,

    input [9:0] bullet_x [0:BULLET_COUNT-1], //input bullet local
    input [9:0] bullet_y [0:BULLET_COUNT-1],
    input       bullet_active [0:BULLET_COUNT-1],

    output reg  bullet_hit [0:BULLET_COUNT-1],

    input [9:0] enemy_x_in [0:ENEMY_COUNT-1], //input enemy local 
    input [9:0] enemy_y_in [0:ENEMY_COUNT-1],
    input       enemy_alive_in [0:ENEMY_COUNT-1],

    output reg  enemy_alive_out [0:ENEMY_COUNT-1]
);

    integer i, j;

    always @(posedge clk25) begin
        for (j = 0; j < BULLET_COUNT; j = j + 1)
            bullet_hit[j] <= 0;

        for (i = 0; i < ENEMY_COUNT; i = i + 1) begin //
            if (enemy_alive_in[i]) begin
                for (j = 0; j < BULLET_COUNT; j = j + 1) begin
                    if (bullet_active[j] &&
                        bullet_x[j] >= enemy_x_in[i] &&
                        bullet_x[j] <  enemy_x_in[i] + 32 &&
                        bullet_y[j] >= enemy_y_in[i] &&
                        bullet_y[j] <  enemy_y_in[i] + 32) begin
                            enemy_alive_out[i] <= 0;
                            bullet_hit[j] <= 1;
                    end else begin
                        enemy_alive_out[i] <= enemy_alive_in[i];
                    end
                end
            end else begin
                enemy_alive_out[i] <= 0;
            end
        end

        if (reset_enemy) begin //reset => start
            for (i = 0; i < ENEMY_COUNT; i = i + 1)
                enemy_alive_out[i] <= 1;
        end
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 04:24:35 PM
// Design Name: 
// Module Name: bullet_controller
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

module bullet_controller #(parameter BULLET_COUNT = 8) (
    input clk25,
    input btn_fire,
    input [9:0] player_x,
    input [9:0] player_y,
    
    input [BULLET_COUNT - 1:0] bullet_hit,

    output reg [10*BULLET_COUNT-1:0] bullet_x_flat,
    output reg [10*BULLET_COUNT-1:0] bullet_y_flat,
    output reg [BULLET_COUNT-1:0] bullet_active_flat
);
reg [19:0] bullet_timer = 0;
reg prev_fire = 0;

integer i;

always @(posedge clk25) begin
    prev_fire <= btn_fire;

    // Fire bullet
    if (btn_fire && !prev_fire) begin : fire_loop
        for (i = 0; i < BULLET_COUNT; i = i + 1) begin
            if (!bullet_active_flat[i]) begin
                bullet_x_flat[i*10 +: 10] <= player_x + 12;
                bullet_y_flat[i*10 +: 10] <= player_y;
                bullet_active_flat[i] <= 1;
                disable fire_loop;
            end
        end
    end

    // CHECK bullet hits
    for (i = 0; i < BULLET_COUNT; i = i + 1) begin
        if (bullet_hit[i]) begin
            bullet_active_flat[i] <= 0;
        end
    end

    // movement
    bullet_timer <= bullet_timer + 1;
    if (bullet_timer[16]) begin
        bullet_timer <= 0;
        for (i = 0; i < BULLET_COUNT; i = i + 1) begin
            if (bullet_active_flat[i]) begin
                if (bullet_y_flat[i*10 +: 10] == 0)
                    bullet_active_flat[i] <= 0;
                else
                    bullet_y_flat[i*10 +: 10] <= bullet_y_flat[i*10 +: 10] - 1;
            end
        end
    end

end
endmodule
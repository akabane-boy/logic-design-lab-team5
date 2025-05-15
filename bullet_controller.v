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
    
    input [BULLET_COUNT - 1:0] bullet_hit, // index of hitten bullet

    // Bullet positions and active flags
    output reg [9:0] bullet_x0, output reg [9:0] bullet_y0, output reg bullet_active0,
    output reg [9:0] bullet_x1, output reg [9:0] bullet_y1, output reg bullet_active1,
    output reg [9:0] bullet_x2, output reg [9:0] bullet_y2, output reg bullet_active2,
    output reg [9:0] bullet_x3, output reg [9:0] bullet_y3, output reg bullet_active3,
    output reg [9:0] bullet_x4, output reg [9:0] bullet_y4, output reg bullet_active4,
    output reg [9:0] bullet_x5, output reg [9:0] bullet_y5, output reg bullet_active5,
    output reg [9:0] bullet_x6, output reg [9:0] bullet_y6, output reg bullet_active6,
    output reg [9:0] bullet_x7, output reg [9:0] bullet_y7, output reg bullet_active7
);

    reg [19:0] bullet_timer = 0;
    reg prev_fire = 0;
    
    integer i = 0;

    // Fire logic (detect rising edge of btn_fire)
    always @(posedge clk25) begin
        prev_fire <= btn_fire;

        if (btn_fire && !prev_fire) begin
            if (!bullet_active0) begin
                bullet_x0 <= player_x + 1;
                bullet_y0 <= player_y;
                bullet_active0 <= 1;
            end else if (!bullet_active1) begin
                bullet_x1 <= player_x + 1;
                bullet_y1 <= player_y;
                bullet_active1 <= 1;
            end else if (!bullet_active2) begin
                bullet_x2 <= player_x + 1;
                bullet_y2 <= player_y;
                bullet_active2 <= 1;
            end else if (!bullet_active3) begin
                bullet_x3 <= player_x + 1;
                bullet_y3 <= player_y;
                bullet_active3 <= 1;
            end else if (!bullet_active4) begin
                bullet_x4 <= player_x + 1;
                bullet_y4 <= player_y;
                bullet_active4 <= 1;
            end else if (!bullet_active5) begin
                bullet_x5 <= player_x + 1;
                bullet_y5 <= player_y;
                bullet_active5 <= 1;
            end else if (!bullet_active6) begin
                bullet_x6 <= player_x + 1;
                bullet_y6 <= player_y;
                bullet_active6 <= 1;
            end else if (!bullet_active7) begin
                bullet_x7 <= player_x + 1;
                bullet_y7 <= player_y;
                bullet_active7 <= 1;
            end
        end

    // Bullet movement logic
        bullet_timer <= bullet_timer + 1;

        if (bullet_timer[16]) begin
            bullet_timer <= 0;

            if (bullet_active0) begin
                if (bullet_y0 == 0)
                    bullet_active0 <= 0;
                else
                    bullet_y0 <= bullet_y0 - 1;
            end

            if (bullet_active1) begin
                if (bullet_y1 == 0)
                    bullet_active1 <= 0;
                else
                    bullet_y1 <= bullet_y1 - 1;
            end

            if (bullet_active2) begin
                if (bullet_y2 == 0)
                    bullet_active2 <= 0;
                else
                    bullet_y2 <= bullet_y2 - 1;
            end

            if (bullet_active3) begin
                if (bullet_y3 == 0)
                    bullet_active3 <= 0;
                else
                    bullet_y3 <= bullet_y3 - 1;
            end

            if (bullet_active4) begin
                if (bullet_y4 == 0)
                    bullet_active4 <= 0;
                else
                    bullet_y4 <= bullet_y4 - 1;
            end

            if (bullet_active5) begin
                if (bullet_y5 == 0)
                    bullet_active5 <= 0;
                else
                    bullet_y5 <= bullet_y5 - 1;
            end

            if (bullet_active6) begin
                if (bullet_y6 == 0)
                    bullet_active6 <= 0;
                else
                    bullet_y6 <= bullet_y6 - 1;
            end

            if (bullet_active7) begin
                if (bullet_y7 == 0)
                    bullet_active7 <= 0;
                else
                    bullet_y7 <= bullet_y7 - 1;
            end
        end
        
        // bullet hit
        for (i = 0; i < BULLET_COUNT; i = i + 1) begin
            if (bullet_hit[i]) begin
                case (i)
                    0: bullet_active0 <= 0;
                    1: bullet_active1 <= 0;
                    2: bullet_active2 <= 0;
                    3: bullet_active3 <= 0;
                    4: bullet_active4 <= 0;
                    5: bullet_active5 <= 0;
                    6: bullet_active6 <= 0;
                    7: bullet_active7 <= 0;
                endcase
            end
        end
    end

endmodule


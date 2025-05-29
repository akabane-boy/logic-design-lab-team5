`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 04:12:52 PM
// Design Name: 
// Module Name: user_sprite_controller
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


module user_sprite_controller(
    input clk25,
    input btn_left,
    input btn_right,
    input btn_up,
    input btn_down,
    output reg [9:0] sprite_x,
    output reg [9:0] sprite_y
);
    reg [19:0] move_counter = 0;
    reg [9:0] next_x = sprite_x;
    reg [9:0] next_y = sprite_y;

    // size of sprite and screen
    localparam SPRITE_W = 32;
    localparam SPRITE_H = 32;
    localparam SCREEN_W = 640;
    localparam SCREEN_H = 480;

    always @(posedge clk25) begin
        move_counter <= move_counter + 1;

        if (move_counter[17]) begin
            move_counter <= 0;


            // horizontal movement 
            if (btn_left  && sprite_x > 0)
                next_x = sprite_x - 1;
            else if (btn_right && sprite_x < SCREEN_W - SPRITE_W)
                next_x = sprite_x + 1;

            // vertical movement
            if (btn_up && sprite_y > 0)
                next_y = sprite_y - 1;
            else if (btn_down && sprite_y < SCREEN_H - SPRITE_H)
                next_y = sprite_y + 1;

            // @next clock, change x and y
            sprite_x <= next_x;
            sprite_y <= next_y;
        end
    end
endmodule

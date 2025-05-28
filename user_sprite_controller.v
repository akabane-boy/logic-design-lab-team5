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
    output reg [9:0] sprite_x = 304,
    output reg [9:0] sprite_y = 400
);
    reg [19:0] move_counter = 0;

    // 스프라이트, 스크린 크기입력 
    localparam SPRITE_W = 32;
    localparam SPRITE_H = 32;
    localparam SCREEN_W = 640;
    localparam SCREEN_H = 480;

    always @(posedge clk25) begin
        move_counter <= move_counter + 1;

        if (move_counter[17]) begin
            move_counter <= 0;

            reg [9:0] next_x = sprite_x;
            reg [9:0] next_y = sprite_y;

            // 수평 이동
            if (btn_left  && sprite_x > 0)
                next_x = sprite_x - 1;
            else if (btn_right && sprite_x < SCREEN_W - SPRITE_W)
                next_x = sprite_x + 1;

            // 수직 이동
            if (btn_up && sprite_y > 0)
                next_y = sprite_y - 1;
            else if (btn_down && sprite_y < SCREEN_H - SPRITE_H)
                next_y = sprite_y + 1;

            // x와 y를 다음쿨럭에서 한번에 반영
            sprite_x <= next_x;
            sprite_y <= next_y;
        end
    end
endmodule

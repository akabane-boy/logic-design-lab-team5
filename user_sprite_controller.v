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
    output reg [9:0] sprite_x = 304,
    output reg [9:0] sprite_y = 400
);
    reg [19:0] move_counter = 0; // moderating speed

    always @(posedge clk25) begin
        move_counter <= move_counter + 1;
        if (move_counter[17]) begin
            move_counter <= 0;
            if (btn_left && sprite_x > 0)
                sprite_x <= sprite_x - 1;
            if (btn_right && sprite_x < 640 - 16)
                sprite_x <= sprite_x + 1;
        end
    end
endmodule

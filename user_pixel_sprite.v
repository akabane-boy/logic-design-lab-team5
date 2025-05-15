`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2025 11:52:59 PM
// Design Name: 
// Module Name: user_pixel_sprite
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


module user_pixel_sprite(
    input [9:0] x,
    input [9:0] y,
    input [9:0] sprite_x,
    input [9:0] sprite_y,
    output [2:0] rgb, // 3-bit RGB
    output valid // if pixel has graphic = 1
    );
    
    // 16x16 black and white (color = 1, none = 0)
    reg [15:0] sprite_data [0:15];
    
    initial begin
        sprite_data[0] = 16'b1111111111111111;
        sprite_data[1] = 16'b1111111111111111;
        sprite_data[2] = 16'b1111111111111111;
        sprite_data[3] = 16'b1111111111111111;
        sprite_data[4] = 16'b1111111111111111;
        sprite_data[5] = 16'b1111111111111111;
        sprite_data[6] = 16'b1111111111111111;
        sprite_data[7] = 16'b1111111111111111;
        sprite_data[8] = 16'b1111111111111111;
        sprite_data[9] = 16'b1111111111111111;
        sprite_data[10] = 16'b1111111111111111;
        sprite_data[11] = 16'b1111111111111111;
        sprite_data[12] = 16'b1111111111111111;
        sprite_data[13] = 16'b1111111111111111;
        sprite_data[14] = 16'b1111111111111111;
        sprite_data[15] = 16'b1111111111111111;

    end

    // ½ºÇÁ¶óÀÌÆ® ³»ºÎ ÁÂÇ¥
    wire [3:0] local_x = x - sprite_x;
    wire [3:0] local_y = y - sprite_y;

    wire in_sprite_area =
        (x >= sprite_x) && (x < sprite_x + 16) &&
        (y >= sprite_y) && (y < sprite_y + 16);

    wire pixel_on = sprite_data[local_y][15 - local_x];  // MSB=¿ÞÂÊ

    assign valid = in_sprite_area && pixel_on;
    assign rgb = valid ? 3'b100 : 3'b000; // »¡°£»ö
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 03:55:06 PM
// Design Name: 
// Module Name: bullet_sprite
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


module bullet_sprite (
    input [9:0] x, y,
    input [9:0] bullet_x, bullet_y,
    input bullet_active,
    output [2:0] rgb,
    output valid
);
    wire in_bullet = bullet_active &&
        (x >= bullet_x && x < bullet_x + 2) &&
        (y >= bullet_y && y < bullet_y + 8);

    assign valid = in_bullet;
    assign rgb = valid ? 3'b111 : 3'b000; // white
endmodule


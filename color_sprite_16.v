`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025
// Design Name: 
// Module Name: color_sprite
// Description: 16x16 RGB 3-bit sprite renderer
//////////////////////////////////////////////////////////////////////////////////


module color_sprite_16 #(
    parameter MEM_FILE = "sprite_16x16.mem"
)(
    input [9:0] x, y,               // Current VGA coordinates
    input [9:0] sprite_x, sprite_y, // Top-left position of sprite
    output reg [2:0] rgb,
    output reg valid
);

    // 16 pixels * 3 bits = 48 bits per row
    reg [47:0] sprite_data [0:15]; // 16 rows

    initial begin
        $readmemb(MEM_FILE, sprite_data);
    end

    wire [3:0] local_x = x - sprite_x;
    wire [3:0] local_y = y - sprite_y;

    wire in_bounds = (x >= sprite_x) && (x < sprite_x + 16) &&
                     (y >= sprite_y) && (y < sprite_y + 16);

    reg [2:0] color;

    always @(*) begin
        rgb = 3'b000;
        valid = 0;

        if (in_bounds) begin
            // Extract 3-bit RGB from 48-bit row data
            color = sprite_data[local_y][(47 - local_x * 3) -: 3];
            if (color != 3'b000) begin
                rgb = color;
                valid = 1;
            end
        end
    end

endmodule


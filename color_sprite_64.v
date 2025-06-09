`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025-06-09
// Design Name: 
// Module Name: color_sprite_64
// Description: 64x64 RGB 3-bit sprite renderer
//////////////////////////////////////////////////////////////////////////////////

module color_sprite_64 #(
    parameter MEM_FILE = "sprite_64x64.mem"
)(
    input [9:0] x, y,               // Current VGA coordinates
    input [9:0] sprite_x, sprite_y, // Top-left position of sprite
    output reg [2:0] rgb,
    output reg valid
);

    // 64 pixels * 3 bits = 192 bits per row
    reg [191:0] sprite_data [0:63]; // 64 rows

    initial begin
        $readmemb(MEM_FILE, sprite_data);
    end

    wire [6:0] local_x = x - sprite_x;
    wire [6:0] local_y = y - sprite_y;

    wire in_bounds = (x >= sprite_x) && (x < sprite_x + 64) &&
                     (y >= sprite_y) && (y < sprite_y + 64);

    reg [2:0] color;

    always @(*) begin
        rgb = 3'b000;
        valid = 0;

        if (in_bounds) begin
            // Extract 3-bit RGB from 192-bit row data
            color = sprite_data[local_y][(191 - local_x * 3) -: 3];
            if (color != 3'b000) begin
                rgb = color;
                valid = 1;
            end
        end
    end

endmodule

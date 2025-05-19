`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 08:35:00 PM
// Design Name: 
// Module Name: color_sprite
// Description: 32x32 RGB 3-bit sprite renderer
//////////////////////////////////////////////////////////////////////////////////

module color_sprite_32 #(
    parameter MEM_FILE = "sprite_32x32.mem"
)(
    input [9:0] x, y,               // Current VGA coordinates
    input [9:0] sprite_x, sprite_y, // Top-left position of sprite
    output reg [2:0] rgb,
    output reg valid
);

    // 32 pixels * 3 bits = 96 bits per row
    reg [95:0] sprite_data [0:31]; // 32 rows

    initial begin
        $readmemb(MEM_FILE, sprite_data);
    end

    wire [5:0] local_x = x - sprite_x;
    wire [5:0] local_y = y - sprite_y;

    wire in_bounds = (x >= sprite_x) && (x < sprite_x + 32) &&
                     (y >= sprite_y) && (y < sprite_y + 32);

    reg [2:0] color;

    always @(*) begin
        rgb = 3'b000;
        valid = 0;

        if (in_bounds) begin
            // Extract 3-bit RGB from 96-bit row data
            color = sprite_data[local_y][(95 - local_x * 3) -: 3];
            if (color != 3'b000) begin
                rgb = color;
                valid = 1;
            end
        end
    end

endmodule


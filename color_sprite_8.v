`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 10:03:09 PM
// Design Name: 
// Module Name: color_sprite_8
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025
// Design Name: 
// Module Name: color_sprite
// Description: 8x8 RGB 3-bit sprite renderer
//////////////////////////////////////////////////////////////////////////////////


module color_sprite_8 #(
    parameter MEM_FILE = "sprite_8x8.mem"
)(
    input [9:0] x, y,               // Current VGA pixel coordinates
    input [9:0] sprite_x, sprite_y, // Top-left corner of the sprite
    output reg [2:0] rgb,           // Output pixel color
    output reg valid                // Whether to draw at this pixel
);

    // 8 pixels × 3 bits = 24 bits per row
    reg [23:0] sprite_data [0:7];  // 8 rows total

    initial begin
        $readmemb(MEM_FILE, sprite_data);
    end

    wire [2:0] local_x = x - sprite_x; // 3-bit because max 7
    wire [2:0] local_y = y - sprite_y;

    wire in_bounds = (x >= sprite_x) && (x < sprite_x + 8) &&
                     (y >= sprite_y) && (y < sprite_y + 8);

    reg [2:0] color;

    always @(*) begin
        rgb = 3'b000;
        valid = 0;

        if (in_bounds) begin
            // Extract the 3-bit color from the row
            color = sprite_data[local_y][(23 - local_x * 3) -: 3];
            if (color != 3'b000) begin
                rgb = color;
                valid = 1;
            end
        end
    end

endmodule


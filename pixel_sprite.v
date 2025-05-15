`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 04:31:32 PM
// Design Name: 
// Module Name: pixel_sprite
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


module pixel_sprite #(
    parameter MEM_FILE = "user_sprite_data.mem" // default
)
(
    input [9:0] x, y,             // VGA 현재 픽셀 좌표
    input [9:0] sprite_x, sprite_y, // 스프라이트 위치
    output reg [2:0] rgb,         // 3-bit color {R,G,B}
    output reg valid              // 유효한 출력인지
);
    reg [15:0] sprite_data [0:15];  // 16x16 

    initial begin
        $readmemb(MEM_FILE, sprite_data);
    end

    wire [3:0] local_x = x - sprite_x;
    wire [3:0] local_y = y - sprite_y;

    wire in_bounds = (x >= sprite_x) && (x < sprite_x + 16) &&
                     (y >= sprite_y) && (y < sprite_y + 16);

    always @(*) begin
        valid = 0;
        rgb = 3'b000;

        if (in_bounds && sprite_data[local_y][15 - local_x]) begin
            valid = 1;
            rgb = 3'b111;
        end
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: -
// Engineer: -
//
// Module Name: background_rom
// Description:
// This module loads a 640x480 RGB565 image from a .mem file and outputs the
// corresponding pixel color for a given (x, y) coordinate on screen.
//
// Usage:
//   - Provide pixel address as `addr = y * 640 + x`
//   - RGB565 output will be available on `rgb`
//
//////////////////////////////////////////////////////////////////////////////////

module background_rom(
    input [18:0] addr,        // Pixel address: y * 640 + x (up to 307199)
    output reg [11:0] rgb     // RGB444 color output
);

    // Memory array to store the image: 640 * 480 = 307200 pixels
    reg [11:0] mem [0:307199];

    // Load the memory from file at synthesis or simulation start
    initial begin
        $readmemb("woods_640x480_rgb444_pixelwise.mem", mem);
    end

    // Synchronous or combinational read
    always @(*) begin
        rgb = mem[addr];
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2025 09:40:10 PM
// Design Name: 
// Module Name: vga_controller
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


module vga_controller(
    input clk25, // 25 Mhz pixel clock
    output reg hsync, vsync,
    output wire [9:0] x, y,
    output wire video_on
    );
    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;
    
    // 수평 스캔
    always @(posedge clk25) begin
        if (h_count == 799) begin
            h_count <= 0;
            if (v_count == 524)
                v_count <= 0;
            else
                v_count = v_count + 1;
        end else begin
            h_count = h_count + 1;
        end
    end
    
    // 동기화 신호
    always @(posedge clk25) begin
        hsync <= ~((h_count >= 656) && (h_count < 752)); // 96
        vsync <= ~((v_count >= 490) && (v_count < 492)); // 2
    end
    
    assign x = h_count;
    assign y = v_count;
    assign video_on = (h_count < 640) && (v_count < 480);
endmodule

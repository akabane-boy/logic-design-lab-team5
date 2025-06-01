`timescale 1ns / 1ps

module spider_motion_controller (
    input clk25,
    input reset_spider,
    output reg [10*4-1:0] spider_x_flat,
    output reg [10*4-1:0] spider_y_flat,
    output reg [3:0]      spider_alive_flat
); 

    reg signed [9:0] dx [0:3];
    reg signed [9:0] dy [0:3];

    integer i;

    always @(posedge clk25) begin
        if (reset_spider) begin
            spider_x_flat[0*10 +: 10] <= 128;  spider_y_flat[0*10 +: 10] <= 0;   dx[0] <=  2; dy[0] <=  2;
            spider_x_flat[1*10 +: 10] <= 288;  spider_y_flat[1*10 +: 10] <= 0;   dx[1] <= -2; dy[1] <=  2;
            spider_x_flat[2*10 +: 10] <= 448;  spider_y_flat[2*10 +: 10] <= 0;   dx[2] <=  2; dy[2] <=  2;
            spider_x_flat[3*10 +: 10] <= 608;  spider_y_flat[3*10 +: 10] <= 0;   dx[3] <= -2; dy[3] <=  2;

            for (i = 0; i < 4; i = i + 1)
                spider_alive_flat[i] <= 1;
        end else begin
            for (i = 0; i < 4; i = i + 1) begin
                if (spider_alive_flat[i]) begin
                    spider_x_flat[i*10 +: 10] <= spider_x_flat[i*10 +: 10] + dx[i];
                    spider_y_flat[i*10 +: 10] <= spider_y_flat[i*10 +: 10] + dy[i];

                    if (spider_x_flat[i*10 +: 10] <= 0 || spider_x_flat[i*10 +: 10] >= 640 - 32)
                        dx[i] <= -dx[i];

                    if (spider_y_flat[i*10 +: 10] >= 480 - 32)
                        spider_alive_flat[i] <= 0;
                end
            end
        end
    end

endmodule

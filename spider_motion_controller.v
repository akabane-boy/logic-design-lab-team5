`timescale 1ns / 1ps

module spider_motion_controller (
    input clk25,
    input reset_spider,
    output reg [9:0] spider_x [0:3],
    output reg [9:0] spider_y [0:3],
    output reg       spider_alive [0:3]
); 

    reg signed [9:0] dx [0:3];
    reg signed [9:0] dy [0:3];

    integer i;

    always @(posedge clk25) begin
        if (reset_spider) begin
            spider_x[0] <= 128;  spider_y[0] <= 0;   dx[0] <=  2; dy[0] <=  2;
            spider_x[1] <= 288;  spider_y[1] <= 0;   dx[1] <= -2; dy[1] <=  2;
            spider_x[2] <= 448;  spider_y[2] <= 0;   dx[2] <=  2; dy[2] <=  2;
            spider_x[3] <= 608;  spider_y[3] <= 0;   dx[3] <= -2; dy[3] <=  2;

            for (i = 0; i < 4; i = i + 1)
                spider_alive[i] <= 1;
        end else begin
            for (i = 0; i < 4; i = i + 1) begin
                if (spider_alive[i]) begin
                    spider_x[i] <= spider_x[i] + dx[i];
                    spider_y[i] <= spider_y[i] + dy[i];

                    // x axis reflection
                    if (spider_x[i] <= 0 || spider_x[i] >= 640 - 32)
                        dx[i] <= -dx[i];

                    // finish
                    if (spider_y[i] >= 448)
                        spider_alive[i] <= 0;
                end
            end
        end
    end

endmodule

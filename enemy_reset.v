`timescale 1ns / 1ps

module fly_stage_starter (
    input clk25,
    output reg stage1_reset
);
    reg [3:0] counter = 0;

    always @(posedge clk25) begin
        if (counter < 2) begin
            stage1_reset <= 1;
            counter <= counter + 1;
        end else begin
            stage1_reset <= 0;
        end
    end
endmodule

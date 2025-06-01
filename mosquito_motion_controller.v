`timescale 1ns / 1ps

module mosquito_motion_controller (
    input clk25,
    input reset_mosquito,
    output reg [10*2-1:0] mosquito_x_flat,
    output reg [10*2-1:0] mosquito_y_flat,
    output reg [1:0]      mosquito_alive_flat
);

    integer i;
    reg [19:0] move_counter = 0;

    always @(posedge clk25) begin
        if (reset_mosquito) begin
            mosquito_x_flat[0*10 +: 10] <= 200;
            mosquito_y_flat[0*10 +: 10] <= 0;
            mosquito_alive_flat[0]      <= 1;

            mosquito_x_flat[1*10 +: 10] <= 440;
            mosquito_y_flat[1*10 +: 10] <= 0;
            mosquito_alive_flat[1]      <= 1;

            move_counter <= 0;
        end else begin
            move_counter <= move_counter + 1;

            if (move_counter[15]) begin
                move_counter <= 0;
                for (i = 0; i < 2; i = i + 1) begin
                    if (mosquito_alive_flat[i]) begin
                        mosquito_y_flat[i*10 +: 10] <= mosquito_y_flat[i*10 +: 10] + 2;

                        if (mosquito_y_flat[i*10 +: 10] >= 480)
                            mosquito_alive_flat[i] <= 0;
                    end
                end
            end
        end
    end

endmodule

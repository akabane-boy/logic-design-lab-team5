`timescale 1ns / 1ps

module mosquito_motion_controller (
    input clk25,
    input reset_mosquito,
    output reg [9:0] mosquito_x [0:1],
    output reg [9:0] mosquito_y [0:1],
    output reg       mosquito_alive [0:1]
);

    integer i;
    reg [19:0] move_counter = 0;

    // setting region
    always @(posedge clk25) begin
        if (reset_mosquito) begin
            mosquito_x[0] <= 200; mosquito_y[0] <= 0; mosquito_alive[0] <= 1;
            mosquito_x[1] <= 440; mosquito_y[1] <= 0; mosquito_alive[1] <= 1;
            move_counter <= 0;
        end else begin
            move_counter <= move_counter + 1;

            // moving 
            if (move_counter[15]) begin
                move_counter <= 0;
                for (i = 0; i < 2; i = i + 1) begin
                    if (mosquito_alive[i]) begin
                        mosquito_y[i] <= mosquito_y[i] + 2;

                      
                        if (mosquito_y[i] >= 480)
                            mosquito_alive[i] <= 0;
                    end
                end
            end
        end
    end

endmodule

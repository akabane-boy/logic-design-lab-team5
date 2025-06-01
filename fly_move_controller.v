`timescale 1ns / 1ps

module fly_enemy_controller (
    input clk25,
    input reset_fly,
    output reg [10*17-1:0] fly_x_flat,
    output reg [10*17-1:0] fly_y_flat,
    output reg [16:0]      fly_alive_flat
);

    reg [19:0] fly_move_counter = 0;
    integer i;

    always @(posedge clk25) begin
        if (reset_fly) begin
            for (i = 0; i < 17; i = i + 1) begin
                fly_x_flat[i*10 +: 10] <= i * 38;
                if (i <= 8)
                    fly_y_flat[i*10 +: 10] <= i * 4;
                else
                    fly_y_flat[i*10 +: 10] <= (16 - i) * 4;
                fly_alive_flat[i] <= 1;
            end
            fly_move_counter <= 0;
        end else begin
            fly_move_counter <= fly_move_counter + 1;

            if (fly_move_counter[15]) begin 
                fly_move_counter <= 0;
                for (i = 0; i < 17; i = i + 1) begin
                    if (fly_alive_flat[i]) begin
                        fly_y_flat[i*10 +: 10] <= fly_y_flat[i*10 +: 10] + 2;
                        if (fly_y_flat[i*10 +: 10] >= 480 - 32)
                            fly_alive_flat[i] <= 0;
                    end
                end
            end
        end
    end

endmodule

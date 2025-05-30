`timescale 1ns / 1ps

module fly_enemy_controller (
    input clk25,
    input reset_fly,
    output reg [9:0] fly_x [0:16],
    output reg [9:0] fly_y [0:16],
    output reg fly_alive [0:16]
);

    reg [19:0] fly_move_counter = 0;
    integer i;

    always @(posedge clk25) begin
        if (reset_fly) begin
            for (i = 0; i < 17; i = i + 1) begin
                fly_x[i] <= i * 38; // x-array
                if (i <= 8)
                    fly_y[i] <= 0 + i * 4;
                else
                    fly_y[i] <= 0 + (16 - i) * 4; // y-array
                fly_alive[i] <= 1;
            end
            fly_move_counter <= 0;
        end else begin
            fly_move_counter <= fly_move_counter + 1;

            if (fly_move_counter[15]) begin 
                fly_move_counter <= 0;
                for (i = 0; i < 17; i = i + 1) begin
                    if (fly_alive[i]) begin
                        fly_y[i] <= fly_y[i] + 2;
                        if (fly_y[i] >= 480 - 32) // 화면 아래 도달 시 제거
                            fly_alive[i] <= 0;
                    end
                end
            end
        end
    end

endmodule

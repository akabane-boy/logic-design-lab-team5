`timescale 1ns / 1ps

module fly_enemy_controller (
    input clk25,
    output reg [10*17-1:0] fly_x_flat,
    output reg [10*17-1:0] fly_y_flat,
    output wire [16:0]     fly_alive_flat
);

    reg [19:0] fly_move_counter = 0;
    integer i;

    // 초기 위치 설정 (초기 한 번만 수행되도록 내부 상태 저장)
    reg initialized = 0;

    always @(posedge clk25) begin
        if (!initialized) begin
            for (i = 0; i < 17; i = i + 1) begin
                fly_x_flat[i*10 +: 10] <= i * 38;
                if (i <= 8)
                    fly_y_flat[i*10 +: 10] <= i * 4;
                else
                    fly_y_flat[i*10 +: 10] <= (16 - i) * 4;
            end
            initialized <= 1;
        end else begin
            fly_move_counter <= fly_move_counter + 1;

            if (fly_move_counter[17]) begin 
                fly_move_counter <= 0;
                for (i = 0; i < 17; i = i + 1) begin
                    fly_y_flat[i*10 +: 10] <= fly_y_flat[i*10 +: 10] + 2;
                    if (fly_y_flat[i*10 +: 10] >= 480)
                        fly_y_flat[i*10 +: 10] <= 0; // 화면 벗어나면 위로 리셋
                end
            end
        end
    end

endmodule

`timescale 1ns / 1ps

module fly_enemy_controller #(
    parameter FLY_COUNT = 4,
    parameter BULLET_COUNT = 8
)(
    input clk25,
    input reset,
    input [10*8-1:0] bullet_x_flat,   // 8 bullets max
    input [10*8-1:0] bullet_y_flat,
    input [7:0] bullet_active_flat,

    output reg [10*FLY_COUNT-1:0] fly_x_flat,
    output reg [10*FLY_COUNT-1:0] fly_y_flat,
    output reg [FLY_COUNT-1:0] fly_alive,
    output reg [FLY_COUNT-1:0] fly_hit, // hit event signal
    output reg [BULLET_COUNT-1:0] bullet_hit
);

    integer i, j;
    reg [9:0] bullet_x[0:7], bullet_y[0:7];
    reg bullet_active[0:7];
    reg [19:0] move_counter = 0;
    reg [FLY_COUNT-1:0] prev_alive; // for comparing prev and curr

    always @(*) begin
        for (j = 0; j < 8; j = j + 1) begin
            bullet_x[j] = bullet_x_flat[j*10 +: 10];
            bullet_y[j] = bullet_y_flat[j*10 +: 10];
            bullet_active[j] = bullet_active_flat[j];
        end
    end

    // movement & hit
    always @(posedge clk25) begin
        if (reset) begin 
            move_counter <= 0;
            bullet_hit <= 0;
            fly_hit <= 0;
            for (i = 0; i < FLY_COUNT; i = i + 1) begin
                fly_x_flat[i*10 +: 10] <= 200 + i * 50;
                fly_y_flat[i*10 +: 10] <= 0;
                fly_alive[i] <= 1;
                fly_hit[i] <= 0;
            end
            prev_alive <= {FLY_COUNT{1'b1}};
        end else begin
            move_counter <= move_counter + 1;

            fly_hit <= 0;
            bullet_hit <= 0;
            
            if (move_counter[19]) begin
                move_counter <= 0;
                for (i = 0; i < FLY_COUNT; i = i + 1) begin
                    if (fly_alive[i]) begin
                        // move downwards
                        fly_y_flat[i*10 +: 10] <= fly_y_flat[i*10 +: 10] + 2;
                        if (fly_y_flat[i*10 +: 10] >= 480 - 32)
                            fly_y_flat[i*10 +: 10] <= 0;

                        // hit logic
                        for (j = 0; j < 8; j = j + 1) begin
                            if (bullet_active[j]) begin
                                if (bullet_x[j] >= fly_x_flat[i*10 +: 10] &&
                                    bullet_x[j] <  fly_x_flat[i*10 +: 10] + 32 &&
                                    bullet_y[j] >= fly_y_flat[i*10 +: 10] &&
                                    bullet_y[j] <  fly_y_flat[i*10 +: 10] + 32) begin
                                        fly_alive[i] <= 0;
                                        bullet_hit[j] <= 1;
                                end
                            end
                        end
                    end
                end
            end

            // hit event
            for (i = 0; i < FLY_COUNT; i = i + 1) begin
                if (prev_alive[i] == 1 && fly_alive[i] == 0) begin
                    fly_hit[i] <= 1;
                end
            end

        // save to prev
        prev_alive <= fly_alive;
        end
    end

endmodule

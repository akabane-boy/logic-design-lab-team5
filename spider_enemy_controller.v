`timescale 1ns / 1ps

module spider_enemy_controller (
    input clk25,
    input enable,

    input [10*8-1:0] bullet_x_flat,
    input [10*8-1:0] bullet_y_flat,
    input [7:0] bullet_active_flat,

    output reg [9:0] spider_x,
    output reg [9:0] spider_y,
    output reg spider_alive,
    output reg [7:0] bullet_hit
);

    reg [3:0] spider_hp; // HP variable
    reg [9:0] bullet_x[0:7], bullet_y[0:7];
    reg bullet_active[0:7];
    integer i;

    reg move_dir; // 0: left, 1: right
    reg [19:0] move_counter;

    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            bullet_x[i] = bullet_x_flat[i*10 +: 10];
            bullet_y[i] = bullet_y_flat[i*10 +: 10];
            bullet_active[i] = bullet_active_flat[i];
        end
    end

    always @(posedge clk25) begin
        bullet_hit <= 8'b0; // reset hit signal

        if (!enable) begin
            // spider not yet spawned
            // INITIAL condition
            spider_x <= 320;
            spider_y <= 0;
            spider_alive <= 0;
            spider_hp <= 0;
            move_counter <= 0;
            move_dir <= 1;
        end
        else if (enable && !spider_alive) begin
            // SPAWN
            spider_alive <= 1;
            spider_hp <= 10;
            spider_x <= 320;
            spider_y <= 0;
            move_counter <= 0;
            move_dir <= 1;
        end
        else if (enable && spider_alive) begin
            // MOVE
            move_counter <= move_counter + 1;
            if (move_counter == 500_000) begin
                move_counter <= 0;

                if (move_dir)
                    spider_x <= spider_x + 2;
                else
                    spider_x <= spider_x - 2;

                if (spider_x <= 10)
                    move_dir <= 1;
                else if (spider_x >= 640 - 32 - 10)
                    move_dir <= 0;
            end

            // collision
            for (i = 0; i < 8; i = i + 1) begin
                if (bullet_active[i] &&
                    bullet_x[i] + 8 >= spider_x &&
                    bullet_x[i] <= spider_x + 31 &&
                    bullet_y[i] + 8 >= spider_y &&
                    bullet_y[i] <= spider_y + 31) begin // if bullets[i] hits enemy?
                    bullet_hit[i] <= 1; // hit!

                    // SPIDER IS ALIVE -> decrease hp
                    if (spider_hp > 1) begin
                        spider_hp <= spider_hp - 1;
                    end
                    // SPIDER HP = 1 -> SPIDER DEAD
                    else begin
                        spider_hp <= 0;
                        spider_alive <= 0;
                    end
                end
            end
        end
    end

endmodule
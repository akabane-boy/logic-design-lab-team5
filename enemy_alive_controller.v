`timescale 1ns / 1ps

module enemy_controller #(
    parameter ENEMY_COUNT = 23,
    parameter BULLET_COUNT = 8
)(
    input clk25,
    
    input reset_fly,
    input reset_spider,
    input reset_mosquito,

    // bullets input
    input [9:0] bullet_x0, bullet_x1, bullet_x2, bullet_x3, bullet_x4, bullet_x5, bullet_x6, bullet_x7,
    input [9:0] bullet_y0, bullet_y1, bullet_y2, bullet_y3, bullet_y4, bullet_y5, bullet_y6, bullet_y7,
    input       bullet_active0, bullet_active1, bullet_active2, bullet_active3, bullet_active4, 
                bullet_active5,  bullet_active6,  bullet_active7, 

    output reg  [0:BULLET_COUNT-1] bullet_hit,

    // enemy inputs and outputs
    input  [9:0] enemy_x0, enemy_x1, enemy_x2, enemy_x3, enemy_x4, enemy_x5, enemy_x6, enemy_x7,
                 enemy_x8, enemy_x9, enemy_x10, enemy_x11, enemy_x12, enemy_x13, enemy_x14, enemy_x15,
                 enemy_x16, enemy_x17, enemy_x18, enemy_x19, enemy_x20, enemy_x21, enemy_x22,

    input  [9:0] enemy_y0, enemy_y1, enemy_y2, enemy_y3, enemy_y4, enemy_y5, enemy_y6, enemy_y7,
                 enemy_y8, enemy_y9, enemy_y10, enemy_y11, enemy_y12, enemy_y13, enemy_y14, enemy_y15,
                 enemy_y16, enemy_y17, enemy_y18, enemy_y19, enemy_y20, enemy_y21, enemy_y22,

    input        enemy_alive_in0, enemy_alive_in1, enemy_alive_in2, enemy_alive_in3, enemy_alive_in4, enemy_alive_in5,
                 enemy_alive_in6, enemy_alive_in7, enemy_alive_in8, enemy_alive_in9, enemy_alive_in10, enemy_alive_in11,
                 enemy_alive_in12, enemy_alive_in13, enemy_alive_in14, enemy_alive_in15, enemy_alive_in16, enemy_alive_in17,
                 enemy_alive_in18, enemy_alive_in19, enemy_alive_in20, enemy_alive_in21, enemy_alive_in22,

    output reg   enemy_alive_out0, enemy_alive_out1, enemy_alive_out2, enemy_alive_out3, enemy_alive_out4,
                 enemy_alive_out5, enemy_alive_out6, enemy_alive_out7, enemy_alive_out8, enemy_alive_out9, 
                 enemy_alive_out10, enemy_alive_out11, enemy_alive_out12, enemy_alive_out13, enemy_alive_out14, 
                 enemy_alive_out15, enemy_alive_out16, enemy_alive_out17, enemy_alive_out18, enemy_alive_out19, 
                 enemy_alive_out20, enemy_alive_out21, enemy_alive_out22
);

    reg [9:0] bullet_x [0:BULLET_COUNT-1];
    reg [9:0] bullet_y [0:BULLET_COUNT-1];
    reg       bullet_active [0:BULLET_COUNT-1];
    reg [9:0] enemy_x_in [0:ENEMY_COUNT-1];
    reg [9:0] enemy_y_in [0:ENEMY_COUNT-1];
    reg       enemy_alive_in [0:ENEMY_COUNT-1];
    reg       enemy_alive_out [0:ENEMY_COUNT-1];

    integer i, j;

    always @(*) begin
        // change each input to array
        bullet_x[0] = bullet_x0; bullet_y[0] = bullet_y0; bullet_active[0] = bullet_active0;
        bullet_x[1] = bullet_x1; bullet_y[1] = bullet_y1; bullet_active[1] = bullet_active1;
        bullet_x[2] = bullet_x2; bullet_y[2] = bullet_y2; bullet_active[2] = bullet_active2;
        bullet_x[3] = bullet_x3; bullet_y[3] = bullet_y3; bullet_active[3] = bullet_active3;
        bullet_x[4] = bullet_x4; bullet_y[4] = bullet_y4; bullet_active[4] = bullet_active4;
        bullet_x[5] = bullet_x5; bullet_y[5] = bullet_y5; bullet_active[5] = bullet_active5;
        bullet_x[6] = bullet_x6; bullet_y[6] = bullet_y6; bullet_active[6] = bullet_active6;
        bullet_x[7] = bullet_x7; bullet_y[7] = bullet_y7; bullet_active[7] = bullet_active7;

        // enemy input info
        enemy_x_in[0]  = enemy_x0;  enemy_y_in[0]  = enemy_y0;  enemy_alive_in[0]  = enemy_alive_in0;
        enemy_x_in[1]  = enemy_x1;  enemy_y_in[1]  = enemy_y1;  enemy_alive_in[1]  = enemy_alive_in1;
        enemy_x_in[2]  = enemy_x2;  enemy_y_in[2]  = enemy_y2;  enemy_alive_in[2]  = enemy_alive_in2;
        enemy_x_in[3]  = enemy_x3;  enemy_y_in[3]  = enemy_y3;  enemy_alive_in[3]  = enemy_alive_in3;
        enemy_x_in[4]  = enemy_x4;  enemy_y_in[4]  = enemy_y4;  enemy_alive_in[4]  = enemy_alive_in4;
        enemy_x_in[5]  = enemy_x5;  enemy_y_in[5]  = enemy_y5;  enemy_alive_in[5]  = enemy_alive_in5;
        enemy_x_in[6]  = enemy_x6;  enemy_y_in[6]  = enemy_y6;  enemy_alive_in[6]  = enemy_alive_in6;
        enemy_x_in[7]  = enemy_x7;  enemy_y_in[7]  = enemy_y7;  enemy_alive_in[7]  = enemy_alive_in7;
        enemy_x_in[8]  = enemy_x8;  enemy_y_in[8]  = enemy_y8;  enemy_alive_in[8]  = enemy_alive_in8;
        enemy_x_in[9]  = enemy_x9;  enemy_y_in[9]  = enemy_y9;  enemy_alive_in[9]  = enemy_alive_in9;
        enemy_x_in[10] = enemy_x10; enemy_y_in[10] = enemy_y10; enemy_alive_in[10] = enemy_alive_in10;
        enemy_x_in[11] = enemy_x11; enemy_y_in[11] = enemy_y11; enemy_alive_in[11] = enemy_alive_in11;
        enemy_x_in[12] = enemy_x12; enemy_y_in[12] = enemy_y12; enemy_alive_in[12] = enemy_alive_in12;
        enemy_x_in[13] = enemy_x13; enemy_y_in[13] = enemy_y13; enemy_alive_in[13] = enemy_alive_in13;
        enemy_x_in[14] = enemy_x14; enemy_y_in[14] = enemy_y14; enemy_alive_in[14] = enemy_alive_in14;
        enemy_x_in[15] = enemy_x15; enemy_y_in[15] = enemy_y15; enemy_alive_in[15] = enemy_alive_in15;
        enemy_x_in[16] = enemy_x16; enemy_y_in[16] = enemy_y16; enemy_alive_in[16] = enemy_alive_in16;
        enemy_x_in[17] = enemy_x17; enemy_y_in[17] = enemy_y17; enemy_alive_in[17] = enemy_alive_in17;
        enemy_x_in[18] = enemy_x18; enemy_y_in[18] = enemy_y18; enemy_alive_in[18] = enemy_alive_in18;
        enemy_x_in[19] = enemy_x19; enemy_y_in[19] = enemy_y19; enemy_alive_in[19] = enemy_alive_in19;
        enemy_x_in[20] = enemy_x20; enemy_y_in[20] = enemy_y20; enemy_alive_in[20] = enemy_alive_in20;
        enemy_x_in[21] = enemy_x21; enemy_y_in[21] = enemy_y21; enemy_alive_in[21] = enemy_alive_in21;
        enemy_x_in[22] = enemy_x22; enemy_y_in[22] = enemy_y22; enemy_alive_in[22] = enemy_alive_in22;

        // enemy output info
        enemy_alive_out0  = enemy_alive_out[0];
        enemy_alive_out1  = enemy_alive_out[1];
        enemy_alive_out2  = enemy_alive_out[2];
        enemy_alive_out3  = enemy_alive_out[3];
        enemy_alive_out4  = enemy_alive_out[4];
        enemy_alive_out5  = enemy_alive_out[5];
        enemy_alive_out6  = enemy_alive_out[6];
        enemy_alive_out7  = enemy_alive_out[7];
        enemy_alive_out8  = enemy_alive_out[8];
        enemy_alive_out9  = enemy_alive_out[9];
        enemy_alive_out10 = enemy_alive_out[10];
        enemy_alive_out11 = enemy_alive_out[11];
        enemy_alive_out12 = enemy_alive_out[12];
        enemy_alive_out13 = enemy_alive_out[13];
        enemy_alive_out14 = enemy_alive_out[14];
        enemy_alive_out15 = enemy_alive_out[15];
        enemy_alive_out16 = enemy_alive_out[16];
        enemy_alive_out17 = enemy_alive_out[17];
        enemy_alive_out18 = enemy_alive_out[18];
        enemy_alive_out19 = enemy_alive_out[19];
        enemy_alive_out20 = enemy_alive_out[20];
        enemy_alive_out21 = enemy_alive_out[21];
        enemy_alive_out22 = enemy_alive_out[22];
    end

    // MAIN LOGIC
    always @(posedge clk25) begin
        // reset bullet hit
        for (j = 0; j < BULLET_COUNT; j = j + 1)
            bullet_hit[j] <= 0;

        // enemy hit
        for (i = 0; i < ENEMY_COUNT; i = i + 1) begin
            enemy_alive_out[i] <= enemy_alive_in[i];

            if (enemy_alive_in[i]) begin
                for (j = 0; j < BULLET_COUNT; j = j + 1) begin
                    if (bullet_active[j] &&
                        bullet_x[j] >= enemy_x_in[i] &&
                        bullet_x[j] <  enemy_x_in[i] + 32 &&
                        bullet_y[j] >= enemy_y_in[i] &&
                        bullet_y[j] <  enemy_y_in[i] + 32) begin
                            enemy_alive_out[i] <= 0;
                            bullet_hit[j] <= 1;
                    end
                end
            end
        end

        // individually reset enemy
        if (reset_fly) begin
            for (i = 0; i <= 16; i = i + 1)
                enemy_alive_out[i] <= 1;
        end
        if (reset_spider) begin
            for (i = 17; i <= 20; i = i + 1)
                enemy_alive_out[i] <= 1;
        end
        if (reset_mosquito) begin
            for (i = 21; i <= 22; i = i + 1)
                enemy_alive_out[i] <= 1;
        end
    end

endmodule


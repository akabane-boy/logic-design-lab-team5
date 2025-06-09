`timescale 1ns / 1ps

module star_controller #(
    parameter STAR_COUNT = 32
)(
    input clk25,
    input [9:0] x, y,  // current VGA coordinate
    output reg [2:0] star_rgb,
    output reg star_on
);

    reg [9:0] star_x [0:STAR_COUNT-1];
    reg [9:0] star_y [0:STAR_COUNT-1];
    reg [9:0] star_y_init [0:STAR_COUNT-1];
    reg [15:0] frame_counter = 0;

    reg initialized = 0;

    integer i;

    initial begin
        // Fixed X positions (pseudo-random)
        star_x[ 0] = 20;  star_x[ 1] = 50;  star_x[ 2] = 80;  star_x[ 3] = 110;
        star_x[ 4] = 140; star_x[ 5] = 170; star_x[ 6] = 200; star_x[ 7] = 230;
        star_x[ 8] = 260; star_x[ 9] = 290; star_x[10] = 320; star_x[11] = 350;
        star_x[12] = 380; star_x[13] = 410; star_x[14] = 440; star_x[15] = 470;
        star_x[16] = 500; star_x[17] = 530; star_x[18] = 560; star_x[19] = 590;
        star_x[20] = 620; star_x[21] = 50;  star_x[22] = 100; star_x[23] = 150;
        star_x[24] = 200; star_x[25] = 250; star_x[26] = 300; star_x[27] = 350;
        star_x[28] = 400; star_x[29] = 450; star_x[30] = 500; star_x[31] = 550;

        star_y_init[ 0] =  5;  star_y_init[ 1] = 32;  star_y_init[ 2] =  8;  star_y_init[ 3] = 75;
        star_y_init[ 4] =  1;  star_y_init[ 5] = 50;  star_y_init[ 6] = 20;  star_y_init[ 7] = 10;
        star_y_init[ 8] = 28;  star_y_init[ 9] = 12;  star_y_init[10] =  4;  star_y_init[11] = 60;
        star_y_init[12] = 16;  star_y_init[13] = 40;  star_y_init[14] = 18;  star_y_init[15] = 33;
        star_y_init[16] = 13;  star_y_init[17] = 21;  star_y_init[18] =  7;  star_y_init[19] = 45;
        star_y_init[20] = 23;  star_y_init[21] = 61;  star_y_init[22] =  3;  star_y_init[23] = 56;
        star_y_init[24] = 19;  star_y_init[25] = 11;  star_y_init[26] = 25;  star_y_init[27] =  9;
        star_y_init[28] = 37;  star_y_init[29] = 48;  star_y_init[30] =  6;  star_y_init[31] = 29;

        for (i = 0; i < STAR_COUNT; i = i + 1)
            star_y[i] = star_y_init[i];
    end

    // Falling movement
    always @(posedge clk25) begin
        if (!initialized) begin
            initialized <= 1;
        end else begin
            frame_counter <= frame_counter + 1;

            if (frame_counter == 0) begin
                for (i = 0; i < STAR_COUNT; i = i + 1) begin
                    if (star_y[i] < 479)
                        star_y[i] <= star_y[i] + 1;
                    else
                        star_y[i] <= star_y_init[i];
                end
            end
        end
    end

    // Star drawing
    always @(*) begin
        star_on = 0;
        star_rgb = 3'b000;

        for (i = 0; i < STAR_COUNT; i = i + 1) begin
            if (x == star_x[i] && y == star_y[i]) begin
                star_on = 1;
                star_rgb = 3'b111; // White star
            end
        end
    end

endmodule
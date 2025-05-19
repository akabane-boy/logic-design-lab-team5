`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2025 09:40:10 PM
// Design Name: 
// Module Name: vga_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_test(
    input clk,                          // 100 MHz
    input btn_right, btn_left, // button for move
    input btn_fire, // button for bullets
    input reset_enemy_sw, // for enemy test
    output [3:0] vga_r, vga_g, vga_b,
    output hsync, vsync
);

    wire [9:0] x, y; // pixels
    wire video_on; // pixel that actually shows on screen
    
/**************************************************************/
/************** 100MHz → about 25MHz divider******************/
/**************************************************************/
    reg [1:0] clkdiv = 0;
    wire clk25;

    always @(posedge clk) clkdiv <= clkdiv + 1;
    assign clk25 = clkdiv[1];


/**************************************************************/
/*************************VGA CONTROLLER***********************/
/************************** 640X480 ***************************/
    vga_controller vga_inst (
        .clk25(clk25),
        .hsync(hsync),
        .vsync(vsync),
        .x(x),
        .y(y),
        .video_on(video_on)
    );


/********************************************************************/
/************************ USER CONTROLLER ***************************/
/********************************************************************/
    reg [9:0] user_sprite_x = 280; // 640
    reg [9:0] user_sprite_y = 400; // 480
    
    wire [9:0] user_x, user_y;
    user_sprite_controller user_ctl (
        .clk25(clk25),
        .btn_left(btn_left),
        .btn_right(btn_right),
        .sprite_x(user_x),
        .sprite_y(user_y)
    );

    
/********************************************************************/
/*********************** bullet controller **************************/
/********************************************************************/
    parameter BULLET_COUNT = 8; // maximum number of bullets in screen
    wire [9:0] bullet_x [0:BULLET_COUNT - 1]; // middle of the screen
    wire [9:0] bullet_y [0:BULLET_COUNT - 1]; // towards the top
    wire bullet_active [0:BULLET_COUNT - 1]; // bullet_active = 1 => outputs bullet
    wire [BULLET_COUNT - 1:0] bullet_hit;
    
    bullet_controller #(.BULLET_COUNT(BULLET_COUNT))
    bullet_ctrl (
        .clk25(clk25),
        .btn_fire(btn_fire),
        .player_x(user_x),
        .player_y(user_y),
        .bullet_hit(bullet_hit),
        .bullet_x0(bullet_x[0]), .bullet_y0(bullet_y[0]), .bullet_active0(bullet_active[0]),
        .bullet_x1(bullet_x[1]), .bullet_y1(bullet_y[1]), .bullet_active1(bullet_active[1]),
        .bullet_x2(bullet_x[2]), .bullet_y2(bullet_y[2]), .bullet_active2(bullet_active[2]),
        .bullet_x3(bullet_x[3]), .bullet_y3(bullet_y[3]), .bullet_active3(bullet_active[3]),
        .bullet_x4(bullet_x[4]), .bullet_y4(bullet_y[4]), .bullet_active4(bullet_active[4]),
        .bullet_x5(bullet_x[5]), .bullet_y5(bullet_y[5]), .bullet_active5(bullet_active[5]),
        .bullet_x6(bullet_x[6]), .bullet_y6(bullet_y[6]), .bullet_active6(bullet_active[6]),
        .bullet_x7(bullet_x[7]), .bullet_y7(bullet_y[7]), .bullet_active7(bullet_active[7])
    );
    
    
/********************************************************************/
/****************************** ENEMY(TEST) *******************************/
/********************************************************************/
// will add enemy_controller_module
parameter ENEMY_COUNT = 4;
wire [9:0] enemy_x [0:ENEMY_COUNT - 1];
wire [9:0] enemy_y [0:ENEMY_COUNT - 1];
wire enemy_alive [0:ENEMY_COUNT - 1];
/*
wire [2:0] enemy_rgb;
wire enemy_valid;
*/

enemy_controller #(
    .ENEMY_COUNT(ENEMY_COUNT),
    .BULLET_COUNT(BULLET_COUNT)
) enemy_ctrl1 (
    .clk25(clk25),
    .reset_enemy(reset_enemy_sw),

    // bullet inputs
    .bullet_x0(bullet_x[0]), .bullet_y0(bullet_y[0]), .bullet_active0(bullet_active[0]),
    .bullet_x1(bullet_x[1]), .bullet_y1(bullet_y[1]), .bullet_active1(bullet_active[1]),
    .bullet_x2(bullet_x[2]), .bullet_y2(bullet_y[2]), .bullet_active2(bullet_active[2]),
    .bullet_x3(bullet_x[3]), .bullet_y3(bullet_y[3]), .bullet_active3(bullet_active[3]),
    .bullet_x4(bullet_x[4]), .bullet_y4(bullet_y[4]), .bullet_active4(bullet_active[4]),
    .bullet_x5(bullet_x[5]), .bullet_y5(bullet_y[5]), .bullet_active5(bullet_active[5]),
    .bullet_x6(bullet_x[6]), .bullet_y6(bullet_y[6]), .bullet_active6(bullet_active[6]),
    .bullet_x7(bullet_x[7]), .bullet_y7(bullet_y[7]), .bullet_active7(bullet_active[7]),

    // outputs
    .bullet_hit(bullet_hit),

    .enemy_x0(enemy_x[0]), .enemy_y0(enemy_y[0]), .enemy_alive0(enemy_alive[0]),
    .enemy_x1(enemy_x[1]), .enemy_y1(enemy_y[1]), .enemy_alive1(enemy_alive[1]),
    .enemy_x2(enemy_x[2]), .enemy_y2(enemy_y[2]), .enemy_alive2(enemy_alive[2]),
    .enemy_x3(enemy_x[3]), .enemy_y3(enemy_y[3]), .enemy_alive3(enemy_alive[3])
);

integer j, k;






/********************************************************************/
/***************************** GRAPHIC ******************************/
/********************************************************************/
    wire [2:0] user_rgb;
    wire [2:0] bullet_rgb [0:BULLET_COUNT - 1];
    wire bullet_valid [0:BULLET_COUNT - 1];
    wire user_valid;
    wire [2:0] enemy_rgb [0:ENEMY_COUNT - 1];
    wire enemy_valid [0:ENEMY_COUNT - 1];
    wire draw_enemy [0:ENEMY_COUNT - 1];

    
    // USER
    color_sprite_32 #(.MEM_FILE("user_sprite_data.mem"))
    user_sprite(
        .x(x), .y(y),
        .sprite_x(user_x), .sprite_y(user_y),
        .rgb(user_rgb), .valid(user_valid)
    );
    // BULLETS
    // make multiple sprite using generate.
    genvar i;
    generate
        for (i = 0; i < BULLET_COUNT; i = i + 1) begin
            color_sprite_8 #(.MEM_FILE("bullet_sprite_data.mem"))
            bullet_inst (
                .x(x), .y(y),
                .sprite_x(bullet_x[i]), .sprite_y(bullet_y[i]),
                .rgb(bullet_rgb[i]),
                .valid(bullet_valid[i])
            );
        end
    endgenerate
    
    reg [2:0] bullet_rgb_final = 3'b000;
    reg any_bullet_valid = 0;
    
    always @(*) begin
        bullet_rgb_final = 3'b000;
        any_bullet_valid = 0;
        
        for (k = 0; k < BULLET_COUNT; k = k + 1) begin
            if (bullet_valid[k] && bullet_active[k] && !any_bullet_valid) begin
                bullet_rgb_final = bullet_rgb[k];
                any_bullet_valid = 1;
            end
        end
    end
    // ENEMY
genvar e;
generate
    for (e = 0; e < ENEMY_COUNT; e = e + 1) begin
        color_sprite_32 #(.MEM_FILE("enemy_sprite_data.mem")) enemy_inst (
            .x(x), .y(y),
            .sprite_x(enemy_x[e]),
            .sprite_y(enemy_y[e]),
            .rgb(enemy_rgb[e]),
            .valid(enemy_valid[e])
        );
        assign draw_enemy[e] = enemy_alive[e] && enemy_valid[e];
    end
endgenerate

reg [2:0] enemy_rgb_final = 3'b000;
reg any_enemy_valid = 0;

integer m;
always @(*) begin
    enemy_rgb_final = 3'b000;
    any_enemy_valid = 0;

    for (m = 0; m < ENEMY_COUNT; m = m + 1) begin
        if (draw_enemy[m] && !any_enemy_valid) begin
            enemy_rgb_final = enemy_rgb[m];
            any_enemy_valid = 1;
        end
    end
end

    
    
/********************************************************************/
/************************** GRAPHIC OUTPUT***************************/
/********************************************************************/
    wire [2:0] final_rgb = user_valid ? user_rgb : // priority user -> bullet -> enemy
                           any_bullet_valid ? bullet_rgb_final : 
                           any_enemy_valid ? enemy_rgb_final :
                           3'b000;
                           
    assign vga_r = video_on ? {4{final_rgb[2]}} : 4'b0000;
    assign vga_g = video_on ? {4{final_rgb[1]}} : 4'b0000;
    assign vga_b = video_on ? {4{final_rgb[0]}} : 4'b0000;
    
endmodule

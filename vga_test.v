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
/************** 100MHz ¡æ about 25MHz divider******************/
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
    reg [BULLET_COUNT - 1:0] bullet_hit;
    
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
reg [9:0] enemy_x = 304;
reg [9:0] enemy_y = 100;
reg enemy_alive = 1;

wire [2:0] enemy_rgb;
wire enemy_valid;

color_sprite #(.MEM_FILE("enemy_sprite_data.mem"))
    enemy_inst1 (
    .x(x), .y(y),
    .sprite_x(enemy_x), .sprite_y(enemy_y),
    .rgb(enemy_rgb),
    .valid(enemy_valid)
);
// enemy logic (need to make another file later)
integer j, k;
always @(posedge clk25) begin
    bullet_hit <= 0; // reset
    
    if (enemy_alive) begin
        for (j = 0; j < BULLET_COUNT; j = j + 1) begin
            if (bullet_active[j] &&
                bullet_x[j] >= enemy_x &&
                bullet_x[j] <  enemy_x + 32 &&
                bullet_y[j] >= enemy_y &&
                bullet_y[j] <  enemy_y + 32) begin
                enemy_alive <= 0;               // enemy down
                bullet_hit[j] <= 1;          // eliminate bullet
            end
        end
    end
    if (reset_enemy_sw) begin
    enemy_alive <= 1;
end


end



/********************************************************************/
/***************************** GRAPHIC ******************************/
/********************************************************************/
    wire [2:0] user_rgb;
    wire [2:0] bullet_rgb [0:BULLET_COUNT - 1];
    wire bullet_valid [0:BULLET_COUNT - 1];
    wire user_valid;
    wire draw_enemy = enemy_alive && enemy_valid;
    
    // USER
    color_sprite #(.MEM_FILE("user_sprite_data.mem"))
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
            color_sprite #(.MEM_FILE("bullet_sprite_data.mem"))
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
    
    
/********************************************************************/
/************************** GRAPHIC OUTPUT***************************/
/********************************************************************/
    wire [2:0] final_rgb = user_valid ? user_rgb : // priority user -> bullet
                           any_bullet_valid ? bullet_rgb_final : 
                           draw_enemy ? enemy_rgb :
                           3'b000;
                           
    assign vga_r = video_on ? {4{final_rgb[2]}} : 4'b0000;
    assign vga_g = video_on ? {4{final_rgb[1]}} : 4'b0000;
    assign vga_b = video_on ? {4{final_rgb[0]}} : 4'b0000;
    
endmodule

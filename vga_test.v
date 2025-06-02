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
    input clk,                         // 100 MHz
    input btn_right, btn_left, btn_up, btn_down, // button for move
    input btn_fire, // button for bullets
    input buzz_sw, // on/off buzz
    input stage_rst, // test sw for stage reset
    input reset_spider, reset_fly, reset_mosquito, // for test
    output [3:0] vga_r, vga_g, vga_b,
    output hsync, vsync, 
    output buzz
);

    wire [9:0] x, y; // pixels
    wire video_on; // pixel that actually shows on screen
    
/**************************************************************/
/************** 100MHz to about 25MHz divider******************/
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
    
    wire [9:0] user_x;
    wire [9:0] user_y;

    user_sprite_controller user_ctl (
        .clk25(clk25),
        .btn_left(btn_left),
        .btn_right(btn_right),
        .btn_up(btn_up),
        .btn_down(btn_down),
        .sprite_x(user_x), // OUTPUT: change of position
        .sprite_y(user_y) // OUTPUT: change of position
    );

    
/********************************************************************/
/*********************** bullet controller **************************/
/********************************************************************/
    parameter BULLET_COUNT = 8; // maximum number of bullets in screen
    wire [9:0] bullet_x[0:BULLET_COUNT-1];
    wire [9:0] bullet_y[0:BULLET_COUNT-1];
    wire bullet_active [0:BULLET_COUNT-1];
    wire [10*BULLET_COUNT-1:0] bullet_x_flat, bullet_y_flat;
    wire [BULLET_COUNT-1:0] bullet_active_flat;
    wire [BULLET_COUNT - 1:0] bullet_hit;
    
   bullet_controller #(.BULLET_COUNT(BULLET_COUNT)) bullet_ctrl (
    .clk25(clk25),
    .btn_fire(btn_fire),
    .player_x(user_x),
    .player_y(user_y),
    .bullet_hit(bullet_hit),
    .bullet_x_flat(bullet_x_flat),
    .bullet_y_flat(bullet_y_flat),
    .bullet_active_flat(bullet_active_flat)
    );

    genvar b;
    generate
        for (b = 0; b < BULLET_COUNT; b = b + 1) begin : bullet_unpack
            assign bullet_x[b] = bullet_x_flat[b*10 +: 10];
            assign bullet_y[b] = bullet_y_flat[b*10 +: 10];
            assign bullet_active[b] = bullet_active_flat[b];
        end
    endgenerate

 
    



integer j, k;





/********************************************************************/
/***************************** GRAPHIC ******************************/
/********************************************************************/
    wire [2:0] user_rgb;
    wire [2:0] bullet_rgb [0:BULLET_COUNT - 1];
    wire bullet_valid [0:BULLET_COUNT - 1];
    wire user_valid;

    
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
    
/********************************************************************/
/****************************** FLY ********************************/
/********************************************************************/
parameter FLY_COUNT = 4;
wire [10*FLY_COUNT-1:0] fly_x_flat, fly_y_flat;
wire [FLY_COUNT-1:0] fly_alive;
wire [2:0] fly_rgb_final;
wire fly_any_valid;
// TODO: need to implement hit event->>buzzer or score
wire [FLY_COUNT-1:0] fly_hit;

fly_enemy_controller #(
    .FLY_COUNT(FLY_COUNT)
    ) fly_ctrl (
    .clk25(clk25),
    .bullet_x_flat(bullet_x_flat),
    .bullet_y_flat(bullet_y_flat),
    .bullet_active_flat(bullet_active_flat),
    .fly_x_flat(fly_x_flat),
    .fly_y_flat(fly_y_flat),
    .fly_alive(fly_alive),
    .fly_hit(fly_hit) // TODO: need to implement hit event
);

fly_sprite_drawer #(
    .FLY_COUNT(FLY_COUNT)
    ) fly_draw (
    .x(x), .y(y),
    .fly_x_flat(fly_x_flat),
    .fly_y_flat(fly_y_flat),
    .fly_alive(fly_alive),
    .fly_rgb_final(fly_rgb_final),
    .fly_any_valid(fly_any_valid)
);


/********************************************************************/
/****************************** MOSQUITO ********************************/
/********************************************************************/
// mosquito enemy
parameter MOSQUITO_COUNT = 12;
wire [10*MOSQUITO_COUNT-1:0] mosquito_x_flat, mosquito_y_flat;
wire [MOSQUITO_COUNT-1:0] mosquito_alive;
wire [2:0] mosquito_rgb_final;
wire mosquito_any_valid;

mosquito_enemy_controller #(.MOSQUITO_COUNT(MOSQUITO_COUNT)) mosquito_ctrl (
    .clk25(clk25),
    .bullet_x_flat(bullet_x_flat),
    .bullet_y_flat(bullet_y_flat),
    .bullet_active_flat(bullet_active_flat),
    .mosquito_x_flat(mosquito_x_flat),
    .mosquito_y_flat(mosquito_y_flat),
    .mosquito_alive(mosquito_alive)
);

mosquito_sprite_drawer #(
    .MOSQUITO_COUNT(MOSQUITO_COUNT)
    ) mosquito_drawer (
    .x(x), .y(y),
    .mosquito_x_flat(mosquito_x_flat),
    .mosquito_y_flat(mosquito_y_flat),
    .mosquito_alive(mosquito_alive),
    .mosquito_rgb_final(mosquito_rgb_final),
    .mosquito_any_valid(mosquito_any_valid)
);


/********************************************************************/
/************************* SPIDER(BOSS)******************************/
/********************************************************************/
wire [9:0] spider_x, spider_y;
wire spider_alive;
wire [2:0] spider_rgb;
wire spider_valid;

spider_enemy_controller spider_ctrl (
    .clk25(clk25),
    .enable(enable_spider),
    .bullet_x_flat(bullet_x_flat),
    .bullet_y_flat(bullet_y_flat),
    .bullet_active_flat(bullet_active_flat),
    .spider_x(spider_x),
    .spider_y(spider_y),
    .spider_alive(spider_alive)
);

spider_sprite_drawer spider_draw (
    .x(x), .y(y),
    .spider_x(spider_x),
    .spider_y(spider_y),
    .spider_alive(spider_alive),
    .rgb(spider_rgb),
    .valid(spider_valid)
);


/********************************************************************/
/*********************** STAGE CONTROLLER ***************************/
/********************************************************************/
wire [1:0] stage_state;

stage_controller stage_ctrl (
    .clk25(clk25),
    .fly_alive(fly_alive[FLY_COUNT*1-1:0]),
    .mosquito_alive(mosquito_alive[MOSQUITO_COUNT*1-1:0]),// 4-bit wire
    .stage_state(stage_state)
);

wire enable_spider = (stage_state == 2'b10); // STAGE_BOSS



/********************************************************************/
/****************************** BUZZ ********************************/
/********************************************************************/
wire buzz_signal;

game_bgm bgm_inst(.clk(clk), .reset(buzz_sw), .buzz(buzz_signal));
assign buzz = buzz_signal;


    
    
/********************************************************************/
/************************** GRAPHIC OUTPUT***************************/
/********************************************************************/
    wire [2:0] final_rgb = user_valid ? user_rgb : // priority user -> bullet -> enemy
                           any_bullet_valid ? bullet_rgb_final : 
                           spider_valid ? spider_rgb :
                           mosquito_any_valid ? mosquito_rgb_final :
                           fly_any_valid ? fly_rgb_final :
                           3'b000;
                           
    assign vga_r = video_on ? {4{final_rgb[2]}} : 4'b0000;
    assign vga_g = video_on ? {4{final_rgb[1]}} : 4'b0000;
    assign vga_b = video_on ? {4{final_rgb[0]}} : 4'b0000;
    
    
endmodule

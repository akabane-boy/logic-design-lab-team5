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
    input reset_enemy_sw, // for enemy test
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
    
    wire [9:0] user_x, user_y;
    user_sprite_controller user_ctl (
        .clk25(clk25),
        .btn_left(btn_left),
        .btn_right(btn_right),
        .btn_up(btn_up),
        .btn_down(btn_down),
        .sprite_x(user_x),
        .sprite_y(user_y)
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

 
    
/********************************************************************/
/****************************** ENEMY *******************************/
/********************************************************************/
// will add enemy_controller_module
parameter ENEMY_COUNT = 23;
wire [9:0] enemy_x [0:ENEMY_COUNT - 1];
wire [9:0] enemy_y [0:ENEMY_COUNT - 1];
wire enemy_alive [0:ENEMY_COUNT - 1];
wire [10*ENEMY_COUNT-1:0] enemy_x_flat;
wire [10*ENEMY_COUNT-1:0] enemy_y_flat;
wire [ENEMY_COUNT-1:0] enemy_alive_flat;
wire [ENEMY_COUNT-1:0] enemy_alive_out_flat;
wire [10*4-1:0] spider_x_flat, spider_y_flat;
wire [3:0] spider_alive_flat;
wire [10*17-1:0] fly_x_flat, fly_y_flat, fly_enemy_x_flat, fly_enemy_y_flat;
wire [16:0] fly_alive_flat, fly_enemy_alive_flat;
wire [10*2-1:0] mosquito_x_flat, mosquito_y_flat;
wire [1:0] mosquito_alive_flat;


enemy_controller #(
    .ENEMY_COUNT(ENEMY_COUNT),
    .BULLET_COUNT(BULLET_COUNT)
) enemy_ctrl1 (
    .clk25(clk25),
    .reset_fly(reset_fly),
    .reset_spider(reset_spider),
    .reset_mosquito(reset_mosquito),
    .bullet_x_flat(bullet_x_flat),
    .bullet_y_flat(bullet_y_flat),
    .bullet_active_flat(bullet_active_flat),
    .bullet_hit(bullet_hit),
    .enemy_x_flat(enemy_x_flat),
    .enemy_y_flat(enemy_y_flat),
    .enemy_alive_in_flat(enemy_alive_flat),
    .enemy_alive_out_flat(enemy_alive_out_flat)
);

genvar u;
generate
    for (u = 0; u < ENEMY_COUNT; u = u + 1) begin : enemy_unpack
        assign enemy_x[u] = enemy_x_flat[u*10 +: 10];
        assign enemy_y[u] = enemy_y_flat[u*10 +: 10];
        assign enemy_alive[u] = enemy_alive_out_flat[u]; // controller's output
    end
endgenerate

// fly
genvar f;
generate
    for (f = 0; f < 17; f = f + 1) begin
        assign enemy_x_flat[f*10 +: 10] = fly_enemy_x_flat[f*10 +: 10];
        assign enemy_y_flat[f*10 +: 10] = fly_enemy_y_flat[f*10 +: 10];
        assign enemy_alive_flat[f] = fly_enemy_alive_flat[f];
    end
endgenerate

// spider
genvar s;
generate
    for (s = 17; s <= 20; s = s + 1) begin
        assign enemy_x_flat[s*10 +: 10] = spider_x_flat[(s-17)*10 +: 10];
        assign enemy_y_flat[s*10 +: 10] = spider_y_flat[(s-17)*10 +: 10];
        assign enemy_alive_flat[s] = spider_alive_flat[s-17];
    end
endgenerate

// mosquito
assign enemy_x_flat[21*10 +: 10] = mosquito_x_flat[0 +: 10];
assign enemy_y_flat[21*10 +: 10] = mosquito_y_flat[0 +: 10];
assign enemy_alive_flat[21] = mosquito_alive_flat[0];

assign enemy_x_flat[22*10 +: 10] = mosquito_x_flat[10 +: 10];
assign enemy_y_flat[22*10 +: 10] = mosquito_y_flat[10 +: 10];
assign enemy_alive_flat[22] = mosquito_alive_flat[1];


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
    genvar z;
    generate
        for (z = 0; z < ENEMY_COUNT; z = z + 1) begin : enemy_sprite_gen
            if (z < 17) begin
                // Fly
                color_sprite_32 #(.MEM_FILE("enemy_sprite_data.mem")) fly_sprite (
                    .x(x), .y(y),
                    .sprite_x(enemy_x[z]), .sprite_y(enemy_y[z]),
                    .rgb(enemy_rgb[z]), .valid(enemy_valid[z])
                );
            end
            else if (z < 21) begin
                // Spider
                color_sprite_32 #(.MEM_FILE("enemy_sprite_data.mem")) spider_sprite (
                    .x(x), .y(y),
                    .sprite_x(enemy_x[z]), .sprite_y(enemy_y[z]),
                    .rgb(enemy_rgb[z]), .valid(enemy_valid[z])
                );
            end
            else begin
                // Mosquito
                color_sprite_32 #(.MEM_FILE("enemy_sprite_data.mem")) mosquito_sprite (
                    .x(x), .y(y),
                    .sprite_x(enemy_x[z]), .sprite_y(enemy_y[z]),
                    .rgb(enemy_rgb[z]), .valid(enemy_valid[z])
                );
            end

            assign draw_enemy[z] = enemy_alive[z] && enemy_valid[z];
        end
    endgenerate



    // ENEMY GENERATION
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


/***************************** SPIDER ******************************/
// SPIDER FLATTEN

// motion controller
spider_motion_controller spider_ctrl (
    .clk25(clk25),
    .reset_spider(reset_spider),
    .spider_x_flat(spider_x_flat),
    .spider_y_flat(spider_y_flat),
    .spider_alive_flat(spider_alive_flat)
);



/***************************** FLY ******************************/
// FLY FLATTEN

// movement
fly_enemy_controller fly_ctrl (
    .clk25(clk25),
    .reset_fly(reset_fly),
    .fly_x_flat(fly_x_flat),
    .fly_y_flat(fly_y_flat),
    .fly_alive_flat(fly_alive_flat)
);



/***************************** MOSQUITO ******************************/
// MOSQUITO FLATTEN

// motion controller
mosquito_motion_controller mosquito_ctrl (
    .clk25(clk25),
    .reset_mosquito(reset_mosquito), 
    .mosquito_x_flat(mosquito_x_flat),
    .mosquito_y_flat(mosquito_y_flat),
    .mosquito_alive_flat(mosquito_alive_flat)
);




/********************************************************************/
/****************************** BUZZ ********************************/
/********************************************************************/
wire buzz_signal;

game_bgm bgm_inst(.clk(clk), .reset(reset_enemy_sw), .buzz(buzz_signal));
assign buzz = buzz_signal;
    

    
    
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

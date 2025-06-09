`timescale 1ns / 1ps

module spider_sprite_drawer (
    input [9:0] x, y,
    input [9:0] spider_x, spider_y,
    input spider_alive,

    output [2:0] rgb,
    output valid
);

    wire [2:0] sprite_rgb;
    wire sprite_valid;

    color_sprite_64 #(.MEM_FILE("spider_sprite_data.mem")) sprite (
        .x(x), .y(y),
        .sprite_x(spider_x),
        .sprite_y(spider_y),
        .rgb(sprite_rgb),
        .valid(sprite_valid)
    );

    assign rgb   = (spider_alive && sprite_valid) ? sprite_rgb : 3'b000;
    assign valid = (spider_alive && sprite_valid);

endmodule
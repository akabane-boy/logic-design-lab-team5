`timescale 1ns / 1ps

module fly_sprite_drawer #(
    parameter FLY_COUNT = 16
)(
    input [9:0] x, y, 
    input [10*FLY_COUNT-1:0] fly_x_flat,
    input [10*FLY_COUNT-1:0] fly_y_flat,
    input [FLY_COUNT-1:0] fly_alive,

    output [2:0] fly_rgb_final,
    output fly_any_valid
);

    wire [9:0] fly_x[0:FLY_COUNT-1];
    wire [9:0] fly_y[0:FLY_COUNT-1];
    wire [2:0] fly_rgb[0:FLY_COUNT-1];
    wire fly_valid[0:FLY_COUNT-1];
    wire draw_fly[0:FLY_COUNT-1];

    genvar i;
    generate
        for (i = 0; i < FLY_COUNT; i = i + 1) begin : unpack
            assign fly_x[i] = fly_x_flat[i*10 +: 10];
            assign fly_y[i] = fly_y_flat[i*10 +: 10];
        end
    endgenerate

    generate
        for (i = 0; i < FLY_COUNT; i = i + 1) begin : draw
            color_sprite_32 #(.MEM_FILE("enemy_sprite_data.mem")) sprite (
                .x(x), .y(y),
                .sprite_x(fly_x[i]),
                .sprite_y(fly_y[i]),
                .rgb(fly_rgb[i]),
                .valid(fly_valid[i])
            );
            assign draw_fly[i] = fly_alive[i] && fly_valid[i];
        end
    endgenerate

    reg [2:0] result_rgb = 3'b000;
    reg valid = 0;
    integer k;
    always @(*) begin
        result_rgb = 3'b000;
        valid = 0;
        for (k = 0; k < FLY_COUNT; k = k + 1) begin
            if (draw_fly[k] && !valid) begin
                result_rgb = fly_rgb[k];
                valid = 1;
            end
        end
    end

    assign fly_rgb_final = result_rgb;
    assign fly_any_valid = valid;

endmodule

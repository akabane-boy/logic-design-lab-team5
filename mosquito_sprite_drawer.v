`timescale 1ns / 1ps

module mosquito_sprite_drawer #(
    parameter MOSQUITO_COUNT = 4
)(
    input [9:0] x, y,
    input [10*MOSQUITO_COUNT-1:0] mosquito_x_flat,
    input [10*MOSQUITO_COUNT-1:0] mosquito_y_flat,
    input [MOSQUITO_COUNT-1:0] mosquito_alive,

    output [2:0] mosquito_rgb_final,
    output mosquito_any_valid
);

    wire [9:0] mosquito_x[0:MOSQUITO_COUNT-1];
    wire [9:0] mosquito_y[0:MOSQUITO_COUNT-1];
    wire [2:0] mosquito_rgb[0:MOSQUITO_COUNT-1];
    wire mosquito_valid[0:MOSQUITO_COUNT-1];
    wire draw_mosquito[0:MOSQUITO_COUNT-1];

    genvar i;
    generate
        for (i = 0; i < MOSQUITO_COUNT; i = i + 1) begin : unpack
            assign mosquito_x[i] = mosquito_x_flat[i*10 +: 10];
            assign mosquito_y[i] = mosquito_y_flat[i*10 +: 10];
        end
    endgenerate

    generate
        for (i = 0; i < MOSQUITO_COUNT; i = i + 1) begin : draw
            color_sprite_32 #(.MEM_FILE("mosquito_sprite_data.mem")) sprite (
                .x(x), .y(y),
                .sprite_x(mosquito_x[i]),
                .sprite_y(mosquito_y[i]),
                .rgb(mosquito_rgb[i]),
                .valid(mosquito_valid[i])
            );
            assign draw_mosquito[i] = mosquito_alive[i] && mosquito_valid[i];
        end
    endgenerate

    reg [2:0] result_rgb = 3'b000;
    reg valid = 0;
    integer k;
    always @(*) begin
        result_rgb = 3'b000;
        valid = 0;
        for (k = 0; k < MOSQUITO_COUNT; k = k + 1) begin
            if (draw_mosquito[k] && !valid) begin
                result_rgb = mosquito_rgb[k];
                valid = 1;
            end
        end
    end

    assign mosquito_rgb_final = result_rgb;
    assign mosquito_any_valid = valid;

endmodule

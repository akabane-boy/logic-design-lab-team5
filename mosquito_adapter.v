`timescale 1ns / 1ps

module mosquito_to_enemy_adapter (
    input  [9:0] mosquito_x [0:1],
    input  [9:0] mosquito_y [0:1],
    input        mosquito_alive [0:1],

    output reg [9:0] enemy_x [21:22],
    output reg [9:0] enemy_y [21:22],
    output reg       enemy_alive [21:22]
);

    always @(*) begin
        enemy_x[21] = mosquito_x[0];
        enemy_y[21] = mosquito_y[0];
        enemy_alive[21] = mosquito_alive[0];

        enemy_x[22] = mosquito_x[1];
        enemy_y[22] = mosquito_y[1];
        enemy_alive[22] = mosquito_alive[1];
    end

endmodule

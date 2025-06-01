module mosquito_to_enemy_adapter (
    input  [10*2-1:0] mosquito_x_flat,
    input  [10*2-1:0] mosquito_y_flat,
    input  [1:0]      mosquito_alive_flat,

    output reg [10*2-1:0] enemy_x_flat,
    output reg [10*2-1:0] enemy_y_flat,
    output reg [1:0]      enemy_alive_flat
);
    integer i;
    always @(*) begin
        for (i = 0; i < 2; i = i + 1) begin
            enemy_x_flat[i*10 +: 10] = mosquito_x_flat[i*10 +: 10];
            enemy_y_flat[i*10 +: 10] = mosquito_y_flat[i*10 +: 10];
            enemy_alive_flat[i]      = mosquito_alive_flat[i];
        end
    end
endmodule

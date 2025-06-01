module spider_to_enemy_adapter (
    input  [10*4-1:0] spider_x_flat,
    input  [10*4-1:0] spider_y_flat,
    input  [3:0]      spider_alive_flat,

    output reg [10*4-1:0] enemy_x_flat,
    output reg [10*4-1:0] enemy_y_flat,
    output reg [3:0]      enemy_alive_flat
);
    integer i;
    always @(*) begin
        for (i = 0; i < 4; i = i + 1) begin
            enemy_x_flat[i*10 +: 10] = spider_x_flat[i*10 +: 10];
            enemy_y_flat[i*10 +: 10] = spider_y_flat[i*10 +: 10];
            enemy_alive_flat[i]      = spider_alive_flat[i];
        end
    end
endmodule

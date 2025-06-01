module fly_to_enemy_adapter (
    input  [10*17-1:0] fly_x_flat,
    input  [10*17-1:0] fly_y_flat,
    input  [16:0]      fly_alive_flat,

    output reg [10*17-1:0] enemy_x_flat,
    output reg [10*17-1:0] enemy_y_flat,
    output reg [16:0]      enemy_alive_flat
);
    integer i;
    always @(*) begin
        for (i = 0; i < 17; i = i + 1) begin
            enemy_x_flat[i*10 +: 10] = fly_x_flat[i*10 +: 10];
            enemy_y_flat[i*10 +: 10] = fly_y_flat[i*10 +: 10];
            enemy_alive_flat[i]      = fly_alive_flat[i];
        end
    end
endmodule


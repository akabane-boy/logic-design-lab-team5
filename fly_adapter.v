module fly_to_enemy_adapter (
    input  [9:0] fly_x [0:16],
    input  [9:0] fly_y [0:16],
    input        fly_alive [0:16],
    
    output reg [9:0] enemy_x [0:16],
    output reg [9:0] enemy_y [0:16],
    output reg       enemy_alive [0:16]
);
    integer i;
    always @(*) begin
        for (i = 0; i < 17; i = i + 1) begin
            enemy_x[i] = fly_x[i];
            enemy_y[i] = fly_y[i];
            enemy_alive[i] = fly_alive[i];
        end
    end
endmodule

`timescale 1ns / 1ps

module spider_to_enemy_adapter (
    input  [9:0] spider_x [0:3],
    input  [9:0] spider_y [0:3],
    input        spider_alive [0:3],
    
  output reg [9:0] enemy_x [17:20],  // spider → enemy 17~20
    output reg [9:0] enemy_y [17:20],
    output reg       enemy_alive [17:20]
);
    integer i;
    always @(*) begin
        for (i = 0; i < 4; i = i + 1) begin
            enemy_x[17 + i] = spider_x[i];
            enemy_y[17 + i] = spider_y[i];
            enemy_alive[17 + i] = spider_alive[i];
        end
    end
endmodule

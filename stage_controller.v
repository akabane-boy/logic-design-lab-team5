// creating stage
module stage_controller (
    input [7:0] seconds,
    output reg [22:0] enable_enemy
);
    always @(*) begin
        enable_enemy = 23'b0;
        if (seconds >= 0)  enable_enemy[0 +: 17] = 17'b11111111111111111; // 0secs~ -> Fly
        if (seconds >= 10) enable_enemy[17 +: 4] = 4'b1111;               // 10secs~ -> Spider
        if (seconds >= 20) enable_enemy[21 +: 2] = 2'b11;                 // 20secs~ -> Mosquito
    end
endmodule

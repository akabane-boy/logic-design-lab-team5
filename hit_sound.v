module kill_sound #(
    parameter clk_100Mhz = 100_000_000
)(
    input clk,
    input reset,
    input hit,        
    output buzz        
);

    
    localparam Do_div   = clk_100Mhz / 523 / 2;
    localparam Bb_div   = clk_100Mhz / 466 / 2;
    localparam Sol_div  = clk_100Mhz / 392 / 2;

    wire clk_Do, clk_Bb, clk_Sol;
    clock_divider #(Do_div)  div_do(clk, reset, clk_Do);
    clock_divider #(Bb_div)  div_bb(clk, reset, clk_Bb);
    clock_divider #(Sol_div) div_sol(clk, reset, clk_Sol);

    reg [1:0] state;
    reg [21:0] dur_cnt;
    reg playing;
    reg buzz_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            dur_cnt <= 0;
            playing <= 0;
            buzz_reg <= 0;
        end else begin
            if (hit && !playing) begin
                playing <= 1;
                state <= 0;
                dur_cnt <= 0;
            end

            if (playing) begin
                dur_cnt <= dur_cnt + 1;

                if (dur_cnt >= 800_000) begin 
                    dur_cnt <= 0;
                    state <= state + 1;
                    if (state == 2) begin
                        playing <= 0;
                        buzz_reg <= 0;
                    end
                end
            end
        end
    end

    always @(*) begin
        case (state)
            2'd0: buzz_reg = clk_Do;
            2'd1: buzz_reg = clk_Bb;
            2'd2: buzz_reg = clk_Sol;
            default: buzz_reg = 0;
        endcase
    end

    assign buzz = buzz_reg;
endmodule

module clock_divider #(
    parameter div = 49999999
)(
    input clk_in,
    input reset,
    output reg clk_out
);
    reg [25:0] q;

    always @(posedge clk_in) begin
        if (reset) begin
            q <= 0;
            clk_out <= 0;
        end else if (q == div) begin
            clk_out <= ~clk_out;
            q <= 0;
        end else begin
            q <= q + 1;
        end
    end
endmodule

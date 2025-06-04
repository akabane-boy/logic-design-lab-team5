module fire_sound #(
    parameter clk_100Mhz = 100_000_000
)(
    input clk,
    input reset,
    input fire,         
    output buzz         
);
    
    localparam Sol_div = clk_100Mhz / 783 / 2;
    localparam La_div  = clk_100Mhz / 880 / 2;

  
    wire clk_Sol, clk_La;
    clock_divider #(Sol_div) div_sol(clk, reset, clk_Sol);
    clock_divider #(La_div)  div_la(clk, reset, clk_La);

    // 재생 상태
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
            if (fire && !playing) begin
                playing <= 1;
                state <= 0;
                dur_cnt <= 0;
            end

            if (playing) begin
                dur_cnt <= dur_cnt + 1;

                if (dur_cnt >= 1_000_000) begin  
                    dur_cnt <= 0;
                    state <= state + 1;
                    if (state == 1) begin
                        playing <= 0;
                        buzz_reg <= 0;
                    end
                end
            end
        end
    end

    
    always @(*) begin
        case (state)
            2'd0: buzz_reg = clk_Sol;
            2'd1: buzz_reg = clk_La;
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

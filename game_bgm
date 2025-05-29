module game_bgm #(
    parameter clk_100Mhz = 26'd100_000_000
)(
    input clk, reset,
    output buzz
);
    
    localparam Do_hz = clk_100Mhz / 27'd523 / 2;
    localparam Re_hz = clk_100Mhz / 27'd587 / 2;
    localparam Mi_hz = clk_100Mhz / 27'd659 / 2;
    localparam Fa_hz = clk_100Mhz / 27'd698 / 2;
    localparam Sol_hz = clk_100Mhz / 27'd783 / 2;
    localparam La_hz = clk_100Mhz / 27'd880 / 2;

    wire clk_Do, clk_Re, clk_Mi, clk_Fa, clk_Sol, clk_La;
    clock_divider #(Do_hz) div0(clk, reset, clk_Do);
    clock_divider #(Re_hz) div1(clk, reset, clk_Re);
    clock_divider #(Mi_hz) div2(clk, reset, clk_Mi);
    clock_divider #(Fa_hz) div3(clk, reset, clk_Fa);
    clock_divider #(Sol_hz) div4(clk, reset, clk_Sol);
    clock_divider #(La_hz) div5(clk, reset, clk_La);

    reg [2:0] melody [0:13];
    initial begin
        melody[0] = 3'd0; 
        melody[1] = 3'd0; 
        melody[2] = 3'd4; 
        melody[3] = 3'd4; 
        melody[4] = 3'd5; 
        melody[5] = 3'd5; 
        melody[6] = 3'd4; 
        melody[7] = 3'd3; 
        melody[8] = 3'd3; 
        melody[9] = 3'd2; 
        melody[10] = 3'd2; 
        melody[11] = 3'd1; 
        melody[12] = 3'd1; 
        melody[13] = 3'd0; 
    end

     reg [3:0] state;
    reg [31:0] tone_cnt;
    wire [31:0] tone_duration = clk_100Mhz / 2;  

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            tone_cnt <= 0;
        end else begin
            if (tone_cnt < tone_duration)
                tone_cnt <= tone_cnt + 1;
            else begin
                tone_cnt <= 0;
                state <= (state == 13) ? 0 : state + 1;
            end
        end
    end

    reg buzz_reg;
    always @(*) begin
        case (melody[state])
            3'd0: buzz_reg = clk_Do;
            3'd1: buzz_reg = clk_Re;
            3'd2: buzz_reg = clk_Mi;
            3'd3: buzz_reg = clk_Fa;
            3'd4: buzz_reg = clk_Sol;
            3'd5: buzz_reg = clk_La;
            default: buzz_reg = 0;
        endcase
    end

    assign buzz = buzz_reg;

endmodule

module clock_divider #(
    parameter div = 49999999   
    )(
    input clk_in, reset,              
    output reg clk_out         
    );
    
    reg [25:0] q;              

    always @(posedge clk_in) begin
        if(reset) begin
            q <= 0;
            clk_out <= 0;
        end
        else if (q == div) begin
            clk_out <= ~clk_out;  
            q <= 0;               
        end
        else begin
            q <= q + 1;           
        end
    end
endmodule

       

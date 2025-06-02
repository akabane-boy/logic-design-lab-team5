// creating seconds from clk25
module game_timer (
    input clk25,
    input reset,
    output reg [7:0] seconds // OUTPUTS: seconds
);
    reg [24:0] counter;

    always @(posedge clk25) begin
        if (reset) begin
            counter <= 0;
            seconds <= 0;
        end else begin
            if (counter == 25_000_000 - 1) begin
                counter <= 0;
                seconds <= seconds + 1;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule

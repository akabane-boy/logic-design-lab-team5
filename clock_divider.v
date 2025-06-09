module clock_divider #(
    parameter div = 49_999_999
)(
    input  wire clk_in,
    input  wire reset,
    output reg  clk_out
);
    reg [25:0] counter;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 26'd0;
            clk_out <= 1'b0;
        end else if (counter >= div) begin
            counter <= 26'd0;
            clk_out <= ~clk_out;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule
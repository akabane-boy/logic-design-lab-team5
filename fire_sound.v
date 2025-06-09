// 원래 fire_sound 모듈로 롤백 (playing 신호 제거)
module fire_sound #(
    parameter clk_100Mhz  = 100_000_000,  // 시스템 클럭 주파수
    parameter NOTE_PERIOD = clk_100Mhz/20  // 한 음 재생 길이 (약 50 ms)
)(
    input  wire clk,
    input  wire reset,
    input  wire fire,       // 발사 신호 입력
    output wire buzz        // 버저 출력
);

    // 음계 주파수 분주 비율
    localparam Sol_div = clk_100Mhz / 783 / 2;  // 솔 음
    localparam La_div  = clk_100Mhz / 880 / 2;  // 라 음

    // 분주기 신호
    wire clk_Sol, clk_La;
    clock_divider #(.div(Sol_div)) div_sol(clk, reset, clk_Sol);
    clock_divider #(.div(La_div))  div_la(clk, reset, clk_La);

    // 재생 제어용 레지스터
    reg        playing_r;
    reg [1:0]  state;
    reg [31:0] dur_cnt;

    // fire 신호 감지 및 재생 타이밍 제어
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            playing_r <= 1'b0;
            state     <= 2'd0;
            dur_cnt   <= 32'd0;
        end else begin
            // fire 발생 시 재생 시작 (one-shot)
            if (fire && !playing_r) begin
                playing_r <= 1'b1;
                state     <= 2'd0;
                dur_cnt   <= 32'd0;
            end

            // 재생 중이라면 카운트 및 상태 전환
            if (playing_r) begin
                dur_cnt <= dur_cnt + 1;
                if (dur_cnt >= NOTE_PERIOD) begin
                    dur_cnt <= 32'd0;
                    if (state == 2'd1) begin
                        playing_r <= 1'b0;  // 두 번째 음 후 재생 종료
                    end else begin
                        state <= state + 1;
                    end
                end
            end
        end
    end

    // combinational 로직: 현재 state에 맞는 tone 선택
    reg buzz_tone;
    always @(*) begin
        if (!playing_r) begin
            buzz_tone = 1'b0;
        end else begin
            case (state)
                2'd0: buzz_tone = clk_Sol;  // 첫 음: 솔
                2'd1: buzz_tone = clk_La;   // 두 번째 음: 라
                default: buzz_tone = 1'b0;
            endcase
        end
    end

    assign buzz = buzz_tone;
endmodule

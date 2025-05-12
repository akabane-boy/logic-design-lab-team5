module top(
    input clk,              // 100MHz 시스템 클럭
    input left_btn,         // 왼쪽 이동 버튼
    input right_btn,        // 오른쪽 이동 버튼
    output [3:0] vga_r,
    output [3:0] vga_g,
    output [3:0] vga_b,
    output vga_hs,
    output vga_vs
);

    wire clk25;
    wire [9:0] x, y;
    wire video_on;
    wire [11:0] pixel_color;

    // 클럭 분주기: 100MHz → 25MHz
    clk_divider div(
        .clk(clk),
        .clk_out(clk25)
    );

    // VGA 좌표 생성기
    vga_controller vga(
        .clk(clk25),
        .x(x),
        .y(y),
        .video_on(video_on),
        .hs(vga_hs),
        .vs(vga_vs)
    );

    // 게임 로직 (플레이어 이동 + 색상 출력)
    game_logic game(
        .clk(clk25),
        .left(left_btn),
        .right(right_btn),
        .x(x),
        .y(y),
        .video_on(video_on),
        .pixel_color(pixel_color)
    );

    // RGB 색상 출력
    assign vga_r = pixel_color[11:8];
    assign vga_g = pixel_color[7:4];
    assign vga_b = pixel_color[3:0];

endmodule

module clk_divider(
    input clk,
    output reg clk_out
);
    reg [1:0] count = 0;

    always @(posedge clk) begin
        count <= count + 1;
        clk_out <= count[1];
    end
endmodule

module vga_controller(
    input clk,
    output reg [9:0] x = 0,
    output reg [9:0] y = 0,
    output reg video_on,
    output reg hs,
    output reg vs
);

    parameter H_VISIBLE = 640;
    parameter H_FRONT   = 16;
    parameter H_SYNC    = 96;
    parameter H_BACK    = 48;
    parameter H_TOTAL   = 800;

    parameter V_VISIBLE = 480;
    parameter V_FRONT   = 10;
    parameter V_SYNC    = 2;
    parameter V_BACK    = 33;
    parameter V_TOTAL   = 525;

    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;

    always @(posedge clk) begin
        // 수평 카운터 증가
        if (h_count == H_TOTAL - 1) begin
            h_count <= 0;
            // 수직 카운터 증가
            if (v_count == V_TOTAL - 1)
                v_count <= 0;
            else
                v_count <= v_count + 1;
        end else begin
            h_count <= h_count + 1;
        end

        x <= h_count;
        y <= v_count;

        hs <= ~(h_count >= H_VISIBLE + H_FRONT &&
                h_count <  H_VISIBLE + H_FRONT + H_SYNC);
        vs <= ~(v_count >= V_VISIBLE + V_FRONT &&
                v_count <  V_VISIBLE + V_FRONT + V_SYNC);

        video_on <= (h_count < H_VISIBLE && v_count < V_VISIBLE);
    end
endmodule

module game_logic(
    input clk,
    input left, right, up, down,
    input [9:0] x, y,
    input video_on,
    output reg [11:0] pixel_color
);

    // 플레이어 초기 위치: 화면 중앙
    reg [9:0] player_x = 304; // (640 - 32) / 2
    reg [9:0] player_y = 224; // (480 - 32) / 2

    parameter PLAYER_WIDTH  = 32;
    parameter PLAYER_HEIGHT = 32;

    // 이전 버튼 상태 저장 (edge 감지용)
    reg left_prev = 0, right_prev = 0;
    reg up_prev = 0, down_prev = 0;

    wire left_edge  = ~left_prev  & left;
    wire right_edge = ~right_prev & right;
    wire up_edge    = ~up_prev    & up;
    wire down_edge  = ~down_prev  & down;

    always @(posedge clk) begin
        // 버튼 상태 업데이트
        left_prev  <= left;
        right_prev <= right;
        up_prev    <= up;
        down_prev  <= down;

        // 위치 업데이트 (화면 경계 체크 포함)
        if (left_edge  && player_x > 0)
            player_x <= player_x - 1;
        else if (right_edge && player_x < 640 - PLAYER_WIDTH)
            player_x <= player_x + 1;

        if (up_edge && player_y > 0)
            player_y <= player_y - 1;
        else if (down_edge && player_y < 480 - PLAYER_HEIGHT)
            player_y <= player_y + 1;
    end

    // 픽셀 색상 출력
    always @(*) begin
        if (!video_on)
            pixel_color = 12'h000;
        else if (x >= player_x && x < player_x + PLAYER_WIDTH &&
                 y >= player_y && y < player_y + PLAYER_HEIGHT)
            pixel_color = 12'h0F0; // 초록 사각형
        else
            pixel_color = 12'h000; // 검정 배경
    end
endmodule

module game_logic(
    input clk,
    input left, right,
    input [9:0] x, y,
    input video_on,
    output reg [11:0] pixel_color
);

    reg [9:0] player_x = 304; // 중앙: (640 - 32)/2
    parameter PLAYER_WIDTH  = 32;
    parameter PLAYER_HEIGHT = 32;
    parameter PLAYER_Y      = 224;

    reg left_prev = 0;
    reg right_prev = 0;

    wire left_edge  = ~left_prev & left;
    wire right_edge = ~right_prev & right;

    // 버튼 edge 감지 및 이동
    always @(posedge clk) begin
        left_prev  <= left;
        right_prev <= right;

        if (left_edge && player_x > 0)
            player_x <= player_x - 1;
        else if (right_edge && player_x < 640 - PLAYER_WIDTH)
            player_x <= player_x + 1;
    end

    // 색상 출력 조건
    always @(*) begin
        if (!video_on)
            pixel_color = 12'h000;
        else if (x >= player_x && x < player_x + PLAYER_WIDTH &&
                 y >= PLAYER_Y && y < PLAYER_Y + PLAYER_HEIGHT)
            pixel_color = 12'h0F0; // 초록 사각형
        else
            pixel_color = 12'h000; // 검정 배경
    end
endmodule


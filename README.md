# Galaga Game on FPGA
Term Project for SKKU Logic Design Lab ICE2005 (Galaga style game) 2025-1

A simplified **Galaga-style shooting game** designed and implemented using **Verilog HDL** on an **FPGA development board**.

## Contribution (for report)
- 그래픽 및 사운드 담당자: 박지훈
- 로직 담당자: 유호선
- 입력 및 통합 담당자: 김범수

### 5/26
함께 스터디 후, 기초 코드 작성

(vga_test.v, vga_controller.v, user_controller.v)

파트 분배

### 6/2
박지훈: color_sprite8.v, color_sprite16.v, color_sprite32.v, *.mem 및 game_bgm.v파일 작성

유호선: user_controller.v, bullet_controller.v, fly_enemy_controller.v 작성

김범수: vga_test.v 및 vga 출력, 파일 통합 및 작동 확인 후 피드백

### 6/9
박지훈: fly_sprite_drawer.v, mosquito_sprite_drawer.v, spider_sprite_drawer.v, bullet_sound.v, hit_sound.v 작성

유호선: stage_controller.v, star_controller.v 작성

김범수: vga_test.v 및 vga 출력, 파일 통합 및 작동 확인 후 피드백

## 완료한 것들
### ✅ Term Project Requirements (Mandatory)

- Player can move horizontally (controlled by push buttons or DIP switches).
- Player can fire bullets.
- Enemies appear and move (simple downward or patterned movement).
- Bullets can hit and eliminate enemies.
- One player, one type of enemy, and a single bullet instance.

### ⭐ Bonus Credits (Optional)

- Graphic Quality
- Player can move vertically or diagonally
- Multiple enemy/bullet types or movement patterns
- Multiple game stages or boss enemies
- Basic sound effects (using buzzer)

 ## 완료 못한 것들

- Score display (using 7-segment LEDs or VGA text rendering)
- Two or multi player mode

## 📺 Display

- The game **must display on a monitor via a VGA connection**.

## 🎮 Input & Interaction

- Uses **FPGA hardware** (e.g., push buttons or DIP switches) to receive input from the **user**.

---

## ✅ Term Project Requirements (Mandatory)

- Player can move horizontally (controlled by push buttons or DIP switches).
- Player can fire bullets.
- Enemies appear and move (simple downward or patterned movement).
- Bullets can hit and eliminate enemies.
- One player, one type of enemy, and a single bullet instance.

---

## ⭐ Bonus Credits (Optional)

- Graphic Quality
- Player can move vertically or diagonally
- Two or multi player mode
- Multiple enemy/bullet types or movement patterns
- Score display (using 7-segment LEDs or VGA text rendering)
- Multiple game stages or boss enemies
- Basic sound effects (using buzzer)

---

## 🧰 Hardware Specification

- **FPGA**: 75,520 Logic Cell Xilinx Artix-7 Series XC7A75T FPGA Device
- **Programming Interface**: USB to JTAG Module (connect without JTAG cable)
- **Display & Indicators**:
  - 16x2 Character LCD
  - 7-Segment Display (8 digits)
  - 16-bit LED Display
- **Output**:
  - RGB VGA Port
  - Piezo Buzzer
- **Input**:
  - Push Buttons: 6 EA
  - DIP Switches: 16 EA
- **Memory**:
  - 256MB DDR3 SDRAM
  - 128KB SRAM
  - 128B I2C EEPROM
  - 128B SPI EEPROM
- **Other Interfaces**:
  - PMOD 3 Port
  - Xilinx XADC Header
  - FMC LPC Connector
 
---

## 🛠 Development

### Tools & Hardware
- FPGA Development Board (e.g., DE10-Lite, Nexys A7, etc.)
- VGA Monitor and Cable
- Push buttons / DIP switches
- Verilog HDL
- Optional: Buzzer, 7-segment display

---


## Weekly report (for attendance check)
•Report project status within 1 pages 
•Upload i-Campus / Individual submission

1) Due 5/26 ~ 23:59
- Briefly introduce project topic / individual contribution
2) Due 6/2 ~ 23:59
- Briefly report implementation status / individual contribution
3) Due 6/9 ~ 23:59
- Briefly report implementation status / individual contribution

# Galaga Game on FPGA
Term Project for SKKU Logic Design Lab ICE2005 (Galaga style game) 2025-1

A simplified **Galaga-style shooting game** designed and implemented using **Verilog HDL** on an **FPGA development board**.

## 참고사항
git 사용에 능숙하시면 브랜치를 만들어서 작업하시면 되고, git 배워서 하기 너무 귀찮다 하시면 아래에 있는대로 하시면 됩니다.
1. upload-here를 제외한 파일을 다운로드 한다.
2. 자신의 vivado src가 있는 폴더에 옮긴다.
3. 코드 작성한다. 자신이 수정, 작성한 파일이 무엇인지 인지 필수.
4. github에서 자신이 수정한 파일에 들어가서 코드를 다 지우고 자신이 작성한 코드를 모두 복사, 붙여넣기 후 commit한다. 새로 생성한 파일이 있을 경우 add file로 추가한다.
5. FPGA로 자신이 확인 불가한 경우, 완료했다고 FPGA를 가지고 있는 사람에게 알린다.
6. 확인 후 수정사항 등, 전달한다.
7. 반복!

## Contribution (for report)
- 그래픽 담당자: *_sprite.v, vga_test.v(graphic part), *.mem 등
- 로직 담당자: *_controller.v 등
- 입력 및 통합 담당자: vga_test.v, vga_controller.v 등

### 5/26
어떤 것을 작업했는지 파트별로 분류 필요. ("사실과 다르더라도" 균등하게 배분)
### 6/2
### 6/9

## Milestone
  ### 박지훈
 - [ ] Score display (using 7-segment LEDs or VGA text rendering)
 - [ ] Basic sound effects (using buzzer)

  ### 김범수
 - [ ] Two or multi player mode
 - [ ] Multiple game stages or boss enemies

  ### 유호선
 - [ ] Multiple enemy/bullet types or movement patterns
 - [ ] Player can move vertically or diagonally

  ### 다같이
 - [ ] Graphic Quality



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

## 📂 Project Structure
Not yet.


---

## 🤝 Team Members

- `@akabane-boy` (e.g., system integration, VGA display)
- `@nanhosun` (e.g., player & bullet logic)
- `@another-id` (e.g., enemy behavior, sound effects)


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

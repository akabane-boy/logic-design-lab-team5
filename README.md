# Galaga Game on FPGA
Term Project for SKKU Logic Design Lab ICE2005 (Galaga style game)

A simplified **Galaga-style shooting game** designed and implemented using **Verilog HDL** on an **FPGA development board**.

## Contribution
  ### 박지훈
 - [ ] Score display (using 7-segment LEDs or VGA text rendering)
 - [ ] Basic sound effects (using buzzer)

  ### 김범수

  ### 유호선

  ### 다같이
 - [ ] Graphic Quality
	마지막

 - [ ] Player can move vertically or diagonally
	쉬움
 - [ ] Two or multi player mode
	중간

 - [ ] Multiple enemy/bullet types or movement patterns
	어려움

 - [ ] Multiple game stages or boss enemies
	어려움


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

### Suggested Branch Strategy
- `main`: stable and working version
- `feature/*`: feature development branches
- `bugfix/*`: bug fix branches
- `docs`: documentation updates

---

## 📂 Project Structure
Not yet.


---

## 🤝 Team Members

- `@akabane-boy` (e.g., system integration, VGA display)
- `@nanhosun` (e.g., player & bullet logic)
- `@another-id` (e.g., enemy behavior, sound effects)

---

## 📅 Milestones

- [ ] VGA Display Test
- [ ] Player Movement
- [ ] Bullet Generation & Collision
- [ ] Enemy Movement
- [ ] Final Integration

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

# Galaga Game on FPGA
Term Project for SKKU Logic Design Lab ICE2005 (Galaga style game)


A simplified **Galaga-style shooting game** designed and implemented using **Verilog HDL** on an **FPGA development board**.

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

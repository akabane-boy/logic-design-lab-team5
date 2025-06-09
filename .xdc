# for debugging LED
set_property PACKAGE_PIN Y18 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN AA18 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN AB18 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN W19 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property PACKAGE_PIN Y19 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property PACKAGE_PIN AA19 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property PACKAGE_PIN W20 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property PACKAGE_PIN AA20 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]

# for buzzer
set_property PACKAGE_PIN V22 [get_ports buzz_sw]
set_property IOSTANDARD LVCMOS33 [get_ports buzz_sw]

# for reset stage
set_property PACKAGE_PIN U21 [get_ports stage_rst]
set_property IOSTANDARD LVCMOS33 [get_ports stage_rst]

# reset fly
set_property PACKAGE_PIN R19 [get_ports reset_fly]
set_property IOSTANDARD LVCMOS33 [get_ports reset_fly]

# reset mosquito
set_property PACKAGE_PIN V19 [get_ports reset_mosquito]
set_property IOSTANDARD LVCMOS33 [get_ports reset_mosquito]

# reset spider
set_property PACKAGE_PIN T20 [get_ports reset_spider]
set_property IOSTANDARD LVCMOS33 [get_ports reset_spider]

# clock
set_property PACKAGE_PIN R4 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

create_clock -period 10.000 -name sys_clk -waveform {0 5} [get_ports clk]


# VGA Horizontal Sync
set_property PACKAGE_PIN K22 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]

# VGA Vertical Sync
set_property PACKAGE_PIN K21 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]

# VGA Red - 4 bits
set_property PACKAGE_PIN H17 [get_ports vga_r[3]]
set_property IOSTANDARD LVCMOS33 [get_ports vga_r[3]]
set_property PACKAGE_PIN G17 [get_ports vga_r[2]]
set_property IOSTANDARD LVCMOS33 [get_ports vga_r[2]]
set_property PACKAGE_PIN H18 [get_ports vga_r[1]]
set_property IOSTANDARD LVCMOS33 [get_ports vga_r[1]]
set_property PACKAGE_PIN G18 [get_ports vga_r[0]]
set_property IOSTANDARD LVCMOS33 [get_ports vga_r[0]]

# VGA Green - 4 bits
set_property PACKAGE_PIN J19 [get_ports vga_g[3]]
set_property IOSTANDARD LVCMOS33 [get_ports vga_g[3]]
set_property PACKAGE_PIN H19 [get_ports vga_g[2]]
set_property IOSTANDARD LVCMOS33 [get_ports vga_g[2]]
set_property PACKAGE_PIN H20 [get_ports vga_g[1]]
set_property IOSTANDARD LVCMOS33 [get_ports vga_g[1]]
set_property PACKAGE_PIN G20 [get_ports vga_g[0]]
set_property IOSTANDARD LVCMOS33 [get_ports vga_g[0]]

# VGA Blue - 4 bits
set_property PACKAGE_PIN J20 [get_ports vga_b[3]]
set_property IOSTANDARD LVCMOS33 [get_ports vga_b[3]]
set_property PACKAGE_PIN J21 [get_ports vga_b[2]]
set_property IOSTANDARD LVCMOS33 [get_ports vga_b[2]]
set_property PACKAGE_PIN H22 [get_ports vga_b[1]]
set_property IOSTANDARD LVCMOS33 [get_ports vga_b[1]]
set_property PACKAGE_PIN J22 [get_ports vga_b[0]] 
set_property IOSTANDARD LVCMOS33 [get_ports vga_b[0]]

 # button right
 set_property PACKAGE_PIN M22 [get_ports btn_right]
 set_property IOSTANDARD LVCMOS33 [get_ports btn_right]
 
 # button left
 set_property PACKAGE_PIN N20 [get_ports btn_left]
 set_property IOSTANDARD LVCMOS33 [get_ports btn_left]
 
  # button up
 set_property PACKAGE_PIN M20 [get_ports btn_up]
 set_property IOSTANDARD LVCMOS33 [get_ports btn_up]
 
  # button down
 set_property PACKAGE_PIN N22 [get_ports btn_down]
 set_property IOSTANDARD LVCMOS33 [get_ports btn_down]
 
 # button mid for bullets
 set_property PACKAGE_PIN M21 [get_ports btn_fire]
 set_property IOSTANDARD LVCMOS33 [get_ports btn_fire]
 
 # buzz
 set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports buzz]   
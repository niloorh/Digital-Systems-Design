#set_property IOSTANDARD LVCMOS33 [get_ports rx_0]
#set_property PACKAGE_PIN W13 [get_ports rx_0]
#set_property PACKAGE_PIN AG11 [get_ports rx_0]

#set_property IOSTANDARD LVCMOS33 [get_ports tx_0]
#set_property PACKAGE_PIN W11 [get_ports tx_0]
#set_property PACKAGE_PIN AF11 [get_ports tx_0]

#set_property IOSTANDARD LVCMOS33 [get_ports done_led]
#set_property PACKAGE_PIN AE12 [get_ports done_led]

#set_property IOSTANDARD DIFF_SSTL12 [get_ports CLK_IN1_D_0_clk_p]
#set_property PACKAGE_PIN AE5 [get_ports CLK_IN1_D_0_clk_p]
#create_clock -period 5.00 -name CLK_IN1_D_0_clk_p -waveform {0.000 2.50} [get_ports CLK_IN1_D_0_clk_p]

set_property PACKAGE_PIN R19 [get_ports led0_0]
set_property IOSTANDARD LVCMOS33 [get_ports led0_0]
set_property PACKAGE_PIN V13 [get_ports led1_0]
set_property IOSTANDARD LVCMOS33 [get_ports led1_0]

set_property PACKAGE_PIN m17 [get_ports tx_0]
set_property IOSTANDARD LVCMOS33 [get_ports tx_0]
set_property PACKAGE_PIN M18 [get_ports rx_0]
set_property IOSTANDARD LVCMOS33 [get_ports rx_0]
set_property PACKAGE_PIN U18 [get_ports mclk_0]
set_property IOSTANDARD LVCMOS33 [get_ports mclk_0]

set_property PACKAGE_PIN U18 [get_ports clk_50MHz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_50MHz]
create_clock -period 20.000 -waveform {0.000 10.000} [get_ports clk_50MHz]

set_property PACKAGE_PIN V16 [get_ports hdmi_oen]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_oen]

set_property PACKAGE_PIN V20 [get_ports {TMDS_Data_p[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_Data_p[0]}]

set_property PACKAGE_PIN T20 [get_ports {TMDS_Data_p[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_Data_p[1]}]

set_property PACKAGE_PIN N20 [get_ports {TMDS_Data_p[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_Data_p[2]}]

set_property PACKAGE_PIN N18 [get_ports TMDS_Clk_p]
set_property IOSTANDARD TMDS_33 [get_ports TMDS_Clk_p]

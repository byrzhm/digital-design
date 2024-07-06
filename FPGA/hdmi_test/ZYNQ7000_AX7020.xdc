set_property PACKAGE_PIN U18 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
create_clock -period 20.000 -waveform {0.000 10.000} [get_ports sys_clk]

#set_property PACKAGE_PIN V16 [get_ports hdmi_oen]
#set_property IOSTANDARD LVCMOS33 [get_ports hdmi_oen]

set_property PACKAGE_PIN V20 [get_ports {TMDSp_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {TMDSp_data[0]}]
set_property PACKAGE_PIN W20 [get_ports {TMDSn_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {TMDSn_data[0]}]

set_property PACKAGE_PIN T20 [get_ports {TMDSp_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {TMDSp_data[1]}]
set_property PACKAGE_PIN U20 [get_ports {TMDSn_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {TMDSn_data[1]}]

set_property PACKAGE_PIN N20 [get_ports {TMDSp_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {TMDSp_data[2]}]
set_property PACKAGE_PIN P20 [get_ports {TMDSn_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {TMDSn_data[2]}]

set_property PACKAGE_PIN N18 [get_ports TMDSp_clk]
set_property IOSTANDARD LVCMOS33 [get_ports TMDSp_clk]
set_property PACKAGE_PIN P19 [get_ports TMDSn_clk]
set_property IOSTANDARD LVCMOS33 [get_ports TMDSn_clk]
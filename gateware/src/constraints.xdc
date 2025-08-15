# GT ports to QSFP

set_property PACKAGE_PIN AA34 [get_ports diff_clock_rtl_clk_n]
set_property PACKAGE_PIN AA33 [get_ports diff_clock_rtl_clk_p]


set_property PACKAGE_PIN AR11 [get_ports o_tx0_trigg_0]
set_property IOSTANDARD LVCMOS18 [get_ports o_tx0_trigg_0]

set_property PACKAGE_PIN AW10 [get_ports o_rx0_trigg_0]
set_property IOSTANDARD LVCMOS18 [get_ports o_rx0_trigg_0]

set_property PACKAGE_PIN AT11 [get_ports o_tx1_trigg_0]
set_property IOSTANDARD LVCMOS18 [get_ports o_tx1_trigg_0]

set_property PACKAGE_PIN AU10 [get_ports led]
set_property IOSTANDARD LVCMOS18 [get_ports led]

set_property PACKAGE_PIN AN13 [get_ports sw]
set_property IOSTANDARD LVCMOS18 [get_ports sw]

set_false_path -from [get_clocks -include_generated_clocks clk_pl_0] -to [get_clocks {txoutclk_out[0]}]
set_false_path -from [get_clocks {txoutclk_out[0]}] -to [get_clocks -include_generated_clocks clk_pl_0]




create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list design_1_i/xxv_ethernet_0/inst/i_core_gtwiz_userclk_tx_inst_0/tx_clk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {design_1_i/Packet_Generator_0/tx0_axis_tstrb[0]} {design_1_i/Packet_Generator_0/tx0_axis_tstrb[1]} {design_1_i/Packet_Generator_0/tx0_axis_tstrb[2]} {design_1_i/Packet_Generator_0/tx0_axis_tstrb[3]} {design_1_i/Packet_Generator_0/tx0_axis_tstrb[4]} {design_1_i/Packet_Generator_0/tx0_axis_tstrb[5]} {design_1_i/Packet_Generator_0/tx0_axis_tstrb[6]} {design_1_i/Packet_Generator_0/tx0_axis_tstrb[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 64 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {design_1_i/Packet_Generator_0/tx0_axis_tdata[0]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[1]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[2]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[3]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[4]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[5]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[6]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[7]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[8]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[9]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[10]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[11]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[12]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[13]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[14]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[15]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[16]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[17]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[18]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[19]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[20]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[21]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[22]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[23]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[24]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[25]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[26]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[27]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[28]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[29]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[30]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[31]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[32]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[33]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[34]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[35]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[36]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[37]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[38]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[39]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[40]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[41]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[42]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[43]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[44]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[45]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[46]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[47]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[48]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[49]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[50]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[51]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[52]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[53]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[54]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[55]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[56]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[57]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[58]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[59]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[60]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[61]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[62]} {design_1_i/Packet_Generator_0/tx0_axis_tdata[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list design_1_i/Packet_Generator_0/tx0_axis_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list design_1_i/Packet_Generator_0/tx0_axis_tready]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list design_1_i/xxv_ethernet_0/inst/i_core_gtwiz_userclk_rx_inst_0/rx_serdes_clk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 64 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[0]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[1]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[2]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[3]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[4]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[5]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[6]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[7]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[8]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[9]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[10]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[11]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[12]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[13]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[14]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[15]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[16]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[17]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[18]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[19]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[20]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[21]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[22]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[23]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[24]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[25]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[26]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[27]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[28]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[29]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[30]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[31]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[32]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[33]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[34]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[35]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[36]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[37]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[38]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[39]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[40]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[41]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[42]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[43]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[44]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[45]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[46]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[47]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[48]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[49]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[50]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[51]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[52]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[53]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[54]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[55]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[56]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[57]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[58]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[59]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[60]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[61]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[62]} {design_1_i/xxv_ethernet_0/rx_axis_tdata_0[63]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 1 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list design_1_i/xxv_ethernet_0/rx_axis_tvalid_0]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_1_rx_serdes_clk]

// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Mon Jun 23 18:22:34 2025
// Host        : el-caciquismo running 64-bit Ubuntu 24.04.2 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/chustillo/vivado/ip_repo/Packet_Generator_1_0/src/fifo_generator_0/fifo_generator_0_stub.v
// Design      : fifo_generator_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu48dr-ffvg1517-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_7,Vivado 2022.2" *)
module fifo_generator_0(clk, srst, din, wr_en, rd_en, dout, full, empty, 
  wr_rst_busy, rd_rst_busy)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[72:0],wr_en,rd_en,dout[72:0],full,empty,wr_rst_busy,rd_rst_busy" */;
  input clk;
  input srst;
  input [72:0]din;
  input wr_en;
  input rd_en;
  output [72:0]dout;
  output full;
  output empty;
  output wr_rst_busy;
  output rd_rst_busy;
endmodule

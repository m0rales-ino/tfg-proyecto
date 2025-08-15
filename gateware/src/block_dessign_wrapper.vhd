--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
--Date        : Mon Jun  9 18:50:04 2025
--Host        : el-caciquismo running 64-bit Ubuntu 24.04.2 LTS
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
  port (
    diff_clock_rtl_clk_n : in STD_LOGIC;
    diff_clock_rtl_clk_p : in STD_LOGIC;
    gt_rtl_grx_n : in STD_LOGIC_VECTOR ( 3 downto 0 );
    gt_rtl_grx_p : in STD_LOGIC_VECTOR ( 3 downto 0 );
    gt_rtl_gtx_n : out STD_LOGIC_VECTOR ( 3 downto 0 );
    gt_rtl_gtx_p : out STD_LOGIC_VECTOR ( 3 downto 0 );
    led : out STD_LOGIC;
    o_rx0_trigg_0 : out STD_LOGIC;
    o_tx0_trigg_0 : out STD_LOGIC;
    o_tx1_trigg_0 : out STD_LOGIC;
    sw : in STD_LOGIC
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    diff_clock_rtl_clk_n : in STD_LOGIC;
    diff_clock_rtl_clk_p : in STD_LOGIC;
    gt_rtl_grx_n : in STD_LOGIC_VECTOR ( 3 downto 0 );
    gt_rtl_grx_p : in STD_LOGIC_VECTOR ( 3 downto 0 );
    gt_rtl_gtx_n : out STD_LOGIC_VECTOR ( 3 downto 0 );
    gt_rtl_gtx_p : out STD_LOGIC_VECTOR ( 3 downto 0 );
    o_tx0_trigg_0 : out STD_LOGIC;
    o_tx1_trigg_0 : out STD_LOGIC;
    o_rx0_trigg_0 : out STD_LOGIC;
    sw : in STD_LOGIC;
    led : out STD_LOGIC
  );
  end component design_1;
begin
design_1_i: component design_1
     port map (
      diff_clock_rtl_clk_n => diff_clock_rtl_clk_n,
      diff_clock_rtl_clk_p => diff_clock_rtl_clk_p,
      gt_rtl_grx_n(3 downto 0) => gt_rtl_grx_n(3 downto 0),
      gt_rtl_grx_p(3 downto 0) => gt_rtl_grx_p(3 downto 0),
      gt_rtl_gtx_n(3 downto 0) => gt_rtl_gtx_n(3 downto 0),
      gt_rtl_gtx_p(3 downto 0) => gt_rtl_gtx_p(3 downto 0),
      led => led,
      o_rx0_trigg_0 => o_rx0_trigg_0,
      o_tx0_trigg_0 => o_tx0_trigg_0,
      o_tx1_trigg_0 => o_tx1_trigg_0,
      sw => sw
    );
end STRUCTURE;

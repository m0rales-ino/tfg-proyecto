----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2025 09:01:23 PM
-- Design Name: 
-- Module Name: testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench is
    generic (
            C_AXI_LITE_DATA_WIDTH	: integer	:= 32;
            C_AXI_LITE_ADDR_WIDTH	: integer	:= 8;
            
            C_AXI_STREAM_DATA_WIDTH : integer   := 64
	);
end testbench;

architecture Behavioral of testbench is

    signal ACLK             : std_logic := '0';
    signal ARST             : std_logic := '1';
----------------------------------------- ----------------------------------------------------------------
    signal s00_axi_aclk	    : std_logic := '0';
    signal s00_axi_aresetn	: std_logic := '1';
    signal s00_axi_awaddr	: std_logic_vector(C_AXI_LITE_ADDR_WIDTH-1 downto 0) := (others => '0');
    signal s00_axi_awprot	: std_logic_vector(2 downto 0) := (others => '0');
    signal s00_axi_awvalid	: std_logic := '0';
    signal s00_axi_awready	: std_logic := '0';
    signal s00_axi_wdata	: std_logic_vector(C_AXI_LITE_DATA_WIDTH-1 downto 0) := (others => '0');
    signal s00_axi_wstrb	: std_logic_vector((C_AXI_LITE_DATA_WIDTH/8)-1 downto 0) := (others => '0');
    signal s00_axi_wvalid	: std_logic := '0';
    signal s00_axi_wready	: std_logic := '0';
    signal s00_axi_bresp	: std_logic_vector(1 downto 0) := (others => '0');
    signal s00_axi_bvalid	: std_logic := '0';
    signal s00_axi_bready	: std_logic := '0';
    signal s00_axi_araddr	: std_logic_vector(C_AXI_LITE_ADDR_WIDTH-1 downto 0) := (others => '0');
    signal s00_axi_arprot	: std_logic_vector(2 downto 0) := (others => '0');
    signal s00_axi_arvalid	: std_logic := '0';
    signal s00_axi_arready	: std_logic := '0';
    signal s00_axi_rdata	: std_logic_vector(C_AXI_LITE_DATA_WIDTH-1 downto 0) := (others => '0');
    signal s00_axi_rresp	: std_logic_vector(1 downto 0) := (others => '0');
    signal s00_axi_rvalid	: std_logic := '0';
    signal s00_axi_rready	: std_logic := '0';
----------------------------------------- ----------------------------------------------------------------
    signal tx0_axis_aclk	: std_logic := '0';
    signal tx0_axis_aresetn	: std_logic := '1';
    signal tx0_axis_tvalid	: std_logic := '0';
    signal tx0_axis_tdata	: std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0) := (others => '0');
    signal tx0_axis_tstrb	: std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0) := (others => '0');
    signal tx0_axis_tlast	: std_logic := '0';
    signal tx0_axis_tready	: std_logic := '0';
----------------------------------------- ----------------------------------------------------------------
    signal tx1_axis_aclk	: std_logic := '0';
    signal tx1_axis_aresetn	: std_logic := '1';
    signal tx1_axis_tvalid	: std_logic := '0';
    signal tx1_axis_tdata	: std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0) := (others => '0');
    signal tx1_axis_tstrb	: std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0) := (others => '0');
    signal tx1_axis_tlast	: std_logic := '0';
    signal tx1_axis_tready	: std_logic := '0';
----------------------------------------- ----------------------------------------------------------------
    signal tx2_axis_aclk	: std_logic := '0';
    signal tx2_axis_aresetn	: std_logic := '1';
    signal tx2_axis_tvalid	: std_logic := '0';
    signal tx2_axis_tdata	: std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0) := (others => '0');
    signal tx2_axis_tstrb	: std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0) := (others => '0');
    signal tx2_axis_tlast	: std_logic := '0';
    signal tx2_axis_tready	: std_logic := '0';
----------------------------------------- ---------------------------------------------------------------
    signal tx3_axis_aclk	: std_logic := '0';
    signal tx3_axis_aresetn	: std_logic := '1';
    signal tx3_axis_tvalid	: std_logic := '0';
    signal tx3_axis_tdata	: std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0) := (others => '0');
    signal tx3_axis_tstrb	: std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0) := (others => '0');
    signal tx3_axis_tlast	: std_logic := '0';
    signal tx3_axis_tready	: std_logic := '0';
----------------------------------------- ----------------------------------------------------------------
    signal rx0_axis_aclk	: std_logic := '0';
    signal rx0_axis_aresetn	: std_logic := '1';
    signal rx0_axis_tready	: std_logic := '0';
    signal rx0_axis_tdata	: std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0) := (others => '0');
    signal rx0_axis_tstrb	: std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0) := (others => '0');
    signal rx0_axis_tlast	: std_logic := '0';
    signal rx0_axis_tvalid	: std_logic := '0';
----------------------------------------- ----------------------------------------------------------------
    signal rx1_axis_aclk	: std_logic := '0';
    signal rx1_axis_aresetn	: std_logic := '1';
    signal rx1_axis_tready	: std_logic := '0';
    signal rx1_axis_tdata	: std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0) := (others => '0');
    signal rx1_axis_tstrb	: std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0) := (others => '0');
    signal rx1_axis_tlast	: std_logic := '0';
    signal rx1_axis_tvalid	: std_logic := '0';
----------------------------------------- ----------------------------------------------------------------
    signal rx2_axis_aclk	: std_logic := '0';
    signal rx2_axis_aresetn	: std_logic := '1';
    signal rx2_axis_tready	: std_logic := '0';
    signal rx2_axis_tdata	: std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0) := (others => '0');
    signal rx2_axis_tstrb	: std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0) := (others => '0');
    signal rx2_axis_tlast	: std_logic := '0';
    signal rx2_axis_tvalid	: std_logic := '0';
----------------------------------------- ----------------------------------------------------------------
    signal rx3_axis_aclk	: std_logic := '0';
    signal rx3_axis_aresetn	: std_logic := '1';
    signal rx3_axis_tready	: std_logic := '0';
    signal rx3_axis_tdata	: std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0) := (others => '0');
    signal rx3_axis_tstrb	: std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0) := (others => '0');
    signal rx3_axis_tlast	: std_logic := '0';
    signal rx3_axis_tvalid	: std_logic := '0';

    signal arm_m0_axis_aclk	: std_logic;
	signal arm_m0_axis_aresetn	: std_logic;
	signal arm_m0_axis_tvalid	: std_logic;
	signal arm_m0_axis_tdata	: std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
	signal arm_m0_axis_tstrb	: std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
	signal arm_m0_axis_tlast	: std_logic;
	signal arm_m0_axis_tready	: std_logic := '1';
	signal arm_m1_axis_aclk	: std_logic;
	signal arm_m1_axis_aresetn	: std_logic;
	signal arm_m1_axis_tvalid	: std_logic;
	signal arm_m1_axis_tdata	: std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
	signal arm_m1_axis_tstrb	: std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
	signal arm_m1_axis_tlast	: std_logic;
	signal arm_m1_axis_tready	: std_logic := '1';
	signal arm_m2_axis_aclk	: std_logic;
	signal arm_m2_axis_aresetn	: std_logic;
	signal arm_m2_axis_tvalid	: std_logic;
	signal arm_m2_axis_tdata	: std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
	signal arm_m2_axis_tstrb	: std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
	signal arm_m2_axis_tlast	: std_logic;
	signal arm_m2_axis_tready	: std_logic := '1';
	signal arm_m3_axis_aclk	: std_logic;
	signal arm_m3_axis_aresetn	: std_logic;
	signal arm_m3_axis_tvalid	: std_logic;
	signal arm_m3_axis_tdata	: std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
	signal arm_m3_axis_tstrb	: std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
	signal arm_m3_axis_tlast	: std_logic;
	signal arm_m3_axis_tready	: std_logic := '1';
    
    component Packet_Generator_v1_0 is
        port (
            ACLK : in std_logic;
            ARST : in std_logic;
--------------------------------------------------------------------------------------------
            s00_axi_aclk	: in std_logic;
            s00_axi_aresetn	: in std_logic;
            s00_axi_awaddr	: in std_logic_vector(C_AXI_LITE_ADDR_WIDTH-1 downto 0);
            s00_axi_awprot	: in std_logic_vector(2 downto 0);
            s00_axi_awvalid	: in std_logic;
            s00_axi_awready	: out std_logic;
            s00_axi_wdata	: in std_logic_vector(C_AXI_LITE_DATA_WIDTH-1 downto 0);
            s00_axi_wstrb	: in std_logic_vector((C_AXI_LITE_DATA_WIDTH/8)-1 downto 0);
            s00_axi_wvalid	: in std_logic;
            s00_axi_wready	: out std_logic;
            s00_axi_bresp	: out std_logic_vector(1 downto 0);
            s00_axi_bvalid	: out std_logic;
            s00_axi_bready	: in std_logic;
            s00_axi_araddr	: in std_logic_vector(C_AXI_LITE_ADDR_WIDTH-1 downto 0);
            s00_axi_arprot	: in std_logic_vector(2 downto 0);
            s00_axi_arvalid	: in std_logic;
            s00_axi_arready	: out std_logic;
            s00_axi_rdata	: out std_logic_vector(C_AXI_LITE_DATA_WIDTH-1 downto 0);
            s00_axi_rresp	: out std_logic_vector(1 downto 0);
            s00_axi_rvalid	: out std_logic;
            s00_axi_rready	: in std_logic;
--------------------------------------------------------------------------------------------
            tx0_axis_aclk	: in std_logic;
            tx0_axis_aresetn	: in std_logic;
            tx0_axis_tvalid	: out std_logic;
            tx0_axis_tdata	: out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
            tx0_axis_tstrb	: out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
            tx0_axis_tlast	: out std_logic;
            tx0_axis_tready	: in std_logic;
--------------------------------------------------------------------------------------------
            tx1_axis_aclk	: in std_logic;
            tx1_axis_aresetn	: in std_logic;
            tx1_axis_tvalid	: out std_logic;
            tx1_axis_tdata	: out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
            tx1_axis_tstrb	: out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
            tx1_axis_tlast	: out std_logic;
            tx1_axis_tready	: in std_logic;
--------------------------------------------------------------------------------------------
            tx2_axis_aclk	: in std_logic;
            tx2_axis_aresetn	: in std_logic;
            tx2_axis_tvalid	: out std_logic;
            tx2_axis_tdata	: out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
            tx2_axis_tstrb	: out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
            tx2_axis_tlast	: out std_logic;
            tx2_axis_tready	: in std_logic;
-------------------------------------------------------------------------------------------
            tx3_axis_aclk	: in std_logic;
            tx3_axis_aresetn	: in std_logic;
            tx3_axis_tvalid	: out std_logic;
            tx3_axis_tdata	: out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
            tx3_axis_tstrb	: out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
            tx3_axis_tlast	: out std_logic;
            tx3_axis_tready	: in std_logic;
--------------------------------------------------------------------------------------------
            rx0_axis_aclk	: in std_logic;
            rx0_axis_aresetn	: in std_logic;
            rx0_axis_tready	: out std_logic;
            rx0_axis_tdata	: in std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
            rx0_axis_tstrb	: in std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
            rx0_axis_tlast	: in std_logic;
            rx0_axis_tvalid	: in std_logic;
--------------------------------------------------------------------------------------------
            rx1_axis_aclk	: in std_logic;
            rx1_axis_aresetn	: in std_logic;
            rx1_axis_tready	: out std_logic;
            rx1_axis_tdata	: in std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
            rx1_axis_tstrb	: in std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
            rx1_axis_tlast	: in std_logic;
            rx1_axis_tvalid	: in std_logic;
--------------------------------------------------------------------------------------------
            rx2_axis_aclk	: in std_logic;
            rx2_axis_aresetn	: in std_logic;
            rx2_axis_tready	: out std_logic;
            rx2_axis_tdata	: in std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
            rx2_axis_tstrb	: in std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
            rx2_axis_tlast	: in std_logic;
            rx2_axis_tvalid	: in std_logic;
--------------------------------------------------------------------------------------------
            rx3_axis_aclk	: in std_logic;
            rx3_axis_aresetn	: in std_logic;
            rx3_axis_tready	: out std_logic;
            rx3_axis_tdata	: in std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
            rx3_axis_tstrb	: in std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
            rx3_axis_tlast	: in std_logic;
            rx3_axis_tvalid	: in std_logic;
            arm_m0_axis_aclk	: in std_logic;
            arm_m0_axis_aresetn	: in std_logic;
            arm_m0_axis_tvalid	: out std_logic;
            arm_m0_axis_tdata	: out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
            arm_m0_axis_tstrb	: out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
            arm_m0_axis_tlast	: out std_logic;
            arm_m0_axis_tready	: in std_logic;

            arm_m1_axis_aclk	: in std_logic;
            arm_m1_axis_aresetn	: in std_logic;
            arm_m1_axis_tvalid	: out std_logic;
            arm_m1_axis_tdata	: out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
            arm_m1_axis_tstrb	: out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
            arm_m1_axis_tlast	: out std_logic;
            arm_m1_axis_tready	: in std_logic;

            arm_m2_axis_aclk	: in std_logic;
            arm_m2_axis_aresetn	: in std_logic;
            arm_m2_axis_tvalid	: out std_logic;
            arm_m2_axis_tdata	: out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
            arm_m2_axis_tstrb	: out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
            arm_m2_axis_tlast	: out std_logic;
            arm_m2_axis_tready	: in std_logic;

            arm_m3_axis_aclk	: in std_logic;
            arm_m3_axis_aresetn	: in std_logic;
            arm_m3_axis_tvalid	: out std_logic;
            arm_m3_axis_tdata	: out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
            arm_m3_axis_tstrb	: out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
            arm_m3_axis_tlast	: out std_logic;
            arm_m3_axis_tready	: in std_logic
        );
    end component;
        
        constant aclk_period    : time := 7 ns;
        
        constant s00_clk_period : time := 10 ns;

        constant tx0_clk_period : time := 10 ns;
        constant tx1_clk_period : time := 10 ns;
        constant tx2_clk_period : time := 10 ns;
        constant tx3_clk_period : time := 10 ns;

        constant rx0_clk_period : time := 10 ns;
        constant rx1_clk_period : time := 10 ns;
        constant rx2_clk_period : time := 10 ns;
        constant rx3_clk_period : time := 10 ns;


begin
    DUT: Packet_Generator_v1_0
    port map(
        ACLK            => ACLK,
        ARST            => ARST,
------------------------=> ,
        s00_axi_aclk	=> s00_axi_aclk,
        s00_axi_aresetn	=> s00_axi_aresetn,
        s00_axi_awaddr	=> s00_axi_awaddr,
        s00_axi_awprot	=> s00_axi_awprot,
        s00_axi_awvalid	=> s00_axi_awvalid,
        s00_axi_awready	=> s00_axi_awready,
        s00_axi_wdata	=> s00_axi_wdata,
        s00_axi_wstrb	=> s00_axi_wstrb,
        s00_axi_wvalid	=> s00_axi_wvalid,
        s00_axi_wready	=> s00_axi_wready,
        s00_axi_bresp	=> s00_axi_bresp,
        s00_axi_bvalid	=> s00_axi_bvalid,
        s00_axi_bready	=> s00_axi_bready,
        s00_axi_araddr	=> s00_axi_araddr,
        s00_axi_arprot	=> s00_axi_arprot,
        s00_axi_arvalid	=> s00_axi_arvalid,
        s00_axi_arready	=> s00_axi_arready,
        s00_axi_rdata	=> s00_axi_rdata,
        s00_axi_rresp	=> s00_axi_rresp,
        s00_axi_rvalid	=> s00_axi_rvalid,
        s00_axi_rready	=> s00_axi_rready,
------------------------=> ,
        tx0_axis_aclk	=> tx0_axis_aclk,
        tx0_axis_aresetn=> tx0_axis_aresetn,
        tx0_axis_tvalid	=> tx0_axis_tvalid,
        tx0_axis_tdata	=> tx0_axis_tdata,
        tx0_axis_tstrb	=> tx0_axis_tstrb,
        tx0_axis_tlast	=> tx0_axis_tlast,
        tx0_axis_tready	=> tx0_axis_tready,
------------------------=> ,
        tx1_axis_aclk	=> tx1_axis_aclk,
        tx1_axis_aresetn=> tx1_axis_aresetn,
        tx1_axis_tvalid	=> tx1_axis_tvalid,
        tx1_axis_tdata	=> tx1_axis_tdata,
        tx1_axis_tstrb	=> tx1_axis_tstrb,
        tx1_axis_tlast	=> tx1_axis_tlast,
        tx1_axis_tready	=> tx1_axis_tready,
------------------------=> ,
        tx2_axis_aclk	=> tx2_axis_aclk,
        tx2_axis_aresetn=> tx2_axis_aresetn,
        tx2_axis_tvalid	=> tx2_axis_tvalid,
        tx2_axis_tdata	=> tx2_axis_tdata,
        tx2_axis_tstrb	=> tx2_axis_tstrb,
        tx2_axis_tlast	=> tx2_axis_tlast,
        tx2_axis_tready	=> tx2_axis_tready,
------------------------=> ,
        tx3_axis_aclk	=> tx3_axis_aclk,
        tx3_axis_aresetn=> tx3_axis_aresetn,
        tx3_axis_tvalid	=> tx3_axis_tvalid,
        tx3_axis_tdata	=> tx3_axis_tdata,
        tx3_axis_tstrb	=> tx3_axis_tstrb,
        tx3_axis_tlast	=> tx3_axis_tlast,
        tx3_axis_tready	=> tx3_axis_tready,
------------------------=> ,
        rx0_axis_aclk	=> tx0_axis_aclk,
        rx0_axis_aresetn=> tx0_axis_aresetn,
        rx0_axis_tready	=> tx0_axis_tready,
        rx0_axis_tdata	=> tx0_axis_tdata,
        rx0_axis_tstrb	=> tx0_axis_tstrb,
        rx0_axis_tlast	=> tx0_axis_tlast,
        rx0_axis_tvalid	=> tx0_axis_tvalid,
------------------------=> ,
        rx1_axis_aclk	=> tx1_axis_aclk,
        rx1_axis_aresetn=> tx1_axis_aresetn,
        rx1_axis_tready	=> open,
        rx1_axis_tdata	=> tx1_axis_tdata,
        rx1_axis_tstrb	=> tx1_axis_tstrb,
        rx1_axis_tlast	=> tx1_axis_tlast,
        rx1_axis_tvalid	=> tx1_axis_tvalid,
------------------------=> ,
        rx2_axis_aclk	=> tx2_axis_aclk,
        rx2_axis_aresetn=> tx2_axis_aresetn,
        rx2_axis_tready	=> tx2_axis_tready,
        rx2_axis_tdata	=> tx2_axis_tdata,
        rx2_axis_tstrb	=> tx2_axis_tstrb,
        rx2_axis_tlast	=> tx2_axis_tlast,
        rx2_axis_tvalid	=> tx2_axis_tvalid,
------------------------=> ,
        rx3_axis_aclk	=> tx3_axis_aclk,
        rx3_axis_aresetn=> tx3_axis_aresetn,
        rx3_axis_tready	=> tx3_axis_tready,
        rx3_axis_tdata	=> tx3_axis_tdata,
        rx3_axis_tstrb	=> tx3_axis_tstrb,
        rx3_axis_tlast	=> tx3_axis_tlast,
        rx3_axis_tvalid	=> tx3_axis_tvalid,
        arm_m0_axis_aclk	=> s00_axi_aclk,
        arm_m0_axis_aresetn	=> s00_axi_aresetn,
        arm_m0_axis_tvalid	=> arm_m0_axis_tvalid,
        arm_m0_axis_tdata	=> arm_m0_axis_tdata,
        arm_m0_axis_tstrb	=> arm_m0_axis_tstrb,
        arm_m0_axis_tlast	=> arm_m0_axis_tlast,
        arm_m0_axis_tready	=> arm_m0_axis_tready,
        arm_m1_axis_aclk	=> s00_axi_aclk,
        arm_m1_axis_aresetn	=> s00_axi_aresetn,
        arm_m1_axis_tvalid	=> arm_m1_axis_tvalid,
        arm_m1_axis_tdata	=> arm_m1_axis_tdata,
        arm_m1_axis_tstrb	=> arm_m1_axis_tstrb,
        arm_m1_axis_tlast	=> arm_m1_axis_tlast,
        arm_m1_axis_tready	=> arm_m1_axis_tready,
        arm_m2_axis_aclk	=> s00_axi_aclk,
        arm_m2_axis_aresetn	=> s00_axi_aresetn,
        arm_m2_axis_tvalid	=> arm_m2_axis_tvalid,
        arm_m2_axis_tdata	=> arm_m2_axis_tdata,
        arm_m2_axis_tstrb	=> arm_m2_axis_tstrb,
        arm_m2_axis_tlast	=> arm_m2_axis_tlast,
        arm_m2_axis_tready	=> arm_m2_axis_tready,
        arm_m3_axis_aclk	=> s00_axi_aclk,
        arm_m3_axis_aresetn	=> s00_axi_aresetn,
        arm_m3_axis_tvalid	=> arm_m3_axis_tvalid,
        arm_m3_axis_tdata	=> arm_m3_axis_tdata,
        arm_m3_axis_tstrb	=> arm_m3_axis_tstrb,
        arm_m3_axis_tlast	=> arm_m3_axis_tlast,
        arm_m3_axis_tready	=> arm_m3_axis_tready
    );

    -- Clock drivers
    ACLK_PROC : process
    begin
        wait for aclk_period/2;
        ACLK <= not (ACLK);
    end process;

    S00_CLK_PROC : process
    begin
        wait for s00_clk_period/2;
        s00_axi_aclk <= not (s00_axi_aclk);
    end process;

    TX0_CLK_PROC : process
    begin
        wait for tx0_clk_period/2;
        tx0_axis_aclk <= not (tx0_axis_aclk);
    end process;

    TX1_CLK_PROC : process
    begin
        wait for tx1_clk_period/2;
        tx1_axis_aclk <= not (tx1_axis_aclk);
    end process;

    TX2_CLK_PROC : process
    begin
        wait for tx2_clk_period/2;
        tx2_axis_aclk <= not (tx2_axis_aclk);
    end process;

    TX3_CLK_PROC : process
    begin
        wait for tx3_clk_period/2;
        tx3_axis_aclk <= not (tx3_axis_aclk);
    end process;

    
    Simulation_process : process
	begin
	    -- APPLYING INITIAL RESET
		wait for s00_clk_period;
		s00_axi_aresetn <= '0';
        ARST <= '0';
        tx0_axis_aresetn <= '0';
        tx1_axis_aresetn <= '0';
        tx2_axis_aresetn <= '0';
        tx3_axis_aresetn <= '0';
		wait for s00_clk_period*5;
		s00_axi_aresetn <= '1';
        ARST <= '1';
        tx0_axis_aresetn <= '1';
        tx1_axis_aresetn <= '1';
        tx2_axis_aresetn <= '1';
        tx3_axis_aresetn <= '1';

        tx1_axis_tready <= '1';
        tx2_axis_tready <= '1';
        tx3_axis_tready <= '1';
        
        -- Writting of gen mode codes
		wait until rising_edge(s00_axi_aclk);
		s00_axi_awaddr <= x"00";
		s00_axi_wdata  <= x"00006890";
		s00_axi_awvalid <= '1';
		s00_axi_wvalid <= '1';
		s00_axi_wstrb <= "1111";
		s00_axi_bready <= '1';
		-- Writting of lower part of dest_mac_0
		wait for s00_clk_period*3;
		s00_axi_awaddr <= x"04";
		s00_axi_wdata  <= x"babe0000";
		
		-- Writting upper part of destination MAC 0 and 1
		wait for s00_clk_period*3;
		s00_axi_awaddr <= x"08";
		s00_axi_wdata  <= x"cafecafe";

        -- Writting lower part of dest MAC 1
		wait for s00_clk_period*3;
		s00_axi_awaddr <= x"0C";
		s00_axi_wdata  <= x"babe0001";

        -- Writting lower part of dest mac 2
		wait for s00_clk_period*3;
		s00_axi_awaddr <= x"10";
		s00_axi_wdata  <= x"babe0002";

        -- Writting upper parts of dest MAC 2 and 3
		wait for s00_clk_period*3;
		s00_axi_awaddr <= x"14";
		s00_axi_wdata  <= x"cafecafe";

        -- Writting lower part of dest MAC 3
		wait for s00_clk_period*3;
		s00_axi_awaddr <= x"18";
		s00_axi_wdata  <= x"babe0003";

        -- Writting of lower part of src_mac_0
		wait for s00_clk_period*3;
		s00_axi_awaddr <= x"1C";
		s00_axi_wdata  <= x"beef0000";
		
		-- Writting upper part of source MAC 0 and 1
		wait for s00_clk_period*3;
		s00_axi_awaddr <= x"20";
		s00_axi_wdata  <= x"deaddead";

        -- Writting lower part of src MAC 1
		wait for s00_clk_period*3;
		s00_axi_awaddr <= x"24";
		s00_axi_wdata  <= x"beef0001";

        -- Writting lower part of src mac 2
		wait for s00_clk_period*3;
		s00_axi_awaddr <= x"28";
		s00_axi_wdata  <= x"beef0002";

        -- Writting upper parts of dest MAC 2 and 3
		wait for s00_clk_period*3;
		s00_axi_awaddr <= x"2C";
		s00_axi_wdata  <= x"deaddead";

        -- Writting lower part of dest MAC 3
		wait for s00_clk_period*3;
		s00_axi_awaddr <= x"30";
		s00_axi_wdata  <= x"beef0003";

        -- Writting payload length 0 and 1
        wait for s00_clk_period*3;
		s00_axi_awaddr <= x"34";
		s00_axi_wdata  <= x"01000040";

        -- Writting payload length 2 and 3
        wait for s00_clk_period*3;
		s00_axi_awaddr <= x"38";
		s00_axi_wdata  <= x"05000B00";

        -- Payload pattern 0
        wait for s00_clk_period*3;
		s00_axi_awaddr <= x"3C";
		s00_axi_wdata  <= x"aaaaaaaa";

        -- Payload pattern 1
        wait for s00_clk_period*3;
		s00_axi_awaddr <= x"40";
		s00_axi_wdata  <= x"bbbbbbbb";

        -- Payload pattern 2
        wait for s00_clk_period*3;
		s00_axi_awaddr <= x"44";
		s00_axi_wdata  <= x"cccccccc";

        -- Payload pattern 3
        wait for s00_clk_period*3;
		s00_axi_awaddr <= x"48";
		s00_axi_wdata  <= x"dddddddd";

        -- Gen mode param 0
        wait for s00_clk_period*3;
		-- s00_axi_awaddr <= x"8C";
		-- s00_axi_wdata  <= x"aaaaaaaa";
		s00_axi_awaddr <= x"8C";
		s00_axi_wdata  <= x"00000005";

        -- Gen mode param 1
        wait for s00_clk_period*3;
		s00_axi_awaddr <= x"90";
		s00_axi_wdata  <= x"00000005";

        -- Gen mode param 2
        wait for s00_clk_period*3;
		s00_axi_awaddr <= x"94";
		s00_axi_wdata  <= x"000000F0";

        -- -- Gen mode param 3
        wait for s00_clk_period*3;
		s00_axi_awaddr <= x"98";
		s00_axi_wdata  <= x"01000003";


        wait for s00_clk_period*3;
		s00_axi_awaddr <= x"00";
        s00_axi_wstrb  <= "0001";
		s00_axi_wdata  <= x"0000689F";

		wait for s00_clk_period*3;
		s00_axi_awvalid <= '0';
		s00_axi_wvalid <= '0';
		wait for s00_clk_period;
		s00_axi_bready <= '0';

        -- wait for 21*s00_clk_period;
        -- s00_axi_awaddr <= x"00";
		-- s00_axi_wdata  <= x"000F689F";
        -- s00_axi_awvalid <= '1';
		-- s00_axi_wvalid <= '1';
		-- s00_axi_wstrb <= "1111";
		-- s00_axi_bready <= '1';

        
		wait;
	end process;


end Behavioral;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Packet_Generator_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_AXI_LITE_DATA_WIDTH	: integer	:= 32;
		C_AXI_LITE_ADDR_WIDTH	: integer	:= 8;
		
		C_AXI_STREAM_DATA_WIDTH : integer   := 64

	);
	port (
		-- Users to add ports here
		ACLK : in std_logic;
		ARST : in std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
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
		

		-- Ports of Axi Master Bus Interface TX0_AXIS
		tx0_axis_aclk	: in std_logic;
		tx0_axis_aresetn	: in std_logic;
		tx0_axis_tvalid	: out std_logic;
		tx0_axis_tdata	: out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		tx0_axis_tstrb	: out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
		tx0_axis_tlast	: out std_logic;
		tx0_axis_tready	: in std_logic;

		o_tx0_trigg     : out std_logic;

		-- Ports of Axi Master Bus Interface TX1_AXIS
		tx1_axis_aclk	: in std_logic;
		tx1_axis_aresetn	: in std_logic;
		tx1_axis_tvalid	: out std_logic;
		tx1_axis_tdata	: out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		tx1_axis_tstrb	: out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
		tx1_axis_tlast	: out std_logic;
		tx1_axis_tready	: in std_logic;

		o_tx1_trigg     : out std_logic;

		-- Ports of Axi Master Bus Interface TX2_AXIS
		tx2_axis_aclk	: in std_logic;
		tx2_axis_aresetn	: in std_logic;
		tx2_axis_tvalid	: out std_logic;
		tx2_axis_tdata	: out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		tx2_axis_tstrb	: out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
		tx2_axis_tlast	: out std_logic;
		tx2_axis_tready	: in std_logic;

		o_tx2_trigg     : out std_logic;

		-- Ports of Axi Master Bus Interface TX3_AXIS
		tx3_axis_aclk	: in std_logic;
		tx3_axis_aresetn	: in std_logic;
		tx3_axis_tvalid	: out std_logic;
		tx3_axis_tdata	: out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		tx3_axis_tstrb	: out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
		tx3_axis_tlast	: out std_logic;
		tx3_axis_tready	: in std_logic;

		tx3_trigg     : out std_logic;

		-- Ports of Axi Slave Bus Interface RX0_AXIS
		rx0_axis_aclk	: in std_logic;
		rx0_axis_aresetn	: in std_logic;
		rx0_axis_tready	: out std_logic;
		rx0_axis_tdata	: in std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		rx0_axis_tstrb	: in std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
		rx0_axis_tlast	: in std_logic;
		rx0_axis_tvalid	: in std_logic;
		o_rx0_trigg : out std_logic;

		-- Ports of Axi Slave Bus Interface RX1_AXIS
		rx1_axis_aclk	: in std_logic;
		rx1_axis_aresetn	: in std_logic;
		rx1_axis_tready	: out std_logic;
		rx1_axis_tdata	: in std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		rx1_axis_tstrb	: in std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
		rx1_axis_tlast	: in std_logic;
		rx1_axis_tvalid	: in std_logic;
		o_rx1_trigg : out std_logic;

		-- Ports of Axi Slave Bus Interface RX2_AXIS
		rx2_axis_aclk	: in std_logic;
		rx2_axis_aresetn	: in std_logic;
		rx2_axis_tready	: out std_logic;
		rx2_axis_tdata	: in std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		rx2_axis_tstrb	: in std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
		rx2_axis_tlast	: in std_logic;
		rx2_axis_tvalid	: in std_logic;
		o_rx2_trigg : out std_logic;

		-- Ports of Axi Slave Bus Interface RX3_AXIS
		rx3_axis_aclk	: in std_logic;
		rx3_axis_aresetn	: in std_logic;
		rx3_axis_tready	: out std_logic;
		rx3_axis_tdata	: in std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		rx3_axis_tstrb	: in std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
		rx3_axis_tlast	: in std_logic;
		rx3_axis_tvalid	: in STD_LOGIC;
		o_rx3_trigg : out std_logic;

		-- Interruption to signal end of generation
		o_intrpt : out std_logic;

		--axi stream if to arm
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
end Packet_Generator_v1_0;

architecture arch_imp of Packet_Generator_v1_0 is

	-- Interconnection signals
		signal s_rx0_packet_counter	: std_logic_vector(31 downto 0);
		signal s_rx0_byte_counter		: std_logic_vector(31 downto 0);
		signal s_rx1_packet_counter	: std_logic_vector(31 downto 0);
		signal s_rx1_byte_counter		: std_logic_vector(31 downto 0);
		signal s_rx2_packet_counter	: std_logic_vector(31 downto 0);
		signal s_rx2_byte_counter		: std_logic_vector(31 downto 0);
		signal s_rx3_packet_counter	: std_logic_vector(31 downto 0);
		signal s_rx3_byte_counter		: std_logic_vector(31 downto 0);
		signal s_tx0_packet_counter	: std_logic_vector(31 downto 0);
		signal s_tx0_byte_counter		: std_logic_vector(31 downto 0);
		signal s_tx1_packet_counter	: std_logic_vector(31 downto 0);
		signal s_tx1_byte_counter		: std_logic_vector(31 downto 0);
		signal s_tx2_packet_counter	: std_logic_vector(31 downto 0);
		signal s_tx2_byte_counter		: std_logic_vector(31 downto 0);
		signal s_tx3_packet_counter	: std_logic_vector(31 downto 0);
		signal s_tx3_byte_counter		: std_logic_vector(31 downto 0);
		signal s_Enable_Traffic_Flags : std_logic_vector(3 downto 0);
		signal s_gen_mode_0 : std_logic_vector (2 downto 0);
		signal s_gen_mode_1 : std_logic_vector (2 downto 0);
		signal s_gen_mode_2 : std_logic_vector (2 downto 0);
		signal s_gen_mode_3 : std_logic_vector (2 downto 0);
		signal s_capture_flags : std_logic_vector (3 downto 0);
		signal s_dest_mac_0 : std_logic_vector (47 downto 0);
		signal s_dest_mac_1 : std_logic_vector (47 downto 0);
		signal s_dest_mac_2 : std_logic_vector (47 downto 0);
		signal s_dest_mac_3 : std_logic_vector (47 downto 0);
		signal s_src_mac_0  : std_logic_vector (47 downto 0);
		signal s_src_mac_1 : std_logic_vector (47 downto 0);
		signal s_src_mac_2 : std_logic_vector (47 downto 0);
		signal s_src_mac_3  : std_logic_vector (47 downto 0);
		signal s_payload_length_0 : std_logic_vector (10 downto 0);
		signal s_payload_length_1 : std_logic_vector (10 downto 0);
		signal s_payload_length_2 : std_logic_vector (10 downto 0);
		signal s_payload_length_3 : std_logic_vector (10 downto 0);
		signal s_payload_pattern_0 : std_logic_vector (31 downto 0);
		signal s_payload_pattern_1 : std_logic_vector (31 downto 0);
		signal s_payload_pattern_3 : std_logic_vector (31 downto 0);
		signal s_payload_pattern_2 : std_logic_vector (31 downto 0);
		signal s_tx0_DONE : std_logic_vector (0 downto 0);
		signal s_tx1_DONE : std_logic_vector (0 downto 0);
		signal s_tx2_DONE : std_logic_vector (0 downto 0);
		signal s_tx3_DONE : std_logic_vector (0 downto 0);
		signal s_tx0_DONE_sync : std_logic_vector (0 downto 0);
		signal s_tx1_DONE_sync : std_logic_vector (0 downto 0);
		signal s_tx2_DONE_sync : std_logic_vector (0 downto 0);
		signal s_tx3_DONE_sync : std_logic_vector (0 downto 0);
		signal s_gen_mode_param_0  : std_logic_vector (31 downto 0);
		signal s_gen_mode_param_1  : std_logic_vector (31 downto 0);
		signal s_gen_mode_param_2  : std_logic_vector (31 downto 0);
		signal s_gen_mode_param_3  : std_logic_vector (31 downto 0);

		-- End S00_AXI signals
	
		signal s_fifo_data_in_TX0 : std_logic_vector (C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		signal s_fifo_data_in_TX1 : std_logic_vector (C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		signal s_fifo_data_in_TX2 : std_logic_vector (C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		signal s_fifo_data_in_TX3 : std_logic_vector (C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		signal s_fifo_data_valid_TX0 : std_logic_vector(C_AXI_STREAM_DATA_WIDTH / 8 - 1 downto 0);
		signal s_fifo_data_valid_TX1 : std_logic_vector(C_AXI_STREAM_DATA_WIDTH / 8 - 1 downto 0);
		signal s_fifo_data_valid_TX2 : std_logic_vector(C_AXI_STREAM_DATA_WIDTH / 8 - 1 downto 0);
		signal s_fifo_data_valid_TX3 : std_logic_vector(C_AXI_STREAM_DATA_WIDTH / 8 - 1 downto 0);
		signal s_fifo_data_last_TX0 : std_logic;
		signal s_fifo_data_last_TX1 : std_logic;
		signal s_fifo_data_last_TX2 : std_logic;
		signal s_fifo_data_last_TX3 : std_logic;
		signal s_fifo_rd_en_TX0 : std_logic;
		signal s_fifo_rd_en_TX1 : std_logic;
		signal s_fifo_rd_en_TX2 : std_logic;
		signal s_fifo_rd_en_TX3 : std_logic;

		signal sync_rx0_input : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);
		signal sync_rx1_input : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);
		signal sync_rx2_input : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);
		signal sync_rx3_input : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);

		signal sync_rx0_output : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);
		signal sync_rx1_output : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);
		signal sync_rx2_output : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);
		signal sync_rx3_output : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);

		signal sync_tx0_input : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);
		signal sync_tx1_input : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);
		signal sync_tx2_input : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);
		signal sync_tx3_input : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);

		signal sync_tx0_output : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);
		signal sync_tx1_output : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);
		signal sync_tx2_output : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);
		signal sync_tx3_output : std_logic_vector (C_AXI_LITE_DATA_WIDTH*2-1 downto 0);

		constant SYNCHRO_VECTOR_LENGTH : integer := 176;
		
		signal ctrl_unit0_params_pre_sync : std_logic_vector(SYNCHRO_VECTOR_LENGTH-1 downto 0);
		signal ctrl_unit0_params_sync 	  : std_logic_vector(SYNCHRO_VECTOR_LENGTH-1 downto 0);
		signal ctrl_unit1_params_pre_sync : std_logic_vector(SYNCHRO_VECTOR_LENGTH-1 downto 0);
		signal ctrl_unit1_params_sync 	  : std_logic_vector(SYNCHRO_VECTOR_LENGTH-1 downto 0);
		signal ctrl_unit2_params_pre_sync : std_logic_vector(SYNCHRO_VECTOR_LENGTH-1 downto 0);
		signal ctrl_unit2_params_sync 	  : std_logic_vector(SYNCHRO_VECTOR_LENGTH-1 downto 0);
		signal ctrl_unit3_params_pre_sync : std_logic_vector(SYNCHRO_VECTOR_LENGTH-1 downto 0);
		signal ctrl_unit3_params_sync 	  : std_logic_vector(SYNCHRO_VECTOR_LENGTH-1 downto 0);

		signal s_fifo_full_ch0 : std_logic;
		signal s_fifo_full_ch1 : std_logic;
		signal s_fifo_full_ch2 : std_logic;
		signal s_fifo_full_ch3 : std_logic;


	-- component declaration
	component Packet_Generator_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 64;
		C_S_AXI_ADDR_WIDTH	: integer	:= 7
		);
		port (
		i_rx0_packet_counter	: in std_logic_vector(31 downto 0);
		i_rx0_byte_counter		: in std_logic_vector(31 downto 0);
		i_rx1_packet_counter	: in std_logic_vector(31 downto 0);
		i_rx1_byte_counter		: in std_logic_vector(31 downto 0);
		i_rx2_packet_counter	: in std_logic_vector(31 downto 0);
		i_rx2_byte_counter		: in std_logic_vector(31 downto 0);
		i_rx3_packet_counter	: in std_logic_vector(31 downto 0);
		i_rx3_byte_counter		: in std_logic_vector(31 downto 0);
		i_tx0_packet_counter	: in std_logic_vector(31 downto 0);
		i_tx0_byte_counter		: in std_logic_vector(31 downto 0);
		i_tx1_packet_counter	: in std_logic_vector(31 downto 0);
		i_tx1_byte_counter		: in std_logic_vector(31 downto 0);
		i_tx2_packet_counter	: in std_logic_vector(31 downto 0);
		i_tx2_byte_counter		: in std_logic_vector(31 downto 0);
		i_tx3_packet_counter	: in std_logic_vector(31 downto 0);
		i_tx3_byte_counter		: in std_logic_vector(31 downto 0);
		o_Enable_Traffic_Flags : out std_logic_vector(3 downto 0);
		o_gen_mode_0 : out std_logic_vector (2 downto 0);
		o_gen_mode_1 : out std_logic_vector (2 downto 0);
		o_gen_mode_2 : out std_logic_vector (2 downto 0);
		o_gen_mode_3 : out std_logic_vector (2 downto 0);
		o_capture_flags : out std_logic_vector (3 downto 0);
		o_dest_mac_0 : out std_logic_vector (47 downto 0);
		o_dest_mac_1 : out std_logic_vector (47 downto 0);
		o_dest_mac_2 : out std_logic_vector (47 downto 0);
		o_dest_mac_3 : out std_logic_vector (47 downto 0);
		o_src_mac_0  : out std_logic_vector (47 downto 0);
		o_src_mac_1 : out std_logic_vector (47 downto 0);
		o_src_mac_2 : out std_logic_vector (47 downto 0);
		o_src_mac_3  : out std_logic_vector (47 downto 0);
		o_payload_length_0 : out std_logic_vector (10 downto 0);
		o_payload_length_1 : out std_logic_vector (10 downto 0);
		o_payload_length_2 : out std_logic_vector (10 downto 0);
		o_payload_length_3 : out std_logic_vector (10 downto 0);
		o_payload_pattern_0 : out std_logic_vector (31 downto 0);
		o_payload_pattern_1 : out std_logic_vector (31 downto 0);
		o_payload_pattern_3 : out std_logic_vector (31 downto 0);
		o_payload_pattern_2 : out std_logic_vector (31 downto 0);
		o_gen_mode_param_0  : out std_logic_vector (31 downto 0);
		o_gen_mode_param_1  : out std_logic_vector (31 downto 0);
		o_gen_mode_param_2  : out std_logic_vector (31 downto 0);
		o_gen_mode_param_3  : out std_logic_vector (31 downto 0);
		i_tx0_DONE : in std_logic;
		i_tx1_DONE : in std_logic;
		i_tx2_DONE : in std_logic;
		i_tx3_DONE : in std_logic;
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
	);
	end component Packet_Generator_v1_0_S00_AXI;

	component Packet_Generator_v1_0_TX_AXIS is
		generic (
		C_M_AXIS_TDATA_WIDTH	: integer	:= 64
		);
		port (
			int_clk : in std_logic; -- Internal Clock
			i_fifo_rd_en : in std_logic;
			fifo_full : out std_logic;
			fifo_data_in : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
			fifo_data_valid : in std_logic_vector(C_M_AXIS_TDATA_WIDTH/8 -1 downto 0);
			fifo_data_last  : in std_logic;
			o_tx_trigg : out std_logic;
			o_tx_packet_counter : out std_logic_vector (31 downto 0);
			o_tx_byte_counter   : out std_logic_vector (31 downto 0);
			M_AXIS_ACLK	: in std_logic;
			M_AXIS_ARESETN	: in std_logic;
			M_AXIS_TVALID	: out std_logic;
			M_AXIS_TDATA	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
			M_AXIS_TSTRB	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
			M_AXIS_TLAST	: out std_logic;
			M_AXIS_TREADY	: in std_logic
		);
	end component Packet_Generator_v1_0_TX_AXIS;

	component Packet_Generator_v1_0_RX_AXIS is
		generic (
		C_S_AXIS_TDATA_WIDTH	: integer	:= 64
		);
		port (
			i_capture_enable : in std_logic;
			o_rx_trigg : out std_logic;
			o_rx_packet_counter : out std_logic_vector (31 downto 0);
			o_rx_byte_counter   : out std_logic_vector (31 downto 0);
			S_AXIS_ACLK	: in std_logic;
			S_AXIS_ARESETN	: in std_logic;
			S_AXIS_TREADY	: out std_logic;
			S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
			S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
			S_AXIS_TLAST	: in std_logic;
			S_AXIS_TVALID	: in std_logic;
			M_AXIS_ACLK     : in std_logic;
			M_AXIS_ARESETN	: in std_logic;
			M_AXIS_TREADY	: in std_logic;
			M_AXIS_TDATA	: out std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
			M_AXIS_TSTRB	: out std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
			M_AXIS_TLAST	: out std_logic;
			M_AXIS_TVALID	: out std_logic
		);
	end component Packet_Generator_v1_0_RX_AXIS;

	component Control_Unit_Tx is
		generic(C_M_AXIS_TDATA_WIDTH : integer := 64);
		Port ( i_eth_TX_En : in STD_LOGIC;
			   i_payload_length : in STD_LOGIC_VECTOR (10 downto 0);
			   i_fifo_full : in STD_LOGIC;
			   o_fifo_data_in : out std_logic_vector (C_M_AXIS_TDATA_WIDTH-1 downto 0);
			   o_fifo_data_valid : out std_logic_vector (C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
			   o_fifo_data_last  : out std_logic;
			   o_fifo_rd_en      : out std_logic;
			   i_dest_MAC : in std_logic_vector (47 downto 0);
			   i_src_MAC : in std_logic_vector (47 downto 0);
			   i_payload_pattern : in std_logic_vector (31 downto 0);
			   i_tx_gm_select : in std_logic_vector (2 downto 0);
			   i_tx_gm_param  : in std_logic_vector (31 downto 0);
			   o_DONE : out std_logic;
			   rst : in std_logic;
			   clk : in std_logic
		);
	end component;

	component cdc_synchronizer is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        -- Clock domain A
        clk_a : in std_logic;
        data_a : in std_logic_vector (DATA_WIDTH-1 downto 0);

        -- Clock domain B
        clk_b : in std_logic;
        data_b : out std_logic_vector (DATA_WIDTH-1 downto 0);

        -- RESET
        arst : in std_logic
    );
	end component;

	component sync_2ff is
    generic(
        DATA_WIDTH : integer := 32
    );
    port (
        --Clock domain A
        data_a : in std_logic_vector (DATA_WIDTH-1 downto 0);

        -- Clock domain B
        clk_b : in std_logic;
        data_b : out std_logic_vector (DATA_WIDTH-1 downto 0);

        -- Asynchronous reset
        arst : in std_logic
    );
	end component;

begin

-- Instantiation of Axi Bus Interface S00_AXI
Packet_Generator_v1_0_S00_AXI_inst : Packet_Generator_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_AXI_LITE_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_AXI_LITE_ADDR_WIDTH
	)
	port map (
		i_rx0_packet_counter => sync_rx0_output (C_AXI_LITE_DATA_WIDTH-1 downto 0),
		i_rx0_byte_counter => sync_rx0_output (C_AXI_LITE_DATA_WIDTH*2-1 downto C_AXI_LITE_DATA_WIDTH),
		i_rx1_packet_counter => sync_rx1_output (C_AXI_LITE_DATA_WIDTH-1 downto 0),
		i_rx1_byte_counter => sync_rx1_output (C_AXI_LITE_DATA_WIDTH*2-1 downto C_AXI_LITE_DATA_WIDTH),
		i_rx2_packet_counter => sync_rx2_output (C_AXI_LITE_DATA_WIDTH-1 downto 0),
		i_rx2_byte_counter => sync_rx2_output (C_AXI_LITE_DATA_WIDTH*2-1 downto C_AXI_LITE_DATA_WIDTH),
		i_rx3_packet_counter => sync_rx3_output (C_AXI_LITE_DATA_WIDTH-1 downto 0),
		i_rx3_byte_counter => sync_rx3_output (C_AXI_LITE_DATA_WIDTH*2-1 downto C_AXI_LITE_DATA_WIDTH),
		i_tx0_packet_counter => sync_tx0_output (C_AXI_LITE_DATA_WIDTH-1 downto 0),
		i_tx0_byte_counter => 	sync_tx0_output (C_AXI_LITE_DATA_WIDTH*2-1 downto C_AXI_LITE_DATA_WIDTH),
		i_tx1_packet_counter => sync_tx1_output (C_AXI_LITE_DATA_WIDTH-1 downto 0),
		i_tx1_byte_counter => 	sync_tx1_output (C_AXI_LITE_DATA_WIDTH*2-1 downto C_AXI_LITE_DATA_WIDTH),
		i_tx2_packet_counter => sync_tx2_output (C_AXI_LITE_DATA_WIDTH-1 downto 0),
		i_tx2_byte_counter => 	sync_tx2_output (C_AXI_LITE_DATA_WIDTH*2-1 downto C_AXI_LITE_DATA_WIDTH),
		i_tx3_packet_counter => sync_tx3_output (C_AXI_LITE_DATA_WIDTH-1 downto 0),
		i_tx3_byte_counter => 	sync_tx3_output (C_AXI_LITE_DATA_WIDTH*2-1 downto C_AXI_LITE_DATA_WIDTH),
		o_Enable_Traffic_Flags => s_Enable_Traffic_Flags,
		o_gen_mode_0 => s_gen_mode_0,
		o_gen_mode_1 => s_gen_mode_1,
		o_gen_mode_2 => s_gen_mode_2,
		o_gen_mode_3 => s_gen_mode_3,
		o_capture_flags => s_capture_flags,
		o_dest_mac_0 => s_dest_mac_0,
		o_dest_mac_1 => s_dest_mac_1,
		o_dest_mac_2 => s_dest_mac_2,
		o_dest_mac_3 => s_dest_mac_3,
		o_src_mac_0 => s_src_mac_0,
		o_src_mac_1 => s_src_mac_1,
		o_src_mac_2 => s_src_mac_2,
		o_src_mac_3 => s_src_mac_3,
		o_payload_length_0 => s_payload_length_0,
		o_payload_length_1 => s_payload_length_1,
		o_payload_length_2 => s_payload_length_2,
		o_payload_length_3 => s_payload_length_3,
		o_payload_pattern_0 => s_payload_pattern_0,
		o_payload_pattern_1 => s_payload_pattern_1,
		o_payload_pattern_3 => s_payload_pattern_3,
		o_payload_pattern_2 => s_payload_pattern_2,
		o_gen_mode_param_0 => s_gen_mode_param_0,
		o_gen_mode_param_1 => s_gen_mode_param_1,
		o_gen_mode_param_2 => s_gen_mode_param_2,
		o_gen_mode_param_3 => s_gen_mode_param_3,
		i_tx0_DONE => s_tx0_DONE_sync(0),
		i_tx1_DONE => s_tx1_DONE_sync(0),
		i_tx2_DONE => s_tx2_DONE_sync(0),
		i_tx3_DONE => s_tx3_DONE_sync(0),
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	sync_rx0_input <= s_rx0_byte_counter & s_rx0_packet_counter;

Synchronizer_rx0 : cdc_synchronizer
generic map (
	DATA_WIDTH => C_AXI_LITE_DATA_WIDTH*2
)
port map (
    clk_a	=> rx0_axis_aclk,
    data_a	=> sync_rx0_input,
    clk_b	=> s00_axi_aclk,
    data_b	=> sync_rx0_output,
    arst	=> arst
);

	sync_rx1_input <= s_rx1_byte_counter & s_rx1_packet_counter;

Synchronizer_rx1 : cdc_synchronizer
generic map (
	DATA_WIDTH => C_AXI_LITE_DATA_WIDTH*2
)
port map (
    clk_a	=> rx1_axis_aclk,
    data_a	=> sync_rx1_input,
    clk_b	=> s00_axi_aclk,
    data_b	=> sync_rx1_output,
    arst	=> arst
);

	sync_rx2_input <= s_rx2_byte_counter & s_rx2_packet_counter;

Synchronizer_rx2 : cdc_synchronizer
generic map (
	DATA_WIDTH => C_AXI_LITE_DATA_WIDTH*2
)
port map (
    clk_a	=> rx2_axis_aclk,
    data_a	=> sync_rx2_input,
    clk_b	=> s00_axi_aclk,
    data_b	=> sync_rx2_output,
    arst	=> arst
);

	sync_rx3_input <= s_rx3_byte_counter & s_rx3_packet_counter;

Synchronizer_rx3 : cdc_synchronizer
generic map (
	DATA_WIDTH => C_AXI_LITE_DATA_WIDTH*2
)
port map (
    clk_a	=> rx3_axis_aclk,
    data_a	=> sync_rx3_input,
    clk_b	=> s00_axi_aclk,
    data_b	=> sync_rx3_output,
    arst	=> arst
);

	sync_tx0_input <= s_tx0_byte_counter & s_tx0_packet_counter;

Synchronizer_tx0 : cdc_synchronizer
generic map (
	DATA_WIDTH => C_AXI_LITE_DATA_WIDTH*2
)
port map (
    clk_a	=> tx0_axis_aclk,
    data_a	=> sync_tx0_input,
    clk_b	=> s00_axi_aclk,
    data_b	=> sync_tx0_output,
    arst	=> arst
);

	sync_tx1_input <= s_tx1_byte_counter & s_tx1_packet_counter;

Synchronizer_tx1 : cdc_synchronizer
generic map (
	DATA_WIDTH => C_AXI_LITE_DATA_WIDTH*2
)
port map (
    clk_a	=> tx1_axis_aclk,
    data_a	=> sync_tx1_input,
    clk_b	=> s00_axi_aclk,
    data_b	=> sync_tx1_output,
    arst	=> arst
);

	sync_tx2_input <= s_tx2_byte_counter & s_tx2_packet_counter;

Synchronizer_tx2 : cdc_synchronizer
generic map (
	DATA_WIDTH => C_AXI_LITE_DATA_WIDTH*2
)
port map (
    clk_a	=> tx2_axis_aclk,
    data_a	=> sync_tx2_input,
    clk_b	=> s00_axi_aclk,
    data_b	=> sync_tx2_output,
    arst	=> arst
);

	sync_tx3_input <= s_tx3_byte_counter & s_tx3_packet_counter;

Synchronizer_tx3 : cdc_synchronizer
generic map (
	DATA_WIDTH => C_AXI_LITE_DATA_WIDTH*2
)
port map (
    clk_a	=> tx3_axis_aclk,
    data_a	=> sync_tx3_input,
    clk_b	=> s00_axi_aclk,
    data_b	=> sync_tx3_output,
    arst	=> arst
);

ctrl_unit0_params_pre_sync <= s_capture_flags(0) & s_gen_mode_param_0 & s_gen_mode_0 & s_payload_pattern_0 & s_src_mac_0 & s_dest_mac_0 & s_payload_length_0 & s_Enable_Traffic_Flags(0);

Sync_regs_2_crtl_unit0 : sync_2ff
generic map (
	DATA_WIDTH => SYNCHRO_VECTOR_LENGTH
)
port map (
	data_a	=> ctrl_unit0_params_pre_sync,
    clk_b	=> tx0_axis_aclk,
    data_b	=> ctrl_unit0_params_sync,
    arst	=> arst
);

ctrl_unit1_params_pre_sync <= s_capture_flags(1) & s_gen_mode_param_1 & s_gen_mode_1 & s_payload_pattern_1 & s_src_mac_1 & s_dest_mac_1 & s_payload_length_1 & s_Enable_Traffic_Flags(1);

Sync_regs_2_crtl_unit1 : sync_2ff
generic map (
	DATA_WIDTH => SYNCHRO_VECTOR_LENGTH
)
port map (
	data_a	=> ctrl_unit1_params_pre_sync,
    clk_b	=> tx1_axis_aclk,
    data_b	=> ctrl_unit1_params_sync,
    arst	=> arst
);

ctrl_unit2_params_pre_sync <= s_capture_flags(2) & s_gen_mode_param_2 & s_gen_mode_2 & s_payload_pattern_2 & s_src_mac_2 & s_dest_mac_2 & s_payload_length_2 & s_Enable_Traffic_Flags(2);

Sync_regs_2_crtl_unit2 : sync_2ff
generic map (
	DATA_WIDTH => SYNCHRO_VECTOR_LENGTH
)
port map (
	data_a	=> ctrl_unit2_params_pre_sync,
    clk_b	=> tx2_axis_aclk,
    data_b	=> ctrl_unit2_params_sync,
    arst	=> arst
);

ctrl_unit3_params_pre_sync <= s_capture_flags(3) & s_gen_mode_param_3 & s_gen_mode_3 & s_payload_pattern_3 & s_src_mac_3 & s_dest_mac_3 & s_payload_length_3 & s_Enable_Traffic_Flags(3);

Sync_regs_2_crtl_unit3 : sync_2ff
generic map (
	DATA_WIDTH => SYNCHRO_VECTOR_LENGTH
)
port map (
	data_a	=> ctrl_unit3_params_pre_sync,
    clk_b	=> tx3_axis_aclk,
    data_b	=> ctrl_unit3_params_sync,
    arst	=> arst
);

Sync_crtl_unit0_2_regs : sync_2ff
generic map (
	DATA_WIDTH => 1
)
port map (
	data_a	=> s_tx0_DONE,
    clk_b	=> s00_axi_aclk,
    data_b	=> s_tx0_DONE_sync,
    arst	=> arst
);

Sync_crtl_unit1_2_regs : sync_2ff
generic map (
	DATA_WIDTH => 1
)
port map (
	data_a	=> s_tx1_DONE,
    clk_b	=> s00_axi_aclk,
    data_b	=> s_tx1_DONE_sync,
    arst	=> arst
);

Sync_crtl_unit2_2_regs : sync_2ff
generic map (
	DATA_WIDTH => 1
)
port map (
	data_a	=> s_tx2_DONE,
    clk_b	=> s00_axi_aclk,
    data_b	=> s_tx2_DONE_sync,
    arst	=> arst
);

Sync_crtl_unit3_2_regs : sync_2ff
generic map (
	DATA_WIDTH => 1
)
port map (
	data_a	=> s_tx3_DONE,
    clk_b	=> s00_axi_aclk,
    data_b	=> s_tx3_DONE_sync,
    arst	=> arst
);

Control_Unit_TX0 : Control_Unit_Tx
generic map(
	C_M_AXIS_TDATA_WIDTH => C_AXI_STREAM_DATA_WIDTH
)
port map(
	i_eth_TX_En => ctrl_unit0_params_sync(0),
	i_payload_length => ctrl_unit0_params_sync(11 downto 1),
	i_fifo_full => s_fifo_full_ch0,
	o_fifo_data_in => s_fifo_data_in_TX0,
	o_fifo_data_valid => s_fifo_data_valid_TX0,
	o_fifo_data_last => s_fifo_data_last_TX0,
	o_fifo_rd_en => s_fifo_rd_en_TX0,
	i_dest_MAC => ctrl_unit0_params_sync(59 downto 12),
	i_src_MAC => ctrl_unit0_params_sync(107 downto 60),
	i_payload_pattern => ctrl_unit0_params_sync(139 downto 108),
	i_tx_gm_select => ctrl_unit0_params_sync(142 downto 140),
	i_tx_gm_param  => ctrl_unit0_params_sync(174 downto 143),
	o_DONE => s_tx0_DONE (0),
	rst => tx0_axis_aresetn,
	clk => tx0_axis_aclk
);

Control_Unit_TX1 : Control_Unit_Tx
generic map(
	C_M_AXIS_TDATA_WIDTH => C_AXI_STREAM_DATA_WIDTH
)
port map(
	i_eth_TX_En => ctrl_unit1_params_sync(0),
	i_payload_length => ctrl_unit1_params_sync(11 downto 1),
	i_fifo_full => s_fifo_full_ch1,
	o_fifo_data_in => s_fifo_data_in_TX1,
	o_fifo_data_valid => s_fifo_data_valid_TX1,
	o_fifo_data_last => s_fifo_data_last_TX1,
	o_fifo_rd_en => s_fifo_rd_en_TX1,
	i_dest_MAC => ctrl_unit1_params_sync(59 downto 12),
	i_src_MAC => ctrl_unit1_params_sync(107 downto 60),
	i_payload_pattern => ctrl_unit1_params_sync(139 downto 108),
	i_tx_gm_select => ctrl_unit1_params_sync(142 downto 140),
	i_tx_gm_param  => ctrl_unit1_params_sync(174 downto 143),
	o_DONE => s_tx1_DONE(0),
	rst => tx1_axis_aresetn,
	clk => tx1_axis_aclk
);

Control_Unit_TX2 : Control_Unit_Tx
generic map(
	C_M_AXIS_TDATA_WIDTH => C_AXI_STREAM_DATA_WIDTH
)
port map(
	i_eth_TX_En => ctrl_unit2_params_sync(0),
	i_payload_length => ctrl_unit2_params_sync(11 downto 1),
	i_fifo_full => s_fifo_full_ch2,
	o_fifo_data_in => s_fifo_data_in_TX2,
	o_fifo_data_valid => s_fifo_data_valid_TX2,
	o_fifo_data_last => s_fifo_data_last_TX2,
	o_fifo_rd_en => s_fifo_rd_en_TX2,
	i_dest_MAC => ctrl_unit2_params_sync(59 downto 12),
	i_src_MAC => ctrl_unit2_params_sync(107 downto 60),
	i_payload_pattern => ctrl_unit2_params_sync(139 downto 108),
	i_tx_gm_select => ctrl_unit2_params_sync(142 downto 140),
	i_tx_gm_param  => ctrl_unit2_params_sync(174 downto 143),
	o_DONE => s_tx2_DONE(0),
	rst => tx2_axis_aresetn,
	clk => tx2_axis_aclk
);

Control_Unit_TX3 : Control_Unit_Tx
generic map(
	C_M_AXIS_TDATA_WIDTH => C_AXI_STREAM_DATA_WIDTH
)
port map(
	i_eth_TX_En => ctrl_unit3_params_sync(0),
	i_payload_length => ctrl_unit3_params_sync(11 downto 1),
	i_fifo_full => s_fifo_full_ch3,
	o_fifo_data_in => s_fifo_data_in_TX3,
	o_fifo_data_valid => s_fifo_data_valid_TX3,
	o_fifo_data_last => s_fifo_data_last_TX3,
	o_fifo_rd_en => s_fifo_rd_en_TX3,
	i_dest_MAC => ctrl_unit3_params_sync(59 downto 12),
	i_src_MAC => ctrl_unit3_params_sync(107 downto 60),
	i_payload_pattern => ctrl_unit3_params_sync(139 downto 108),
	i_tx_gm_select => ctrl_unit3_params_sync(142 downto 140),
	i_tx_gm_param  => ctrl_unit3_params_sync(174 downto 143),
	o_DONE 	=> s_tx3_DONE(0),
	rst => tx3_axis_aresetn,
	clk => tx3_axis_aclk
);

-- Instantiation of Axi Bus Interface TX0_AXIS
Packet_Generator_v1_0_TX0_AXIS_inst : Packet_Generator_v1_0_TX_AXIS
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> C_AXI_STREAM_DATA_WIDTH
	)
	port map (
		int_clk 		=> ACLK,
		i_fifo_rd_en 	=> s_fifo_rd_en_TX0,
		fifo_full 		=> s_fifo_full_ch0,
		fifo_data_in 	=> s_fifo_data_in_TX0,
		fifo_data_valid => s_fifo_data_valid_TX0,
		fifo_data_last  => s_fifo_data_last_TX0,
		o_tx_trigg		=> o_tx0_trigg,
		o_tx_packet_counter => s_tx0_packet_counter,
		o_tx_byte_counter   => s_tx0_byte_counter,
		M_AXIS_ACLK		=> tx0_axis_aclk,
		M_AXIS_ARESETN	=> tx0_axis_aresetn,
		M_AXIS_TVALID	=> tx0_axis_tvalid,
		M_AXIS_TDATA	=> tx0_axis_tdata,
		M_AXIS_TSTRB	=> tx0_axis_tstrb,
		M_AXIS_TLAST	=> tx0_axis_tlast,
		M_AXIS_TREADY	=> tx0_axis_tready
	);

-- Instantiation of Axi Bus Interface TX1_AXIS
Packet_Generator_v1_0_TX1_AXIS_inst : Packet_Generator_v1_0_TX_AXIS
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> C_AXI_STREAM_DATA_WIDTH
	)
	port map (
		int_clk 		=> ACLK,
		i_fifo_rd_en 	=> s_fifo_rd_en_TX1,
		fifo_full 		=> s_fifo_full_ch1,
		fifo_data_in 	=> s_fifo_data_in_TX1,
		fifo_data_valid => s_fifo_data_valid_TX1,
		fifo_data_last  => s_fifo_data_last_TX1,
		o_tx_trigg		=> o_tx1_trigg,
		o_tx_packet_counter => s_tx1_packet_counter,
		o_tx_byte_counter   => s_tx1_byte_counter,
		M_AXIS_ACLK		=> tx1_axis_aclk,
		M_AXIS_ARESETN	=> tx1_axis_aresetn,
		M_AXIS_TVALID	=> tx1_axis_tvalid,
		M_AXIS_TDATA	=> tx1_axis_tdata,
		M_AXIS_TSTRB	=> tx1_axis_tstrb,
		M_AXIS_TLAST	=> tx1_axis_tlast,
		M_AXIS_TREADY	=> tx1_axis_tready
	);

-- Instantiation of Axi Bus Interface TX2_AXIS
Packet_Generator_v1_0_TX2_AXIS_inst : Packet_Generator_v1_0_TX_AXIS
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> C_AXI_STREAM_DATA_WIDTH
	)
	port map (
		int_clk 		=> ACLK,
		i_fifo_rd_en 	=> s_fifo_rd_en_TX2,
		fifo_full 		=> s_fifo_full_ch2,
		fifo_data_in 	=> s_fifo_data_in_TX2,
		fifo_data_valid => s_fifo_data_valid_TX2,
		fifo_data_last  => s_fifo_data_last_TX2,
		o_tx_packet_counter => s_tx2_packet_counter,
		o_tx_byte_counter   => s_tx2_byte_counter,
		o_tx_trigg		=> o_tx2_trigg,
		M_AXIS_ACLK		=> tx2_axis_aclk,
		M_AXIS_ARESETN	=> tx2_axis_aresetn,
		M_AXIS_TVALID	=> tx2_axis_tvalid,
		M_AXIS_TDATA	=> tx2_axis_tdata,
		M_AXIS_TSTRB	=> tx2_axis_tstrb,
		M_AXIS_TLAST	=> tx2_axis_tlast,
		M_AXIS_TREADY	=> tx2_axis_tready
	);

-- Instantiation of Axi Bus Interface TX3_AXIS
Packet_Generator_v1_0_TX3_AXIS_inst : Packet_Generator_v1_0_TX_AXIS
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> C_AXI_STREAM_DATA_WIDTH
	)
	port map (
		int_clk 		=> ACLK,
		i_fifo_rd_en 	=> s_fifo_rd_en_TX3,
		fifo_full 		=> s_fifo_full_ch3,
		fifo_data_in 	=> s_fifo_data_in_TX3,
		fifo_data_valid => s_fifo_data_valid_TX3,
		fifo_data_last  => s_fifo_data_last_TX3,
		o_tx_packet_counter => s_tx3_packet_counter,
		o_tx_byte_counter   => s_tx3_byte_counter,
		o_tx_trigg		=> tx3_trigg,
		M_AXIS_ACLK		=> tx3_axis_aclk,
		M_AXIS_ARESETN	=> tx3_axis_aresetn,
		M_AXIS_TVALID	=> tx3_axis_tvalid,
		M_AXIS_TDATA	=> tx3_axis_tdata,
		M_AXIS_TSTRB	=> tx3_axis_tstrb,
		M_AXIS_TLAST	=> tx3_axis_tlast,
		M_AXIS_TREADY	=> tx3_axis_tready
	);

-- Instantiation of Axi Bus Interface RX0_AXIS
Packet_Generator_v1_0_RX0_AXIS_inst : Packet_Generator_v1_0_RX_AXIS
	generic map (
		C_S_AXIS_TDATA_WIDTH	=> C_AXI_STREAM_DATA_WIDTH
	)
	port map (
		i_capture_enable => ctrl_unit0_params_sync(175),
		o_rx_trigg  => o_rx0_trigg,
		o_rx_packet_counter => s_rx0_packet_counter,
		o_rx_byte_counter => s_rx0_byte_counter,
		S_AXIS_ACLK	=> rx0_axis_aclk,
		S_AXIS_ARESETN	=> rx0_axis_aresetn,
		S_AXIS_TREADY	=> rx0_axis_tready,
		S_AXIS_TDATA	=> rx0_axis_tdata,
		S_AXIS_TSTRB	=> rx0_axis_tstrb,
		S_AXIS_TLAST	=> rx0_axis_tlast,
		S_AXIS_TVALID	=> rx0_axis_tvalid,
		M_AXIS_ACLK     => arm_m0_axis_aclk,
		M_AXIS_ARESETN	=> arm_m0_axis_aresetn,
		M_AXIS_TREADY	=> arm_m0_axis_tready,
		M_AXIS_TDATA	=> arm_m0_axis_tdata,
		M_AXIS_TSTRB	=> arm_m0_axis_tstrb,
		M_AXIS_TLAST	=> arm_m0_axis_tlast,
		M_AXIS_TVALID	=> arm_m0_axis_tvalid
	);

-- Instantiation of Axi Bus Interface RX1_AXIS
Packet_Generator_v1_0_RX1_AXIS_inst : Packet_Generator_v1_0_RX_AXIS
	generic map (
		C_S_AXIS_TDATA_WIDTH	=> C_AXI_STREAM_DATA_WIDTH
	)
	port map (
		i_capture_enable => ctrl_unit1_params_sync(175),
		o_rx_trigg  => o_rx1_trigg,
		o_rx_packet_counter => s_rx1_packet_counter,
		o_rx_byte_counter => s_rx1_byte_counter,
		S_AXIS_ACLK	=> rx1_axis_aclk,
		S_AXIS_ARESETN	=> rx1_axis_aresetn,
		S_AXIS_TREADY	=> rx1_axis_tready,
		S_AXIS_TDATA	=> rx1_axis_tdata,
		S_AXIS_TSTRB	=> rx1_axis_tstrb,
		S_AXIS_TLAST	=> rx1_axis_tlast,
		S_AXIS_TVALID	=> rx1_axis_tvalid,
		M_AXIS_ACLK     => arm_m1_axis_aclk,
		M_AXIS_ARESETN	=> arm_m1_axis_aresetn,
		M_AXIS_TREADY	=> arm_m1_axis_tready,
		M_AXIS_TDATA	=> arm_m1_axis_tdata,
		M_AXIS_TSTRB	=> arm_m1_axis_tstrb,
		M_AXIS_TLAST	=> arm_m1_axis_tlast,
		M_AXIS_TVALID	=> arm_m1_axis_tvalid
	);


-- Instantiation of Axi Bus Interface RX2_AXIS
Packet_Generator_v1_0_RX2_AXIS_inst : Packet_Generator_v1_0_RX_AXIS
	generic map (
		C_S_AXIS_TDATA_WIDTH	=> C_AXI_STREAM_DATA_WIDTH
	)
	port map (
		i_capture_enable => ctrl_unit2_params_sync(175),
		o_rx_trigg  => o_rx2_trigg,
		o_rx_packet_counter => s_rx2_packet_counter,
		o_rx_byte_counter => s_rx2_byte_counter,
		S_AXIS_ACLK	=> rx2_axis_aclk,
		S_AXIS_ARESETN	=> rx2_axis_aresetn,
		S_AXIS_TREADY	=> rx2_axis_tready,
		S_AXIS_TDATA	=> rx2_axis_tdata,
		S_AXIS_TSTRB	=> rx2_axis_tstrb,
		S_AXIS_TLAST	=> rx2_axis_tlast,
		S_AXIS_TVALID	=> rx2_axis_tvalid,
		M_AXIS_ACLK     => arm_m2_axis_aclk,
		M_AXIS_ARESETN	=> arm_m2_axis_aresetn,
		M_AXIS_TREADY	=> arm_m2_axis_tready,
		M_AXIS_TDATA	=> arm_m2_axis_tdata,
		M_AXIS_TSTRB	=> arm_m2_axis_tstrb,
		M_AXIS_TLAST	=> arm_m2_axis_tlast,
		M_AXIS_TVALID	=> arm_m2_axis_tvalid
	);

-- Instantiation of Axi Bus Interface RX3_AXIS
Packet_Generator_v1_0_RX3_AXIS_inst : Packet_Generator_v1_0_RX_AXIS
	generic map (
		C_S_AXIS_TDATA_WIDTH	=> C_AXI_STREAM_DATA_WIDTH
	)
	port map (
		i_capture_enable => ctrl_unit3_params_sync(175),
		o_rx_trigg  => o_rx3_trigg,
		o_rx_packet_counter => s_rx3_packet_counter,
		o_rx_byte_counter => s_rx3_byte_counter,
		S_AXIS_ACLK	=> rx3_axis_aclk,
		S_AXIS_ARESETN	=> rx3_axis_aresetn,
		S_AXIS_TREADY	=> rx3_axis_tready,
		S_AXIS_TDATA	=> rx3_axis_tdata,
		S_AXIS_TSTRB	=> rx3_axis_tstrb,
		S_AXIS_TLAST	=> rx3_axis_tlast,
		S_AXIS_TVALID	=> rx3_axis_tvalid,
		M_AXIS_ACLK     => arm_m3_axis_aclk,
		M_AXIS_ARESETN	=> arm_m3_axis_aresetn,
		M_AXIS_TREADY	=> arm_m3_axis_tready,
		M_AXIS_TDATA	=> arm_m3_axis_tdata,
		M_AXIS_TSTRB	=> arm_m3_axis_tstrb,
		M_AXIS_TLAST	=> arm_m3_axis_tlast,
		M_AXIS_TVALID	=> arm_m3_axis_tvalid
	);

end arch_imp;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.project_pkg.all;

entity Packet_Generator_v1_0_RX_AXIS is
	generic (
		C_S_AXIS_TDATA_WIDTH	: integer	:= 64;
		C_TRIGGER_DELAY_STAGES  : integer	:= 20
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
end Packet_Generator_v1_0_RX_AXIS;

architecture arch_imp of Packet_Generator_v1_0_RX_AXIS is
	signal axis_tlast_pulse : std_logic;
	signal s_rx_trigg_delay : std_logic_vector(C_TRIGGER_DELAY_STAGES-1 downto 0);

	signal rx_packet_counter : std_logic_vector (31 downto 0);
	signal rx_byte_counter   : std_logic_vector (31 downto 0);

	signal axis_tvalid : STD_LOGIC;
	signal axis_tready : STD_LOGIC;

	signal init_capture : std_logic;
	


	-- Instantiation of axi stream data fifo
	COMPONENT axis_data_fifo_0
	PORT (
		s_axis_aresetn : IN STD_LOGIC;
		s_axis_aclk : IN STD_LOGIC;
		s_axis_tvalid : IN STD_LOGIC;
		s_axis_tready : OUT STD_LOGIC;
		s_axis_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
		s_axis_tstrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		s_axis_tlast : IN STD_LOGIC;
		m_axis_aclk : IN STD_LOGIC;
		m_axis_tvalid : OUT STD_LOGIC;
		m_axis_tready : IN STD_LOGIC;
		m_axis_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
		m_axis_tstrb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		m_axis_tlast : OUT STD_LOGIC 
	);
	END COMPONENT;

begin
	-- Description of logic dedicated to count the statistics related to RX
	stat_counter : process (S_AXIS_ACLK)
	begin
		if S_AXIS_ARESETN = '0' then
			rx_packet_counter <= (others => '0');
			rx_byte_counter   <= (others => '0');
		elsif rising_edge(S_AXIS_ACLK) then
			r_update_stats(
                tvalid       => S_AXIS_TVALID,
                tlast        => S_AXIS_TLAST,
                tstrb        => S_AXIS_TSTRB,
                pkt_cnt   => rx_packet_counter,
                byte_cnt  => rx_byte_counter
            );
		end if;
	end process;

	o_rx_packet_counter <= rx_packet_counter;
	o_rx_byte_counter   <= rx_byte_counter;
	-- End of description of statistics countering


	rx_trigger : process(M_AXIS_ACLK, axis_tlast_pulse)
	begin
		if M_AXIS_ARESETN = '0' then
			s_rx_trigg_delay <= (others => '0');
			axis_tlast_pulse <= '0';
		elsif rising_edge(M_AXIS_ACLK) then
			axis_tlast_pulse <= s_axis_tlast;
			s_rx_trigg_delay(0) <= s_axis_tlast and not axis_tlast_pulse;

			for i in C_TRIGGER_DELAY_STAGES-1 downto 1 loop
				s_rx_trigg_delay(i) <= s_rx_trigg_delay(i-1);
        	end loop;
			
		end if;
	end process;

	o_rx_trigg <= or_reduce(s_rx_trigg_delay);
	-- End of description of received frame signaling

	-- Fifo to send frames to the processor
	init_capture_proc:
	process (m_axis_aclk)
	begin
		if M_AXIS_ARESETN = '0' then
			init_capture <= '0';
		elsif rising_edge(m_axis_aclk) then
			if i_capture_enable = '1' then
				if s_axis_tlast = '1' then
					init_capture <= '1';
				else
					init_capture <= init_capture;
				end if;
			else 
				init_capture <= '0';
			end if;
		end if;
	end process;
	axis_tvalid <= s_axis_tvalid and init_capture;

	s_axis_tready <= axis_tready when i_capture_enable = '1' else '1';

	fifo :  axis_data_fifo_0
	PORT MAP (
		s_axis_aresetn => s_axis_aresetn,
		s_axis_aclk    =>    s_axis_aclk,
		s_axis_tvalid  =>    axis_tvalid,
		s_axis_tready  =>    axis_tready,
		s_axis_tdata   =>   s_axis_tdata,
		s_axis_tstrb   =>   s_axis_tstrb,
		s_axis_tlast   =>   s_axis_tlast,
		m_axis_aclk    =>    m_axis_aclk,
		m_axis_tvalid  =>  m_axis_tvalid,
		m_axis_tready  =>  m_axis_tready,
		m_axis_tdata   =>   m_axis_tdata,
		m_axis_tstrb   =>   m_axis_tstrb,
		m_axis_tlast   =>   m_axis_tlast
	);


end arch_imp;

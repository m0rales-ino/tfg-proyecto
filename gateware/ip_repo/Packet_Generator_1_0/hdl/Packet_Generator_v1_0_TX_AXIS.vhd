library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
use work.project_pkg.all;

entity Packet_Generator_v1_0_TX_AXIS is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		C_M_AXIS_TDATA_WIDTH	: integer	:= 64;
		C_TRIGGER_DELAY_STAGES  : integer	:= 20
	);
	port (
		-- Users to add ports here
		int_clk : in std_logic; -- Internal Clock
		i_fifo_rd_en : in std_logic;
		fifo_full : out std_logic;
		fifo_data_in : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		fifo_data_valid : in std_logic_vector(C_M_AXIS_TDATA_WIDTH/8 -1 downto 0);
		fifo_data_last  : in std_logic;

		o_tx_packet_counter : out std_logic_vector (31 downto 0);
		o_tx_byte_counter   : out std_logic_vector (31 downto 0);

		
		o_tx_trigg : out std_logic;
		
		

		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Global ports
		M_AXIS_ACLK	: in std_logic;
		-- 
		M_AXIS_ARESETN	: in std_logic;
		-- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		M_AXIS_TVALID	: out std_logic;
		-- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		M_AXIS_TDATA	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		-- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
		M_AXIS_TSTRB	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
		-- TLAST indicates the boundary of a packet.
		M_AXIS_TLAST	: out std_logic;
		-- TREADY indicates that the slave can accept a transfer in the current cycle.
		M_AXIS_TREADY	: in std_logic
	);
end Packet_Generator_v1_0_TX_AXIS;

architecture implementation of Packet_Generator_v1_0_TX_AXIS is                                                                   
	attribute mark_debug : string;
    attribute mark_debug of o_tx_trigg : signal is "true";
	--streaming data valid
	signal axis_tvalid	: std_logic;
	signal axis_tstrb : std_logic_vector (C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
	--Last of the streaming data 
	signal axis_tlast, axis_tlast_pulse	: std_logic;
	--FIFO implementation signals
	signal tx_en	: std_logic;
	--The master has issued all the streaming data stored in FIFO
	signal tx_packet_counter : std_logic_vector (31 downto 0);
	signal tx_byte_counter   : std_logic_vector (31 downto 0);
	-- Custom logic

	signal s_tx_trigg_delay: std_logic_vector (C_TRIGGER_DELAY_STAGES-1 downto 0);

	COMPONENT fifo_generator_0
	PORT (
        clk : IN STD_LOGIC;
        srst : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(72 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(72 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC
      );
	END COMPONENT;
	

	signal fifo_empty : std_logic := '0';
	signal fifo_rd_en : std_logic := '0';
	signal din, dout  : std_logic_vector (C_M_AXIS_TDATA_WIDTH + (C_M_AXIS_TDATA_WIDTH/8) downto 0);
	signal s_fifo_full : std_logic := '0';
	signal fifo_rst    : std_logic := '0';


begin

	axis_tvalid <= not (fifo_empty);
    M_AXIS_TVALID <= axis_tvalid;
	
	AXIS_TLAST <= dout(C_M_AXIS_TDATA_WIDTH + (C_M_AXIS_TDATA_WIDTH/8)); -- MSB will be tlast
	M_AXIS_TLAST <= axis_tlast; 
	M_AXIS_TDATA <= dout (C_M_AXIS_TDATA_WIDTH-1 downto 0);
	axis_tstrb <= dout (C_M_AXIS_TDATA_WIDTH + (C_M_AXIS_TDATA_WIDTH/8)-1 downto C_M_AXIS_TDATA_WIDTH);
	M_AXIS_TSTRB <= axis_tstrb;
	
	din <= fifo_data_last & fifo_data_valid & fifo_data_in;

	--FIFO read enable generation 

	tx_en <= M_AXIS_TREADY and axis_tvalid;                                 
	                                                                                
	-- FIFO Implementation   
	
	fifo_rd_en <= i_fifo_rd_en and not(s_fifo_full);
	fifo_full <= s_fifo_full;
	fifo_rst  <= not(M_AXIS_ARESETN);
	
	fifo_tx : fifo_generator_0
	PORT MAP (
		srst => fifo_rst,
		clk => M_AXIS_ACLK,
		din => din,
		wr_en => fifo_rd_en,
		rd_en => tx_en,
		dout => dout,
		full => s_fifo_full,
		empty => fifo_empty
	);



	tx_trigger : process(M_AXIS_ACLK, axis_tlast_pulse)
	begin
		if M_AXIS_ARESETN = '0' then
			s_tx_trigg_delay <= (others => '0');
			axis_tlast_pulse <= '0';
		elsif rising_edge(M_AXIS_ACLK) then
			axis_tlast_pulse <= axis_tlast;
			s_tx_trigg_delay(0) <= axis_tlast and not axis_tlast_pulse;

			for i in C_TRIGGER_DELAY_STAGES-1 downto 1 loop
				s_tx_trigg_delay(i) <= s_tx_trigg_delay(i-1);
        	end loop;
			
		end if;
	end process;


	o_tx_trigg <=or_reduce(s_tx_trigg_delay);


	-- Description of logic dedicated to count the statistics related to RX
	stat_counter : process (M_AXIS_ACLK)
	begin
		if M_AXIS_ARESETN = '0' then
			tx_packet_counter <= (others => '0');
			tx_byte_counter   <= (others => '0');
		elsif rising_edge(M_AXIS_ACLK) then
			r_update_stats(
                tvalid       => axis_tvalid,
                tlast        => axis_tlast,
                tstrb        => axis_tstrb,
                pkt_cnt   => tx_packet_counter,
                byte_cnt  => tx_byte_counter
            );
		end if;
	end process;

	o_tx_packet_counter <= tx_packet_counter;
	o_tx_byte_counter <= tx_byte_counter;

end implementation;

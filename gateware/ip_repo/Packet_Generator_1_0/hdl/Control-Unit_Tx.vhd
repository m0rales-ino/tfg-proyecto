----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2025 06:54:10 PM
-- Design Name: 
-- Module Name: Control-Unit_Tx_0 - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Control_Unit_Tx is
    generic(C_M_AXIS_TDATA_WIDTH : integer := 64);
    Port ( i_eth_TX_En : in STD_LOGIC;
           i_payload_length : in STD_LOGIC_VECTOR (10 downto 0);
           i_fifo_full : in STD_LOGIC;

           o_fifo_data_in : out std_logic_vector (C_M_AXIS_TDATA_WIDTH-1 downto 0);
           o_fifo_data_valid : out std_logic_vector (C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
           o_fifo_data_last  : out std_logic;
           o_fifo_rd_en      : out std_logic;
           
           -- Signals from registers
           i_dest_MAC : in std_logic_vector (47 downto 0);
           i_src_MAC : in std_logic_vector (47 downto 0);
           i_payload_pattern : in std_logic_vector (31 downto 0);

           i_tx_gm_select : in std_logic_vector (2 downto 0);
           i_tx_gm_param  : in std_logic_vector (31 downto 0);

           -- Signals to registers
           o_DONE : out std_logic;

           rst : in std_logic;
           clk : in std_logic
    );
end Control_Unit_Tx;

architecture Behavioral of Control_Unit_Tx is

    --FSM signal and type declaration
    type t_STATES is (IDLE, E0, E1, E2, E3, DONE, HALT);
    signal current_st8 : t_STATES;
    signal next_st8 : t_STATES;

    

    -- Other signal declaration
    signal ctrl_mux : integer range 0 to 10 := 0;

    signal ether_type : std_logic_vector (15 downto 0);

    signal s_DONE : std_logic := '0';

    --signal counter : integer := 0;
    signal counter : std_logic_vector(10 downto 0);
    signal next_counter : std_logic_vector (10 downto 0);
    --signal next_counter : integer range 0 to 31 := 0;

    signal test : std_logic_vector (10 downto 0);
    --signal test : integer range 0 to 31 := 0;
    signal s_fifo_data_valid : std_logic_vector (C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    signal s_fifo_rd_en : std_logic;

    signal tx_packet_counter : std_logic_vector (31 downto 0);
    --signal tx_byte_counter   : std_logic_vector (55 downto 0) := (others => '0');
    signal tx_byte_counter : integer;
    signal tx_byte_index   : integer;

    signal sending_bytes   : integer;

    function set_last_bits(
        num_bits  : std_logic_vector(10 downto 0)
    ) 
    return std_logic_vector is
        variable vector : std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    begin
        vector := (others => '0');
        for i in C_M_AXIS_TDATA_WIDTH/8-1 downto 0 loop
            if i < num_bits then
                vector(i) := '1';
            end if;
        end loop;
    return vector;
    end function;

    function count_bits(
        vector : std_logic_vector (C_M_AXIS_TDATA_WIDTH/8-1 downto 0)
    )
    return integer is
        variable n_bits : integer;
    begin
        n_bits := 0;
        for i in C_M_AXIS_TDATA_WIDTH/8-1 downto 0 loop
            if vector(i) = '1' then
                n_bits := n_bits + 1;
            end if;
        end loop;
    return n_bits;
    end function;

    signal s_fifo_data_last : std_logic := '0';
    
    -- Burst Operation Mode signals
    signal bm_pckt_per_brst : std_logic_vector (15 downto 0);
    signal bm_clk_cycles_per_halt : std_logic_vector (15 downto 0);

    signal bm_halt         : std_logic := '0';
    signal tx_pckt_index   : std_logic_vector (31 downto 0);
    signal bm_halt_counter : std_logic_vector (31 downto 0);

    signal next_counter_trigg    : std_logic;

    signal counter_rst : std_logic;
    signal counter_enable : std_logic;

    -- attribute keep : string;
    -- attribute keep of next_counter : signal is "true";
    -- attribute keep of counter : signal is "true";
    attribute mark_debug : string;
    attribute mark_debug of current_st8 : signal is "true";
    attribute mark_debug of ctrl_mux : signal is "true";

begin
    
    o_fifo_data_valid <= s_fifo_data_valid;
    
    
    next_counter_trigg <= '1' when counter >= i_payload_length - "1000" else '0';
    FSM_COMB : process (i_eth_TX_En, current_st8, next_counter_trigg, bm_halt, i_fifo_full, s_DONE)
    begin
        if (rst = '0') then
            ctrl_mux <= 0;
            s_fifo_rd_en <= '0';
            counter_rst <= '1';
            counter_enable <= '0';
            s_fifo_data_valid <= (others => '0');
            s_fifo_data_last <= '0';
            next_counter <= (others => '0');
        else
            case (current_st8) is
                when IDLE =>
                    ctrl_mux <= 0;
                    s_fifo_rd_en <= '0';
                    counter_rst <= '1';
                    counter_enable <= '0';
                    s_fifo_data_valid <= (others => '0');
                    s_fifo_data_last <= '0';
                    next_counter <= (others => '0');
                        --s_DONE <= '0';
        
                    if i_eth_TX_En = '1' then
                        next_st8 <= E0;
                    else 
                        next_st8 <= IDLE;
                    end if;
                when E0 => 
                    s_fifo_rd_en <= '1';
                    counter_rst <= '1';
                    counter_enable <= '0';
                    ctrl_mux <= 0;
                    s_fifo_data_valid <= (others => '1');
                    s_fifo_data_last <= '0';
                    --s_DONE <= '0';
        
                    next_st8 <= E1;
                when E1 =>
                    s_fifo_rd_en <= '1';
                    ctrl_mux <= 1;
                    counter_rst <= '1';
                    counter_enable <= '0';
                    s_fifo_data_valid <= (others => '1');
                    s_fifo_data_last <= '0';
        
                    next_st8 <= E2;
        
                when E2 =>
                    s_fifo_rd_en <= '1';
                    ctrl_mux <= 2;
                    s_fifo_data_valid <= (others => '1');
                    s_fifo_data_last <= '0';
                    next_counter <= "00000000010";
                    counter_rst <= '0';
                    counter_enable <= '1';
        
                    next_st8 <= E3;
                when E3 =>
                    s_fifo_rd_en <= '1';
                    ctrl_mux <= 2;
                    next_counter <= "00000001000";

                    counter_rst <= '0';
                    counter_enable <= '1';                
                    
                    if next_counter_trigg = '1' then -- next_counter_trigg <= '1' when counter >= i_payload_length - "1000" else '0';
                        s_fifo_data_last <= '1';
                        s_fifo_data_valid <= set_last_bits(test);
                        if s_DONE = '1' then
                            next_st8 <= DONE;
                        elsif i_tx_gm_param = "011" and bm_halt = '1' then
                            next_st8 <= HALT;
                        elsif i_eth_TX_En = '1' then
                            next_st8 <= E0;
                        else
                            next_st8 <= IDLE;
                        end if;
                        
                    else
                        next_st8 <= E3;
                        s_fifo_data_last <= '0';
                        s_fifo_data_valid <= (others => '1');
                    end if;
                when DONE =>
                    ctrl_mux <= 0;
                    s_fifo_rd_en <= '0';
                    counter_rst <= '1';
                    counter_enable <= '0';    
                    s_fifo_data_valid <= (others => '0');
                    s_fifo_data_last <= '0';
                    if i_eth_TX_En = '1' then
                        next_st8 <= DONE;
                    else
                        next_st8 <= IDLE;
                    end if;
                when HALT =>
                    ctrl_mux <= 8;
                    s_fifo_rd_en <= '0';
                    counter_rst <= '1';
                    counter_enable <= '0';    
                    s_fifo_data_valid <= (others => '0');
                    s_fifo_data_last <= '0';
                    if bm_halt = '0' then
                        if i_eth_TX_En = '1' then
                            next_st8 <= E0;
                        else
                            next_st8 <= IDLE;
                        end if;
                    else
                        next_st8 <= HALT;
                    end if;
        
            end case;

            if i_fifo_full = '1' then
                s_fifo_rd_en <= '0';
                counter_enable <= '0';
        
                next_st8 <= current_st8;
            end if;
        end if;
    end process;

    FSM_SYNC : process (rst, clk)
    begin
        if (rst = '0') then
            current_st8 <= IDLE;

        elsif rising_edge(clk) then
            current_st8 <= next_st8;
            
        end if;

  
    end process FSM_SYNC;

    counter_proc: process (clk)
    begin
        if (rst = '0') then
            counter <= (others => '0');
        elsif rising_edge(clk) then
            if counter_enable = '1' then
                counter <= counter + next_counter;
            elsif counter_rst = '1' then 
                counter <= (others => '0');
            else
                counter <= counter;
            end if;
        end if;
    end process;

    
    o_fifo_data_last <= s_fifo_data_last;
    o_fifo_rd_en <= s_fifo_rd_en;
    
    stats_countering: process (clk)
    begin
        if rst = '0' then
            tx_packet_counter <= (others => '0');
            tx_byte_counter <= 0;
            tx_byte_index   <= 0;
            bm_halt_counter <= (others => '0');
        elsif rising_edge(clk) then
            -- Number of packets sent counter
            if s_DONE = '1' then
                tx_packet_counter <= (others => '0');
            elsif s_fifo_data_last = '1' and i_eth_TX_En = '1' then
                tx_packet_counter <= tx_packet_counter + "1";
            end if;

            -- Number of bytes sent counter
            
            if s_fifo_rd_en = '1' then
                tx_byte_counter <= tx_byte_counter + count_bits(s_fifo_data_valid);
                if s_DONE = '1' then
                    tx_byte_index <= tx_byte_counter;
                end if;
            end if;
            
            if bm_halt = '0' then
                bm_halt_counter <= (others => '0');
            elsif bm_halt = '1' and i_tx_gm_select = "011" then
                bm_halt_counter <= bm_halt_counter + "1";
            end if;
        end if;
    end process;

    o_DONE <= s_DONE;


    bm_pckt_per_brst <= i_tx_gm_param (15 downto 0);
    bm_clk_cycles_per_halt <= i_tx_gm_param (31 downto 16);

    done_halt_signaling : process (clk)
    begin
        if (rst = '0') then
            tx_pckt_index <= (others => '0');
        elsif rising_edge(clk) then
            case (i_tx_gm_select) is
                when "001" => -- Send specified number of packets
                    if i_tx_gm_param  <= (tx_packet_counter + "1") then
                        s_DONE <= '1';
                    else
                        s_DONE <= '0';
                    end if;
                when "010" => -- Send specified number of bytes
                    if i_tx_gm_param  <= tx_byte_counter then
                        s_DONE <= '1';
                    else
                        s_DONE <= '0';
                    end if;
                when "011" => -- Burst mode operation
                    if i_eth_TX_En = '1' and  (bm_pckt_per_brst + tx_pckt_index) <= tx_packet_counter + "1" then
                        bm_halt <= '1';
                        tx_pckt_index <= tx_pckt_index + bm_pckt_per_brst;
                    elsif bm_clk_cycles_per_halt <= bm_halt_counter then
                        bm_halt <= '0';
                    else
                        bm_halt <= bm_halt;
                    end if;

                when others =>
                    s_DONE <= '0';
            end case;
        end if;
    end process;
    
    -- CTRL_MUX_PROC : process(ctrl_mux, clk)
    -- begin
    --     case (ctrl_mux) is
    --         when 0 =>
    --             o_fifo_data_in <= i_src_MAC (15 downto 0) & i_dest_MAC (47 downto 0);
    --         when 1 =>
    --             o_fifo_data_in <= i_payload_pattern (15 downto 0) & ether_type & i_src_MAC (47 downto 16);
    --         when 2 =>
    --             o_fifo_data_in <= i_payload_pattern (15 downto 0) & i_payload_pattern (31 downto 0) & i_payload_pattern (31 downto 16);
    --         when others =>
    --             o_fifo_data_in <= X"1100110011001100";
    --     end case;
    -- end process;

    CTRL_MUX_PROC : process(clk)
    begin
        case (ctrl_mux) is
            when 0 =>
                o_fifo_data_in <= i_src_MAC (15 downto 0) & i_dest_MAC (47 downto 0);
            when 1 =>
                o_fifo_data_in <= tx_packet_counter (15 downto 0) & ether_type & i_src_MAC (47 downto 16);
            when 2 =>
                o_fifo_data_in <= i_payload_pattern (31 downto 0) & i_payload_pattern (31 downto 0);
            when others =>
                o_fifo_data_in <= X"1100110011001100";
        end case;
    end process;

    -- Combinational assigments

    --if () then
    ether_type <= i_payload_length(7 downto 0 ) & "00000" & i_payload_length (10 downto 8) ;
    test <= i_payload_length-counter;
    --end if;
end Behavioral;

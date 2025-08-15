----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/19/2025 03:39:47 PM
-- Design Name: 
-- Module Name: 2ff_sync - Behavioral
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


entity sync_2ff is
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
end sync_2ff;

architecture Behavioral of sync_2ff is
    signal data_a_ff1, data_a_ff2 : std_logic_vector (DATA_WIDTH-1 downto 0);
begin
    process (clk_b, arst)
    begin
        if arst = '0' then
            data_a_ff1 <= (others => '0');
            data_a_ff2 <= (others => '0');
        elsif rising_edge(clk_b) then
            data_a_ff1 <= data_a;
            data_a_ff2 <= data_a_ff1;
            data_b <= data_a_ff2;
        end if;
    end process;

end Behavioral;

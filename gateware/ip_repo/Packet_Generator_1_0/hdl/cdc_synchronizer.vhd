----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/19/2025 12:53:48 PM
-- Design Name: 
-- Module Name: cdc_synchronizer - Behavioral
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
--use IEEE.numeric_std.all;

entity cdc_synchronizer is
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
end cdc_synchronizer;

architecture Behavioral of cdc_synchronizer is
    
    signal req : std_logic_vector(2 downto 0);
    signal ack : std_logic_vector(2 downto 0);
    signal data_a_latch : std_logic_vector (DATA_WIDTH-1 downto 0);

begin

    process (clk_a, arst)
    begin
        if (arst = '0') then
            data_a_latch <= (others => '0');
            req(0) <= '0';
            ack (2 downto 1) <= (others => '0');
        elsif rising_edge(clk_a) then
            ack(1) <= ack(0);
            ack(2) <= ack(1);

            if req(0) = '0' and ack(2) = '0' then
                data_a_latch <= data_a;
                req(0) <= '1';
            elsif req(0) = '1' and ack(2) = '1' then
                req(0) <= '0';
            end if;
        end if;
    end process;

    process (clk_b, arst)
    begin
        if (arst = '0') then
            data_b <= (others => '0');
            req (2 downto 1) <= (others => '0');
            ack(0) <= '0';
        elsif rising_edge(clk_b) then
            req(1) <= req(0);
            req(2) <= req(1);
            if req(2) = '1' and ack(0) = '0' then
                data_b <= data_a_latch;
                ack(0) <= '1';
            elsif req(2) = '0' and ack(0) = '1' then
                ack(0) <= '0';
            end if;
        end if;
    end process;

end Behavioral;

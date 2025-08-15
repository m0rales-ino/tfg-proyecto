library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package project_pkg is

    function count_bits(
        vector : std_logic_vector
    )
    return integer;

    procedure r_update_stats(
        signal tvalid       : in  std_logic;
        signal tlast        : in  std_logic;
        signal tstrb        : in  std_logic_vector;
        signal pkt_cnt   : inout std_logic_vector;
        signal byte_cnt  : inout std_logic_vector
    );

end package;

package body project_pkg is

    -- This function counts de number of bits of a vector. It is used to abstract the number
	-- of bytes received leveraging the axi stream strb vector.
	function count_bits(
        vector : std_logic_vector
    )
    return integer is
        variable n_bits : integer;
    begin
        n_bits := 0;
        for i in 0 to vector'length-1 loop
            if vector(i) = '1' then
                n_bits := n_bits + 1;
            end if;
        end loop;
    return n_bits;
    end function;

    procedure r_update_stats(
        signal tvalid       : in  std_logic;
        signal tlast        : in  std_logic;
        signal tstrb        : in  std_logic_vector;
        signal pkt_cnt   : inout std_logic_vector;
        signal byte_cnt  : inout std_logic_vector
    ) is
    begin
        if tlast = '1' and tvalid = '1' then
            pkt_cnt <= pkt_cnt + "1";
        end if;

        if tvalid = '1' then
            byte_cnt <= byte_cnt + count_bits(tstrb);
        end if;
    end procedure;

end package body project_pkg;
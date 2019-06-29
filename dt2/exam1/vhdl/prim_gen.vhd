-----------------------------------------------------------------
-- Name: Burkhardt
-- Vorname: Simon
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity prim_gen is
  port( 
    rst        : in     std_ulogic;
    clk        : in     std_ulogic;
    en         : in     std_ulogic;
    prim       : out    std_ulogic_vector (3 downto 0);
    prim_valid : out    std_ulogic
  );
end entity prim_gen;

architecture logic_prim_count of prim_gen is

begin

	p_primes : process( rst, clk )
	begin
		if rst = '1' then
			prim <= (others => '0');
		elsif rising_edge(clk) then
			if en = '1' then
				if (prim = "0000") then
					prim <= "0010";
				elsif prim = "0010" then
					prim <= "0011";
				elsif prim = "0011" then
					prim <= "0101";
				elsif prim = "0101" then
					prim <= "0111";
				elsif prim = "0111" then
					prim <= "1011";
				elsif prim = "1011" then
					prim <= "1101";
				elsif prim <= "1101" then
					prim <= "0010";  -- wrap around
				else 
					prim <= "0000";
				end if;
			else
				prim <= "0000";
			end if;
		end if;
	end process p_primes; 

	prim_valid <= '0' when prim = "0000" else '1';

end architecture logic_prim_count;


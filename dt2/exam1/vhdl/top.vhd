-----------------------------------------------------------------
-- Name: Burkhardt
-- Vorname: Simon
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity top is
  port( 
    clk       : in     std_ulogic;
    en        : in     std_ulogic;
    rst       : in     std_ulogic;
    avg       : out    std_ulogic_vector (3 downto 0);
    avg_valid : out    std_ulogic
  );
end entity top ;

architecture average_prime of top is

	component avg_gen
		port( 
		    reset      : in     std_ulogic;
		    clock      : in     std_ulogic;
		    data       : in     std_ulogic_vector (3 downto 0);
		    data_valid : in     std_ulogic;
		    avg        : out    std_ulogic_vector (3 downto 0)
		  );
	end component;

	component prim_gen
		port( 
		    rst        : in     std_ulogic;
		    clk        : in     std_ulogic;
		    en         : in     std_ulogic;
		    prim       : out    std_ulogic_vector (3 downto 0);
		    prim_valid : out    std_ulogic
		  );
	end component;

	signal s_prime : std_ulogic_vector (3 downto 0);
	signal s_valid : std_ulogic;
	signal s_avg   : std_ulogic_vector (3 downto 0);

begin
	
	io_prim_gen : prim_gen
	port map ( clk => clk,
		rst => rst,
		en => en,
		prim => s_prime,
		prim_valid => s_valid);

	io_avg_gen : avg_gen
	port map ( clock => clk,
		reset => rst,
		data => s_prime,
		data_valid => s_valid,
		avg => s_avg
		);

	avg <= s_avg;
	
end architecture average_prime;


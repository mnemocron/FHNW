-----------------------------------------------------------------
-- Name: Burkhardt
-- Vorname: Simon
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;

entity verify is
  port(rd_data     : in  std_ulogic_vector (31 downto 0);
       rd_data_rdy : in  std_ulogic;
       empty       : in  std_ulogic;
       full        : in  std_ulogic;
       rst         : out std_ulogic;
       clk         : out std_ulogic;
       wr_data     : out std_ulogic_vector (31 downto 0);
       wr_req      : out std_ulogic;
       rd_req      : out std_ulogic);
end entity verify ;


architecture stim_and_mon of verify is
  constant c_cycle_time : time := 20 ns;
  signal enable : boolean := true;
  signal s_value : std_ulogic_vector(31 downto 0);
begin
  
  -------------------------------------------------------
  -- System reset:
  rst <= transport '1', '0' after 10 ns;

  p_stim : process
  	-- File ist relativ zum workspace auf meinem PC 
  	-- file input_file : text open read_mode is "./BurkhardtSimon/stim/fifo_values.txt";
  	file input_file : text open read_mode is "./stim/fifo_values.txt";
	variable v_input_line : line;
	variable v_value : std_ulogic_vector(31 downto 0);
	variable n : natural;
  begin
    rd_req <= '0';
  	wr_req <= '0';
  	-- schreiben 8x
  	n := 0;
  	wait for 100 ns;
  	while n < 8 loop
  		readline(input_file, v_input_line); -- liest 1... Zeile 
		hread(v_input_line, v_value); 		-- liest 1... Wert aus 1... Zeile
		wr_data <= v_value;
		wait for c_cycle_time/4;
		wr_req <= '1';
		wait for c_cycle_time/2;
		wr_req <= '0';
		wait for c_cycle_time/4;
		n := n+1;
	end loop;

	-- schreiben 8x
	n := 0;
  	wait for 100 ns;
  	while n < 8 loop
  		readline(input_file, v_input_line); -- liest 9... Zeile 
		hread(v_input_line, v_value); 		-- liest 9... Wert aus 9... Zeile
		wr_data <= v_value;
		wait for c_cycle_time/4;
		wr_req <= '1';
		wait for c_cycle_time/2;
		wr_req <= '0';
		wait for c_cycle_time/4;
		n := n+1;
	end loop;
	wait for 100 ns;

	-- Lesen 16x
	while n < 15 loop
		rd_req <= '1';
		wait until rd_data_rdy = '1';
		s_value <= rd_data;
		rd_req <= '0';
		n := n+1;
	end loop;

	wait for 100 ns;

	-- write hat bei mir hier nicht funktioniert
	write(output, "simulation done");
	-- Implementation vom selbständigen Ahnalten habe ich nicht gefunden
	wait;  -- nicht nochmals ausführen
  end process p_stim;

  -- 50MHz
  p_system_clk : process
  begin
    while enable loop
      clk <= '0';
      wait for c_cycle_time/2;
      clk <= '1';
      wait for c_cycle_time/2;
    end loop;
    wait;  -- don't do it again
  end process p_system_clk;
  -------------------------------------------------------
  
  -------------------------------------------------------
  p_mon_status : process
  	variable n : natural; 
  begin
  	wait until falling_edge(rst);
  	assert empty = '1' report "empty is not 1: " & to_string(empty) severity error;
  	assert full = '0' report "full is not 0: " & to_string(full) severity error;

  	-- Schreiben 16x
	while n < 15 loop
		wait until falling_edge(wr_req);
		assert empty = '0' report "empty is not 0: " & to_string(empty) & " at write: " & to_string(n) severity error;
  		assert full = '0' report "full is not 0: " & to_string(full) & " at write: " & to_string(n) severity error;
		n := n+1;
	end loop;
	-- now Full
	wait until falling_edge(wr_req);
	assert empty = '0' report "empty is not 0: " & to_string(empty) severity error;
  	assert full = '1' report "full is not 1: " & to_string(full) severity error;

	-- Lesen 16x
	while n < 15 loop
		wait until falling_edge(wr_req);
		assert empty = '1' report "empty is not 1: " & to_string(empty) & " at write: " & to_string(n) severity error;
  		assert full = '0' report "full is not 0: " & to_string(full) & " at write: " & to_string(n) severity error;
		n := n+1;
	end loop;
	-- now Empty
	wait until falling_edge(wr_req);
	assert empty = '1' report "empty is not 1: " & to_string(empty) severity error;
  	assert full = '0' report "full is not 0: " & to_string(full) severity error;
  	wait;  -- don't do it again
  end process p_mon_status;
  -------------------------------------------------------

  -------------------------------------------------------
  p_mon_level : process
  	alias a_sig_level is <<signal .tb_fifo.duv.level : std_ulogic_vector(4 downto 0)>>;
  begin
  	wait until rising_edge(full);
  	assert a_sig_level = "10000" report "level is not (16) b10000: " & to_string(a_sig_level) severity error; 
  	wait;  -- don't do it again
  end process p_mon_level;
  ------------------------------------------------------- 

end architecture stim_and_mon;


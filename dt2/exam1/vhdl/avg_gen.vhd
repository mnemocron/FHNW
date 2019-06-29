-----------------------------------------------------------------
-- Name: Burkhardt
-- Vorname: Simon
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avg_gen is
  port( 
    reset      : in     std_ulogic;
    clock      : in     std_ulogic;
    data       : in     std_ulogic_vector (3 downto 0);
    data_valid : in     std_ulogic;
    avg        : out    std_ulogic_vector (3 downto 0)
  );
end entity avg_gen ;


architecture rtl of avg_gen is
  signal data_cnt : unsigned(6 downto 0);
  signal sum      : unsigned(6 downto 0);
begin

  p_data_cnt : process(reset, clock)
  begin
    if reset = '1' then
      data_cnt <= "0000000";
      sum <= "0000000";
      avg <= (others => '0');
    elsif rising_edge(clock) then
      if data_valid = '1' and sum < 100 then
        data_cnt <= data_cnt + 1;
        sum <= sum + unsigned(data);
      elsif sum > 99 then
        avg <= std_ulogic_vector(resize((sum / data_cnt), avg'length));
      end if;
    end if;
  end process p_data_cnt;

end architecture rtl;

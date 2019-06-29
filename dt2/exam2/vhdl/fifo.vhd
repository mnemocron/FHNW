library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo is
  port(rst            : in  std_ulogic;
       clk            : in  std_ulogic;
       fifo_in        : in  std_ulogic_vector (31 downto 0);
       fifo_wr        : in  std_ulogic;
       fifo_rd        : in  std_ulogic;
       fifo_out       : out std_ulogic_vector (31 downto 0);
       fifo_out_valid : out std_ulogic;      
       fifo_empty     : out std_ulogic;
       fifo_full      : out std_ulogic);
end entity fifo;


architecture rtl of fifo is
  type t_mem is array(0 to 15) of std_ulogic_vector(31 downto 0);
  signal wr_ptr : unsigned(3 downto 0);
  signal rd_ptr : unsigned(3 downto 0);
  signal level  : unsigned(4 downto 0);
  signal mem : t_mem;
  signal fifo_empty_i : std_ulogic;
  signal fifo_full_i : std_ulogic;
begin

  p_wr_ptr : process(rst, clk)
  begin
    if rst = '1' then
      wr_ptr <= (others => '0');
    elsif rising_edge(clk) then
      if fifo_wr = '1' and fifo_full_i = '0' then
        wr_ptr <= wr_ptr+1;
      end if;
    end if;
  end process p_wr_ptr;
  
  
  p_rd_ptr : process(rst, clk)
  begin
    if rst = '1' then
      rd_ptr <= (others => '0');
    elsif rising_edge(clk) then
      if fifo_rd = '1' and fifo_empty_i = '0' then
        rd_ptr <= rd_ptr+1;
      end if;
    end if;
  end process p_rd_ptr;
  
  
  p_level : process(rst, clk)
  begin
    if rst = '1' then
      level <= (others => '0');
    elsif rising_edge(clk) then
      if fifo_wr = '1' and fifo_full_i = '0' and fifo_rd = '0' then
        level <= level+1;
      elsif fifo_wr = '0' and fifo_rd = '1' and fifo_empty_i = '0' then
        level <= level-1;
      end if;
    end if;
  end process p_level;
  
  -- status:
  fifo_empty_i <= '1' when level = 0 else '0';
  fifo_full_i  <= '1' when level = 16 else '0';
  
  fifo_empty <= fifo_empty_i;
  fifo_full  <= fifo_full_i;
  
  p_write : process(rst, clk)
  begin
    if rst = '1' then
      mem <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if fifo_wr = '1' and fifo_full_i = '0' then 
        mem(to_integer(wr_ptr)) <= fifo_in;
      end if;
    end if;
  end process p_write;
  
  p_read : process(rst, clk)
  begin
    if rst = '1' then
      fifo_out <= (others => '0');
      fifo_out_valid <= '0';
    elsif rising_edge(clk) then
      if fifo_rd = '1' and fifo_empty_i = '0' then
        fifo_out <= mem(to_integer(rd_ptr));
      end if;
      fifo_out_valid <= fifo_rd;
    end if;
  end process p_read;  
  
end architecture rtl;

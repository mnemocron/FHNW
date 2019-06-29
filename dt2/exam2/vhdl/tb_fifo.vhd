-----------------------------------------------------------------
-- Name: Burkhardt
-- Vorname: Simon
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity tb_fifo is
end entity tb_fifo;


architecture struct of tb_fifo is
  	-- Component declarations:
  component verify is
  	port(rd_data     : in  std_ulogic_vector (31 downto 0);
       rd_data_rdy : in  std_ulogic;
       empty       : in  std_ulogic;
       full        : in  std_ulogic;
       rst         : out std_ulogic;
       clk         : out std_ulogic;
       wr_data     : out std_ulogic_vector (31 downto 0);
       wr_req      : out std_ulogic;
       rd_req      : out std_ulogic);
  end component verify ;

  component fifo is
    port(rst            : in  std_ulogic;
       clk            : in  std_ulogic;
       fifo_in        : in  std_ulogic_vector (31 downto 0);
       fifo_wr        : in  std_ulogic;
       fifo_rd        : in  std_ulogic;
       fifo_out       : out std_ulogic_vector (31 downto 0);
       fifo_out_valid : out std_ulogic;      
       fifo_empty     : out std_ulogic;
       fifo_full      : out std_ulogic);
  end component fifo;

  -- Internal signal declaration:
  signal rst : std_ulogic;
  signal clk : std_ulogic;
  signal wr_req : std_ulogic;
  signal wr_data : std_ulogic_vector(31 downto 0);
  signal rd_req : std_ulogic;
  signal rd_data : std_ulogic_vector(31 downto 0);
  signal rd_data_rdy : std_ulogic;
  signal empty : std_ulogic;
  signal full : std_ulogic;
begin

	stim : verify
		port map(
			rd_data => rd_data,
			rd_data_rdy => rd_data_rdy,
			empty => empty,
			full => full,
			rst => rst,
			clk => clk,
			wr_data => wr_data,
			wr_req => wr_req,
			rd_req => rd_req
		);

	duv : fifo
		port map(
			rst => rst,
			clk => clk,
			fifo_in => wr_data,
			fifo_wr => wr_req,
			fifo_rd => rd_req,
			fifo_out => rd_data,
			fifo_out_valid => rd_data_rdy,
			fifo_empty => empty,
			fifo_full => full  
		);


end architecture struct;

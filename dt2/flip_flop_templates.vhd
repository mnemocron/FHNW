-- Templates for flip-flops in VHDL

-- D flip-flops / registers
reg: process (clk) is
begin
	if rising_edge(clk) then
		q <= d;
	end if;
end process reg;

-- D flip-flops with clock enable input
reg: process (clk) is
begin
	if rising_edge(clk) then
		if ce = '1' then
			q <= d;
		end if;
	end if;
end process reg;

-- synchronous reset
reg: process (clk) is
begin
	if rising_edge(clk) then
		if reset = '1' then
			q <= '0';
		elsif ce = '1' then
			q <= d;
		end if;
	end if;
end process reg;

-- asynchronous reset
reg: process (clk, reset) is
begin
	if reset = '1' then
		q <= '0';
		elsif rising_edge(clk) then
			if ce = '1' then
			q <= d;
		end if;
	end if;
end process reg;

-- for multibit register initialization
q <= "000000";


-- latch (rarely used)
latch: process (LE, D) is
begin
	if LE = '1' then
		q <= d;
	end if;
end process latch;

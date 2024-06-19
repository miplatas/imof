library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity modm is
generic(
    N: integer := 4
    );
    
port(
    clk,reset,enable: in STD_LOGIC;
    max_tick: out STD_LOGIC;
    M: in STD_LOGIC_VECTOR(N-1 downto 0);
    q: out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end modm;

architecture Behavioral of modm is
    signal r_reg: unsigned(N-1 downto 0);
    signal r_next: unsigned(N-1 downto 0);
    signal mtick: std_logic;

begin
process(clk,reset)
begin
if (reset = '1') then
    r_reg <= (others=> '0');
elsif rising_edge(clk) then
    if (enable = '1') then
        r_reg <= r_next;
    end if;
end if;
end process;    

r_next <= (others => '0') when r_reg = (unsigned(M)-1) else r_reg+1;

q <= std_logic_vector(r_reg);
mtick <= '1' when r_reg = (unsigned(M)-1) else '0';
max_tick <= mtick and enable;

end Behavioral;

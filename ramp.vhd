library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ramp is
    Port ( input  : in  STD_LOGIC_VECTOR(7 downto 0); 
           clk, reset, enable : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR(7 downto 0)
         );
end ramp;

architecture Behavioral of ramp is

signal counter_tick : STD_LOGIC;
signal counter_next, counter_reg : unsigned(7 downto 0) := (others => '0'); 

begin

ramp_modm_unit: entity work.modm(Behavioral)
    generic map(N => 24)
    port map(clk => clk, reset => reset, enable => enable, q => open, max_tick => counter_tick, M => "100110001001011010000000");

-- register
process(clk, reset)
begin
    if reset = '1' then
        counter_reg <= (others => '0');
    elsif rising_edge(clk) then
            counter_reg <= counter_next; 
    end if;
end process;

process(counter_reg, counter_tick)
begin
counter_next <= counter_reg;
if counter_tick='1' then
        if counter_reg < unsigned(input) then
            counter_next <= counter_reg+1;
        end if;
        if counter_reg > unsigned(input) then
            counter_next <= counter_reg-1;
        end if;  
end if; 
end process;

output <= std_logic_vector(counter_reg);

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_level_desc is
generic(
    delay: integer := 15 -- max delay 19 pulsos
    );

    Port ( clk         : in  STD_LOGIC;
           start      : in STD_LOGIC;
           reset       : in STD_LOGIC;
           input  : in  STD_LOGIC_VECTOR(15 downto 0); 
           LED    : out STD_LOGIC_VECTOR(15 downto 0);
           igbt    : out STD_LOGIC_VECTOR(5 downto 0);
           seg : out STD_LOGIC_VECTOR(6 downto 0);
           dp : out STD_LOGIC;
           an : out STD_LOGIC_VECTOR(3 downto 0)
           );
end top_level_desc;

architecture Behavioral of top_level_desc is

signal freq_sine : std_logic_vector(15 downto 0);
signal freq_carrier : std_logic_vector(15 downto 0);
signal input_ramp : std_logic_vector(15 downto 0);
signal enable : std_logic;

begin

inverter_unit: entity work.Inversor(Behavioral)
    generic map(Delay => 10)
    port map(clk => clk, start=>start, reset => reset, enable => enable, freq_sine => freq_sine, freq_carrier => freq_carrier, LED => LED, igbt => igbt, mode => input(15));

sseg_unit: entity work.ssegdriver(Behavioral)
    port map(input => input_ramp, reset => reset, enable => enable, clk => clk, sseg => seg, dp => dp, an => an);

ramp_freq_unit: entity work.ramp(Behavioral)
    port map(input => input(7 downto 0), reset => reset, enable => enable, clk => clk, output => input_ramp(7 downto 0));

freq_sine <= std_logic_vector(unsigned("00" & input_ramp(7 downto 0) & "100000"));
freq_carrier <= std_logic_vector(unsigned("000000000" & input(14 downto 8)));
input_ramp(15 downto 8) <= input(14 downto 8) & "1";

end Behavioral;

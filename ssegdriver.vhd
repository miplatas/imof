library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ssegdriver is
    Port ( input  : in  STD_LOGIC_VECTOR(15 downto 0); 
           clk, reset, enable : in STD_LOGIC;
           sseg : out STD_LOGIC_VECTOR(6 downto 0);
           dp : out STD_LOGIC;
           an : out STD_LOGIC_VECTOR(3 downto 0)
         );
end ssegdriver;

architecture Behavioral of ssegdriver is

signal digitv : std_logic_vector(3 downto 0);
signal ssegv : std_logic_vector(6 downto 0);
signal disp_num : std_logic_vector(19 downto 0);
signal disp_l2 : std_logic_vector(1 downto 0);


begin

inverter_unit: entity work.bcdto7seg(Behavioral)
    port map(digit => digitv, sseg => ssegv);

sseg_modm_unit: entity work.modm(Behavioral)
    generic map(N => 20)
    port map(clk => clk, reset => '0', enable => '1', q => disp_num, max_tick => open, M => "11111111111111111111");

    disp_l2 <= disp_num(19 downto 18);
    
    process(disp_l2)
    begin
        case disp_l2 is
            when "00" => digitv <= input(3 downto 0); -- 0
            when "01" => digitv <= input(7 downto 4); -- 1
            when "10" => digitv <= input(11 downto 8); -- 2
            when "11" => digitv <= input(15 downto 12); -- 3
            when others => digitv <= "0000"; -- Apagar todos los segmentos
        end case;
    end process;

    process(disp_l2)
    begin
        case disp_l2 is
            when "00" => sseg <= ssegv; -- 0
            when "01" => sseg <= ssegv; -- 1
            when "10" => sseg <= ssegv; -- 2
            when "11" => sseg <= ssegv; -- 3
            when others => sseg <= "0000000"; -- Apagar todos los segmentos
        end case;
    end process;
    
       process(disp_l2, reset)
    begin
        case disp_l2 is
            when "00" => an <= "1110"; -- 0
            when "01" => an <= "1101"; -- 1
            when "10" => an <= "1011"; -- 2
            when "11" => an <= "0111"; -- 3
            when others => an <= "1111"; -- Apagar todos los segmentos
        end case;
    end process; 
    
           process(disp_l2)
    begin
        case disp_l2 is
            when "00" => dp <= '1'; -- 0
            when "01" => dp <= '1'; -- 1
            when "10" => dp <= '0'; -- 2
            when "11" => dp <= '1'; -- 3
            when others => dp <= '0'; -- Apagar todos los segmentos
        end case;
    end process; 
    
end Behavioral;

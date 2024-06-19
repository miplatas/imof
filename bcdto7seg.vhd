library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcdto7seg is
    Port ( digit  : in  STD_LOGIC_VECTOR(3 downto 0); 
           sseg : out STD_LOGIC_VECTOR(6 downto 0)
         );
end bcdto7seg;

architecture Behavioral of bcdto7seg is
begin
    process(digit)
    begin
        case digit is
            when "0000" => sseg <= "1000000"; -- 0
            when "0001" => sseg <= "1111001"; -- 1
            when "0010" => sseg <= "0100100"; -- 2
            when "0011" => sseg <= "0110000"; -- 3
            when "0100" => sseg <= "0011001"; -- 4
            when "0101" => sseg <= "0010010"; -- 5
            when "0110" => sseg <= "0000010"; -- 6
            when "0111" => sseg <= "1111000"; -- 7
            when "1000" => sseg <= "0000000"; -- 8
            when "1001" => sseg <= "0010000"; -- 9
            when "1010" => sseg <= "0001000"; -- A
            when "1011" => sseg <= "0000011"; -- B
            when "1100" => sseg <= "1000110"; -- C
            when "1101" => sseg <= "0100001"; -- D
            when "1110" => sseg <= "0000110"; -- E
            when "1111" => sseg <= "0001110"; -- F
            when others => sseg <= "1111111"; -- Apagar todos los segmentos en caso no definido
        end case;
    end process;
end Behavioral;


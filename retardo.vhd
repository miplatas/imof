library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity retardo is
    Port (  clk, reset : in STD_LOGIC;
            igbt_in : in STD_LOGIC_VECTOR(1 downto 0);
            igbt_out : out STD_LOGIC_VECTOR(1 downto 0)
           );
end retardo;

architecture Behavioral of retardo is

    constant N : integer := 5; -- retraso de 10 clocks a 100 MHz 
    type state_type is (zero, waitup, waitdown, one, idle);
    signal state_reg, state_next : state_type;
    signal q_reg, q_next : unsigned(N-1 downto 0);
    signal q_load, q_dec, q_zero : std_logic;
    

begin
-- FSMD
process(clk, reset)
begin
    if reset = '1' then
        state_reg <= idle;
        q_reg <= (others =>'0');
    elsif (clk'event and clk='1') then
        state_reg <= state_next;
        q_reg <= q_next;
    end if;
end process;

-- FSMD data path
q_next <= (others => '1') when q_load = '1' else
            q_reg - 1 when q_dec = '1' else
            q_reg;
            
q_zero <= '1' when q_next = 0 else '0';

-- FSMD control path
process(state_reg, igbt_in, q_zero)
begin
    q_load <= '0';
    q_dec <= '0';
    igbt_out <= "00";
    state_next <= state_reg;

case state_reg is
    when idle =>
        if (igbt_in = "10") then
            state_next <= waitup;
            q_load <= '1';
        end if;
        if (igbt_in = "01") then
            state_next <= waitdown;
            q_load <= '1';
        end if;           
    when waitup =>
        if (igbt_in = "10") then
            q_dec <= '1';
            if (q_zero = '1') then
                state_next <= one;
            end if;
        end if;
    when one => 
        igbt_out <= "10";
        if (igbt_in = "01") then
            state_next <= waitdown;
            q_load <= '1';
        end if;
    when waitdown =>
        if (igbt_in = "01") then
            q_dec <= '1';
            if (q_zero = '1') then
                state_next <= zero;
            end if;
        end if;
    when zero => 
        igbt_out <= "01";
        if (igbt_in = "10") then
            state_next <= waitup;
            q_load <= '1';
        end if;
    end case;
end process;

end Behavioral;

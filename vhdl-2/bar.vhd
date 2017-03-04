
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_1164.all;

entity Bar is
end entity Bar;

architecture Struct of Bar is
    signal wclk    : std_logic;
    signal we      : std_logic;
    signal lwe     : std_logic;
    
    signal done    : boolean;
    signal counter : natural := 0;
begin
    process (wclk, we)
    begin
        if wclk'event and wclk='1' then
            lwe <= we;
        end if;
    end process;
    
    we <=
        '0' when counter=0 else
        '1' when counter=1 else
        '1' when counter=2 else
        '0' when counter=3 else
        '0' when counter=4 else
        '1' when counter=5 else
        '0' when counter=6 else
        '0' when counter=7 else '0';
    
    process (wclk) begin
        if falling_edge(wclk) then
            counter <= counter + 1;
        end if;
    end process;
    
    done <= counter >= 20;
    
    process begin
        while not done loop
            wclk <= '1';
            wait for 5 ns;
            wclk <= '0';
            wait for 5 ns;
        end loop;
        wait;
    end process;
end Struct;


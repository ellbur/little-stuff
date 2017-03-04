
library ieee;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_1164.all;

entity Main is
end entity Main;

architecture Behavior of Main is
    signal x : std_logic := '0';
begin
    -- http://ghdl.free.fr/ghdl/The-hello-word-program.html#The-hello-word-program
    process
        variable l : line;
    begin
        wait for 0 ns;
        
        write(l, String'("Yo"));
        writeline(output, l);
        
        wait;
    end process;
end Behavior;


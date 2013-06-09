
library ieee;
use std.textio.all;
-- For printf
library EASICS_PACKAGES;
use EASICS_PACKAGES.PCK_FIO.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Main is
end entity Main;

architecture Behavior of Main is
    signal x : unsigned(7 downto 0) := (others => '0');
    signal y : unsigned(7 downto 0) := (others => '0');
    signal z : unsigned(7 downto 0);
    signal p : natural range 0 to 255;
    signal q : natural range 0 to 255;
    signal r : natural range 0 to 255;
begin
    
    p <= to_integer(x);
    q <= to_integer(y);
    r <= to_integer(z);
    y <= x;
    z <= x;
    
    -- http://ghdl.free.fr/ghdl/The-hello-word-program.html#The-hello-word-program
    process
        variable l : line;
    begin
        fprint(output, l, "Hi\n");
        wait;
    end process;
end Behavior;


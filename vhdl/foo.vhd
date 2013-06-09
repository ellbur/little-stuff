
-- --------------------------------------------------------
-- Encoder

library ieee;
use ieee.std_logic_1164.all;

-- 4 -> 2 priority encoder
entity P4 is
    port (
        lines : in std_logic_vector(3 downto 0);
        which : out std_logic_vector(1 downto 0)
    );
end P4;

architecture P4_arch of P4 is
begin
    -- Continuous assignment implementation
    which <= "00" when lines(0) = '1' else
             "01" when lines(1) = '1' else
             "10" when lines(2) = '1' else
             "11";
    
    -- Procedural implementation
    --process() begin
    --    if (lines(0) = '1')    then which <= "00";
    --    elsif (lines(1) = '1') then which <= "01";
    --    elsif (lines(2) = '1') then which <= "10";
    --    else                        which <= "11";
    --    end if;
    --end process;
end P4_arch;

-- --------------------------------------------------------

library ieee;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_1164.all;

entity Main is
end entity Main;

architecture Behavior of Main is
    component P4
        port (
            lines : in std_logic_vector(3 downto 0);
            which : out std_logic_vector(1 downto 0)
        );
    end component;
    
    function v(b: std_logic) return std_logic_vector is
        variable it : std_logic_vector(0 downto 0);
        begin
            it(0) := b;
            return it;
        end;
            
    signal which : std_logic_vector(1 downto 0);
begin
    p4_1 : P4 port map("0110", which);
    
    -- http://ghdl.free.fr/ghdl/The-hello-word-program.html#The-hello-word-program
    process
        variable l : line;
    begin
        -- Let the logic happen first
        wait for 0 ns;
        
        -- Now print out the results!
        write(l, String'("Position: "));
        write(l, which);
        writeline(output, l);
        
        -- Now assert that they are what they should be
        assert(which = "01");
        
        -- And test that function from above
        assert("110" = v('1') & v('1') & v('0'));
        
        wait;
    end process;
end Behavior;


library ieee;
use ieee.std_logic_1164.all;

entity tb_MyNand is
end tb_MyNand;

architecture TB of tb_MyNand is

    -- component declaration for module under test
    component mynand
    port (  a   : in    std_ulogic;
            b   : in    std_ulogic;
            x   : out   std_ulogic);
    end component mynand;

    -- signal declaration
    signal u, v, w : std_ulogic;

begin

    -- instantiate the module under test
    inst_nynand : mynand
    port map (  a => u,
                b => v,
                x => w);

    process

        -- variable actual, expected, check_fail : std_ulogic := '0';

        -----------------------------------------------------------------------
        -- procedure for testing automatically
        procedure testcase (in_a : in std_ulogic;
                            in_b : in std_ulogic) is
        variable actual, expected, check_fail : std_ulogic := '0';
        begin
            -- connect given input signals to DUT
            u <= in_a;
            v <= in_b;
            -- wait for signals to settle
            wait for 1 ms;
            -- read actual value from DUT
            actual := w;
            -- compute expected result
            expected := not(in_a and in_b);
            -- compare actual and expected responses
            check_fail := actual xor expected;
            if check_fail = '1' then
                report "ERROR for input pattern: " &
                std_ulogic'image(u) & " " & std_ulogic'image(v) &
                "\n actual: "  & std_ulogic'image(actual) & 
                " expected: " & std_ulogic'image(expected)
                severity failure;
            else
                report "Input pattern: " & std_ulogic'image(u) &
                " " & std_ulogic'image(v) & " tested OK."
                severity note;
            end if;
        end procedure testcase;

    begin

        -----------------------------------------------------------------------
        -- test patterns: 
        --
        -- u v -> w
        -- 0 0 -> 1
        -- 0 1 -> 1
        -- 1 0 -> 1
        -- 1 1 -> 0

        -- 1st test pattern
        testcase('0','0');
        -- 2nd test pattern
        testcase('0','1');
        -- 3th test pattern
        testcase('1','0');
        -- 4th test pattern
        testcase('1','1');

        -----------------------------------------------------------------------
        report "==== End of Simulation ====" severity failure;

    end process;
  
end TB;


library ieee;
use ieee.std_logic_1164.all;

entity MyAnd is
    port (  a_and : in  std_logic;
            b_and : in  std_logic;
            x_and : out std_logic);
end MyAnd;

architecture TWOAND of MyAnd is

begin

    x_and <= a_and and b_and;

end architecture TWOAND;

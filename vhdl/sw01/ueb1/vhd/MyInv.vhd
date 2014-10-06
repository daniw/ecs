library ieee;
use ieee.std_logic_1164.all;

entity MyInv is
    port (  a_inv : in    std_ulogic;
            x_inv : out   std_ulogic);
end MyInv;

architecture A of MyInv is

begin
    x_inv <= not a_inv;
end architecture A;

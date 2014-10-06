library ieee;
use ieee.std_logic_1164.all;

entity MyNand is
    port (  a   : in    std_ulogic;
            b   : in    std_ulogic;
            x   : out   std_ulogic);
end MyNand;

architecture TWONAND of MyNand is   -- Connection from and to inv
    
    signal  tmp : std_ulogic;

    component myand
    port (  a_and : in  std_ulogic;
            b_and : in  std_ulogic;
            x_and : out std_ulogic);
    end component myand;

    component myinv
    port (  a_inv : in  std_ulogic;
            x_inv : out std_ulogic);
    end component myinv;

begin

    inst_and : myand
    port map (  a_and => a, 
                b_and => b,
                x_and => tmp);
    
    inst_inv : myinv
    port map (  a_inv => tmp,
                x_inv => x);
	
end architecture TWONAND;

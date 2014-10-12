-------------------------------------------------------------------------------
-- Company    :  HSLU, Waj
-- Create Date:  20-Apr-12
-- Project    :  ECS, Uebung 2
-- Description:  Combinational circuit (Enable gate) described in different
--               forms 
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity EnableGate is
    port(
        x  : in  std_ulogic_vector(3 downto 0);
        en : in  std_ulogic;
        y  : out std_ulogic_vector(3 downto 0)
    );
end EnableGate;

-- concurrent signal assignment (naive)
architecture A_conc_sig_ass_1 of EnableGate is
begin
    y(0) <= x(0) and en;
    y(1) <= x(1) and en;
    y(2) <= x(2) and en;
    y(3) <= x(3) and en;
end architecture;

architecture A_conc_sig_ass_2 of EnableGate is
begin
    y <= x and (others => en);
end architecture;

-- conditional signal assignment
architecture A_cond_sig_ass_1 of EnableGate is
begin
    y <= x when en = '1' else (others => '0');
end architecture;

-- selected signal assignment
architecture A_sel_sig_ass_1 of EnableGate is
begin
    with en select
    y   <=  x when '1',
            (others => '0') when others;
end architecture;

-- process statement with sequential signal ass. (naive)
architecture A_proc_seq_sig_ass_1 of EnableGate is
begin
    process(x, en)
    begin
        y(0) <= x(0) and en;
        y(1) <= x(1) and en;
        y(2) <= x(2) and en;
        y(3) <= x(3) and en;
    end process;
end architecture;


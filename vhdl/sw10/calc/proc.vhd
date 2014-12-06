----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:59:02 11/20/2014 
-- Design Name: 
-- Module Name:    proc - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity proc is
    Port ( 
        op1         : in    STD_ULOGIC_VECTOR (3 downto 0);
        op2         : in    STD_ULOGIC_VECTOR (3 downto 0);
        op          : in    STD_ULOGIC_VECTOR (2 downto 0);
        led         : out   STD_ULOGIC_VECTOR (7 downto 0));
end proc;

architecture Behavioral of proc is

begin

opcalc: process (op1, op2, op)
begin
    case op is
        when "000" => -- no output
            led <= "00000000";
        when "001" => -- display op1
            led <= "0010" & op1;
        when "010" => -- display op2
            --led <= "0100" & op2;
            led <= op1 & op2;
        when "011" => -- add
            led <= std_ulogic_vector( signed( op1 ) + signed( op2 ) );
        when "100" => -- sub
            led <= std_ulogic_vector( signed( op1 ) - signed( op2 ) );
        when "101" => -- mult
            led <= std_ulogic_vector( signed( op1 ) * signed( op2 ) );
        when others => -- no output 
            led <= "00000000";
    end case;
end process;

end Behavioral;


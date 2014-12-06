----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:57:17 11/20/2014 
-- Design Name: 
-- Module Name:    ctrl - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ctrl is
    Port ( 
        rst         : in    STD_ULOGIC;
        clk         : in    STD_ULOGIC;
        rot_c       : in    STD_ULOGIC;
        btn_east    : in    STD_ULOGIC;
        btn_west    : in    STD_ULOGIC;
        btn_north   : in    STD_ULOGIC;
        sw          : in    STD_ULOGIC_VECTOR (3 downto 0);
        op1         : out   STD_ULOGIC_VECTOR (3 downto 0);
        op2         : out   STD_ULOGIC_VECTOR (3 downto 0);
        op          : out   STD_ULOGIC_VECTOR (2 downto 0));
end ctrl;

architecture Behavioral of ctrl is

type state is (s_start, s_op1, s_op2, s_add, s_sub, s_mult);
signal c_st         : state;
signal n_st         : state;
signal rot_c_prev   : STD_ULOGIC;
signal op1_ff       : STD_ULOGIC_VECTOR (3 downto 0);
signal op2_ff       : STD_ULOGIC_VECTOR (3 downto 0);

begin

-- memorizing process
p_seq: process (rst, clk)
begin
    if rst = '1' then
        c_st <= s_start;
        rot_c_prev <= '0';
    elsif rising_edge(clk) then
        c_st <= n_st;
        rot_c_prev <= rot_c;
        op1 <= op1_ff;
        op2 <= op2_ff;
    else 
        c_st <= c_st;
        rot_c_prev <= rot_c_prev;
    end if;
end process;

-- memoryless process
p_com: process (rst, rot_c, btn_east, btn_west, btn_north, sw, c_st)
begin
    -- default assignments
    n_st    <= c_st;    -- remain in current state
    op1_ff  <= "0000";  -- 
    op2_ff  <= "0000";  -- 
    op      <= "000";   -- 
    -- specific assignments
    case c_st is
        when s_start =>
            if rot_c = '1' and rot_c_prev = '0' then 
                n_st <= s_op1;
            else
                n_st <= c_st;
            end if;
            op1_ff  <= "0000";
            op2_ff  <= "0000";
            op      <= "000";
        when s_op1 =>
            if rot_c = '1' and rot_c_prev = '0' then 
                n_st <= s_op2;
            else
                n_st <= c_st;
            end if;
            op1_ff  <= sw;
            op2_ff  <= "0000";
            op      <= "001";   -- display op1
        when s_op2 =>
            if btn_west = '1' then
                n_st <= s_add;
            elsif btn_east = '1' then
                n_st <= s_sub;
            elsif btn_north = '1' then
                n_st <= s_mult;
            else
                n_st <= c_st;
            end if;
            op1_ff  <= op1_ff;
            op2_ff  <= sw;
            op      <= "010";   -- display op2
        when s_add =>
            if rst = '1' then 
                n_st <= s_start;
            else
                n_st <= c_st;
            end if;
            op1_ff  <= op1_ff;
            op2_ff  <= op2_ff;
            op      <= "011";    -- add
        when s_sub =>
            if rst = '1' then 
                n_st <= s_start;
            else
                n_st <= c_st;
            end if;
            op1_ff  <= op1_ff;
            op2_ff  <= op2_ff;
            op      <= "100";    -- sub
        when s_mult =>
            if rst = '1' then 
                n_st <= s_start;
            else
                n_st <= c_st;
            end if;
            op1_ff  <= op1_ff;
            op2_ff  <= op2_ff;
            op      <= "101";    -- mul
        when others =>
            n_st    <= s_start; -- undefined state -> reset to start
            op1_ff  <= "0000";
            op2_ff  <= "0000";
            op      <= "000";
    end case;
end process;

end Behavioral;


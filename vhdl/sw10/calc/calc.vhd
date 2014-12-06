----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:28:55 11/20/2014 
-- Design Name: 
-- Module Name:    calc - Behavioral 
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

entity calc is
    generic (clk_frq: Integer := 50_000_000); -- 50 MHz
    Port ( 
        rst         : in    STD_ULOGIC;    -- BTN_SOUTH
        clk         : in    STD_ULOGIC;
        rot_c       : in    STD_ULOGIC;
        btn_east    : in    STD_ULOGIC;
        btn_west    : in    STD_ULOGIC;
        btn_north   : in    STD_ULOGIC;
        sw          : in    STD_ULOGIC_VECTOR (3 downto 0);
        led         : out   STD_ULOGIC_VECTOR (7 downto 0));
end calc;

architecture Behavioral of calc is

    signal  op1 : STD_ULOGIC_VECTOR (3 downto 0);
    signal  op2 : STD_ULOGIC_VECTOR (3 downto 0);
    signal  op  : STD_ULOGIC_VECTOR (2 downto 0);
    signal  dbnc_cnt : integer;
    signal  rot_c_prev : STD_ULOGIC;
    signal  rot_c_dbnc : STD_ULOGIC;

    component ctrl is
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
        op          : out   STD_ULOGIC_VECTOR (2 downto 0)
        );
    end component ctrl;

    component proc is
    Port ( 
        op1         : in    STD_ULOGIC_VECTOR (3 downto 0);
        op2         : in    STD_ULOGIC_VECTOR (3 downto 0);
        op          : in    STD_ULOGIC_VECTOR (2 downto 0);
        led         : out   STD_ULOGIC_VECTOR (7 downto 0)
        );
    end component;

begin

    ctrlinst : ctrl
        Port Map (  rst         =>  rst      ,
                    clk         =>  clk      ,
                    rot_c       =>  rot_c_dbnc,
                    btn_east    =>  btn_east ,
                    btn_west    =>  btn_west ,
                    btn_north   =>  btn_north,
                    sw          =>  sw       ,
                    op1         =>  op1      ,
                    op2         =>  op2      ,
                    op          =>  op       
                );

    procinst : proc
        Port Map (  op1 => op1,
                    op2 => op2,
                    op  => op ,
                    led => led
                );

    dbnc_rot_c : process(rot_c, rst, clk)
    begin
        if rst = '1' then
            dbnc_cnt <= 5000000;
            rot_c_dbnc <= '0';
        elsif rising_edge(clk) then 
            if dbnc_cnt = 0 then
                dbnc_cnt <= 5000000;
                rot_c_dbnc <= rot_c_dbnc;
            elsif dbnc_cnt < 5000000 then
                dbnc_cnt <= dbnc_cnt - 1;
                rot_c_dbnc <= rot_c_dbnc;
            elsif rot_c_prev /= rot_c then
                dbnc_cnt <= dbnc_cnt - 1;
                rot_c_dbnc <= rot_c;
            else
                dbnc_cnt <= 5000000;
                rot_c_dbnc <= rot_c_dbnc;
            end if;
        end if;
    end process;

end Behavioral;


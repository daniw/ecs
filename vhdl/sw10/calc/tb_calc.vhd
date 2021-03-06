-------------------------------------------------------------------------------
-- Entity: Tb_Calc
-- Author: Waj
-- Date  : 15-May-11, 13-May-12, 14-Apr-2013, 14-Apr-2014
-------------------------------------------------------------------------------
-- Description: (ECS Uebung 7)
-- Testbench for "Taschenrechner".
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Tb_Calc is
  generic(
    CLK_FRQ : integer := 50_000 -- use 50 kHz instead of 50 MHz for simulation
                                -- in order to cut simulation time (only
                                -- 1/1000 clock events are generated per second)
    );
end Tb_Calc;

architecture TB of Tb_Calc is

  component Calc is
   generic(
    CLK_FRQ : integer := CLK_FRQ 
    );
   port(
    rst       : in  std_ulogic; -- BTN_SOUTH
    clk       : in  std_ulogic;
    ROT_C     : in  std_ulogic;
    BTN_EAST  : in  std_ulogic;
    BTN_WEST  : in  std_ulogic;
	 BTN_NORTH : in  std_ulogic;
    SW        : in  std_ulogic_vector(3 downto 0);
    LED       : out std_ulogic_vector(7 downto 0)
      );
  end component Calc;

  signal rst      : std_ulogic := '1';
  signal clk      : std_ulogic := '0';
  signal ROT_C    : std_ulogic := '0';
  signal BTN_EAST : std_ulogic := '0';
  signal BTN_WEST : std_ulogic := '0';
  signal BTN_NORTH: std_ulogic := '0';
  signal SW       : std_ulogic_vector(3 downto 0) := (others => '0');
  signal LED      : std_ulogic_vector(7 downto 0);
  
  constant opA_add : integer range -8 to 7 := -7;  
  constant opB_add : integer range -8 to 7 :=  7;  
  constant opA_sub : integer range -8 to 7 := -8;  
  constant opB_sub : integer range -8 to 7 := -7;  
  constant opA_mul : integer range -8 to 7 := -8;  
  constant opB_mul : integer range -8 to 7 :=  5;  

begin

  -- instantiate MUT
  MUT : Calc
    port map(
    rst       => rst,
    clk       => clk,
    ROT_C     => ROT_C,
    BTN_EAST  => BTN_EAST,
    BTN_WEST  => BTN_WEST,
    BTN_NORTH => BTN_NORTH,
    SW        => SW,
    LED       => LED
      );

  -- clock generation
  p_clk: process
  begin
    wait for 1 sec / CLK_FRQ/2;
    clk <= not clk;
  end process;

  -- stimuli generation and response checking
  p_stim: process
  begin
    -- apply stimuli and gather responses between active clock edges
    wait until falling_edge(clk);
    -- reset generation
    wait for 5*( 1 sec / CLK_FRQ);      -- 5 clock cycles
    rst   <= '0';
    ---------------------------------------------------------------------------
    -- test Addition
    ---------------------------------------------------------------------------
    -- provide 1. operand
    wait for 5*( 1 sec / CLK_FRQ);
    SW <= std_ulogic_vector(to_signed(opA_add,4));
    wait for 5*( 1 sec / CLK_FRQ);
    ROT_C <= '1', '0' after 2*( 1 sec / CLK_FRQ),
                  '1' after 5*( 1 sec / CLK_FRQ),
                  '0' after 7*( 1 sec / CLK_FRQ);  -- bouncing
    -- check display of operand A in result format
    wait for 50*( 1 sec / CLK_FRQ);
    assert LED(7 downto 0) = std_ulogic_vector(to_signed(8*opA_add,8))
      report "ERROR: Operand A not displayed correctly!" severity failure;    
    -- wait for blank time to expire
    wait for 5000*( 1 sec / CLK_FRQ);      -- 5000 clock cycles (100 ms)
    -- provide 2. operand
    wait for 50*( 1 sec / CLK_FRQ);
    SW <= std_ulogic_vector(to_signed(opB_add,4));
    wait for 20*( 1 sec / CLK_FRQ);
    ROT_C <= '1', '0' after 20*( 1 sec / CLK_FRQ);
    -- check display of operand B in result format
    wait for 50*( 1 sec / CLK_FRQ);
    assert LED(7 downto 0) = std_ulogic_vector(to_signed(2*opB_add,8))
      report "ERROR: Operand B not displayed correctly!" severity failure;    
    -- select operation
    wait for 50*( 1 sec / CLK_FRQ);
    BTN_WEST <= '1', '0' after 2*( 1 sec / CLK_FRQ),
                     '1' after 5*( 1 sec / CLK_FRQ),
                     '0' after 7*( 1 sec / CLK_FRQ);  -- bouncing
    -- check result of operation
    wait for 5 *( 1 sec / CLK_FRQ);
    assert LED = std_ulogic_vector(to_signed(2*(4*opA_add+opB_add),8))
      report "ERROR: Wrong result of + operation!" severity failure;
    ---------------------------------------------------------------------------
    -- test reset
    ---------------------------------------------------------------------------
    wait for 20*( 1 sec / CLK_FRQ);
    -- reset generation
    rst   <= '1';
    wait for 5*( 1 sec / CLK_FRQ);      -- 5 clock cycles
    rst   <= '0';
    assert LED = "00000000"
      report "ERROR: LED not dark after Reset!" severity failure;
    wait for 20*( 1 sec / CLK_FRQ);
    ---------------------------------------------------------------------------
    -- test Subtraction
    ---------------------------------------------------------------------------

    
--**** ToDo ****

  
    ---------------------------------------------------------------------------
    -- test reset
    ---------------------------------------------------------------------------
    wait for 20*( 1 sec / CLK_FRQ);
    -- reset generation
    rst   <= '1';
    wait for 5*( 1 sec / CLK_FRQ);      -- 5 clock cycles
    rst   <= '0';
    assert LED = "00000000"
      report "ERROR: LED not dark after Reset!" severity failure;
    wait for 20*( 1 sec / CLK_FRQ);
    ---------------------------------------------------------------------------
    -- test Multiplication
    ---------------------------------------------------------------------------

    
--**** ToDo ****


    ---------------------------------------------------------------------------
    -- end of simulation
    wait for 20*( 1 sec / CLK_FRQ);
    report "OK! Normal end of simulation, no errors found!" severity failure;
  end process;
  
end TB;

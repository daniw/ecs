-------------------------------------------------------------------------------
-- Entity: cpu
-- Author: Waj
-- Date  : 12-May-14
-------------------------------------------------------------------------------
-- Description: 
-- Top-level of CPU for simple von-Neumann MCU.
-------------------------------------------------------------------------------
-- Total # of FFs: 0
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mcu_pkg.all;

entity cpu is
  port(rst     : in    std_logic;
       clk     : in    std_logic;
       -- CPU bus signals
       bus_in  : in  t_bus2cpu;
       bus_out : out t_cpu2bus
       );
end cpu;

architecture rtl of cpu is

  signal addr_cnt : unsigned(5 downto 0);
  type t_reg is array (0 to 1) of std_logic_vector(DW-1 downto 0);
  signal reg_arr : t_reg;

begin

  -----------------------------------------------------------------------------
  -- sequential process: DUMMY 
  -- ... To be replaced ...
  -----------------------------------------------------------------------------  
  P_dummy: process(rst, clk)
  begin
    if rst = '1' then
     addr_cnt     <= (others => '0');
     bus_out.addr <= (others => '0');
     bus_out.data <= (others => '0');
     bus_out.r_w  <= '0';
     bus_out.data <= (others => '0');
    elsif rising_edge(clk) then
      addr_cnt <= addr_cnt + 1;
      if addr_cnt = 0 then
        -- read from ROM address 0
        bus_out.addr <= HBA(ROM) & std_logic_vector(addr_cnt);
        bus_out.r_w  <= '0';
      elsif addr_cnt = 1 then
        -- read from ROM address 1
        bus_out.addr <= HBA(ROM) & std_logic_vector(addr_cnt);
        bus_out.r_w  <= '0';
      elsif addr_cnt = 2 then
        -- read from ROM address 2
        bus_out.addr <= HBA(ROM) & std_logic_vector(addr_cnt);
        bus_out.r_w  <= '0';
        -- store value from ROM address 0
        reg_arr(0) <=  bus_in.data;
      elsif addr_cnt = 3 then
        -- read from ROM address 3
        bus_out.addr <= HBA(ROM) & std_logic_vector(addr_cnt);
        bus_out.r_w  <= '0';
        -- store value from ROM address 1
        reg_arr(1) <=  bus_in.data;
      elsif addr_cnt = 4 then
        -- store value to RAM address 0
        bus_out.addr <= HBA(RAM) & std_logic_vector(addr_cnt-4);
        bus_out.r_w  <= '1';
        bus_out.data <= reg_arr(0);   
      elsif addr_cnt = 5 then
        -- store value to RAM address 1
        bus_out.addr <= HBA(RAM) & std_logic_vector(addr_cnt-4);
        bus_out.r_w  <= '1';
        bus_out.data <= reg_arr(1);   
      end if;
    end if;
  end process;

  
end rtl;

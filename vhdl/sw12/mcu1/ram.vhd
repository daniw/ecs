-------------------------------------------------------------------------------
-- Entity: ram
-- Author: Waj
-- Date  : 12_May-14
-------------------------------------------------------------------------------
-- Description: 
-- Data memory for simple von-Neumann MCU with registered read data output.
-------------------------------------------------------------------------------
-- Total # of FFs: (2**AW)*DW + DW (better to use BRAM)
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mcu_pkg.all;

entity ram is
  port(clk     : in    std_logic;
       -- RAM bus signals
       bus_in  : in  t_bus2rws;
       bus_out : out t_rws2bus
       );
end ram;

architecture rtl of ram is

  type t_ram is array (0 to 2**AW-1) of std_logic_vector(DW-1 downto 0);
  signal ram    : t_ram;
  signal r_addr : std_logic_vector(AW-1 downto 0);
  
begin
  -----------------------------------------------------------------------------
  -- sequential process: RAM (read before write)
  ----------------------------------------------------------------------------- 
  P_ram: process(clk)
  begin
    if rising_edge(clk) then
      if bus_in.we = '1' then
        ram(to_integer(unsigned(bus_in.addr))) <= bus_in.data;
      end if;
      r_addr <= bus_in.addr;
      -- read before write
      bus_out.data <= ram(to_integer(unsigned(r_addr)));
    end if;
  end process;

  -- write before read
  --bus_out.data <= ram(to_integer(unsigned(bus_in.r_addr)));
  
end rtl;


-------------------------------------------------------------------------------
-- Entity: rom
-- Author: Waj
-- Date  : 12-May-14
-------------------------------------------------------------------------------
-- Description:
-- Program memory for simple von-Neumann MCU with registerd read data output.
-------------------------------------------------------------------------------
-- Total # of FFs: DW
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mcu_pkg.all;

entity rom is
  port(clk     : in    std_logic;
       -- ROM bus signals
       bus_in  : in  t_bus2ros;
       bus_out : out t_ros2bus
       );
end rom;

architecture rtl of rom is

  type t_rom is array (0 to 2**AWL-1) of std_logic_vector(DW-1 downto 0);
  constant rom_table : t_rom := (
    ---------------------------------------------------------------------------
    -- program code -----------------------------------------------------------
    ---------------------------------------------------------------------------
         0         => X"FFFF",                  -- command xy
         1         => X"EEEE",                  -- command xy
         2         => X"DDDD",                  -- command xy
         3         => X"CCCC",                  -- command xy
         4         => X"BBBB",                  -- command xy
         5         => X"AAAA",                  -- command xy
         6         => X"9999",                  -- command xy
         7         => X"8888",                  -- command xy
         8         => X"7777",                  -- command xy
         others    => (others => '0')
         );
  
begin

  -----------------------------------------------------------------------------
  -- sequential process: ROM table with registerd output
  -----------------------------------------------------------------------------  
  P_rom: process(clk)
  begin
    if rising_edge(clk) then
      bus_out.data <= rom_table(to_integer(unsigned(bus_in.addr)));
    end if;
  end process;
  
end rtl;

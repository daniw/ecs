-------------------------------------------------------------------------------
-- Entity: ram
-- Author: Waj
-- Date  : 12-May-14
-------------------------------------------------------------------------------
-- Description: 
-- Data/address/control bus for simple von-Neumann MCU.
-- The bus master (CPU) can read/write in every cycle. The bus slaves are
-- assumed to have registerd read data output with an address-in to data-out
-- latency of 1 cc. The read data muxing from bus slaves to the bus master is
-- done combinationally. Thus, at the bus master interface, there results a
-- read data latency of 1 cc.
-------------------------------------------------------------------------------
-- Note on code portability:
-------------------------------------------------------------------------------
-- The address decoding logic as implemented in process P_dec below, shows how
-- to write portable code by means of a user-defined enumaration type which is
-- used as the index range for a constant array, see mcu_pkg. This allows to
-- leave the local code (in process P_dec) unchanged when the number and/or
-- base addresses of the bus slaves in the system change. Such changes then
-- need only to be made in the global definition package.
-- To generate such portable code for the rest of the functionality (e.g. for
-- the read data mux) would require to organize all data input vectors in a
-- signal array first. This would destroy the portability of the code, since it
-- requires manual code adaption when design parameter change. 
-------------------------------------------------------------------------------
-- Total # of FFs: 2
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mcu_pkg.all;

entity buss is
  port(rst     : in    std_logic;
       clk     : in    std_logic;
       -- CPU bus signals
       cpu_in  : in  t_cpu2bus;
       cpu_out : out t_bus2cpu;
       -- ROM bus signals
       rom_in  : in  t_ros2bus;
       rom_out : out t_bus2ros;
       -- RAM bus signals
       ram_in  : in  t_rws2bus;
       ram_out : out t_bus2rws;
       -- GPIO bus signals
       gpio_in  : in  t_rws2bus;
       gpio_out : out t_bus2rws;
       -- LCD bus signals
       lcd_in  : in  t_rws2bus;
       lcd_out : out t_bus2rws
       );
end buss;

architecture rtl of buss is 
  
begin

  -- dummy to avoid optimization
  ram_out.data <= cpu_in.data;
  ram_out.addr <= cpu_in.addr(AWL-1 downto 0);
  ram_out.we   <= cpu_in.r_w;
  cpu_out.data <= ram_in.data;
  
  -----------------------------------------------------------------------------
  -- address decoding
  -----------------------------------------------------------------------------
  -- t.b.d.

  -----------------------------------------------------------------------------
  -- write transfer logic
  -----------------------------------------------------------------------------
  -- t.b.d.
 
  -----------------------------------------------------------------------------
  -- read transfer logic
  -----------------------------------------------------------------------------
  -- t.b.d
  
end rtl;

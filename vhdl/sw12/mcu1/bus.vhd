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

  signal slave      : std_logic_vector(AWH - 1 downto 0);
  signal slave_reg  : std_logic_vector(AWH - 1 downto 0);
  
begin

  -----------------------------------------------------------------------------
  -- address decoding
  -----------------------------------------------------------------------------
  rom_out.addr  <= cpu_in.addr(AWL-1 downto 0);
  ram_out.addr  <= cpu_in.addr(AWL-1 downto 0);
  gpio_out.addr <= cpu_in.addr(AWL-1 downto 0);
  lcd_out.addr  <= cpu_in.addr(AWL-1 downto 0);
  slave         <= cpu_in.addr(AW-1 downto AWL);
  

  ------------------------------------------------------------------------------
  -- write transfer logic
  -----------------------------------------------------------------------------
  ram_out.data  <= cpu_in.data;
  gpio_out.data <= cpu_in.data;
  lcd_out.data  <= cpu_in.data;
  ram_out.we    <= cpu_in.r_w when slave_reg = "01" else '0';
  gpio_out.we   <= cpu_in.r_w when slave_reg = "10" else '0';
  lcd_out.we    <= cpu_in.r_w when slave_reg = "11" else '0';
  
 
  -----------------------------------------------------------------------------
  -- read transfer logic
  -----------------------------------------------------------------------------
  with slave_reg select 
    cpu_out.data <= 
      rom_in.data     when "00",
      ram_in.data     when "01",
      gpio_in.data    when "10",
      lcd_in.data     when "11",
      (others => '0') when others;

  -----------------------------------------------------------------------------
  -- FF to buffer slave
  -----------------------------------------------------------------------------
  P_slave_reg: process(rst, clk) begin
    if (rst = '1') then
      slave_reg <= "00";
    elsif (rising_edge(clk)) then
      slave_reg <= slave;
    end if;
  end process;

end rtl;

-------------------------------------------------------------------------------
-- Entity: mcu_pkg
-- Author: Waj
-- Date  : 12-Mar-14
-------------------------------------------------------------------------------
-- Description:
-- VHDL package for definition of design parameters and types used throughout
-- the MCU.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mcu_pkg is

  -----------------------------------------------------------------------------
  -- design parameters
  -----------------------------------------------------------------------------
  -- system clock frequency in Hz
  constant CF : natural :=  50_000_000;           -- 50 MHz
  -- bus architecture parameters
  constant DW  : natural range 4 to 64 := 16;     -- data word width
  constant AW  : natural range 2 to 64 := 8;      -- total address width
  constant AWH : natural range 1 to 64 := 2;      -- high address width
  constant AWL : natural range 1 to 64 := AW-AWH; -- low address width
  -- memory map
  type t_bus_slave is (ROM, RAM, GPIO, LCD);      -- list of bus slaves
  type t_ba is array (t_bus_slave) of std_logic_vector(AW-1 downto 0);
  constant BA : t_ba := (             -- full base addresses 
         ROM  => X"00",
         RAM  => X"40",
         GPIO => X"80",
         LCD  => X"C0"
         );
  type t_hba is array (t_bus_slave) of std_logic_vector(AWH-1 downto 0);
  constant HBA : t_hba := (            -- high base address for decoding
         ROM  => BA(ROM)(AW-1 downto AW-AWH),
         RAM  => BA(RAM)(AW-1 downto AW-AWH),
         GPIO => BA(GPIO)(AW-1 downto AW-AWH),
         LCD  => BA(LCD)(AW-1 downto AW-AWH)
         );
  -- LCD peripheral
  constant LCD_PW : natural := 7;  -- # of LCD control + data signal
 
  -----------------------------------------------------------------------------
  -- global types
  -----------------------------------------------------------------------------
  -- Master bus interface -----------------------------------------------------
  type t_bus2cpu is record
    data    : std_logic_vector(DW-1 downto 0);
  end record;
  type t_cpu2bus is record
    data    : std_logic_vector(DW-1 downto 0);
    addr    : std_logic_vector(AW-1 downto 0);
    r_w     : std_logic; -- read = '0', write = '1'
  end record;
  -- Read-only slave bus interface  -------------------------------------------
  type t_bus2ros is record
    data    : std_logic_vector(DW-1 downto 0);
    addr    : std_logic_vector(AWL-1 downto 0);
  end record;
  type t_ros2bus is record
    data    : std_logic_vector(DW-1 downto 0);
  end record;
  -- read/write slave bus interface -------------------------------------------
  type t_bus2rws is record
    data    : std_logic_vector(DW-1 downto 0);
    addr    : std_logic_vector(AWL-1 downto 0);
    we      : std_logic; -- read = '0', write = '1'
  end record;
  type t_rws2bus is record
    data    : std_logic_vector(DW-1 downto 0);
  end record;
  -- GPIO ---------------------------------------------------------------------
  type t_gpio_pin_in is record
    in_0 : std_logic_vector(DW-1 downto 0);
    in_1 : std_logic_vector(DW-1 downto 0);
    in_2 : std_logic_vector(DW-1 downto 0);
    in_3 : std_logic_vector(DW-1 downto 0);
  end record;
  type t_gpio_pin_out is record
    out_0 : std_logic_vector(DW-1 downto 0);
    out_1 : std_logic_vector(DW-1 downto 0);
    out_2 : std_logic_vector(DW-1 downto 0);
    out_3 : std_logic_vector(DW-1 downto 0);
    enb_0 : std_logic_vector(DW-1 downto 0);
    enb_1 : std_logic_vector(DW-1 downto 0);
    enb_2 : std_logic_vector(DW-1 downto 0);
    enb_3 : std_logic_vector(DW-1 downto 0);
  end record; 

  -----------------------------------------------------------------------------
  -- CPU internal types and
  -----------------------------------------------------------------------------
  -- t.b.d.
  
  -----------------------------------------------------------------------------
  -- CPU instruction set
  -----------------------------------------------------------------------------
  -- t.b.d.
  
end mcu_pkg;

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
  type t_alu2reg is record
    result        : std_logic_vector(DW-1 downto 0);
  end record;
  type t_reg2alu is record
    op1           : std_logic_vector(DW-1 downto 0);
    op2           : std_logic_vector(DW-1 downto 0);
  end record;
  type t_flag is record
    Z             : std_logic;
    N             : std_logic;
    C             : std_logic;
    O             : std_logic;
  end record;
  type t_ctrl2alu is record
    op            : t_opcode;
    enb           : std_logic;
  end record;
  type t_alu2ctrl is record
    flag          : t_flag;
  end record;
  type t_ctrl2reg is record
    data          : std_logic_vector(DW-1 downto 0);
    src1          : std_logic_vector(2 downto 0);
    src2          : std_logic_vector(2 downto 0);
    dest          : std_logic_vector(2 downto 0);
    enb_res       : std_logic;
    enb_data_low  : std_logic;
    enb_data_high : std_logic;
  end record;
  type t_reg2ctrl is record
    data          : std_logic_vector(DW-1 downto 0);
    addr          : std_logic_vector(AW-1 downto 0);
  end record;
  type t_ctrl2prc is record
    addr          : std_logic_vector(AW-1 downto 0);
    mode          : std_logic; -- ?????????
    enb           : std_logic;
  end record;
  type t_prc2ctrl is record
    pc            : std_logic_vector(7 downto 0);
    exc           : std_logic_vector; -- ????????
  end record;
  
  -----------------------------------------------------------------------------
  -- CPU instruction set
  -----------------------------------------------------------------------------
  type t_opcode is := (
    add   => "00000",
    sub   => "00001",
    andi  => "00010",
    ori   => "00011",
    xori  => "00100",
    slai  => "00101",
    srai  => "00110",
    mov   => "00111",
    ----------------------------------------------------------------------------
    addil => "01100",
    addih => "01101",
    ----------------------------------------------------------------------------
    ld    => "10000",
    st    => "10001",
    ----------------------------------------------------------------------------
    jmp   => "11000",
    bne   => "11001",
    bge   => "11010",
    blt   => "11011",
    ----------------------------------------------------------------------------
    nop   => "11111"
  );
  
end mcu_pkg;

-------------------------------------------------------------------------------
-- Company    :  HSLU, Waj
-- Create Date:  20-Apr-12
-- Project    :  ECS, Uebung 2
-- Description:  Testbench for enable gate with configuration selection
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity tb_EnableGate is
end tb_EnableGate;

architecture TB of tb_EnableGate is

  component EnableGate
    port(
      x  : in  std_ulogic_vector(3 downto 0);
      en : in  std_ulogic;
      y  : out std_ulogic_vector(3 downto 0));
  end component EnableGate;

  -- configure architecture of UUT to be simulated
  for UUT1  : EnableGate use entity work.EnableGate(A_conc_sig_ass_1);
  for UUT2  : EnableGate use entity work.EnableGate(A_conc_sig_ass_2);
  for UUT3  : EnableGate use entity work.EnableGate(A_cond_sig_ass_1);
  for UUT4  : EnableGate use entity work.EnableGate(A_sel_sig_ass_1);
  for UUT5  : EnableGate use entity work.EnableGate(A_proc_seq_sig_ass_1);

  signal x  : std_ulogic_vector(3 downto 0);
  signal en : std_ulogic;
  signal y1 : std_ulogic_vector(3 downto 0);
  signal y2 : std_ulogic_vector(3 downto 0);
  signal y3 : std_ulogic_vector(3 downto 0);
  signal y4 : std_ulogic_vector(3 downto 0);
  signal y5 : std_ulogic_vector(3 downto 0);

begin

  -- Unit Under Test port map
  UUT1 : EnableGate
    port map (
      x  => x,
      en => en,
      y  => y1
      );
  UUT2 : EnableGate
    port map (
      x  => x,
      en => en,
      y  => y2
      );
  UUT3 : EnableGate
    port map (
      x  => x,
      en => en,
      y  => y3
      );
  UUT4 : EnableGate
    port map (
      x  => x,
      en => en,
      y  => y4
      );
  UUT5 : EnableGate
    port map (
      x  => x,
      en => en,
      y  => y5
      );

  process
  begin
    for e in std_ulogic'('0') to '1' loop
      en <= e;
      for i in 0 to 3 loop
        x <= (others => '0');
        x(i) <= '1';
        wait for 1us;  -- wait before checking response and applying next stimuli vector
        if e = '1' then
          assert y1 = x report "ERROR: Simulation failed!!!" severity failure;
          assert y2 = x report "ERROR: Simulation failed!!!" severity failure;
          assert y3 = x report "ERROR: Simulation failed!!!" severity failure;
          assert y4 = x report "ERROR: Simulation failed!!!" severity failure;
          assert y5 = x report "ERROR: Simulation failed!!!" severity failure;
        else
          assert y1 = "0000" report "ERROR: Simulation failed!!!" severity failure;
          assert y2 = "0000" report "ERROR: Simulation failed!!!" severity failure;
          assert y3 = "0000" report "ERROR: Simulation failed!!!" severity failure;
          assert y4 = "0000" report "ERROR: Simulation failed!!!" severity failure;
          assert y5 = "0000" report "ERROR: Simulation failed!!!" severity failure;
        end if;
      end loop;
    end loop;
    report "Simulation completed - Waiting for 8hr";
    wait for 153min;
    report "o.k. Simulation done" severity failure; -- failure: stop simulation 
                                                    -- note: continue simulation
    wait; -- suspend process forever
  end process;
  
end TB;


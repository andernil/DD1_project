----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2017 19:52:43
-- Design Name: 
-- Module Name: MonPro_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use ieee.numeric_std.all;

entity MonPro_tb is
    --Port 
end MonPro_tb;

architecture Behavioral of MonPro_tb is
  constant CLK_PERIOD    : time := 10 ns;


  signal    n_in    : STD_LOGIC_VECTOR (127 downto 0);
  signal    a_in    : STD_LOGIC_VECTOR (127 downto 0);
  signal    b_in    : STD_LOGIC_VECTOR (127 downto 0);
  signal    u_out   : STD_LOGIC_VECTOR (127 downto 0);
  signal    clk     : std_logic := '0';
  signal    reset_n : std_logic := '0';
  signal    MP_done : std_logic;

  signal    MP_done_test : std_logic;

begin

  dut: entity work.MonPro 
    port map (
    
      -- Clocks and resets 
      clk            => clk, 
      reset_n        => reset_n, 
  
      -- Data input interface           
      n_in  => n_in, 
      b_in  => b_in,            
      a_in  => a_in,
      u_out => u_out,
      MP_done => MP_done
      
    );

  clk <= not clk after CLK_PERIOD/2;
  
  
  Input_test: process begin
  reset_n <= '1';
  
  wait for CLK_PERIOD/2;
--  n_in <= x"00000000000000000000000000000143";
--  a_in <= x"0000000000000000000000000000000f";
--  b_in <= x"00000000000000000000000000000022";  
--136
--  n_in <= x"00000000000000000000000000001143";
--  a_in <= x"0000000000000000000000000000001f";
--  b_in <= x"00000000000000000000000000000122";  
--3379
  n_in <= x"9236e1c77cf9a0aa7e906d47fd6f26cd";
  a_in <= x"4cc2575b23de0d7ed530f17701f38eea";
  b_in <= x"48d9d6bbaa1d12d730b373b4e12e9440";    
  --59851687672952017923648942054037034922
    wait for 3*CLK_PERIOD;
  reset_n <= '0';  
  
  wait;
  
  end process;
  
  TEST: process(MP_done,reset_n) begin
    if(reset_n = '1') then
      MP_done_test <= '0';
    elsif(MP_done = '1') then
      MP_done_test <= '1';
    end if;
  end process;
  
end Behavioral;

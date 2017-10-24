----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2017 20:50:03
-- Design Name: 
-- Module Name: ModExp_tb - Behavioral
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
use ieee.std_logic_arith.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ModExp_tb is
--  Port ( );
end ModExp_tb;

architecture Behavioral of ModExp_tb is
constant CLK_PERIOD    : time := 10 ns;

signal    clk  : STD_LOGIC := '1';
signal reset_n : STD_LOGIC;

signal M_in    : STD_LOGIC_VECTOR (127 downto 0);
signal e_in    : STD_LOGIC_VECTOR (127 downto 0);
signal n_in    : STD_LOGIC_VECTOR (127 downto 0);

signal r_n     : STD_LOGIC_VECTOR (127 downto 0);
signal rr_n    : STD_LOGIC_VECTOR (127 downto 0);

signal ME_done : STD_LOGIC;
signal M_out   : STD_LOGIC_VECTOR (127 downto 0);
begin

dut: entity work.ModExp 
    port map (
clk     => clk,
reset_n => reset_n,

M_in    => M_in,
e_in    => e_in,
n_in    => n_in,

r_n     => r_n,
rr_n    => rr_n,

ME_done => ME_done,
M_out   => M_out
);

  clk <= not clk after CLK_PERIOD/2;
  
  
  Input_test: process begin
  reset_n <= '1';
  
  wait for CLK_PERIOD/2;
--  n_in <= conv_std_logic_vector(323,128);
--  e_in <= conv_std_logic_vector(257,128);
--  M_in <= conv_std_logic_vector(123,128); 
--  r_n  <= conv_std_logic_vector(189,128);
--  rr_n <= conv_std_logic_vector(191,128);
-- 

--  n_in <= conv_std_logic_vector(25100099,128);
--  e_in <= conv_std_logic_vector(3750121,128);
--  M_in <= conv_std_logic_vector(13388804,128); 
--  r_n  <= conv_std_logic_vector(8454333,128);
--  rr_n <= conv_std_logic_vector(1759717,128);
-- 123456

--  n_in <= x"00000000000000000001C91376BE85F9";
--  e_in <= x"00000000000000000000146B9E59B8E9";
--  M_in <= x"000000000000000000009317A8E17632";
--  r_n  <= x"0000000000000000000036EC89417A07";
--  rr_n <= x"000000000000000000000B8682ED771D";
--

  n_in <= x"1b27031cf42c5a5af095dd7d4739bcdd";
  e_in <= x"1650cf48ace37b54008ce02db19f9f7b"; --1650cf48ace37b54008ce02db19f9f7b   (1694278819184587528995910492621800195) df2818d6c0e2d1480580c1c8f03c3ace
  M_in <= x"0dfdf5c41b9a74b4aeadff7dd4763fc5";
  r_n  <= x"04d8fce30bd3a5a50f6a2282b8c64323";
  rr_n <= x"0654615e12a8b2ca13f45a4b74fa7de0";
--102030405060708090123456789

  wait for 3*CLK_PERIOD;
  reset_n <= '0';  
  
  wait for 20*CLK_PERIOD;
-- reset_n <= '1';  

  wait for 1*CLK_PERIOD;
--  reset_n <= '0';  

  wait;
  
  end process;
end Behavioral;
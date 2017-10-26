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

library work;
use work.CompDecl.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TorgeTest_TB is
--  Port ( );
end TorgeTest_TB;

architecture Behavioral of TorgeTest_TB is


signal Clk             : STD_LOGIC := '1';
signal Resetn          : STD_LOGIC;
signal InitRsa         : STD_LOGIC;
signal StartRsa        : STD_LOGIC;
signal CoreFinished    : STD_LOGIC;

signal DataIn          : STD_LOGIC_VECTOR (31 downto 0);
signal DataOut          : STD_LOGIC_VECTOR (31 downto 0);


constant CLK_PERIOD    : time := 10 ns;

signal M_in    : STD_LOGIC_VECTOR (127 downto 0);
signal e_in    : STD_LOGIC_VECTOR (127 downto 0);
signal n_in    : STD_LOGIC_VECTOR (127 downto 0);
signal r_n     : STD_LOGIC_VECTOR (127 downto 0);
signal rr_n    : STD_LOGIC_VECTOR (127 downto 0);

signal test_reg :STD_LOGIC_VECTOR (127 downto 0);

begin

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

  R: RSACore
  port map(      
    Clk              => Clk, 
    Resetn           => Resetn,
    InitRsa          => InitRsa, 
    StartRsa         => StartRsa, 
    DataIn           => DataIn, 
    DataOut          => DataOut, 
    CoreFinished     => CoreFinished
  );

  clk <= not clk after CLK_PERIOD/2;
  
  
  Input_test: process begin
  Resetn <= '0';
  StartRsa <= '0';
  InitRsa <= '0';
  wait for CLK_PERIOD;
  Resetn <= '1';
  wait for CLK_PERIOD;
  InitRsa <= '1';
  DataIn <= e_in(31 downto 0);
  wait for CLK_PERIOD;
  InitRsa <= '0';
  DataIn <= e_in(63 downto 32);  
  wait for CLK_PERIOD;
  DataIn <= e_in(95 downto 64);
  wait for CLK_PERIOD;
  DataIn <= e_in(127 downto 96);
  wait for CLK_PERIOD;
  DataIn <= n_in(31 downto 0);
  wait for CLK_PERIOD;
  DataIn <= n_in(63 downto 32);  
  wait for CLK_PERIOD;
  DataIn <= n_in(95 downto 64);
  wait for CLK_PERIOD;
  DataIn <= n_in(127 downto 96);
  wait for CLK_PERIOD;
  DataIn <= r_n(31 downto 0);
  wait for CLK_PERIOD;
  DataIn <= r_n(63 downto 32);  
  wait for CLK_PERIOD;
  DataIn <= r_n(95 downto 64);
  wait for CLK_PERIOD;
  DataIn <= r_n(127 downto 96);
  wait for CLK_PERIOD;
  DataIn <= rr_n(31 downto 0);
  wait for CLK_PERIOD;
  DataIn <= rr_n(63 downto 32);  
  wait for CLK_PERIOD;
  DataIn <= rr_n(95 downto 64);
  wait for CLK_PERIOD;
  DataIn <= rr_n(127 downto 96); 
  
  wait until CoreFinished = '1';
  wait for CLK_PERIOD;
  StartRSA <= '1';
  DataIn <= M_in(31 downto 0);
  wait for CLK_PERIOD;
  StartRSA <= '0';
  DataIn <= M_in(63 downto 32);  
  wait for CLK_PERIOD;
  DataIn <= M_in(95 downto 64);
  wait for CLK_PERIOD;
  DataIn <= M_in(127 downto 96); 
  
  wait until CoreFinished = '1';
  wait for CLK_PERIOD;

  test_reg(31 downto 0) <= DataOut;
  wait for CLK_PERIOD;
  test_reg(63 downto 32) <= DataOut;
  wait for CLK_PERIOD;
  test_reg(95 downto 64) <= DataOut;
  wait for CLK_PERIOD;
  test_reg(127 downto 96) <= DataOut;
  wait;
  end process;
  
end Behavioral;
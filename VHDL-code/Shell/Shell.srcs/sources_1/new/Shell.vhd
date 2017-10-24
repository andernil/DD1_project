----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.10.2017 12:48:59
-- Design Name: 
-- Module Name: RSACore - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RSACore is
    Port ( 
 DataIn         : in STD_LOGIC_VECTOR (31 downto 0);
 DataOut        : out STD_LOGIC_VECTOR (31 downto 0);
 Clk            : in STD_LOGIC;
 InitRSA        : in STD_LOGIC;
 StartRSA       : in STD_LOGIC;
 CoreFinished   : out STD_LOGIC;
 Resetn         : in STD_LOGIC);
end RSACore;

architecture Behavioral of RSACore is

begin
CoreFinished <= '0';

end Behavioral;

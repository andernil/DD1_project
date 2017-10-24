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
use IEEE.numeric_std.all;


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
signal reset_ME : STD_LOGIC;

signal M_in    : STD_LOGIC_VECTOR (127 downto 0);
signal e_in    : STD_LOGIC_VECTOR (127 downto 0);
signal n_in    : STD_LOGIC_VECTOR (127 downto 0);

signal r_n     : STD_LOGIC_VECTOR (127 downto 0);
signal rr_n    : STD_LOGIC_VECTOR (127 downto 0);

signal ME_done : STD_LOGIC;
signal M_out   : STD_LOGIC_VECTOR (127 downto 0);
signal Data_in_reg : STD_LOGIC_VECTOR (127 downto 0);

signal state   : STD_LOGIC_VECTOR (1 downto 0);
signal in_state: std_logic;
signal counter : STD_LOGIC_VECTOR (4 downto 0);
begin

process(InitRSA,StartRSA,ME_done,resetn,clk) begin
--    if (clk'event and clk = '1') then
      if (resetn = '0') then
        state <= "00";
      elsif(InitRSA = '1') then
        state <= "01";
      elsif(StartRSA = '1') then
        state <= "10";
      elsif (ME_done = '1') then
        state <= "11";
      end if;
--   end if;
end process;

process(clk,state,counter,InitRSA) begin
  if (InitRSA = '1') then 
      counter <= (others => '0');
  elsif (clk'event and clk = '1' and state = "01") then
      counter <= std_logic_vector(unsigned(counter) + "1");
  end if;
end process;

process(counter, clk) begin
  if (clk'event and clk = '1' and state = "01") then
    Data_in_reg(31 downto 0) <= Data_in_reg(63 downto 32);
    Data_in_reg(63 downto 32) <= Data_in_reg(95 downto 64);
    Data_in_reg(95 downto 64) <= Data_in_reg(127 downto 96);
    Data_in_reg(127 downto 96) <= DataIn;
        
  end if;
end process;


process(counter, clk) begin
  if (clk'event and clk = '1' and state = "01") then
  case counter is
      when "00011" => e_in  <= Data_in_reg;
      when "00111" => n_in  <= Data_in_reg;
      when "01011" => r_n   <= Data_in_reg;
      when "01111" => rr_n  <= Data_in_reg;
      when others => null;
    end case;    
  end if;
end process;

M_in <= Data_in_reg;
ModExp: entity work.ModExp 
    port map (
clk     => clk,
reset_n => reset_ME,

M_in    => M_in,
e_in    => e_in,
n_in    => n_in,

r_n     => r_n,
rr_n    => rr_n,

ME_done => ME_done,
M_out   => M_out
);

end Behavioral;

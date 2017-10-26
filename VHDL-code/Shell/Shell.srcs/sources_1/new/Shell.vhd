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

signal Data_out_reg: STD_LOGIC_VECTOR (127 downto 0);

signal state   : STD_LOGIC_VECTOR (1 downto 0);
signal out_state: std_logic;
signal counter     : STD_LOGIC_VECTOR (4 downto 0);
signal counter_nxt : STD_LOGIC_VECTOR (4 downto 0);
begin

process(InitRSA,StartRSA,ME_done,resetn,clk) begin
    if (clk'event and clk = '1') then
      if (resetn = '0') then
        state <= "00";
      elsif(InitRSA = '1') then
        state <= "01";
      elsif(StartRSA = '1') then
        state <= "10";
      elsif (ME_done = '1') then
        state <= "11";
      end if;
   end if;
end process;

process(state,counter) begin
  if(state = "01" and unsigned(counter) > "01111") then
    CoreFinished <= '1';
  elsif (state = "11") then
    CoreFinished <= '1';
  else
    CoreFinished <= '0';
  end if;
end process;


counter_nxt <= std_logic_vector(unsigned(counter) + "1");

process(clk,state,counter_nxt,InitRSA,StartRSA,counter) begin
  if (InitRSA = '1' or StartRSA = '1' or state = "00" or state = "11") then
      counter <= (others => '0');
  elsif (clk'event and clk = '1') then
    if (counter_nxt <= "11000") then
      counter <= counter_nxt;
    end if;
  end if;
end process;

process(DataIn, clk) begin
  if (clk'event and clk = '1') then
      Data_in_reg(127 downto 96) <= DataIn;
  end if;
end process;
process(Data_in_reg, clk) begin
  if (clk'event and clk = '1') then
      Data_in_reg(95  downto 64) <= Data_in_reg(127 downto 96);
  end if;
end process;
process(Data_in_reg, clk) begin
  if (clk'event and clk = '1') then
      Data_in_reg(63  downto 32) <= Data_in_reg(95  downto 64);
  end if;
end process;
process(Data_in_reg, clk) begin
  if (clk'event and clk = '1') then
      Data_in_reg(31  downto 0)  <= Data_in_reg(63  downto 32);
  end if;
end process;

process(state, counter) begin
  if((state = "10") and (counter > "00100")) then
    reset_ME <= '0';
  elsif(state = "11") then
    reset_ME <= '0';
  else
    reset_ME <= '1';
  end if;
end process;

process(counter_nxt, clk, state) begin
  if (clk'event and clk = '1' and state = "01") then
    case counter_nxt is
      when "00100" => e_in  <= Data_in_reg;
      when "01000" => n_in  <= Data_in_reg;
      when "01100" => r_n   <= Data_in_reg;
      when "10000" => rr_n  <= Data_in_reg;
      when others => null;
    end case;    
  end if;
end process;

process(counter_nxt, clk, state) begin
  if (clk'event and clk = '1' and state = "10" and counter_nxt = "00100") then
    M_in  <= Data_in_reg;
  end if;
end process;


process(ME_done,clk,M_Out,Data_out_reg,out_state,resetn)begin
  if(resetn = '0') then
    out_state <= '0';
  elsif(clk'event and clk = '1')then
    if(out_state = '0') then
      Data_out_reg <= M_out;
      if(ME_done = '1') then
        out_state <= '1';
      end if;
    else
      Data_out_reg(31 downto 0)  <= Data_out_reg(63  downto 32);
      Data_out_reg(63 downto 32) <= Data_out_reg(95  downto 64);
      Data_out_reg(95 downto 64) <= Data_out_reg(127 downto 96);
      Data_out_reg(127 downto 96)<= Data_out_reg(31 downto 0);
    end if;
  end if;
end process;

DataOut <= Data_out_reg(31 downto 0);

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

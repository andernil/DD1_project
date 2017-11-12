----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2017 20:45:36
-- Design Name: 
-- Module Name: ModExp - Behavioral
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
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity ModExp is
    Port (
    clk : in STD_LOGIC;
    reset_n : in STD_LOGIC;
    
    M_in : in STD_LOGIC_VECTOR (127 downto 0);
    e_in : in STD_LOGIC_VECTOR (127 downto 0);
    n_in : in STD_LOGIC_VECTOR (127 downto 0);

    rr_n : in STD_LOGIC_VECTOR (127 downto 0);

    ME_done : out STD_LOGIC;
    M_out : out STD_LOGIC_VECTOR (127 downto 0));
end ModExp;

architecture Behavioral of ModExp is
    signal reset_monpro  : STD_LOGIC;
    signal MP_done_first : STD_LOGIC;
    signal MP_done       : STD_LOGIC;

--Signals for MonPro 1
    signal a_in_1        : STD_LOGIC_VECTOR (127 downto 0);
    signal b_in_1        : STD_LOGIC_VECTOR (127 downto 0);
    signal u_out_1       : STD_LOGIC_VECTOR (127 downto 0);
    signal u_reg_1       : STD_LOGIC_VECTOR (127 downto 0);

--Signals for MonPro 2
    signal a_in_2        : STD_LOGIC_VECTOR (127 downto 0);
    signal b_in_2        : STD_LOGIC_VECTOR (127 downto 0);
    signal u_out_2       : STD_LOGIC_VECTOR (127 downto 0);
    signal u_reg_2       : STD_LOGIC_VECTOR (127 downto 0);
        
    signal ME_done_int   : STD_LOGIC_VECTOR (1 downto 0);
    signal loop_count    : STD_LOGIC_VECTOR (6 downto 0);
begin
 
  process (reset_n,MP_done,clk) begin
    if (reset_n = '1') then
      MP_done_first <= '0';
    elsif(clk'event and clk = '1' and MP_done = '1') then
      MP_done_first <= '1';
    end if;
  end process;

  REG_1:process(reset_n,clk,u_out_1,MP_done) 
  begin
    if (clk'event and clk = '1' and MP_done = '1') then
      u_reg_1 <= u_out_1;
    end if;
  end process;
  
  Start_MUX:process(M_in,u_reg_1,MP_done_first,rr_n) 
  begin
      if (MP_done_first = '1') then --First MonPro cycle
        b_in_1 <= u_reg_1;
        a_in_1 <= u_reg_1;
      else                          --Main MonPro cycles
        b_in_1 <= M_in;
        a_in_1 <= rr_n;
      end if;
  end process;
    
  process(clk, MP_done,reset_n,reset_monpro) begin
    if (reset_n = '1') then
      reset_monpro <= '1';
    elsif(clk'event and clk = '1')then
      if (MP_done = '1' and reset_monpro = '0') then
        reset_monpro <= '1';
      else
        reset_monpro <= '0';
      end if;
    end if;
  end process;
      
    Dobbel_MonPro: entity work.MonPro
    port map(
    clk => clk,
    reset_n => reset_monpro,
    n_in => n_in,
    
    MP_done => MP_done,
    a_in1 => a_in_1,
    b_in1 => b_in_1,
    u_out1 => u_out_1,
    
    a_in2 => a_in_2,
    b_in2 => b_in_2,
    u_out2 => u_out_2
    );
      
  --ME done fiks
  process(MP_done,loop_count,e_in,ME_done_int,reset_n,clk) 
      variable loop_test : std_logic_vector(128 downto 0);
  begin
    loop_test := (others => '0');
    if (MP_done_first = '1') then
      loop_test(to_integer("0" & unsigned(loop_count) + "1")) := '1';
    end if;
    
    if(reset_n = '1') then
      ME_done_int <= "00";
    elsif (clk'event and clk = '1' and MP_done = '1') then
      if (ME_done_int = "01") then
        ME_done_int <= "11";
      elsif(unsigned(loop_test) > unsigned(e_in)) then
        if (ME_done_int = "00") then
          ME_done_int <= "01";
        end if;
      else 
        ME_done_int <= "00";
      end if;
    end if;
  end process;
  
  MUX_2:process(M_in,u_reg_1,u_reg_2,MP_done_first,rr_n,ME_done_int) begin
    if (ME_done_int(0) = '1')then    -- One MonPro cycle until done
       a_in_2 <= x"00000000000000000000000000000001";
       b_in_2 <= u_reg_2;    
    elsif (MP_done_first = '1') then -- Main part
       a_in_2 <= u_reg_1;
       b_in_2 <= u_reg_2;
    else                             -- First monpro cycle
      a_in_2 <= x"00000000000000000000000000000001";
      b_in_2 <= rr_n;
    end if;
  end process;  
  
  ME_done <= ME_done_int(1) OR(MP_done and ME_done_int(0));
  
  REG_2:process(MP_done,u_out_2,loop_count,e_in,MP_done_first,clk) 
  begin
      if(clk'event and clk = '1' and MP_done = '1') then      
        if (MP_done_first = '0' or e_in(to_integer(unsigned(loop_count))) = '1') then        
          u_reg_2 <= u_out_2;
        end if;
      end if;
  end process;

  Loop_counting:process(MP_done,reset_n,loop_count,clk) begin
    if(reset_n = '1') then
        loop_count <= (others => '1');
    elsif(clk'event and clk = '1' and MP_done = '1') then
        loop_count <= std_logic_vector(unsigned(loop_count) + "1");    
    end if;
  end process;
   M_out <= u_out_2;

end Behavioral;
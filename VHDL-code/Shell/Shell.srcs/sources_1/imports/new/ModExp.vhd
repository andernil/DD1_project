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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ModExp is
    Port (
    clk : in STD_LOGIC;
    reset_n : in STD_LOGIC;
    
    M_in : in STD_LOGIC_VECTOR (127 downto 0);
    e_in : in STD_LOGIC_VECTOR (127 downto 0);
    n_in : in STD_LOGIC_VECTOR (127 downto 0);

    r_n : in STD_LOGIC_VECTOR (127 downto 0);
    rr_n : in STD_LOGIC_VECTOR (127 downto 0);

    ME_done : out STD_LOGIC;
    M_out : out STD_LOGIC_VECTOR (127 downto 0));
end ModExp;

architecture Behavioral of ModExp is
    signal reset_monpro : std_logic;
    signal MP_done_first:std_logic;

    signal a_in_1       : STD_LOGIC_VECTOR (127 downto 0);
    signal b_in_1       : STD_LOGIC_VECTOR (127 downto 0);
    signal u_out_1      : STD_LOGIC_VECTOR (127 downto 0);
    signal u_reg_1      : STD_LOGIC_VECTOR (127 downto 0);
    signal MP_done_1    : std_logic;

    signal a_in_2       : STD_LOGIC_VECTOR (127 downto 0);
    signal b_in_2       : STD_LOGIC_VECTOR (127 downto 0);
    signal u_out_2      : STD_LOGIC_VECTOR (127 downto 0);
    signal u_reg_2      : STD_LOGIC_VECTOR (127 downto 0);
    signal MP_done_2    : std_logic;
    
    signal ME_done_int  : std_logic_vector (1 downto 0);
    signal loop_test    : std_logic_vector (127 downto 0);
    signal loop_count   : STD_LOGIC_VECTOR (6 downto 0);
begin
 
  process (reset_n,MP_done_1,clk) begin
    if (reset_n = '1') then
      MP_done_first <= '0';
    elsif(clk'event and clk = '1' and MP_done_1 = '1') then
      MP_done_first <= '1';
    end if;
  end process;

  REG_1:process(reset_n,clk,u_out_1,MP_done_1) 
  begin
    if (clk'event and clk = '1' and MP_done_1 = '1') then
      u_reg_1 <= u_out_1;
    end if;
  end process;
  
  Start_MUX:process(rr_n,M_in,u_reg_1,MP_done_first) 
  begin
      if (MP_done_first = '1') then
        b_in_1 <= u_reg_1;
        a_in_1 <= u_reg_1;
      else
        b_in_1 <= M_in;
        a_in_1 <= rr_n;
      end if;
  end process;
    
  --reset_monpro <= reset_n or MP_done_1;
  process(clk, MP_done_1,reset_n,reset_monpro) begin
    if (reset_n = '1') then
      reset_monpro <= '1';
    elsif(clk'event and clk = '1')then
      if (MP_done_1 = '1' and reset_monpro = '0') then
        reset_monpro <= '1';
      else
        reset_monpro <= '0';
      end if;
    end if;
  end process;
      
    MonPro_1: entity work.MonPro
    port map(
    clk => clk,
    reset_n => reset_monpro,
    n_in => n_in,
    
    MP_done => MP_done_1,
    a_in => a_in_1,
    b_in => b_in_1,
    u_out => u_out_1
    );
    
    
  process(loop_count,reset_n,MP_done_2,MP_done_first,clk) begin
   if (reset_n = '1') then
     loop_test <= (others => '0');
    elsif (clk'event and clk = '1' and (MP_done_2 = '1' and MP_done_first = '1')) then
     loop_test(to_integer(unsigned(loop_count))) <= '1';
    end if;
  end process;
  
  end_mux:process(ME_done_int,u_reg_1) begin
    if (ME_done_int(0) = '1') then
      a_in_2 <= x"00000000000000000000000000000001";
    else
      a_in_2 <= u_reg_1;
    end if;
  end process;
  
  --ME done fiks
  process(MP_done_2,loop_test,e_in,ME_done_int,reset_n,clk) 
  begin
    if(reset_n = '1') then
      ME_done_int <= "00";
    elsif (clk'event and clk = '1' and MP_done_2 = '1') then
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
  
  ME_done <= ME_done_int(1) OR(MP_done_2 and ME_done_int(0));
  
  REG_2:process(reset_n,MP_done_2,u_out_2,loop_count,r_n,e_in,MP_done_first,clk) 
  begin
      if(reset_n = '1') then
        u_reg_2 <= r_n;
      elsif(clk'event and clk = '1' and MP_done_2 = '1') then      
        if (MP_done_first = '1' AND e_in(to_integer(unsigned(loop_count))) = '1') then        
          u_reg_2 <= u_out_2;
        end if;
      end if;
  end process;

  b_in_2 <= u_reg_2;

  Loop_counting:process(MP_done_2,reset_n,loop_count,clk) begin
    if(reset_n = '1') then
        loop_count <= (others => '1');
    elsif(clk'event and clk = '1' and MP_done_2 = '1') then
        loop_count <= std_logic_vector(unsigned(loop_count) + "1");    
    end if;
  end process;


    MonPro_2: entity work.MonPro
    port map(
    clk => clk,
    reset_n => reset_monpro,
    n_in => n_in,
    
    MP_done => MP_done_2,
    a_in => a_in_2,
    b_in => b_in_2,
    u_out => u_out_2
    );    

   M_out <= u_out_2;

end Behavioral;
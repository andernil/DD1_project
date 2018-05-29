----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2017 19:49:54
-- Design Name: 
-- Module Name: MonPro - Behavioral
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

--MonPro-loop is one pass of the for loop in MonPro
entity MonPro_loop is
    Port ( 
   clk       : in  STD_LOGIC;
   reset_n   : in  STD_LOGIC;
   n_in      : in  STD_LOGIC_VECTOR (127 downto 0);
   a_in      : in  STD_LOGIC_VECTOR (127 downto 0);
   b_in      : in  STD_LOGIC_VECTOR (127 downto 0);
   a_bit     : in  STD_LOGIC_VECTOR (7 downto 0);
   u_ut      : out STD_LOGIC_VECTOR (127 downto 0));
end MonPro_loop;

architecture Behavioral of MonPro_loop is
   signal loop_reg    : STD_LOGIC_VECTOR (128 downto 0);
   signal loop_nxt    : STD_LOGIC_VECTOR (128 downto 0);
begin                                                      
    
    
--This is very ugly, but hella fast, and any atemt to improve it, makes it slower.    
    data_beregning: process(n_in,a_in,b_in,a_bit,loop_reg) 
    variable u_tmp : std_logic_vector(129 downto 0);
    begin
    if (((a_in(to_integer(unsigned(a_bit(6 downto 0))))  = '1') AND (b_in(0) = '1')) XOR (loop_reg(0) = '1')) then  
      if(a_in(to_integer(unsigned(a_bit(6 downto 0))))  = '1') then
        u_tmp := std_logic_vector(( '0' & unsigned(loop_reg))+ unsigned(b_in) + unsigned(n_in));
      else
        u_tmp := std_logic_vector(( '0' & unsigned(loop_reg))+ unsigned(n_in));
      end if;
    elsif(a_in(to_integer(unsigned(a_bit(6 downto 0))))  = '1') then
        u_tmp := std_logic_vector(unsigned(b_in) + unsigned('0' & loop_reg));
    else
        u_tmp := '0' & loop_reg;
    end if;
    
    loop_nxt <= u_tmp(129 downto 1);
    end process;

    u_reg: process(clk,reset_n,loop_nxt) begin
      if(clk'event and clk = '1') then 
        if(reset_n = '1') then
          loop_reg <= (others => '0');
        else
          loop_reg <= loop_nxt;
        end if;
      end if;  
    end process;
    
   process(loop_reg,n_in) 
   variable u_ut_tmp : std_logic_vector(128 downto 0);  
   begin
        if (unsigned(loop_reg) > unsigned(n_in)) then
            u_ut_tmp := std_logic_vector(unsigned(loop_reg) - unsigned(n_in));
        else
            u_ut_tmp := loop_reg;
        end if;
        u_ut <= u_ut_tmp(127 downto 0);
    end process;
    
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MonPro is
    Port ( 
           clk      : in  std_logic;
           reset_n  : in  std_logic;
           n_in     : in STD_LOGIC_VECTOR (127 downto 0);
           a_in1    : in STD_LOGIC_VECTOR (127 downto 0);
           b_in1    : in STD_LOGIC_VECTOR (127 downto 0);
           a_in2    : in STD_LOGIC_VECTOR (127 downto 0);
           b_in2    : in STD_LOGIC_VECTOR (127 downto 0);
           MP_done  : out std_logic;
           u_out1   : out STD_LOGIC_VECTOR (127 downto 0);
           u_out2   : out STD_LOGIC_VECTOR (127 downto 0));

end MonPro;

architecture Behavioral of MonPro is
   signal u_int_ut1 : STD_LOGIC_VECTOR (127 downto 0);   
   signal u_int_ut2 : STD_LOGIC_VECTOR (127 downto 0);
       
   signal a_bit   : STD_LOGIC_VECTOR (7 downto 0);
   
   shared variable n_less_than_128_bit : std_logic := '0'; --Set to 1 to allow "n" less than 128-bit (n(msb) == "0").
                                                           --Design is smaler when only supporting n = 128 bit
begin

-- Find when monpro is done

  process(clk,a_bit,reset_n) begin
    if(clk'event and clk = '1') then
      if(reset_n = '1') then
        a_bit <= (others => '0');
      else        
        a_bit <= std_logic_vector(unsigned(a_bit) + "1");    
      end if;
    end if;
  end process;

  process(n_in,a_bit,reset_n)
    variable a_test : STD_LOGIC_VECTOR(127 downto 0);
  begin
   if (n_less_than_128_bit = '1') then
   a_test := (others => '0');
   a_test(to_integer(unsigned(a_bit(6 downto 0)))) := '1';
   
    if (reset_n = '1') then
      MP_done <= '0';
    elsif(unsigned(a_test(127 downto 0)) > unsigned(n_in) or (unsigned(a_bit) > "01111111")) then
      MP_done <= '1';
    else 
      MP_done <= '0';
    end if;
  else
    if (reset_n = '1') then
      MP_done <= '0';
    else 
      MP_done <= a_bit(7); --is '1' if a_bit > "01111111"
    end if;  
  end if;
  end process;
      
  loopti_loop1: entity work.MonPro_loop
  port map (
    -- Data input interface
    clk     => clk,
    reset_n => reset_n,           
    n_in    => n_in, 
    b_in    => b_in1,            
    a_in    => a_in1,    
    a_bit   => a_bit,
    u_ut => u_int_ut1
  );
  
  loopti_loop2: entity work.MonPro_loop
  port map (
    -- Data input interface 
    clk     => clk,
    reset_n => reset_n,         
    n_in    => n_in, 
    b_in    => b_in2,            
    a_in    => a_in2,    
    a_bit   => a_bit,
    u_ut => u_int_ut2
    );
  
  u_out1 <= u_int_ut1;
  u_out2 <= u_int_ut2;

end Behavioral;
--monpro test build
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
--use ieee.std_logic_arith.all;

-- bit 0 = lsb

entity MonPro_loop is
    Port ( 
           n_in    : in STD_LOGIC_VECTOR (127 downto 0);
           a_in    : in STD_LOGIC_VECTOR (127 downto 0);
           b_in    : in STD_LOGIC_VECTOR (127 downto 0);
           a_bit   : in STD_LOGIC_VECTOR (6 downto 0);
           u_temp_ut : out STD_LOGIC_VECTOR (127 downto 0);
           u_temp_in : in STD_LOGIC_VECTOR (127 downto 0));
end MonPro_loop;

architecture Behavioral of MonPro_loop is
   signal u_int : STD_LOGIC_VECTOR (128 downto 0);
   signal u_int2 : STD_LOGIC_VECTOR (128 downto 0);
begin
    
    data_beregning: process(n_in,a_in,b_in,a_bit,u_temp_in,u_int) 
    begin
        if (a_in(to_integer(unsigned(a_bit(6 downto 0)))) = '1') then
            u_int <= std_logic_vector(( '0' & unsigned(u_temp_in))+ unsigned(b_in));
        else
            u_int <= std_logic_vector( '0' & unsigned(u_temp_in));
        end if;
        
        if (u_int(0) = '1') then
            u_int2 <= std_logic_vector(unsigned(u_int) + unsigned(n_in));
        else
            u_int2 <= u_int;
        end if;
    end process;    

    u_temp_ut <= u_int2(128 downto 1);
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MonPro is
    Port ( 
           clk     : in  std_logic;
           reset_n : in  std_logic;
           n_in    : in STD_LOGIC_VECTOR (127 downto 0);
           a_in    : in STD_LOGIC_VECTOR (127 downto 0);
           b_in    : in STD_LOGIC_VECTOR (127 downto 0);
           MP_done : out std_logic;
           u_out   : out STD_LOGIC_VECTOR (127 downto 0));
end MonPro;


-- bit 0 = lsb
architecture Behavioral of MonPro is
   signal u_int_ut : STD_LOGIC_VECTOR (127 downto 0);
   signal u_int_in : STD_LOGIC_VECTOR (127 downto 0);   
   signal a_bit   : STD_LOGIC_VECTOR (6 downto 0);
   signal a_test : STD_LOGIC_VECTOR (127 downto 0);
begin


-- Find when monpro is done
  process(a_bit,reset_n,clk) 
  begin
    if (reset_n = '1') then
      a_test <= (others => '0');
    elsif (clk'event and clk = '1') then
      a_test(to_integer(unsigned(a_bit(6 downto 0)))) <= '1';
    end if;
  end process;
  
  process(n_in,a_test,a_bit) 
  begin
    if(unsigned(a_test) > unsigned(n_in) or (unsigned(a_bit) > "01111111")) then
      MP_done <= '1';
    else 
      MP_done <= '0';
    end if;
  end process;  
  
  
  loopti_loop: entity work.MonPro_loop
  port map (
  --      reset_n        => reset_n, 

    -- Data input interface           
    n_in  => n_in, 
    b_in  => b_in,            
    a_in  => a_in,    
    --           reset_n : in  std_logic;
    a_bit => a_bit,
    u_temp_ut => u_int_ut,
    u_temp_in => u_int_in 
  );
    process(u_int_in,n_in) begin
        if (unsigned(u_int_in) > unsigned(n_in)) then
            u_out <= std_logic_vector(unsigned(u_int_in) - unsigned(n_in));
        else
            u_out <= u_int_in;
        end if;
    end process;
 
  process(clk,a_bit,reset_n) begin

    if(clk'event and clk = '1') then
      if(reset_n = '1') then
        a_bit <= (others => '0');
      else        
        a_bit <= std_logic_vector(unsigned(a_bit) + "1");    
      end if;
    end if;
  end process;
    
  process(u_int_ut,reset_n,clk) begin
    if(clk'event and clk = '1') then 
      if(reset_n = '1') then
        u_int_in <= (others => '0');
      else
       u_int_in <= u_int_ut;
      end if;
    end if;  
  end process; 
end Behavioral;

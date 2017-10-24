@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto 44ec1947f6b74393a78fc062adcc6d79 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot MonPro_tb_behav xil_defaultlib.MonPro_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim ModExp_tb_behav -key {Behavioral:sim_1:Functional:ModExp_tb} -tclbatch ModExp_tb.tcl -view C:/Users/Torgeir Leithe/Google Drive/stor-skole/TFE4141 Design av digitale system 1/RSA/MonPro/ModExp/ModExp_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim MonPro_tb_time_synth -key {Post-Synthesis:sim_1:Timing:MonPro_tb} -tclbatch MonPro_tb.tcl -view C:/Users/Torgeir Leithe/Google Drive/stor-skole/TFE4141 Design av digitale system 1/RSA/MonPro/MonPro/MonPro_tb_func_synth.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

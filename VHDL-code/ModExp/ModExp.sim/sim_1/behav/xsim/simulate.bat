@echo off
REM ****************************************************************************
REM Vivado (TM) v2017.3 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Wed Oct 25 13:18:19 +0200 2017
REM SW Build 2018833 on Wed Oct  4 19:58:22 MDT 2017
REM
REM Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
call xsim ModExp_tb_behav -key {Behavioral:sim_1:Functional:ModExp_tb} -tclbatch ModExp_tb.tcl -view C:/Users/Torgeir Leithe/Google Drive/stor-skole/TFE4141 Design av digitale system 1/RSA/Git/DD1_project/VHDL-code/ModExp/ModExp_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

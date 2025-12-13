############################################################
## This file is generated automatically by Vitis HLS.
## Please DO NOT edit it.
## Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
############################################################
open_project trabalho2SD
set_top matrix_mult_3x3
add_files multMatriz.c
open_solution "solucao" -flow_target vivado
set_part {xcau25p-sfvb784-2-i}
create_clock -period 10 -name default
source "./trabalho2SD/solucao/directives.tcl"
#csim_design
csynth_design
#cosim_design
export_design -format ip_catalog

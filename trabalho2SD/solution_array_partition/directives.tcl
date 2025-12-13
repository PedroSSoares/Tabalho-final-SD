############################################################
## This file is generated automatically by Vitis HLS.
## Please DO NOT edit it.
## Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
############################################################
set_directive_top -name matrix_mult_3x3 "matrix_mult_3x3"
set_directive_array_partition -type complete -dim 0 "matrix_mult_3x3" A
set_directive_unroll "matrix_mult_3x3/linha_loop"
set_directive_array_partition -dim 0 -type complete "matrix_mult_3x3" B

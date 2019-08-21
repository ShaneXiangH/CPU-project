-makelib ies_lib/xil_defaultlib -sv \
  "/home/ltj/vivado/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "/home/ltj/vivado/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../computer_org_lab09.srcs/sources_1/ip/cpuclk/cpuclk_clk_wiz.v" \
  "../../../../computer_org_lab09.srcs/sources_1/ip/cpuclk/cpuclk.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib


// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.1 (lin64) Build 5076996 Wed May 22 18:36:09 MDT 2024
// Date        : Wed Dec 11 15:28:27 2024
// Host        : thinkpad-e14 running 64-bit Arch Linux
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_gen_1_sim_netlist.v
// Design      : blk_mem_gen_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_1,blk_mem_gen_v8_4_8,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_8,Vivado 2024.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [11:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [11:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [11:0]douta;

  wire [11:0]addra;
  wire clka;
  wire [11:0]dina;
  wire [11:0]douta;
  wire ena;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [11:0]NLW_U0_doutb_UNCONNECTED;
  wire [11:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "12" *) 
  (* C_ADDRB_WIDTH = "12" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.35215 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_1.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_gen_1.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "3072" *) 
  (* C_READ_DEPTH_B = "3072" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "12" *) 
  (* C_READ_WIDTH_B = "12" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "3072" *) 
  (* C_WRITE_DEPTH_B = "3072" *) 
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "12" *) 
  (* C_WRITE_WIDTH_B = "12" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_8 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[11:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[11:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[11:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[11:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2024.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
RSqbsRZSIb+QlYJMfFv1T7uHQ7PiCEXQkl687MHGm2LgPB15GIYcPmqKUSXgtkLsIFes91PTAyyB
9H9cyY4ZUxedcRg/9ZOB5pm3zPqAbcvGPmg1ivMhr/MlS19t5lYKM2tQo+0Yd+arJXlVZu2BMnvn
+I3G9t9tJuWUIWKjI+I=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
VRSQ05ZaB6bIhFIQ823mTvlJaG9+5iW5C3+KxGjq0sq9ziCshKOLpOGPDMmOWDqA4uBaxC5IKISr
w8+A8mqbYjXo5m1g8sGjNaETS0HKJsK+l5Y++tN4IEUs+DwxgrPR/+LWtChuOzVkfC7BG3LVUEMj
zM3GAyGcXGJ3sdBItZAfsevyiy7kr4Fw+nk2hWytGteu1NZk3VzPE7KQHLkOlHBPXf6P0j8LpKcr
2oNDgQ/WaEmg6OOvFeJuaWDaee8Sn6wKP/caMyoGdSeczsPtRrJeoSRlbNHlxhCv7zg+Cn2AgwrR
PTqGsMrkhv9U0sq+waS0CmwChsk4WB7RspGYUg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
tNziOjCznlvIl4dadmB9r23Duf+HQHWOuHmupEU3PJxrazHVtZdNKspG9sRXhF9mjbpnSiKYCdFK
Jr9W/dxUid36faFIPKQazVTuOiE0hkzVQAGpYxXjT/ITB/9EFBvgvP5L3EAhHv32x6MA1vkFSI7x
HrZ09YNFEF6T7DPTZE4=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QCYfxgkUHlX1cre1q9aS3sVDIOX36YBK4ZwJXAVUwA6f1OQ77XibjpWJHt5FK9F0PcYp/j21pqzO
BRdkDcFLVAjxER4J5t5iMVhoeMk+3fpiKfYrm4WFl1ygsJsfFJP0jqO1OkjC8iFBtm3n6b7CTl1o
cjBbcBp8UgW6E8rf5inXA0dRqybnyxKJSnMFYLinvpVU6QEc4OKO7mi/i/s9p/efiP+CdQf0yDRU
Fw7o7x0D7tjBv943g5L+4wGZ2JYU+ISqn4Ajxy/bWTTJDe6T/15evhngS61MC8Xjamzc4YLZBP8o
ShfSLoeZeO+Hk5n3xzJRghM0DQ6Sj7NqXFY68w==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Uy8FDDy3dZQGAnMQV0HBesEs+/oZdaq35Kj1PGhy9J/+EBZm0nhhQgYtku8tWABW2jKAC1GtNTvo
uReQyr1hteMxTbD5OIuqv86eb1hXZVENlZ7ichG8auUjkeHAkaSYNbHOuDLIhSqHEL67XbcZ9zPG
1JOY3+VONSww0KYPcQbGSo/2DaC5C0Y+mZODRfJ4+b0WXjce6UaJetilBc3VtqqmodIM2d3HDawF
R0xVJfHj86rXmUkY+SNUw60zsV6raCY6G3k/rXpei1d6zn8tCThkKG5fwiWY8zA7kRdTFIlVKP9h
fb6kfzRBRT/BgVQ8d4RgEcEVV8m3u/Mf4KIlTw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2023_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Pk1GeRlkUK9lt6DVXYVdtOABlzDEWQDcBsP/p+Wo5HaglDLG5b8gk08xTP3IcJ1RKcfuARPMGO2s
/VqFbnVADV90T1rhjIuWMcBnzYQK/ALUvwv11Uju9Gn0fvPIz52l3QBnpjHI1nlsFB7WeqkzVfHZ
tg9gO9bPHjHLjVd9BzH6McrEWY5RkZ0UBy0Fmh/SownJX1b0YGE7LdwKydEMEpyvb28bwTOwfEv/
4RtsfYtEvTjo6e1ZBm66D9IQmKUu32wzTfn5bFZHdyjZg6+HcTzvHMtQX2+AggXfP6FsO2/83qkb
0bfj226fnLhr32dJxtsaJS5OR63GYtzDJ05ITA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LCfWqKmUoUSVOTKNAl5p8n1hfz7SMU2kDOUMBjsDncgSFqiu2zUy1I6GSDrVnF/2umJG5/mWcpvi
rQaFJOlrJ8DNctSuavdlopRAwTMsVi6dAlNGrAawSiDIxtI3tN3MDVdMiH5H+pJMqMt59yXneyCf
2RRSRz2sUQK/aj0lXlqKjVJzVbk8HaBQ8akBJF4iWSMK4foIzJ6iO1EupYovuW6uEiO7jQRWezlW
pbbDenOHHWbfinuX5cbkjpTKHGsEKct65q+ZXJp60m3sconSK3Y2eLQxusuJ1FHDJ4GGKO8mEzCv
3cfGdXX3pVL81OfGO/JD1aMs9H98CO5ssbHqlw==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
A4S1e3DHcTeWzaDVuWDRb3Yf1BjiEsR1RtAeL0BJ7J/oPWMNj96MeGsUiHtZoiYqteTZxqax2cyZ
PV0cMLoBK4Ya8CyM+BTnkFA2ablsGt5Es4TgG/nFS9VEhmeKxu8boAsqW5697aiqOATJf/LucQh5
GOnPXHAuPrDj0A/fu8N2QduqGyysWUSc1KsoJ0/0noJYvLJ2yOhFi4uIUYQfG5LOuOrca5P43pqA
iwUKW/RrFXal2acJdFeXIKffZpKanSV97urdzKyBvf9EPV/M8g9uPFJJ1z6aS+FbknhVPs0pt6eD
+J/qib4gVp/HGnRo4YlxauUMv6Yv9wxiaObY6ttDfYf5p3uzWZMlf3i7YOzZwcd4aS/6+vkD28LG
L9piBIpLx2dvQy74RdvCVdvaP1LC6RMju9RfuXJhuX4ZAmDxRi0zQyRda838ikzwYeOCSKLIvRPb
nuJ8Zx2ot8EFqSeGaaRFaEMU6Zf5SptCUuVMHvSkinBewcwrLB5uiJTJ

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
gj+uMxV+tK4Di7pgSOE82FOBeWmUB1A7OKFOSMUW3qrmQ4/YhryfHMlWPxfAq8avQL7tnBTnRFEg
czbErdIcNzYjrM7Qq00QC/mTqmeQX4/apbqGvN+rwK4RR5oj22wfTib/UQNEQX6fbpi6PtmAeUR9
eShsfq+YWcf7z2Zw4Q+o4+E6m4/3CzU68vglNpzNsJ8S9/8XpdIrvAA/WRAX6OEOC4wlNIKDZsq/
+zMbFgSzN1rP844I/CDmxYM0NIzBWWhYBkPfJyQyigmUoXb84lDip0/Dmnq4EHvu7D/tZNnDl5st
JpftRfEpT6S8e/5MBeKUuhbfg6etHo/oFZvPKQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
aWTy3xv6SqKsldtLS2gY4KrTS8U+KtFNRHS314f6EYZy1MHE9t7oICJ8eNB8up8A+odoE23N3fJb
1alhaadeRWU2GjlIiK1LjZ5PQw+jb1u1GWtRiY+TcTlD75XUlqwykVBrCDfm565DmgZjZle9T3/t
WEfLo+m/8GfBe8trVnoftsk/XI00BMFXRzw8doPGDhNECS1NUrLebryb9iO5Hf4A/40dtslTARsR
nicN0KoIIyiQ+QzliqyXU/8VjS45inON8R0Kv9Qx46EXUp7bds5uQ7QycRhpLG0IPnMIweudU67w
eQmpHJzvZKBCZks/R0OafZx44H6Jib2+QazBCw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UGdPiChIPj1lSozqzCQx17Bi+8FWSuMUMzXUkDLH5zcP1t8tZLzh4CU4WAR8lmJxn8gH763fLp5c
RYU6zA0yxHzl2ksc5YRU1XEfQQT9ha8fQnz+18wVKcsa5UIOfMbGDwnS9yfX59ntG8CB0uF8bJKE
y1CS6U/1Stfs1w2mF94iDxI2n2GJlb1UPtWpmxMBI88hY0GktTPXP2Y7JKl8zRl/Lq0wIF8pHwXk
B4nOgKm6hfzPj0xZ6E/TuER/JE3fy8RSm24IlL/CUgpReEslEOYjQ4EKKZRG9/fxg26utQWW9p+G
fWVU53qrFGzBhKQ96Paj1ROkv6hDHyUb6n7uSw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 36592)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif

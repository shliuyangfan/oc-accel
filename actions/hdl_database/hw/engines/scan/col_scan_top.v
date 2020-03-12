/*
 * Copyright 2020 International Business Machines
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

`include "col_scan_defines.v"

module col_scan_top #(
    parameter AXI_MM_ADDR_WIDTH     = 64,
    parameter AXI_MM_DATA_WIDTH     = 1024,
    parameter AXI_MM_ID_WIDTH       = 5,
    parameter AXI_MM_AWUSER_WIDTH   = 9,
    parameter AXI_MM_ARUSER_WIDTH   = 9,
    parameter AXI_MM_WUSER_WIDTH    = 9,
    parameter AXI_MM_RUSER_WIDTH    = 9,
    parameter AXI_MM_BUSER_WIDTH    = 9,
    parameter AXI_LT_ADDR_WIDTH     = 32,
    parameter AXI_LT_DATA_WIDTH     = 32,
    parameter HLS_ST_DATA_WIDTH     = 32
)
(
    input                               clk,                    //Clock
    input                               rst_n,                  //Reset, active low
    //----- AXI4 read addr master interface -----
    output                              m_axi_arvalid,          //AXI read address valid
    input                               m_axi_arready,          //AXI read address ready
    output [AXI_MM_ADDR_WIDTH-1 : 0]    m_axi_araddr,           //AXI read address
    output [AXI_MM_ID_WIDTH-1 : 0]      m_axi_arid,             //AXI read address ID
    output [7 : 0]                      m_axi_arlen,            //AXI read address burst length
    output [2 : 0]                      m_axi_arsize,           //AXI read address burst size
    output [1 : 0]                      m_axi_arburst,          //AXI read address burst type
    output [2 : 0]                      m_axi_arprot,           //AXI read address protection type
    output                              m_axi_arlock,           //AXI read address lock type
    output [3 : 0]                      m_axi_arqos,            //AXI read address quality of service
    output [3 : 0]                      m_axi_arcache,          //AXI read address memory type
    output [3 : 0]                      m_axi_arregion,         //AXI read address region identifier
    output [AXI_MM_ARUSER_WIDTH-1 : 0]  m_axi_aruser,           //AXI read address user signal
    //----- AXI4 read data master interface -----
    input                               m_axi_rvalid,           //AXI read valid
    output                              m_axi_rready,           //AXI read ready
    input  [1 : 0]                      m_axi_rresp,            //AXI read response
    input  [AXI_MM_ID_WIDTH-1 : 0]      m_axi_rid,              //AXI read ID
    input  [AXI_MM_DATA_WIDTH-1 : 0]    m_axi_rdata,            //AXI read data
    input                               m_axi_rlast,            //AXI read last
    input  [AXI_MM_RUSER_WIDTH-1 : 0]   m_axi_ruser,            //AXI read user signal
    //----- AXI4 write addr master interface -----
    output                              m_axi_awvalid,          //AXI write address valid
    input                               m_axi_awready,          //AXI write address ready
    output [AXI_MM_ADDR_WIDTH-1 : 0]    m_axi_awaddr,           //AXI write address
    output [AXI_MM_ID_WIDTH-1 : 0]      m_axi_awid,             //AXI write address ID
    output [7 : 0]                      m_axi_awlen,            //AXI write address burst length
    output [2 : 0]                      m_axi_awsize,           //AXI write address burst size
    output [1 : 0]                      m_axi_awburst,          //AXI write address burst type
    output [2 : 0]                      m_axi_awprot,           //AXI write address protection type
    output                              m_axi_awlock,           //AXI write address lock type
    output [3 : 0]                      m_axi_awqos,            //AXI write address quality of service
    output [3 : 0]                      m_axi_awcache,          //AXI write address memory type
    output [3 : 0]                      m_axi_awregion,         //AXI write address region identifier
    output [AXI_MM_ARUSER_WIDTH-1 : 0]  m_axi_awuser,           //AXI write address user signal
    //----- AXI4 write data master interface -----
    output                              m_axi_wvalid,           //AXI write data valid
    input                               m_axi_wready,           //AXI write data ready
    output [AXI_MM_DATA_WIDTH-1 : 0]    m_axi_wdata,            //AXI write data
    output [AXI_MM_DATA_WIDTH/8-1 : 0]  m_axi_wstrb,            //AXI write data strobe
    output                              m_axi_wlast,            //AXI write data last
    output [AXI_MM_WUSER_WIDTH-1 : 0]   m_axi_wuser,            //AXI write data user signal
    //----- AXI4 write response master interface -----
    input                               m_axi_bvalid,           //AXI write response valid
    output                              m_axi_bready,           //AXI write response ready
    input  [1 : 0]                      m_axi_bresp,            //AXI write response
    input  [AXI_MM_ID_WIDTH-1 : 0]      m_axi_bid,              //AXI write response ID
    input  [AXI_MM_BUSER_WIDTH-1 : 0]   m_axi_buser,            //AXI write response user signal
    //----- AXI4 lite slave interface -----
    input                               s_axi_lite_arvalid,     //AXI lite slave read address valid
    input  [AXI_LT_ADDR_WIDTH-1 : 0]    s_axi_lite_araddr,      //AXI lite slave read address
    output                              s_axi_lite_arready,     //AXI lite slave read address ready
    output                              s_axi_lite_rvalid,      //AXI lite slave read valid
    output [AXI_LT_DATA_WIDTH-1 : 0]    s_axi_lite_rdata,       //AXI lite slave read data
    output [1 : 0]                      s_axi_lite_rresp,       //AXI lite slave read response
    input                               s_axi_lite_rready,      //AXI lite slave read ready
    input                               s_axi_lite_awvalid,     //AXI lite slave write address valid
    input  [AXI_LT_ADDR_WIDTH-1 : 0]    s_axi_lite_awaddr,      //AXI lite slave write address
    output                              s_axi_lite_awready,     //AXI lite slave write address ready
    input                               s_axi_lite_wvalid,      //AXI lite slave write valid
    input  [AXI_LT_DATA_WIDTH-1 : 0]    s_axi_lite_wdata,       //AXI lite slave write data
    input  [AXI_LT_DATA_WIDTH/8-1 : 0]  s_axi_lite_wstrb,       //AXI lite slave write strobes
    output                              s_axi_lite_wready,      //AXI lite slave write ready
    output                              s_axi_lite_bvalid,      //AXI lite slave write resp valid
    output [1 : 0]                      s_axi_lite_bresp,       //AXI lite slave write resp response
    input                               s_axi_lite_bready,      //AXI lite slave write resp ready
    //----- AXI4 lite master interface -----
    output                              m_axi_lite_arvalid,     //AXI lite master read address valid
    output [AXI_LT_ADDR_WIDTH-1 : 0]    m_axi_lite_araddr,      //AXI lite master read address
    input                               m_axi_lite_arready,     //AXI lite master read address ready
    input                               m_axi_lite_rvalid,      //AXI lite master read valid
    input  [AXI_LT_DATA_WIDTH-1 : 0 ]   m_axi_lite_rdata,       //AXI lite master read data
    input  [1 : 0 ]                     m_axi_lite_rresp,       //AXI lite master read response
    output                              m_axi_lite_rready,      //AXI lite master read ready
    output                              m_axi_lite_awvalid,     //AXI lite master write address valid
    output [AXI_LT_ADDR_WIDTH-1 : 0]    m_axi_lite_awaddr,      //AXI lite master write address
    input                               m_axi_lite_awready,     //AXI lite master write address ready
    output                              m_axi_lite_wvalid,      //AXI lite master write valid
    output [AXI_LT_DATA_WIDTH-1 : 0 ]   m_axi_lite_wdata,       //AXI lite master write data
    output [AXI_LT_DATA_WIDTH/8-1 : 0 ] m_axi_lite_wstrb,       //AXI lite master write strobes
    input                               m_axi_lite_wready,      //AXI lite master write ready
    input                               m_axi_lite_bvalid,      //AXI lite master write resp valid
    input  [1 : 0 ]                     m_axi_lite_bresp,       //AXI lite master write resp response
    output                              m_axi_lite_bready,      //AXI lite master write resp ready
    //----- HLS stream master interface for scan channel -----
`ifdef COL_SCAN_LANE_0_EN
  `ifdef COL_OUT_CHAN_0_EN
    output                              scan0_tvalid_col0_ch0,  //Lane0 column0 channel0 stream data valid
    input                               scan0_tready_col0_ch0,  //Lane0 column0 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col0_ch0,   //Lane0 column0 channel0 stream data
    output                              scan0_tvalid_col1_ch0,  //Lane0 column1 channel0 stream data valid
    input                               scan0_tready_col1_ch0,  //Lane0 column1 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col1_ch0,   //Lane0 column1 channel0 stream data
    output                              scan0_tvalid_col2_ch0,  //Lane0 column2 channel0 stream data valid
    input                               scan0_tready_col2_ch0,  //Lane0 column2 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col2_ch0,   //Lane0 column2 channel0 stream data
    output                              scan0_tvalid_col3_ch0,  //Lane0 column3 channel0 stream data valid
    input                               scan0_tready_col3_ch0,  //Lane0 column3 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col3_ch0,   //Lane0 column3 channel0 stream data
    output                              scan0_tvalid_col4_ch0,  //Lane0 column4 channel0 stream data valid
    input                               scan0_tready_col4_ch0,  //Lane0 column4 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col4_ch0,   //Lane0 column4 channel0 stream data
    output                              scan0_tvalid_col5_ch0,  //Lane0 column5 channel0 stream data valid
    input                               scan0_tready_col5_ch0,  //Lane0 column5 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col5_ch0,   //Lane0 column5 channel0 stream data
    output                              scan0_tvalid_col6_ch0,  //Lane0 column6 channel0 stream data valid
    input                               scan0_tready_col6_ch0,  //Lane0 column6 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col6_ch0,   //Lane0 column6 channel0 stream data
    output                              scan0_tvalid_col7_ch0,  //Lane0 column7 channel0 stream data valid
    input                               scan0_tready_col7_ch0,  //Lane0 column7 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col7_ch0,   //Lane0 column7 channel0 stream data
    output                              scan0_tlast_ch0,        //Lane0 channel0 stream data last
  `endif
  `ifdef COL_OUT_CHAN_1_EN
    output                              scan0_tvalid_col0_ch1,  //Lane0 column0 channel1 stream data valid
    input                               scan0_tready_col0_ch1,  //Lane0 column0 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col0_ch1,   //Lane0 column0 channel1 stream data
    output                              scan0_tvalid_col1_ch1,  //Lane0 column1 channel1 stream data valid
    input                               scan0_tready_col1_ch1,  //Lane0 column1 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col1_ch1,   //Lane0 column1 channel1 stream data
    output                              scan0_tvalid_col2_ch1,  //Lane0 column2 channel1 stream data valid
    input                               scan0_tready_col2_ch1,  //Lane0 column2 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col2_ch1,   //Lane0 column2 channel1 stream data
    output                              scan0_tvalid_col3_ch1,  //Lane0 column3 channel1 stream data valid
    input                               scan0_tready_col3_ch1,  //Lane0 column3 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col3_ch1,   //Lane0 column3 channel1 stream data
    output                              scan0_tvalid_col4_ch1,  //Lane0 column4 channel1 stream data valid
    input                               scan0_tready_col4_ch1,  //Lane0 column4 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col4_ch1,   //Lane0 column4 channel1 stream data
    output                              scan0_tvalid_col5_ch1,  //Lane0 column5 channel1 stream data valid
    input                               scan0_tready_col5_ch1,  //Lane0 column5 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col5_ch1,   //Lane0 column5 channel1 stream data
    output                              scan0_tvalid_col6_ch1,  //Lane0 column6 channel1 stream data valid
    input                               scan0_tready_col6_ch1,  //Lane0 column6 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col6_ch1,   //Lane0 column6 channel1 stream data
    output                              scan0_tvalid_col7_ch1,  //Lane0 column7 channel1 stream data valid
    input                               scan0_tready_col7_ch1,  //Lane0 column7 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col7_ch1,   //Lane0 column7 channel1 stream data
    output                              scan0_tlast_ch1,        //Lane0 channel1 stream data last
  `endif
  `ifdef COL_OUT_CHAN_2_EN
    output                              scan0_tvalid_col0_ch2,  //Lane0 column0 channel2 stream data valid
    input                               scan0_tready_col0_ch2,  //Lane0 column0 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col0_ch2,   //Lane0 column0 channel2 stream data
    output                              scan0_tvalid_col1_ch2,  //Lane0 column1 channel2 stream data valid
    input                               scan0_tready_col1_ch2,  //Lane0 column1 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col1_ch2,   //Lane0 column1 channel2 stream data
    output                              scan0_tvalid_col2_ch2,  //Lane0 column2 channel2 stream data valid
    input                               scan0_tready_col2_ch2,  //Lane0 column2 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col2_ch2,   //Lane0 column2 channel2 stream data
    output                              scan0_tvalid_col3_ch2,  //Lane0 column3 channel2 stream data valid
    input                               scan0_tready_col3_ch2,  //Lane0 column3 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col3_ch2,   //Lane0 column3 channel2 stream data
    output                              scan0_tvalid_col4_ch2,  //Lane0 column4 channel2 stream data valid
    input                               scan0_tready_col4_ch2,  //Lane0 column4 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col4_ch2,   //Lane0 column4 channel2 stream data
    output                              scan0_tvalid_col5_ch2,  //Lane0 column5 channel2 stream data valid
    input                               scan0_tready_col5_ch2,  //Lane0 column5 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col5_ch2,   //Lane0 column5 channel2 stream data
    output                              scan0_tvalid_col6_ch2,  //Lane0 column6 channel2 stream data valid
    input                               scan0_tready_col6_ch2,  //Lane0 column6 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col6_ch2,   //Lane0 column6 channel2 stream data
    output                              scan0_tvalid_col7_ch2,  //Lane0 column7 channel2 stream data valid
    input                               scan0_tready_col7_ch2,  //Lane0 column7 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col7_ch2,   //Lane0 column7 channel2 stream data
    output                              scan0_tlast_ch2,        //Lane0 channel2 stream data last
  `endif
  `ifdef COL_OUT_CHAN_3_EN
    output                              scan0_tvalid_col0_ch3,  //Lane0 column0 channel3 stream data valid
    input                               scan0_tready_col0_ch3,  //Lane0 column0 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col0_ch3,   //Lane0 column0 channel3 stream data
    output                              scan0_tvalid_col1_ch3,  //Lane0 column1 channel3 stream data valid
    input                               scan0_tready_col1_ch3,  //Lane0 column1 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col1_ch3,   //Lane0 column1 channel3 stream data
    output                              scan0_tvalid_col2_ch3,  //Lane0 column2 channel3 stream data valid
    input                               scan0_tready_col2_ch3,  //Lane0 column2 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col2_ch3,   //Lane0 column2 channel3 stream data
    output                              scan0_tvalid_col3_ch3,  //Lane0 column3 channel3 stream data valid
    input                               scan0_tready_col3_ch3,  //Lane0 column3 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col3_ch3,   //Lane0 column3 channel3 stream data
    output                              scan0_tvalid_col4_ch3,  //Lane0 column4 channel3 stream data valid
    input                               scan0_tready_col4_ch3,  //Lane0 column4 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col4_ch3,   //Lane0 column4 channel3 stream data
    output                              scan0_tvalid_col5_ch3,  //Lane0 column5 channel3 stream data valid
    input                               scan0_tready_col5_ch3,  //Lane0 column5 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col5_ch3,   //Lane0 column5 channel3 stream data
    output                              scan0_tvalid_col6_ch3,  //Lane0 column6 channel3 stream data valid
    input                               scan0_tready_col6_ch3,  //Lane0 column6 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col6_ch3,   //Lane0 column6 channel3 stream data
    output                              scan0_tvalid_col7_ch3,  //Lane0 column7 channel3 stream data valid
    input                               scan0_tready_col7_ch3,  //Lane0 column7 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan0_tdata_col7_ch3,   //Lane0 column7 channel3 stream data
    output                              scan0_tlast_ch3,        //Lane0 channel3 stream data last
  `endif
`endif
`ifdef COL_SCAN_LANE_1_EN
  `ifdef COL_OUT_CHAN_0_EN
    output                              scan1_tvalid_col0_ch0,  //Lane1 column0 channel0 stream data valid
    input                               scan1_tready_col0_ch0,  //Lane1 column0 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col0_ch0,   //Lane1 column0 channel0 stream data
    output                              scan1_tvalid_col1_ch0,  //Lane1 column1 channel0 stream data valid
    input                               scan1_tready_col1_ch0,  //Lane1 column1 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col1_ch0,   //Lane1 column1 channel0 stream data
    output                              scan1_tvalid_col2_ch0,  //Lane1 column2 channel0 stream data valid
    input                               scan1_tready_col2_ch0,  //Lane1 column2 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col2_ch0,   //Lane1 column2 channel0 stream data
    output                              scan1_tvalid_col3_ch0,  //Lane1 column3 channel0 stream data valid
    input                               scan1_tready_col3_ch0,  //Lane1 column3 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col3_ch0,   //Lane1 column3 channel0 stream data
    output                              scan1_tvalid_col4_ch0,  //Lane1 column4 channel0 stream data valid
    input                               scan1_tready_col4_ch0,  //Lane1 column4 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col4_ch0,   //Lane1 column4 channel0 stream data
    output                              scan1_tvalid_col5_ch0,  //Lane1 column5 channel0 stream data valid
    input                               scan1_tready_col5_ch0,  //Lane1 column5 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col5_ch0,   //Lane1 column5 channel0 stream data
    output                              scan1_tvalid_col6_ch0,  //Lane1 column6 channel0 stream data valid
    input                               scan1_tready_col6_ch0,  //Lane1 column6 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col6_ch0,   //Lane1 column6 channel0 stream data
    output                              scan1_tvalid_col7_ch0,  //Lane1 column7 channel0 stream data valid
    input                               scan1_tready_col7_ch0,  //Lane1 column7 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col7_ch0,   //Lane1 column7 channel0 stream data
    output                              scan1_tlast_ch0,        //Lane1 channel0 stream data last
  `endif
  `ifdef COL_OUT_CHAN_1_EN
    output                              scan1_tvalid_col0_ch1,  //Lane1 column0 channel1 stream data valid
    input                               scan1_tready_col0_ch1,  //Lane1 column0 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col0_ch1,   //Lane1 column0 channel1 stream data
    output                              scan1_tvalid_col1_ch1,  //Lane1 column1 channel1 stream data valid
    input                               scan1_tready_col1_ch1,  //Lane1 column1 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col1_ch1,   //Lane1 column1 channel1 stream data
    output                              scan1_tvalid_col2_ch1,  //Lane1 column2 channel1 stream data valid
    input                               scan1_tready_col2_ch1,  //Lane1 column2 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col2_ch1,   //Lane1 column2 channel1 stream data
    output                              scan1_tvalid_col3_ch1,  //Lane1 column3 channel1 stream data valid
    input                               scan1_tready_col3_ch1,  //Lane1 column3 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col3_ch1,   //Lane1 column3 channel1 stream data
    output                              scan1_tvalid_col4_ch1,  //Lane1 column4 channel1 stream data valid
    input                               scan1_tready_col4_ch1,  //Lane1 column4 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col4_ch1,   //Lane1 column4 channel1 stream data
    output                              scan1_tvalid_col5_ch1,  //Lane1 column5 channel1 stream data valid
    input                               scan1_tready_col5_ch1,  //Lane1 column5 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col5_ch1,   //Lane1 column5 channel1 stream data
    output                              scan1_tvalid_col6_ch1,  //Lane1 column6 channel1 stream data valid
    input                               scan1_tready_col6_ch1,  //Lane1 column6 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col6_ch1,   //Lane1 column6 channel1 stream data
    output                              scan1_tvalid_col7_ch1,  //Lane1 column7 channel1 stream data valid
    input                               scan1_tready_col7_ch1,  //Lane1 column7 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col7_ch1,   //Lane1 column7 channel1 stream data
    output                              scan1_tlast_ch1,        //Lane1 channel1 stream data last
  `endif
  `ifdef COL_OUT_CHAN_2_EN
    output                              scan1_tvalid_col0_ch2,  //Lane1 column0 channel2 stream data valid
    input                               scan1_tready_col0_ch2,  //Lane1 column0 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col0_ch2,   //Lane1 column0 channel2 stream data
    output                              scan1_tvalid_col1_ch2,  //Lane1 column1 channel2 stream data valid
    input                               scan1_tready_col1_ch2,  //Lane1 column1 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col1_ch2,   //Lane1 column1 channel2 stream data
    output                              scan1_tvalid_col2_ch2,  //Lane1 column2 channel2 stream data valid
    input                               scan1_tready_col2_ch2,  //Lane1 column2 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col2_ch2,   //Lane1 column2 channel2 stream data
    output                              scan1_tvalid_col3_ch2,  //Lane1 column3 channel2 stream data valid
    input                               scan1_tready_col3_ch2,  //Lane1 column3 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col3_ch2,   //Lane1 column3 channel2 stream data
    output                              scan1_tvalid_col4_ch2,  //Lane1 column4 channel2 stream data valid
    input                               scan1_tready_col4_ch2,  //Lane1 column4 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col4_ch2,   //Lane1 column4 channel2 stream data
    output                              scan1_tvalid_col5_ch2,  //Lane1 column5 channel2 stream data valid
    input                               scan1_tready_col5_ch2,  //Lane1 column5 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col5_ch2,   //Lane1 column5 channel2 stream data
    output                              scan1_tvalid_col6_ch2,  //Lane1 column6 channel2 stream data valid
    input                               scan1_tready_col6_ch2,  //Lane1 column6 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col6_ch2,   //Lane1 column6 channel2 stream data
    output                              scan1_tvalid_col7_ch2,  //Lane1 column7 channel2 stream data valid
    input                               scan1_tready_col7_ch2,  //Lane1 column7 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col7_ch2,   //Lane1 column7 channel2 stream data
    output                              scan1_tlast_ch2,        //Lane1 channel2 stream data last
  `endif
  `ifdef COL_OUT_CHAN_3_EN
    output                              scan1_tvalid_col0_ch3,  //Lane1 column0 channel3 stream data valid
    input                               scan1_tready_col0_ch3,  //Lane1 column0 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col0_ch3,   //Lane1 column0 channel3 stream data
    output                              scan1_tvalid_col1_ch3,  //Lane1 column1 channel3 stream data valid
    input                               scan1_tready_col1_ch3,  //Lane1 column1 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col1_ch3,   //Lane1 column1 channel3 stream data
    output                              scan1_tvalid_col2_ch3,  //Lane1 column2 channel3 stream data valid
    input                               scan1_tready_col2_ch3,  //Lane1 column2 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col2_ch3,   //Lane1 column2 channel3 stream data
    output                              scan1_tvalid_col3_ch3,  //Lane1 column3 channel3 stream data valid
    input                               scan1_tready_col3_ch3,  //Lane1 column3 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col3_ch3,   //Lane1 column3 channel3 stream data
    output                              scan1_tvalid_col4_ch3,  //Lane1 column4 channel3 stream data valid
    input                               scan1_tready_col4_ch3,  //Lane1 column4 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col4_ch3,   //Lane1 column4 channel3 stream data
    output                              scan1_tvalid_col5_ch3,  //Lane1 column5 channel3 stream data valid
    input                               scan1_tready_col5_ch3,  //Lane1 column5 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col5_ch3,   //Lane1 column5 channel3 stream data
    output                              scan1_tvalid_col6_ch3,  //Lane1 column6 channel3 stream data valid
    input                               scan1_tready_col6_ch3,  //Lane1 column6 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col6_ch3,   //Lane1 column6 channel3 stream data
    output                              scan1_tvalid_col7_ch3,  //Lane1 column7 channel3 stream data valid
    input                               scan1_tready_col7_ch3,  //Lane1 column7 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    scan1_tdata_col7_ch3,   //Lane1 column7 channel3 stream data
    output                              scan1_tlast_ch3,        //Lane1 channel3 stream data last
  `endif
`endif
    //----- HLS stream master interface for config channel -----
    output                              cfg_tvalid,             //Config stream data valid
    input                               cfg_tready,             //Config stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    cfg_tdata,              //Config stream data
    output                              cfg_tlast               //Config stream data last
);
//------------------------------------------------------------------------------
// Internal signals
//------------------------------------------------------------------------------
//--- Config Lane ---
wire                                cfg_m_axi_arvalid;          
wire                                cfg_m_axi_arready;          
wire   [AXI_MM_ADDR_WIDTH-1 : 0]    cfg_m_axi_araddr;           
wire   [AXI_MM_ID_WIDTH-1 : 0]      cfg_m_axi_arid;             
wire   [7 : 0]                      cfg_m_axi_arlen;            
wire   [2 : 0]                      cfg_m_axi_arsize;           
wire   [1 : 0]                      cfg_m_axi_arburst;          
wire   [2 : 0]                      cfg_m_axi_arprot;           
wire                                cfg_m_axi_arlock;           
wire   [3 : 0]                      cfg_m_axi_arqos;            
wire   [3 : 0]                      cfg_m_axi_arcache;          
wire   [3 : 0]                      cfg_m_axi_arregion;         
wire   [AXI_MM_ARUSER_WIDTH-1 : 0]  cfg_m_axi_aruser;           
wire                                cfg_m_axi_rvalid;           
wire                                cfg_m_axi_rready;           
wire   [1 : 0]                      cfg_m_axi_rresp;            
wire   [AXI_MM_ID_WIDTH-1 : 0]      cfg_m_axi_rid;              
wire   [AXI_MM_DATA_WIDTH-1 : 0]    cfg_m_axi_rdata;            
wire                                cfg_m_axi_rlast;            
wire   [AXI_MM_RUSER_WIDTH-1 : 0]   cfg_m_axi_ruser;            
wire   [63: 0]                      cfg_buf_addr;           
wire   [31: 0]                      cfg_buf_size;           
wire   [31: 0]                      cfg_stream_timer;       
wire                                cfg_busy;               
wire                                cfg_buf_rd_err;         
wire                                cfg_st_timeout_err;     
wire                                engine_run;             
wire                                scan_run;                
//--- Scan Lane 0 ---
`ifdef COL_SCAN_LANE_0_EN
wire                                scan0_m_axi_arvalid;          
wire                                scan0_m_axi_arready;          
wire   [AXI_MM_ADDR_WIDTH-1 : 0]    scan0_m_axi_araddr;           
wire   [AXI_MM_ID_WIDTH-1 : 0]      scan0_m_axi_arid;             
wire   [7 : 0]                      scan0_m_axi_arlen;            
wire   [2 : 0]                      scan0_m_axi_arsize;           
wire   [1 : 0]                      scan0_m_axi_arburst;          
wire   [2 : 0]                      scan0_m_axi_arprot;           
wire                                scan0_m_axi_arlock;           
wire   [3 : 0]                      scan0_m_axi_arqos;            
wire   [3 : 0]                      scan0_m_axi_arcache;          
wire   [3 : 0]                      scan0_m_axi_arregion;         
wire   [AXI_MM_ARUSER_WIDTH-1 : 0]  scan0_m_axi_aruser;           
wire                                scan0_m_axi_rvalid;           
wire                                scan0_m_axi_rready;           
wire   [1 : 0]                      scan0_m_axi_rresp;            
wire   [AXI_MM_ID_WIDTH-1 : 0]      scan0_m_axi_rid;              
wire   [AXI_MM_DATA_WIDTH-1 : 0]    scan0_m_axi_rdata;            
wire                                scan0_m_axi_rlast;            
wire   [AXI_MM_RUSER_WIDTH-1 : 0]   scan0_m_axi_ruser;            
wire   [63: 0]                      scan0_tab0_pg_buf_addr;       
wire   [31: 0]                      scan0_tab0_pg_buf_size;       
wire   [63: 0]                      scan0_tab0_rel_attr_buf_addr; 
wire   [31: 0]                      scan0_tab0_rel_attr_buf_size; 
wire   [63: 0]                      scan0_tab0_attr_id_buf_addr;  
wire   [31: 0]                      scan0_tab0_attr_id_buf_size;  
wire                                scan0_tab1_en;                
wire   [63: 0]                      scan0_tab1_pg_buf_addr;       
wire   [31: 0]                      scan0_tab1_pg_buf_size;       
wire   [63: 0]                      scan0_tab1_rel_attr_buf_addr; 
wire   [31: 0]                      scan0_tab1_rel_attr_buf_size; 
wire   [63: 0]                      scan0_tab1_attr_id_buf_addr;  
wire   [31: 0]                      scan0_tab1_attr_id_buf_size;  
wire   [31: 0]                      scan0_stream_timer;      
wire                                scan0_busy;              
wire                                scan0_pg_buf_rd_err;          
wire                                scan0_rel_attr_buf_rd_err;    
wire                                scan0_attr_id_buf_rd_err;     
wire                                scan0_pg_data_rd_err;         
wire                                scan0_attr_num_err;           
wire                                scan0_line_end_err;           
wire                                scan0_toast_attr_err;         
wire                                scan0_col0_st_timeout_err;    
wire                                scan0_col1_st_timeout_err;    
wire                                scan0_col2_st_timeout_err;    
wire                                scan0_col3_st_timeout_err;    
wire                                scan0_col4_st_timeout_err;    
wire                                scan0_col5_st_timeout_err;    
wire                                scan0_col6_st_timeout_err;    
wire                                scan0_col7_st_timeout_err;    
`endif
//--- Scan Lane 1 ---
`ifdef COL_SCAN_LANE_1_EN
wire                                scan1_m_axi_arvalid;          
wire                                scan1_m_axi_arready;          
wire   [AXI_MM_ADDR_WIDTH-1 : 0]    scan1_m_axi_araddr;           
wire   [AXI_MM_ID_WIDTH-1 : 0]      scan1_m_axi_arid;             
wire   [7 : 0]                      scan1_m_axi_arlen;            
wire   [2 : 0]                      scan1_m_axi_arsize;           
wire   [1 : 0]                      scan1_m_axi_arburst;          
wire   [2 : 0]                      scan1_m_axi_arprot;           
wire                                scan1_m_axi_arlock;           
wire   [3 : 0]                      scan1_m_axi_arqos;            
wire   [3 : 0]                      scan1_m_axi_arcache;          
wire   [3 : 0]                      scan1_m_axi_arregion;         
wire   [AXI_MM_ARUSER_WIDTH-1 : 0]  scan1_m_axi_aruser;           
wire                                scan1_m_axi_rvalid;           
wire                                scan1_m_axi_rready;           
wire   [1 : 0]                      scan1_m_axi_rresp;            
wire   [AXI_MM_ID_WIDTH-1 : 0]      scan1_m_axi_rid;              
wire   [AXI_MM_DATA_WIDTH-1 : 0]    scan1_m_axi_rdata;            
wire                                scan1_m_axi_rlast;            
wire   [AXI_MM_RUSER_WIDTH-1 : 0]   scan1_m_axi_ruser;            
wire   [63: 0]                      scan1_tab0_pg_buf_addr;       
wire   [31: 0]                      scan1_tab0_pg_buf_size;       
wire   [63: 0]                      scan1_tab0_rel_attr_buf_addr; 
wire   [31: 0]                      scan1_tab0_rel_attr_buf_size; 
wire   [63: 0]                      scan1_tab0_attr_id_buf_addr;  
wire   [31: 0]                      scan1_tab0_attr_id_buf_size;  
wire                                scan1_tab1_en;                
wire   [63: 0]                      scan1_tab1_pg_buf_addr;       
wire   [31: 0]                      scan1_tab1_pg_buf_size;       
wire   [63: 0]                      scan1_tab1_rel_attr_buf_addr; 
wire   [31: 0]                      scan1_tab1_rel_attr_buf_size; 
wire   [63: 0]                      scan1_tab1_attr_id_buf_addr;  
wire   [31: 0]                      scan1_tab1_attr_id_buf_size;  
wire   [31: 0]                      scan1_stream_timer;      
wire                                scan1_busy;              
wire                                scan1_pg_buf_rd_err;          
wire                                scan1_rel_attr_buf_rd_err;    
wire                                scan1_attr_id_buf_rd_err;     
wire                                scan1_pg_data_rd_err;         
wire                                scan1_attr_num_err;           
wire                                scan1_line_end_err;           
wire                                scan1_toast_attr_err;         
wire                                scan1_col0_st_timeout_err;    
wire                                scan1_col1_st_timeout_err;    
wire                                scan1_col2_st_timeout_err;    
wire                                scan1_col3_st_timeout_err;    
wire                                scan1_col4_st_timeout_err;    
wire                                scan1_col5_st_timeout_err;    
wire                                scan1_col6_st_timeout_err;    
wire                                scan1_col7_st_timeout_err;    
`endif
//------------------------------------------------------------------------------
col_scan_cfg_lane #(
  .AXI_MM_ADDR_WIDTH   (AXI_MM_ADDR_WIDTH  ), 
  .AXI_MM_DATA_WIDTH   (AXI_MM_DATA_WIDTH  ), 
  .AXI_MM_ID_WIDTH     (AXI_MM_ID_WIDTH    ), 
  .AXI_MM_AWUSER_WIDTH (AXI_MM_AWUSER_WIDTH), 
  .AXI_MM_ARUSER_WIDTH (AXI_MM_ARUSER_WIDTH), 
  .AXI_MM_WUSER_WIDTH  (AXI_MM_WUSER_WIDTH ), 
  .AXI_MM_RUSER_WIDTH  (AXI_MM_RUSER_WIDTH ), 
  .AXI_MM_BUSER_WIDTH  (AXI_MM_BUSER_WIDTH ), 
  .HLS_ST_DATA_WIDTH   (HLS_ST_DATA_WIDTH  ) 
  )
  cfg_lane(
    .clk                   (clk                 ), 
    .rst_n                 (rst_n               ), 
    .m_axi_arvalid         (cfg_m_axi_arvalid   ), 
    .m_axi_arready         (cfg_m_axi_arready   ), 
    .m_axi_araddr          (cfg_m_axi_araddr    ), 
    .m_axi_arid            (cfg_m_axi_arid      ), 
    .m_axi_arlen           (cfg_m_axi_arlen     ), 
    .m_axi_arsize          (cfg_m_axi_arsize    ), 
    .m_axi_arburst         (cfg_m_axi_arburst   ), 
    .m_axi_arprot          (cfg_m_axi_arprot    ), 
    .m_axi_arlock          (cfg_m_axi_arlock    ), 
    .m_axi_arqos           (cfg_m_axi_arqos     ), 
    .m_axi_arcache         (cfg_m_axi_arcache   ), 
    .m_axi_arregion        (cfg_m_axi_arregion  ), 
    .m_axi_aruser          (cfg_m_axi_aruser    ), 
    .m_axi_rvalid          (cfg_m_axi_rvalid    ), 
    .m_axi_rready          (cfg_m_axi_rready    ), 
    .m_axi_rresp           (cfg_m_axi_rresp     ), 
    .m_axi_rid             (cfg_m_axi_rid       ), 
    .m_axi_rdata           (cfg_m_axi_rdata     ), 
    .m_axi_rlast           (cfg_m_axi_rlast     ), 
    .m_axi_ruser           (cfg_m_axi_ruser     ), 
    .m_st_tvalid           (cfg_tvalid          ), 
    .m_st_tready           (cfg_tready          ), 
    .m_st_tdata            (cfg_tdata           ), 
    .m_st_tlast            (cfg_tlast           ), 
    .cfg_buf_addr          (cfg_buf_addr        ), 
    .cfg_buf_size          (cfg_buf_size        ), 
    .cfg_stream_timer      (cfg_stream_timer    ), 
    .cfg_busy              (cfg_busy            ), 
    .cfg_buf_rd_err        (cfg_buf_rd_err      ), 
    .cfg_st_timeout_err    (cfg_st_timeout_err  ), 
    .engine_run            (engine_run          ), 
    .scan_run              (scan_run            )  
);

`ifdef COL_SCAN_LANE_0_EN
col_scan_lane #(
  .LANE_ID             (0                  ), 
  .AXI_MM_ADDR_WIDTH   (AXI_MM_ADDR_WIDTH  ), 
  .AXI_MM_DATA_WIDTH   (AXI_MM_DATA_WIDTH  ), 
  .AXI_MM_ID_WIDTH     (AXI_MM_ID_WIDTH    ), 
  .AXI_MM_AWUSER_WIDTH (AXI_MM_AWUSER_WIDTH), 
  .AXI_MM_ARUSER_WIDTH (AXI_MM_ARUSER_WIDTH), 
  .AXI_MM_WUSER_WIDTH  (AXI_MM_WUSER_WIDTH ), 
  .AXI_MM_RUSER_WIDTH  (AXI_MM_RUSER_WIDTH ), 
  .AXI_MM_BUSER_WIDTH  (AXI_MM_BUSER_WIDTH ), 
  .HLS_ST_DATA_WIDTH   (HLS_ST_DATA_WIDTH  ) 
  )
  scan_lane0(
    .clk                   (clk                   ), 
    .rst_n                 (rst_n                 ), 
    .m_axi_arvalid         (scan0_m_axi_arvalid   ), 
    .m_axi_arready         (scan0_m_axi_arready   ), 
    .m_axi_araddr          (scan0_m_axi_araddr    ), 
    .m_axi_arid            (scan0_m_axi_arid      ), 
    .m_axi_arlen           (scan0_m_axi_arlen     ), 
    .m_axi_arsize          (scan0_m_axi_arsize    ), 
    .m_axi_arburst         (scan0_m_axi_arburst   ), 
    .m_axi_arprot          (scan0_m_axi_arprot    ), 
    .m_axi_arlock          (scan0_m_axi_arlock    ), 
    .m_axi_arqos           (scan0_m_axi_arqos     ), 
    .m_axi_arcache         (scan0_m_axi_arcache   ), 
    .m_axi_arregion        (scan0_m_axi_arregion  ), 
    .m_axi_aruser          (scan0_m_axi_aruser    ), 
    .m_axi_rvalid          (scan0_m_axi_rvalid    ), 
    .m_axi_rready          (scan0_m_axi_rready    ), 
    .m_axi_rresp           (scan0_m_axi_rresp     ), 
    .m_axi_rid             (scan0_m_axi_rid       ), 
    .m_axi_rdata           (scan0_m_axi_rdata     ), 
    .m_axi_rlast           (scan0_m_axi_rlast     ), 
    .m_axi_ruser           (scan0_m_axi_ruser     ), 
  `ifdef COL_OUT_CHAN_0_EN 
    .tvalid_col0_ch0       (scan0_tvalid_col0_ch0 ), 
    .tready_col0_ch0       (scan0_tready_col0_ch0 ), 
    .tdata_col0_ch0        (scan0_tdata_col0_ch0  ), 
    .tvalid_col1_ch0       (scan0_tvalid_col1_ch0 ), 
    .tready_col1_ch0       (scan0_tready_col1_ch0 ), 
    .tdata_col1_ch0        (scan0_tdata_col1_ch0  ), 
    .tvalid_col2_ch0       (scan0_tvalid_col2_ch0 ), 
    .tready_col2_ch0       (scan0_tready_col2_ch0 ), 
    .tdata_col2_ch0        (scan0_tdata_col2_ch0  ), 
    .tvalid_col3_ch0       (scan0_tvalid_col3_ch0 ), 
    .tready_col3_ch0       (scan0_tready_col3_ch0 ), 
    .tdata_col3_ch0        (scan0_tdata_col3_ch0  ), 
    .tvalid_col4_ch0       (scan0_tvalid_col4_ch0 ), 
    .tready_col4_ch0       (scan0_tready_col4_ch0 ), 
    .tdata_col4_ch0        (scan0_tdata_col4_ch0  ), 
    .tvalid_col5_ch0       (scan0_tvalid_col5_ch0 ), 
    .tready_col5_ch0       (scan0_tready_col5_ch0 ), 
    .tdata_col5_ch0        (scan0_tdata_col5_ch0  ), 
    .tvalid_col6_ch0       (scan0_tvalid_col6_ch0 ), 
    .tready_col6_ch0       (scan0_tready_col6_ch0 ), 
    .tdata_col6_ch0        (scan0_tdata_col6_ch0  ), 
    .tvalid_col7_ch0       (scan0_tvalid_col7_ch0 ), 
    .tready_col7_ch0       (scan0_tready_col7_ch0 ), 
    .tdata_col7_ch0        (scan0_tdata_col7_ch0  ), 
    .tlast_ch0             (scan0_tlast_ch0       ), 
  `endif                   
  `ifdef COL_OUT_CHAN_1_EN 
    .tvalid_col0_ch1       (scan0_tvalid_col0_ch1 ), 
    .tready_col0_ch1       (scan0_tready_col0_ch1 ), 
    .tdata_col0_ch1        (scan0_tdata_col0_ch1  ), 
    .tvalid_col1_ch1       (scan0_tvalid_col1_ch1 ), 
    .tready_col1_ch1       (scan0_tready_col1_ch1 ), 
    .tdata_col1_ch1        (scan0_tdata_col1_ch1  ), 
    .tvalid_col2_ch1       (scan0_tvalid_col2_ch1 ), 
    .tready_col2_ch1       (scan0_tready_col2_ch1 ), 
    .tdata_col2_ch1        (scan0_tdata_col2_ch1  ), 
    .tvalid_col3_ch1       (scan0_tvalid_col3_ch1 ), 
    .tready_col3_ch1       (scan0_tready_col3_ch1 ), 
    .tdata_col3_ch1        (scan0_tdata_col3_ch1  ), 
    .tvalid_col4_ch1       (scan0_tvalid_col4_ch1 ), 
    .tready_col4_ch1       (scan0_tready_col4_ch1 ), 
    .tdata_col4_ch1        (scan0_tdata_col4_ch1  ), 
    .tvalid_col5_ch1       (scan0_tvalid_col5_ch1 ), 
    .tready_col5_ch1       (scan0_tready_col5_ch1 ), 
    .tdata_col5_ch1        (scan0_tdata_col5_ch1  ), 
    .tvalid_col6_ch1       (scan0_tvalid_col6_ch1 ), 
    .tready_col6_ch1       (scan0_tready_col6_ch1 ), 
    .tdata_col6_ch1        (scan0_tdata_col6_ch1  ), 
    .tvalid_col7_ch1       (scan0_tvalid_col7_ch1 ), 
    .tready_col7_ch1       (scan0_tready_col7_ch1 ), 
    .tdata_col7_ch1        (scan0_tdata_col7_ch1  ), 
    .tlast_ch1             (scan0_tlast_ch1       ), 
  `endif                   
  `ifdef COL_OUT_CHAN_2_EN 
    .tvalid_col0_ch2       (scan0_tvalid_col0_ch2 ), 
    .tready_col0_ch2       (scan0_tready_col0_ch2 ), 
    .tdata_col0_ch2        (scan0_tdata_col0_ch2  ), 
    .tvalid_col1_ch2       (scan0_tvalid_col1_ch2 ), 
    .tready_col1_ch2       (scan0_tready_col1_ch2 ), 
    .tdata_col1_ch2        (scan0_tdata_col1_ch2  ), 
    .tvalid_col2_ch2       (scan0_tvalid_col2_ch2 ), 
    .tready_col2_ch2       (scan0_tready_col2_ch2 ), 
    .tdata_col2_ch2        (scan0_tdata_col2_ch2  ), 
    .tvalid_col3_ch2       (scan0_tvalid_col3_ch2 ), 
    .tready_col3_ch2       (scan0_tready_col3_ch2 ), 
    .tdata_col3_ch2        (scan0_tdata_col3_ch2  ), 
    .tvalid_col4_ch2       (scan0_tvalid_col4_ch2 ), 
    .tready_col4_ch2       (scan0_tready_col4_ch2 ), 
    .tdata_col4_ch2        (scan0_tdata_col4_ch2  ), 
    .tvalid_col5_ch2       (scan0_tvalid_col5_ch2 ), 
    .tready_col5_ch2       (scan0_tready_col5_ch2 ), 
    .tdata_col5_ch2        (scan0_tdata_col5_ch2  ), 
    .tvalid_col6_ch2       (scan0_tvalid_col6_ch2 ), 
    .tready_col6_ch2       (scan0_tready_col6_ch2 ), 
    .tdata_col6_ch2        (scan0_tdata_col6_ch2  ), 
    .tvalid_col7_ch2       (scan0_tvalid_col7_ch2 ), 
    .tready_col7_ch2       (scan0_tready_col7_ch2 ), 
    .tdata_col7_ch2        (scan0_tdata_col7_ch2  ), 
    .tlast_ch2             (scan0_tlast_ch2       ), 
  `endif                  
  `ifdef COL_OUT_CHAN_3_EN 
    .tvalid_col0_ch3       (scan0_tvalid_col0_ch3 ), 
    .tready_col0_ch3       (scan0_tready_col0_ch3 ), 
    .tdata_col0_ch3        (scan0_tdata_col0_ch3  ), 
    .tvalid_col1_ch3       (scan0_tvalid_col1_ch3 ), 
    .tready_col1_ch3       (scan0_tready_col1_ch3 ), 
    .tdata_col1_ch3        (scan0_tdata_col1_ch3  ), 
    .tvalid_col2_ch3       (scan0_tvalid_col2_ch3 ), 
    .tready_col2_ch3       (scan0_tready_col2_ch3 ), 
    .tdata_col2_ch3        (scan0_tdata_col2_ch3  ), 
    .tvalid_col3_ch3       (scan0_tvalid_col3_ch3 ), 
    .tready_col3_ch3       (scan0_tready_col3_ch3 ), 
    .tdata_col3_ch3        (scan0_tdata_col3_ch3  ), 
    .tvalid_col4_ch3       (scan0_tvalid_col4_ch3 ), 
    .tready_col4_ch3       (scan0_tready_col4_ch3 ), 
    .tdata_col4_ch3        (scan0_tdata_col4_ch3  ), 
    .tvalid_col5_ch3       (scan0_tvalid_col5_ch3 ), 
    .tready_col5_ch3       (scan0_tready_col5_ch3 ), 
    .tdata_col5_ch3        (scan0_tdata_col5_ch3  ), 
    .tvalid_col6_ch3       (scan0_tvalid_col6_ch3 ), 
    .tready_col6_ch3       (scan0_tready_col6_ch3 ), 
    .tdata_col6_ch3        (scan0_tdata_col6_ch3  ), 
    .tvalid_col7_ch3       (scan0_tvalid_col7_ch3 ), 
    .tready_col7_ch3       (scan0_tready_col7_ch3 ), 
    .tdata_col7_ch3        (scan0_tdata_col7_ch3  ), 
    .tlast_ch3             (scan0_tlast_ch3       ), 
  `endif                    
    .tab0_pg_buf_addr      (scan0_tab0_pg_buf_addr      ), 
    .tab0_pg_buf_size      (scan0_tab0_pg_buf_size      ), 
    .tab0_rel_attr_buf_addr(scan0_tab0_rel_attr_buf_addr), 
    .tab0_rel_attr_buf_size(scan0_tab0_rel_attr_buf_size), 
    .tab0_attr_id_buf_addr (scan0_tab0_attr_id_buf_addr ), 
    .tab0_attr_id_buf_size (scan0_tab0_attr_id_buf_size ), 
    .tab1_en               (scan0_tab1_en               ), 
    .tab1_pg_buf_addr      (scan0_tab1_pg_buf_addr      ), 
    .tab1_pg_buf_size      (scan0_tab1_pg_buf_size      ), 
    .tab1_rel_attr_buf_addr(scan0_tab1_rel_attr_buf_addr), 
    .tab1_rel_attr_buf_size(scan0_tab1_rel_attr_buf_size), 
    .tab1_attr_id_buf_addr (scan0_tab1_attr_id_buf_addr ), 
    .tab1_attr_id_buf_size (scan0_tab1_attr_id_buf_size ), 
    .scan_stream_timer     (scan0_stream_timer          ), 
    .scan_busy             (scan0_busy                  ), 
    .pg_buf_rd_err         (scan0_pg_buf_rd_err         ), 
    .rel_attr_buf_rd_err   (scan0_rel_attr_buf_rd_err   ), 
    .attr_id_buf_rd_err    (scan0_attr_id_buf_rd_err    ), 
    .pg_data_rd_err        (scan0_pg_data_rd_err        ), 
    .attr_num_err          (scan0_attr_num_err          ), 
    .line_end_err          (scan0_line_end_err          ), 
    .toast_attr_err        (scan0_toast_attr_err        ), 
    .col0_st_timeout_err   (scan0_col0_st_timeout_err   ), 
    .col1_st_timeout_err   (scan0_col1_st_timeout_err   ), 
    .col2_st_timeout_err   (scan0_col2_st_timeout_err   ), 
    .col3_st_timeout_err   (scan0_col3_st_timeout_err   ), 
    .col4_st_timeout_err   (scan0_col4_st_timeout_err   ), 
    .col5_st_timeout_err   (scan0_col5_st_timeout_err   ), 
    .col6_st_timeout_err   (scan0_col6_st_timeout_err   ), 
    .col7_st_timeout_err   (scan0_col7_st_timeout_err   ), 
    .scan_run              (scan_run                    )  
);
`endif                    

`ifdef COL_SCAN_LANE_1_EN
col_scan_lane #(
  .LANE_ID             (1                  ), 
  .AXI_MM_ADDR_WIDTH   (AXI_MM_ADDR_WIDTH  ), 
  .AXI_MM_DATA_WIDTH   (AXI_MM_DATA_WIDTH  ), 
  .AXI_MM_ID_WIDTH     (AXI_MM_ID_WIDTH    ), 
  .AXI_MM_AWUSER_WIDTH (AXI_MM_AWUSER_WIDTH), 
  .AXI_MM_ARUSER_WIDTH (AXI_MM_ARUSER_WIDTH), 
  .AXI_MM_WUSER_WIDTH  (AXI_MM_WUSER_WIDTH ), 
  .AXI_MM_RUSER_WIDTH  (AXI_MM_RUSER_WIDTH ), 
  .AXI_MM_BUSER_WIDTH  (AXI_MM_BUSER_WIDTH ), 
  .HLS_ST_DATA_WIDTH   (HLS_ST_DATA_WIDTH  ) 
  )
  scan_lane1(
    .clk                   (clk                   ), 
    .rst_n                 (rst_n                 ), 
    .m_axi_arvalid         (scan1_m_axi_arvalid   ), 
    .m_axi_arready         (scan1_m_axi_arready   ), 
    .m_axi_araddr          (scan1_m_axi_araddr    ), 
    .m_axi_arid            (scan1_m_axi_arid      ), 
    .m_axi_arlen           (scan1_m_axi_arlen     ), 
    .m_axi_arsize          (scan1_m_axi_arsize    ), 
    .m_axi_arburst         (scan1_m_axi_arburst   ), 
    .m_axi_arprot          (scan1_m_axi_arprot    ), 
    .m_axi_arlock          (scan1_m_axi_arlock    ), 
    .m_axi_arqos           (scan1_m_axi_arqos     ), 
    .m_axi_arcache         (scan1_m_axi_arcache   ), 
    .m_axi_arregion        (scan1_m_axi_arregion  ), 
    .m_axi_aruser          (scan1_m_axi_aruser    ), 
    .m_axi_rvalid          (scan1_m_axi_rvalid    ), 
    .m_axi_rready          (scan1_m_axi_rready    ), 
    .m_axi_rresp           (scan1_m_axi_rresp     ), 
    .m_axi_rid             (scan1_m_axi_rid       ), 
    .m_axi_rdata           (scan1_m_axi_rdata     ), 
    .m_axi_rlast           (scan1_m_axi_rlast     ), 
    .m_axi_ruser           (scan1_m_axi_ruser     ), 
  `ifdef COL_OUT_CHAN_0_EN 
    .tvalid_col0_ch0       (scan1_tvalid_col0_ch0 ), 
    .tready_col0_ch0       (scan1_tready_col0_ch0 ), 
    .tdata_col0_ch0        (scan1_tdata_col0_ch0  ), 
    .tvalid_col1_ch0       (scan1_tvalid_col1_ch0 ), 
    .tready_col1_ch0       (scan1_tready_col1_ch0 ), 
    .tdata_col1_ch0        (scan1_tdata_col1_ch0  ), 
    .tvalid_col2_ch0       (scan1_tvalid_col2_ch0 ), 
    .tready_col2_ch0       (scan1_tready_col2_ch0 ), 
    .tdata_col2_ch0        (scan1_tdata_col2_ch0  ), 
    .tvalid_col3_ch0       (scan1_tvalid_col3_ch0 ), 
    .tready_col3_ch0       (scan1_tready_col3_ch0 ), 
    .tdata_col3_ch0        (scan1_tdata_col3_ch0  ), 
    .tvalid_col4_ch0       (scan1_tvalid_col4_ch0 ), 
    .tready_col4_ch0       (scan1_tready_col4_ch0 ), 
    .tdata_col4_ch0        (scan1_tdata_col4_ch0  ), 
    .tvalid_col5_ch0       (scan1_tvalid_col5_ch0 ), 
    .tready_col5_ch0       (scan1_tready_col5_ch0 ), 
    .tdata_col5_ch0        (scan1_tdata_col5_ch0  ), 
    .tvalid_col6_ch0       (scan1_tvalid_col6_ch0 ), 
    .tready_col6_ch0       (scan1_tready_col6_ch0 ), 
    .tdata_col6_ch0        (scan1_tdata_col6_ch0  ), 
    .tvalid_col7_ch0       (scan1_tvalid_col7_ch0 ), 
    .tready_col7_ch0       (scan1_tready_col7_ch0 ), 
    .tdata_col7_ch0        (scan1_tdata_col7_ch0  ), 
    .tlast_ch0             (scan1_tlast_ch0       ), 
  `endif                   
  `ifdef COL_OUT_CHAN_1_EN 
    .tvalid_col0_ch1       (scan1_tvalid_col0_ch1 ), 
    .tready_col0_ch1       (scan1_tready_col0_ch1 ), 
    .tdata_col0_ch1        (scan1_tdata_col0_ch1  ), 
    .tvalid_col1_ch1       (scan1_tvalid_col1_ch1 ), 
    .tready_col1_ch1       (scan1_tready_col1_ch1 ), 
    .tdata_col1_ch1        (scan1_tdata_col1_ch1  ), 
    .tvalid_col2_ch1       (scan1_tvalid_col2_ch1 ), 
    .tready_col2_ch1       (scan1_tready_col2_ch1 ), 
    .tdata_col2_ch1        (scan1_tdata_col2_ch1  ), 
    .tvalid_col3_ch1       (scan1_tvalid_col3_ch1 ), 
    .tready_col3_ch1       (scan1_tready_col3_ch1 ), 
    .tdata_col3_ch1        (scan1_tdata_col3_ch1  ), 
    .tvalid_col4_ch1       (scan1_tvalid_col4_ch1 ), 
    .tready_col4_ch1       (scan1_tready_col4_ch1 ), 
    .tdata_col4_ch1        (scan1_tdata_col4_ch1  ), 
    .tvalid_col5_ch1       (scan1_tvalid_col5_ch1 ), 
    .tready_col5_ch1       (scan1_tready_col5_ch1 ), 
    .tdata_col5_ch1        (scan1_tdata_col5_ch1  ), 
    .tvalid_col6_ch1       (scan1_tvalid_col6_ch1 ), 
    .tready_col6_ch1       (scan1_tready_col6_ch1 ), 
    .tdata_col6_ch1        (scan1_tdata_col6_ch1  ), 
    .tvalid_col7_ch1       (scan1_tvalid_col7_ch1 ), 
    .tready_col7_ch1       (scan1_tready_col7_ch1 ), 
    .tdata_col7_ch1        (scan1_tdata_col7_ch1  ), 
    .tlast_ch1             (scan1_tlast_ch1       ), 
  `endif                   
  `ifdef COL_OUT_CHAN_2_EN 
    .tvalid_col0_ch2       (scan1_tvalid_col0_ch2 ), 
    .tready_col0_ch2       (scan1_tready_col0_ch2 ), 
    .tdata_col0_ch2        (scan1_tdata_col0_ch2  ), 
    .tvalid_col1_ch2       (scan1_tvalid_col1_ch2 ), 
    .tready_col1_ch2       (scan1_tready_col1_ch2 ), 
    .tdata_col1_ch2        (scan1_tdata_col1_ch2  ), 
    .tvalid_col2_ch2       (scan1_tvalid_col2_ch2 ), 
    .tready_col2_ch2       (scan1_tready_col2_ch2 ), 
    .tdata_col2_ch2        (scan1_tdata_col2_ch2  ), 
    .tvalid_col3_ch2       (scan1_tvalid_col3_ch2 ), 
    .tready_col3_ch2       (scan1_tready_col3_ch2 ), 
    .tdata_col3_ch2        (scan1_tdata_col3_ch2  ), 
    .tvalid_col4_ch2       (scan1_tvalid_col4_ch2 ), 
    .tready_col4_ch2       (scan1_tready_col4_ch2 ), 
    .tdata_col4_ch2        (scan1_tdata_col4_ch2  ), 
    .tvalid_col5_ch2       (scan1_tvalid_col5_ch2 ), 
    .tready_col5_ch2       (scan1_tready_col5_ch2 ), 
    .tdata_col5_ch2        (scan1_tdata_col5_ch2  ), 
    .tvalid_col6_ch2       (scan1_tvalid_col6_ch2 ), 
    .tready_col6_ch2       (scan1_tready_col6_ch2 ), 
    .tdata_col6_ch2        (scan1_tdata_col6_ch2  ), 
    .tvalid_col7_ch2       (scan1_tvalid_col7_ch2 ), 
    .tready_col7_ch2       (scan1_tready_col7_ch2 ), 
    .tdata_col7_ch2        (scan1_tdata_col7_ch2  ), 
    .tlast_ch2             (scan1_tlast_ch2       ), 
  `endif                  
  `ifdef COL_OUT_CHAN_3_EN 
    .tvalid_col0_ch3       (scan1_tvalid_col0_ch3 ), 
    .tready_col0_ch3       (scan1_tready_col0_ch3 ), 
    .tdata_col0_ch3        (scan1_tdata_col0_ch3  ), 
    .tvalid_col1_ch3       (scan1_tvalid_col1_ch3 ), 
    .tready_col1_ch3       (scan1_tready_col1_ch3 ), 
    .tdata_col1_ch3        (scan1_tdata_col1_ch3  ), 
    .tvalid_col2_ch3       (scan1_tvalid_col2_ch3 ), 
    .tready_col2_ch3       (scan1_tready_col2_ch3 ), 
    .tdata_col2_ch3        (scan1_tdata_col2_ch3  ), 
    .tvalid_col3_ch3       (scan1_tvalid_col3_ch3 ), 
    .tready_col3_ch3       (scan1_tready_col3_ch3 ), 
    .tdata_col3_ch3        (scan1_tdata_col3_ch3  ), 
    .tvalid_col4_ch3       (scan1_tvalid_col4_ch3 ), 
    .tready_col4_ch3       (scan1_tready_col4_ch3 ), 
    .tdata_col4_ch3        (scan1_tdata_col4_ch3  ), 
    .tvalid_col5_ch3       (scan1_tvalid_col5_ch3 ), 
    .tready_col5_ch3       (scan1_tready_col5_ch3 ), 
    .tdata_col5_ch3        (scan1_tdata_col5_ch3  ), 
    .tvalid_col6_ch3       (scan1_tvalid_col6_ch3 ), 
    .tready_col6_ch3       (scan1_tready_col6_ch3 ), 
    .tdata_col6_ch3        (scan1_tdata_col6_ch3  ), 
    .tvalid_col7_ch3       (scan1_tvalid_col7_ch3 ), 
    .tready_col7_ch3       (scan1_tready_col7_ch3 ), 
    .tdata_col7_ch3        (scan1_tdata_col7_ch3  ), 
    .tlast_ch3             (scan1_tlast_ch3       ), 
  `endif                    
    .tab0_pg_buf_addr      (scan1_tab0_pg_buf_addr      ), 
    .tab0_pg_buf_size      (scan1_tab0_pg_buf_size      ), 
    .tab0_rel_attr_buf_addr(scan1_tab0_rel_attr_buf_addr), 
    .tab0_rel_attr_buf_size(scan1_tab0_rel_attr_buf_size), 
    .tab0_attr_id_buf_addr (scan1_tab0_attr_id_buf_addr ), 
    .tab0_attr_id_buf_size (scan1_tab0_attr_id_buf_size ), 
    .tab1_en               (scan1_tab1_en               ), 
    .tab1_pg_buf_addr      (scan1_tab1_pg_buf_addr      ), 
    .tab1_pg_buf_size      (scan1_tab1_pg_buf_size      ), 
    .tab1_rel_attr_buf_addr(scan1_tab1_rel_attr_buf_addr), 
    .tab1_rel_attr_buf_size(scan1_tab1_rel_attr_buf_size), 
    .tab1_attr_id_buf_addr (scan1_tab1_attr_id_buf_addr ), 
    .tab1_attr_id_buf_size (scan1_tab1_attr_id_buf_size ), 
    .scan_stream_timer     (scan1_stream_timer          ), 
    .scan_busy             (scan1_busy                  ), 
    .pg_buf_rd_err         (scan1_pg_buf_rd_err         ), 
    .rel_attr_buf_rd_err   (scan1_rel_attr_buf_rd_err   ), 
    .attr_id_buf_rd_err    (scan1_attr_id_buf_rd_err    ), 
    .pg_data_rd_err        (scan1_pg_data_rd_err        ), 
    .attr_num_err          (scan1_attr_num_err          ), 
    .line_end_err          (scan1_line_end_err          ), 
    .toast_attr_err        (scan1_toast_attr_err        ), 
    .col0_st_timeout_err   (scan1_col0_st_timeout_err   ), 
    .col1_st_timeout_err   (scan1_col1_st_timeout_err   ), 
    .col2_st_timeout_err   (scan1_col2_st_timeout_err   ), 
    .col3_st_timeout_err   (scan1_col3_st_timeout_err   ), 
    .col4_st_timeout_err   (scan1_col4_st_timeout_err   ), 
    .col5_st_timeout_err   (scan1_col5_st_timeout_err   ), 
    .col6_st_timeout_err   (scan1_col6_st_timeout_err   ), 
    .col7_st_timeout_err   (scan1_col7_st_timeout_err   ), 
    .scan_run              (scan_run                    )  
);
`endif                    

col_scan_registers #(
    .ADDR_WIDTH (AXI_LT_ADDR_WIDTH),
    .DATA_WIDTH (AXI_LT_DATA_WIDTH)
)
  registers(
    .clk                          (clk                          ), 
    .rst_n                        (rst_n                        ), 
    .s_axi_lite_arvalid           (s_axi_lite_arvalid           ), 
    .s_axi_lite_araddr            (s_axi_lite_araddr            ), 
    .s_axi_lite_arready           (s_axi_lite_arready           ), 
    .s_axi_lite_rvalid            (s_axi_lite_rvalid            ), 
    .s_axi_lite_rdata             (s_axi_lite_rdata             ), 
    .s_axi_lite_rresp             (s_axi_lite_rresp             ), 
    .s_axi_lite_rready            (s_axi_lite_rready            ), 
    .s_axi_lite_awvalid           (s_axi_lite_awvalid           ), 
    .s_axi_lite_awaddr            (s_axi_lite_awaddr            ), 
    .s_axi_lite_awready           (s_axi_lite_awready           ), 
    .s_axi_lite_wvalid            (s_axi_lite_wvalid            ), 
    .s_axi_lite_wdata             (s_axi_lite_wdata             ), 
    .s_axi_lite_wstrb             (s_axi_lite_wstrb             ), 
    .s_axi_lite_wready            (s_axi_lite_wready            ), 
    .s_axi_lite_bvalid            (s_axi_lite_bvalid            ), 
    .s_axi_lite_bresp             (s_axi_lite_bresp             ), 
    .s_axi_lite_bready            (s_axi_lite_bready            ), 
    .m_axi_lite_arvalid           (m_axi_lite_arvalid           ), 
    .m_axi_lite_araddr            (m_axi_lite_araddr            ), 
    .m_axi_lite_arready           (m_axi_lite_arready           ), 
    .m_axi_lite_rvalid            (m_axi_lite_rvalid            ), 
    .m_axi_lite_rdata             (m_axi_lite_rdata             ), 
    .m_axi_lite_rresp             (m_axi_lite_rresp             ), 
    .m_axi_lite_rready            (m_axi_lite_rready            ), 
    .m_axi_lite_awvalid           (m_axi_lite_awvalid           ), 
    .m_axi_lite_awaddr            (m_axi_lite_awaddr            ), 
    .m_axi_lite_awready           (m_axi_lite_awready           ), 
    .m_axi_lite_wvalid            (m_axi_lite_wvalid            ), 
    .m_axi_lite_wdata             (m_axi_lite_wdata             ), 
    .m_axi_lite_wstrb             (m_axi_lite_wstrb             ), 
    .m_axi_lite_wready            (m_axi_lite_wready            ), 
    .m_axi_lite_bvalid            (m_axi_lite_bvalid            ), 
    .m_axi_lite_bresp             (m_axi_lite_bresp             ), 
    .m_axi_lite_bready            (m_axi_lite_bready            ), 
  `ifdef COL_SCAN_LANE_0_EN       
    .scan0_tab0_pg_buf_addr       (scan0_tab0_pg_buf_addr       ), 
    .scan0_tab0_pg_buf_size       (scan0_tab0_pg_buf_size       ), 
    .scan0_tab0_rel_attr_buf_addr (scan0_tab0_rel_attr_buf_addr ), 
    .scan0_tab0_rel_attr_buf_size (scan0_tab0_rel_attr_buf_size ), 
    .scan0_tab0_attr_id_buf_addr  (scan0_tab0_attr_id_buf_addr  ), 
    .scan0_tab0_attr_id_buf_size  (scan0_tab0_attr_id_buf_size  ), 
    .scan0_tab1_en                (scan0_tab1_en                ), 
    .scan0_tab1_pg_buf_addr       (scan0_tab1_pg_buf_addr       ), 
    .scan0_tab1_pg_buf_size       (scan0_tab1_pg_buf_size       ), 
    .scan0_tab1_rel_attr_buf_addr (scan0_tab1_rel_attr_buf_addr ), 
    .scan0_tab1_rel_attr_buf_size (scan0_tab1_rel_attr_buf_size ), 
    .scan0_tab1_attr_id_buf_addr  (scan0_tab1_attr_id_buf_addr  ), 
    .scan0_tab1_attr_id_buf_size  (scan0_tab1_attr_id_buf_size  ), 
    .scan0_stream_timer           (scan0_stream_timer           ), 
    .scan0_busy                   (scan0_busy                   ), 
    .scan0_pg_buf_rd_err          (scan0_pg_buf_rd_err          ), 
    .scan0_rel_attr_buf_rd_err    (scan0_rel_attr_buf_rd_err    ), 
    .scan0_attr_id_buf_rd_err     (scan0_attr_id_buf_rd_err     ), 
    .scan0_pg_data_rd_err         (scan0_pg_data_rd_err         ), 
    .scan0_attr_num_err           (scan0_attr_num_err           ), 
    .scan0_line_end_err           (scan0_line_end_err           ), 
    .scan0_toast_attr_err         (scan0_toast_attr_err         ), 
    .scan0_col0_st_timeout_err    (scan0_col0_st_timeout_err    ), 
    .scan0_col1_st_timeout_err    (scan0_col1_st_timeout_err    ), 
    .scan0_col2_st_timeout_err    (scan0_col2_st_timeout_err    ), 
    .scan0_col3_st_timeout_err    (scan0_col3_st_timeout_err    ), 
    .scan0_col4_st_timeout_err    (scan0_col4_st_timeout_err    ), 
    .scan0_col5_st_timeout_err    (scan0_col5_st_timeout_err    ), 
    .scan0_col6_st_timeout_err    (scan0_col6_st_timeout_err    ), 
    .scan0_col7_st_timeout_err    (scan0_col7_st_timeout_err    ), 
  `endif                          
  `ifdef COL_SCAN_LANE_1_EN       
    .scan1_tab0_pg_buf_addr       (scan1_tab0_pg_buf_addr       ), 
    .scan1_tab0_pg_buf_size       (scan1_tab0_pg_buf_size       ), 
    .scan1_tab0_rel_attr_buf_addr (scan1_tab0_rel_attr_buf_addr ), 
    .scan1_tab0_rel_attr_buf_size (scan1_tab0_rel_attr_buf_size ), 
    .scan1_tab0_attr_id_buf_addr  (scan1_tab0_attr_id_buf_addr  ), 
    .scan1_tab0_attr_id_buf_size  (scan1_tab0_attr_id_buf_size  ), 
    .scan1_tab1_en                (scan1_tab1_en                ), 
    .scan1_tab1_pg_buf_addr       (scan1_tab1_pg_buf_addr       ), 
    .scan1_tab1_pg_buf_size       (scan1_tab1_pg_buf_size       ), 
    .scan1_tab1_rel_attr_buf_addr (scan1_tab1_rel_attr_buf_addr ), 
    .scan1_tab1_rel_attr_buf_size (scan1_tab1_rel_attr_buf_size ), 
    .scan1_tab1_attr_id_buf_addr  (scan1_tab1_attr_id_buf_addr  ), 
    .scan1_tab1_attr_id_buf_size  (scan1_tab1_attr_id_buf_size  ), 
    .scan1_stream_timer           (scan1_stream_timer           ), 
    .scan1_busy                   (scan1_busy                   ), 
    .scan1_pg_buf_rd_err          (scan1_pg_buf_rd_err          ), 
    .scan1_rel_attr_buf_rd_err    (scan1_rel_attr_buf_rd_err    ), 
    .scan1_attr_id_buf_rd_err     (scan1_attr_id_buf_rd_err     ), 
    .scan1_pg_data_rd_err         (scan1_pg_data_rd_err         ), 
    .scan1_attr_num_err           (scan1_attr_num_err           ), 
    .scan1_line_end_err           (scan1_line_end_err           ), 
    .scan1_toast_attr_err         (scan1_toast_attr_err         ), 
    .scan1_col0_st_timeout_err    (scan1_col0_st_timeout_err    ), 
    .scan1_col1_st_timeout_err    (scan1_col1_st_timeout_err    ), 
    .scan1_col2_st_timeout_err    (scan1_col2_st_timeout_err    ), 
    .scan1_col3_st_timeout_err    (scan1_col3_st_timeout_err    ), 
    .scan1_col4_st_timeout_err    (scan1_col4_st_timeout_err    ), 
    .scan1_col5_st_timeout_err    (scan1_col5_st_timeout_err    ), 
    .scan1_col6_st_timeout_err    (scan1_col6_st_timeout_err    ), 
    .scan1_col7_st_timeout_err    (scan1_col7_st_timeout_err    ), 
  `endif                          
    .cfg_buf_addr                 (cfg_buf_addr                 ), 
    .cfg_buf_size                 (cfg_buf_size                 ), 
    .cfg_stream_timer             (cfg_stream_timer             ), 
    .cfg_busy                     (cfg_busy                     ), 
    .cfg_buf_rd_err               (cfg_buf_rd_err               ), 
    .cfg_st_timeout_err           (cfg_st_timeout_err           ), 
    .engine_run                   (engine_run                   )         
);

// Xilinx IP: AXI Interconnect
col_scan_axi_interconnect axi_con(
    .aclk                    (clk                   ), 
    .aresetn                 (~rst_n                ),
    .s00_aclk                (clk                   ), 
    .s00_aresetn             (~rst_n                ), 
    .s00_axi_arvalid         (cfg_m_axi_arvalid     ), 
    .s00_axi_arready         (cfg_m_axi_arready     ), 
    .s00_axi_araddr          (cfg_m_axi_araddr      ), 
    .s00_axi_arid            (cfg_m_axi_arid        ), 
    .s00_axi_arlen           (cfg_m_axi_arlen       ), 
    .s00_axi_arsize          (cfg_m_axi_arsize      ), 
    .s00_axi_arburst         (cfg_m_axi_arburst     ), 
    .s00_axi_arprot          (cfg_m_axi_arprot      ), 
    .s00_axi_arlock          (cfg_m_axi_arlock      ), 
    .s00_axi_arqos           (cfg_m_axi_arqos       ), 
    .s00_axi_arcache         (cfg_m_axi_arcache     ), 
    .s00_axi_arregion        (cfg_m_axi_arregion    ), 
    .s00_axi_aruser          (cfg_m_axi_aruser      ), 
    .s00_axi_rvalid          (cfg_m_axi_rvalid      ), 
    .s00_axi_rready          (cfg_m_axi_rready      ), 
    .s00_axi_rresp           (cfg_m_axi_rresp       ), 
    .s00_axi_rid             (cfg_m_axi_rid         ), 
    .s00_axi_rdata           (cfg_m_axi_rdata       ), 
    .s00_axi_rlast           (cfg_m_axi_rlast       ), 
    .s00_axi_ruser           (cfg_m_axi_ruser       ), 
    .s00_axi_awvalid         (0),          
    .s00_axi_awready         ( ), 
    .s00_axi_awaddr          (0), 
    .s00_axi_awid            (0), 
    .s00_axi_awlen           (0), 
    .s00_axi_awsize          (0), 
    .s00_axi_awburst         (0), 
    .s00_axi_awprot          (0), 
    .s00_axi_awlock          (0), 
    .s00_axi_awqos           (0), 
    .s00_axi_awcache         (0), 
    .s00_axi_awregion        (0), 
    .s00_axi_awuser          (0), 
    .s00_axi_wvalid          (0), 
    .s00_axi_wready          ( ), 
    .s00_axi_wdata           (0), 
    .s00_axi_wstrb           (0), 
    .s00_axi_wlast           (0), 
    .s00_axi_wuser           (0), 
    .s00_axi_bvalid          ( ), 
    .s00_axi_bready          (0), 
    .s00_axi_bresp           ( ), 
    .s00_axi_bid             ( ), 
    .s00_axi_buser           ( ),   
  `ifdef COL_SCAN_LANE_0_EN       
    .s01_aclk                (clk                   ), 
    .s01_aresetn             (~rst_n                ), 
    .s01_axi_arvalid         (scan0_m_axi_arvalid   ), 
    .s01_axi_arready         (scan0_m_axi_arready   ), 
    .s01_axi_araddr          (scan0_m_axi_araddr    ), 
    .s01_axi_arid            (scan0_m_axi_arid      ), 
    .s01_axi_arlen           (scan0_m_axi_arlen     ), 
    .s01_axi_arsize          (scan0_m_axi_arsize    ), 
    .s01_axi_arburst         (scan0_m_axi_arburst   ), 
    .s01_axi_arprot          (scan0_m_axi_arprot    ), 
    .s01_axi_arlock          (scan0_m_axi_arlock    ), 
    .s01_axi_arqos           (scan0_m_axi_arqos     ), 
    .s01_axi_arcache         (scan0_m_axi_arcache   ), 
    .s01_axi_arregion        (scan0_m_axi_arregion  ), 
    .s01_axi_aruser          (scan0_m_axi_aruser    ), 
    .s01_axi_rvalid          (scan0_m_axi_rvalid    ), 
    .s01_axi_rready          (scan0_m_axi_rready    ), 
    .s01_axi_rresp           (scan0_m_axi_rresp     ), 
    .s01_axi_rid             (scan0_m_axi_rid       ), 
    .s01_axi_rdata           (scan0_m_axi_rdata     ), 
    .s01_axi_rlast           (scan0_m_axi_rlast     ), 
    .s01_axi_ruser           (scan0_m_axi_ruser     ), 
    .s01_axi_awvalid         (0),          
    .s01_axi_awready         ( ), 
    .s01_axi_awaddr          (0), 
    .s01_axi_awid            (0), 
    .s01_axi_awlen           (0), 
    .s01_axi_awsize          (0), 
    .s01_axi_awburst         (0), 
    .s01_axi_awprot          (0), 
    .s01_axi_awlock          (0), 
    .s01_axi_awqos           (0), 
    .s01_axi_awcache         (0), 
    .s01_axi_awregion        (0), 
    .s01_axi_awuser          (0), 
    .s01_axi_wvalid          (0), 
    .s01_axi_wready          ( ), 
    .s01_axi_wdata           (0), 
    .s01_axi_wstrb           (0), 
    .s01_axi_wlast           (0), 
    .s01_axi_wuser           (0), 
    .s01_axi_bvalid          ( ), 
    .s01_axi_bready          (0), 
    .s01_axi_bresp           ( ), 
    .s01_axi_bid             ( ), 
    .s01_axi_buser           ( ),  
  `endif                          
  `ifdef COL_SCAN_LANE_1_EN       
    .s02_aclk                (clk                   ), 
    .s02_aresetn             (~rst_n                ), 
    .s02_axi_arvalid         (scan1_m_axi_arvalid   ), 
    .s02_axi_arready         (scan1_m_axi_arready   ), 
    .s02_axi_araddr          (scan1_m_axi_araddr    ), 
    .s02_axi_arid            (scan1_m_axi_arid      ), 
    .s02_axi_arlen           (scan1_m_axi_arlen     ), 
    .s02_axi_arsize          (scan1_m_axi_arsize    ), 
    .s02_axi_arburst         (scan1_m_axi_arburst   ), 
    .s02_axi_arprot          (scan1_m_axi_arprot    ), 
    .s02_axi_arlock          (scan1_m_axi_arlock    ), 
    .s02_axi_arqos           (scan1_m_axi_arqos     ), 
    .s02_axi_arcache         (scan1_m_axi_arcache   ), 
    .s02_axi_arregion        (scan1_m_axi_arregion  ), 
    .s02_axi_aruser          (scan1_m_axi_aruser    ), 
    .s02_axi_rvalid          (scan1_m_axi_rvalid    ), 
    .s02_axi_rready          (scan1_m_axi_rready    ), 
    .s02_axi_rresp           (scan1_m_axi_rresp     ), 
    .s02_axi_rid             (scan1_m_axi_rid       ), 
    .s02_axi_rdata           (scan1_m_axi_rdata     ), 
    .s02_axi_rlast           (scan1_m_axi_rlast     ), 
    .s02_axi_ruser           (scan1_m_axi_ruser     ), 
    .s02_axi_awvalid         (0),          
    .s02_axi_awready         ( ), 
    .s02_axi_awaddr          (0), 
    .s02_axi_awid            (0), 
    .s02_axi_awlen           (0), 
    .s02_axi_awsize          (0), 
    .s02_axi_awburst         (0), 
    .s02_axi_awprot          (0), 
    .s02_axi_awlock          (0), 
    .s02_axi_awqos           (0), 
    .s02_axi_awcache         (0), 
    .s02_axi_awregion        (0), 
    .s02_axi_awuser          (0), 
    .s02_axi_wvalid          (0), 
    .s02_axi_wready          ( ), 
    .s02_axi_wdata           (0), 
    .s02_axi_wstrb           (0), 
    .s02_axi_wlast           (0), 
    .s02_axi_wuser           (0), 
    .s02_axi_bvalid          ( ), 
    .s02_axi_bready          (0), 
    .s02_axi_bresp           ( ), 
    .s02_axi_bid             ( ), 
    .s02_axi_buser           ( ),  
  `endif                          
    .m00_aclk                (clk                   ), 
    .m00_aresetn             (~rst_n                ), 
    .m00_axi_arvalid         (m_axi_arvalid         ), 
    .m00_axi_arready         (m_axi_arready         ), 
    .m00_axi_araddr          (m_axi_araddr          ), 
    .m00_axi_arid            (m_axi_arid            ), 
    .m00_axi_arlen           (m_axi_arlen           ), 
    .m00_axi_arsize          (m_axi_arsize          ), 
    .m00_axi_arburst         (m_axi_arburst         ), 
    .m00_axi_arprot          (m_axi_arprot          ), 
    .m00_axi_arlock          (m_axi_arlock          ), 
    .m00_axi_arqos           (m_axi_arqos           ), 
    .m00_axi_arcache         (m_axi_arcache         ), 
    .m00_axi_arregion        (m_axi_arregion        ), 
    .m00_axi_aruser          (m_axi_aruser          ), 
    .m00_axi_rvalid          (m_axi_rvalid          ), 
    .m00_axi_rready          (m_axi_rready          ), 
    .m00_axi_rresp           (m_axi_rresp           ), 
    .m00_axi_rid             (m_axi_rid             ), 
    .m00_axi_rdata           (m_axi_rdata           ), 
    .m00_axi_rlast           (m_axi_rlast           ), 
    .m00_axi_ruser           (m_axi_ruser           ), 
    .m00_axi_awvalid         (m_axi_awvalid         ),          
    .m00_axi_awready         (m_axi_awready         ), 
    .m00_axi_awaddr          (m_axi_awaddr          ), 
    .m00_axi_awid            (m_axi_awid            ), 
    .m00_axi_awlen           (m_axi_awlen           ), 
    .m00_axi_awsize          (m_axi_awsize          ), 
    .m00_axi_awburst         (m_axi_awburst         ), 
    .m00_axi_awprot          (m_axi_awprot          ), 
    .m00_axi_awlock          (m_axi_awlock          ), 
    .m00_axi_awqos           (m_axi_awqos           ), 
    .m00_axi_awcache         (m_axi_awcache         ), 
    .m00_axi_awregion        (m_axi_awregion        ), 
    .m00_axi_awuser          (m_axi_awuser          ), 
    .m00_axi_wvalid          (m_axi_wvalid          ), 
    .m00_axi_wready          (m_axi_wready          ), 
    .m00_axi_wdata           (m_axi_wdata           ), 
    .m00_axi_wstrb           (m_axi_wstrb           ), 
    .m00_axi_wlast           (m_axi_wlast           ), 
    .m00_axi_wuser           (m_axi_wuser           ), 
    .m00_axi_bvalid          (m_axi_bvalid          ), 
    .m00_axi_bready          (m_axi_bready          ), 
    .m00_axi_bresp           (m_axi_bresp           ), 
    .m00_axi_bid             (m_axi_bid             ), 
    .m00_axi_buser           (m_axi_buser           ) 
);

endmodule

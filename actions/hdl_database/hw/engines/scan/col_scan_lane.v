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

module col_scan_lane #(
    parameter LANE_ID               = 0,
    parameter AXI_MM_ADDR_WIDTH     = 64,
    parameter AXI_MM_DATA_WIDTH     = 1024,
    parameter AXI_MM_ID_WIDTH       = 5,
    parameter AXI_MM_AWUSER_WIDTH   = 9,
    parameter AXI_MM_ARUSER_WIDTH   = 9,
    parameter AXI_MM_WUSER_WIDTH    = 1,
    parameter AXI_MM_RUSER_WIDTH    = 1,
    parameter AXI_MM_BUSER_WIDTH    = 1,
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
    //----- HLS stream master interface -----
  `ifdef COL_OUT_CHAN_0_EN
    output                              tvalid_col0_ch0,        //column0 channel0 stream data valid
    input                               tready_col0_ch0,        //column0 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col0_ch0,         //column0 channel0 stream data
    output                              tvalid_col1_ch0,        //column1 channel0 stream data valid
    input                               tready_col1_ch0,        //column1 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col1_ch0,         //column1 channel0 stream data
    output                              tvalid_col2_ch0,        //column2 channel0 stream data valid
    input                               tready_col2_ch0,        //column2 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col2_ch0,         //column2 channel0 stream data
    output                              tvalid_col3_ch0,        //column3 channel0 stream data valid
    input                               tready_col3_ch0,        //column3 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col3_ch0,         //column3 channel0 stream data
    output                              tvalid_col4_ch0,        //column4 channel0 stream data valid
    input                               tready_col4_ch0,        //column4 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col4_ch0,         //column4 channel0 stream data
    output                              tvalid_col5_ch0,        //column5 channel0 stream data valid
    input                               tready_col5_ch0,        //column5 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col5_ch0,         //column5 channel0 stream data
    output                              tvalid_col6_ch0,        //column6 channel0 stream data valid
    input                               tready_col6_ch0,        //column6 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col6_ch0,         //column6 channel0 stream data
    output                              tvalid_col7_ch0,        //column7 channel0 stream data valid
    input                               tready_col7_ch0,        //column7 channel0 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col7_ch0,         //column7 channel0 stream data
    output                              tlast_ch0,              //channel0 stream data last
  `endif
  `ifdef COL_OUT_CHAN_1_EN
    output                              tvalid_col0_ch1,        //column0 channel1 stream data valid
    input                               tready_col0_ch1,        //column0 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col0_ch1,         //column0 channel1 stream data
    output                              tvalid_col1_ch1,        //column1 channel1 stream data valid
    input                               tready_col1_ch1,        //column1 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col1_ch1,         //column1 channel1 stream data
    output                              tvalid_col2_ch1,        //column2 channel1 stream data valid
    input                               tready_col2_ch1,        //column2 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col2_ch1,         //column2 channel1 stream data
    output                              tvalid_col3_ch1,        //column3 channel1 stream data valid
    input                               tready_col3_ch1,        //column3 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col3_ch1,         //column3 channel1 stream data
    output                              tvalid_col4_ch1,        //column4 channel1 stream data valid
    input                               tready_col4_ch1,        //column4 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col4_ch1,         //column4 channel1 stream data
    output                              tvalid_col5_ch1,        //column5 channel1 stream data valid
    input                               tready_col5_ch1,        //column5 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col5_ch1,         //column5 channel1 stream data
    output                              tvalid_col6_ch1,        //column6 channel1 stream data valid
    input                               tready_col6_ch1,        //column6 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col6_ch1,         //column6 channel1 stream data
    output                              tvalid_col7_ch1,        //column7 channel1 stream data valid
    input                               tready_col7_ch1,        //column7 channel1 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col7_ch1,         //column7 channel1 stream data
    output                              tlast_ch1,              //channel1 stream data last
  `endif
  `ifdef COL_OUT_CHAN_2_EN
    output                              tvalid_col0_ch2,        //column0 channel2 stream data valid
    input                               tready_col0_ch2,        //column0 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col0_ch2,         //column0 channel2 stream data
    output                              tvalid_col1_ch2,        //column1 channel2 stream data valid
    input                               tready_col1_ch2,        //column1 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col1_ch2,         //column1 channel2 stream data
    output                              tvalid_col2_ch2,        //column2 channel2 stream data valid
    input                               tready_col2_ch2,        //column2 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col2_ch2,         //column2 channel2 stream data
    output                              tvalid_col3_ch2,        //column3 channel2 stream data valid
    input                               tready_col3_ch2,        //column3 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col3_ch2,         //column3 channel2 stream data
    output                              tvalid_col4_ch2,        //column4 channel2 stream data valid
    input                               tready_col4_ch2,        //column4 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col4_ch2,         //column4 channel2 stream data
    output                              tvalid_col5_ch2,        //column5 channel2 stream data valid
    input                               tready_col5_ch2,        //column5 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col5_ch2,         //column5 channel2 stream data
    output                              tvalid_col6_ch2,        //column6 channel2 stream data valid
    input                               tready_col6_ch2,        //column6 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col6_ch2,         //column6 channel2 stream data
    output                              tvalid_col7_ch2,        //column7 channel2 stream data valid
    input                               tready_col7_ch2,        //column7 channel2 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col7_ch2,         //column7 channel2 stream data
    output                              tlast_ch2,              //channel2 stream data last
  `endif
  `ifdef COL_OUT_CHAN_3_EN
    output                              tvalid_col0_ch3,        //column0 channel3 stream data valid
    input                               tready_col0_ch3,        //column0 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col0_ch3,         //column0 channel3 stream data
    output                              tvalid_col1_ch3,        //column1 channel3 stream data valid
    input                               tready_col1_ch3,        //column1 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col1_ch3,         //column1 channel3 stream data
    output                              tvalid_col2_ch3,        //column2 channel3 stream data valid
    input                               tready_col2_ch3,        //column2 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col2_ch3,         //column2 channel3 stream data
    output                              tvalid_col3_ch3,        //column3 channel3 stream data valid
    input                               tready_col3_ch3,        //column3 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col3_ch3,         //column3 channel3 stream data
    output                              tvalid_col4_ch3,        //column4 channel3 stream data valid
    input                               tready_col4_ch3,        //column4 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col4_ch3,         //column4 channel3 stream data
    output                              tvalid_col5_ch3,        //column5 channel3 stream data valid
    input                               tready_col5_ch3,        //column5 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col5_ch3,         //column5 channel3 stream data
    output                              tvalid_col6_ch3,        //column6 channel3 stream data valid
    input                               tready_col6_ch3,        //column6 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col6_ch3,         //column6 channel3 stream data
    output                              tvalid_col7_ch3,        //column7 channel3 stream data valid
    input                               tready_col7_ch3,        //column7 channel3 stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    tdata_col7_ch3,         //column7 channel3 stream data
    output                              tlast_ch3,              //channel3 stream data last
  `endif
    //----- Register interface -----
    input  [63: 0]                      tab0_pg_buf_addr,       //table0 page point buffer start addr
    input  [31: 0]                      tab0_pg_buf_size,       //table0 page point buffer size
    input  [63: 0]                      tab0_rel_attr_buf_addr, //table0 relation attribute buffer start addr
    input  [31: 0]                      tab0_rel_attr_buf_size, //table0 relation attribute buffer size
    input  [63: 0]                      tab0_attr_id_buf_addr,  //table0 attribute id buffer start addr
    input  [31: 0]                      tab0_attr_id_buf_size,  //table0 attribute id buffer size
    input                               tab1_en,                //table1 enable
    input  [63: 0]                      tab1_pg_buf_addr,       //table1 page point buffer start addr
    input  [31: 0]                      tab1_pg_buf_size,       //table1 page point buffer size
    input  [63: 0]                      tab1_rel_attr_buf_addr, //table1 relation attribute buffer start addr
    input  [31: 0]                      tab1_rel_attr_buf_size, //table1 relation attribute buffer size
    input  [63: 0]                      tab1_attr_id_buf_addr,  //table1 attribute id buffer start addr
    input  [31: 0]                      tab1_attr_id_buf_size,  //table1 attribute id buffer size
    input  [31: 0]                      scan_stream_timer,      //scan lane stream timeout timer
    output                              scan_busy,              //scan lane is busy
    output reg                          pg_buf_rd_err,          //page point buffer read error
    output reg                          rel_attr_buf_rd_err,    //relation attribute buffer read error
    output reg                          attr_id_buf_rd_err,     //attribute id buffer read error
    output reg                          pg_data_rd_err,         //page data read error
    output                              attr_num_err,           //attribute number error
    output                              line_end_err,           //unexpected line end error
    output                              toast_attr_err,         //unexpected TOAST attribute error
    output                              col0_st_timeout_err,    //column0 stream timeout error
    output                              col1_st_timeout_err,    //column1 stream timeout error
    output                              col2_st_timeout_err,    //column2 stream timeout error
    output                              col3_st_timeout_err,    //column3 stream timeout error
    output                              col4_st_timeout_err,    //column4 stream timeout error
    output                              col5_st_timeout_err,    //column5 stream timeout error
    output                              col6_st_timeout_err,    //column6 stream timeout error
    output                              col7_st_timeout_err,    //column7 stream timeout error
    //----- Cfg lane interface -----
    input                               scan_run                //Scan start to run
);
//------------------------------------------------------------------------------
// Local Parameters
//------------------------------------------------------------------------------
//--- Host Data params ---
localparam  PAGE_SIZE               = 8192;
localparam  ATTR_ID_WIDTH           = 32;
localparam  REL_ATTR_WIDTH          = 32;
localparam  PG_PTR_WIDTH            = 64;
localparam  MAX_REL_ATTR_NUM        = 64;
localparam  REL_ATTR_RAM_ADDR_WIDTH = `LOCAL_LOG2(MAX_REL_ATTR_NUM);
localparam  ATTR_ID_BYTE_WIDTH      = `BIT2BYTE_LOG(ATTR_ID_WIDTH);
localparam  REL_ATTR_BYTE_WIDTH     = `BIT2BYTE_LOG(REL_ATTR_WIDTH);
localparam  PG_PTR_BYTE_WIDTH       = `BIT2BYTE_LOG(PG_PTR_WIDTH);
localparam  AXI_DATA_BYTE           = AXI_MM_DATA_WIDTH >> 3;
localparam  AXI_DATA_BYTE_WIDTH     = `BIT2BYTE_LOG(AXI_MM_DATA_WIDTH);
localparam  ATTR_ID_AXI_ID          = `ATTR_ID_BUF_AXI_ID + (LANE_ID << 2);
localparam  REL_ATTR_AXI_ID         = `REL_ATTR_BUF_AXI_ID + (LANE_ID << 2);
localparam  PG_PTR_AXI_ID           = `PAGE_BUF_AXI_ID + (LANE_ID << 2);
localparam  PG_DATA_AXI_ID          = `PAGE_DATA_AXI_ID + (LANE_ID << 2);
localparam  PG_RAM_WADDR_WIDTH      = `LOCAL_LOG2(PAGE_SIZE >> AXI_DATA_BYTE_WIDTH);
localparam  PG_RAM_WR_NO_USE_WIDTH  = 11 - PG_RAM_WADDR_WIDTH;
//--- Page Data params ---
localparam  PG_PD_LOWER_RAM_ADDR    = 11'd3;
localparam  PG_HDR_LEN              = 16'd24;
localparam  PG_LP_START_RAM_ADDR    = 11'd6;
localparam  PG_INFOMASK2_RAM_OFF    = 11'd4;
localparam  PG_INFOMASK_RAM_OFF     = 11'd5;
localparam  PG_BITMAP_RAM_OFF       = 11'd6;
localparam  PG_NATTS_MASK           = 16'h07FF;
//--- Main FSM ---
localparam  IDLE         = 4'b0000,
            RD_ATTR_ID   = 4'b0001,    //issue axi cmd to read attr id buffer
            RD_REL_ATTR  = 4'b0010,    //issue axi cmd to read relation attr buffer
            RD_PG_PTR    = 4'b0011,    //issue axi cmd to read page pointer buffer
            WAIT_PG_PTR  = 4'b0100,    //wait page pointer available
            RD_PG_DATA   = 4'b0101,    //issue axi cmd to read page data
            WAIT_PG_DONE = 4'b0110,    //wait one page column scan done
            SCAN_DONE    = 4'b0111,    //column scan done for one relation
            RD_ERR       = 4'b1000;    //axi read data error
//--- Scan FSM ---
localparam  RD_PG_HDR    = 4'b0000,    //read page header for pd_lower
            RD_LINE_PTR  = 4'b0001,    //read a line pointer
            RD_LINE_HDR1 = 4'b0010,    //read line header for infomask2
            RD_LINE_HDR2 = 4'b0011,    //read line header for infomask and t_hoff
            RD_LINE_HDR3 = 4'b0100,    //read line header for t_bits
            ATTR_SCAN    = 4'b0101,    //scan one attribute
            DO_VARLEN    = 4'b0110,    //get variable length attr length
            DO_CSTRING   = 4'b0111,    //handle cstring attr
            PRE_OUT      = 4'b1000,    //attr data output prepare
            ATTR_OUT     = 4'b1001,    //attr data output
            ATTR_NUM_ERR = 4'b1010,    //attr num exceed error
            LINE_END_ERR = 4'b1011,    //unexpected line end error
            TOAST_ERR    = 4'b1100,    //unsupported TOAST attr error
            STREAM_ERR   = 4'b1101;    //stream timeout error

//------------------------------------------------------------------------------
// Internal signals
//------------------------------------------------------------------------------
wire                                        fifo_rst;                           //FIFO reset, active high
//--- Main FSM ---
reg     [3  : 0]                            fsm_cur_state;                      //FSM current state
reg     [3  : 0]                            fsm_nxt_state;                      //FSM next state
wire                                        fsm_state_idle;                     //FSM state IDLE
wire                                        fsm_state_rd_attr_id;               //FSM state RD_ATTR_ID
wire                                        fsm_state_rd_rel_attr;              //FSM state RD_REL_ATTR
wire                                        fsm_state_wait_pg_ptr;              //FSM state WAIT_PG_PTR
wire                                        fsm_state_rd_pg_ptr;                //FSM state RD_PG_PTR
wire                                        fsm_state_rd_pg_data;               //FSM state RD_PG_DATA
wire                                        fsm_state_wait_pg_done;             //FSM state WAIT_PG_DONE
wire                                        fsm_state_scan_done;                //FSM state SCAN_DONE
wire                                        fsm_state_rd_err;                   //FSM state RD_ERR
wire                                        rd_attr_id_done;                    //attr id buffer AXI read cmd issue done
wire                                        rd_rel_attr_done;                   //relation attr buffer AXI read cmd issue done
wire                                        rd_pg_ptr_done;                     //page pointer buffer AXI read cmd issue done
wire                                        rd_pg_data_done;                    //page data AXI read cmd issue done
reg                                         is_rel_first_pg_rd;                 //first time read page for one relation
reg                                         table0_done;                        //table0 all pages column scan done 
reg                                         table1_done;                        //table1 all pages column scan done 
//--- Attr id buffer AXI read ---
wire    [63 : 0]                            tab0_attr_id_buf_end_addr;          //table0 attr id buffer end address
wire    [63 : 0]                            tab0_attr_id_buf_start_align_addr;  //table0 attr id buffer aligned start address
wire    [63 : 0]                            tab0_attr_id_buf_end_align_addr;    //table0 attr id buffer aligned end address
wire    [63 : 0]                            tab1_attr_id_buf_end_addr;          //table1 attr id buffer end address
wire    [63 : 0]                            tab1_attr_id_buf_start_align_addr;  //table1 attr id buffer aligned start address
wire    [63 : 0]                            tab1_attr_id_buf_end_align_addr;    //table1 attr id buffer aligned end address
wire    [63 : 0]                            attr_id_buf_addr;                   //attr id buffer start address
wire    [63 : 0]                            attr_id_buf_start_align_addr;       //attr id buffer aligned start address
wire    [63 : 0]                            attr_id_buf_end_align_addr;         //attr id buffer aligned end address
wire    [31 : 0]                            attr_id_buf_size;                   //attr id buffer size
reg     [63 : 0]                            attr_id_buf_cur_axi_start_addr;     //attr id buffer current axi read start address
wire    [63 : 0]                            attr_id_buf_cur_axi_end_addr;       //attr id buffer current axi read end address
wire    [7  : 0]                            attr_id_buf_cur_axi_length;         //attr id buffer current axi read length
wire    [63 : 0]                            attr_id_buf_nxt_axi_4k_addr;        //attr id buffer next axi read 4KB boundary address
wire                                        attr_id_buf_axi_last_cmd;           //attr id buffer last axi read command
//--- Relation attr buffer AXI read ---
wire    [63 : 0]                            tab0_rel_attr_buf_end_addr;         //table0 relation attr buffer end address
wire    [63 : 0]                            tab0_rel_attr_buf_start_align_addr; //table0 relation attr buffer aligned start address
wire    [63 : 0]                            tab0_rel_attr_buf_end_align_addr;   //table0 relation attr buffer aligned end address
wire    [63 : 0]                            tab1_rel_attr_buf_end_addr;         //table1 relation attr buffer end address
wire    [63 : 0]                            tab1_rel_attr_buf_start_align_addr; //table1 relation attr buffer aligned start address
wire    [63 : 0]                            tab1_rel_attr_buf_end_align_addr;   //table1 relation attr buffer aligned end address
wire    [63 : 0]                            rel_attr_buf_addr;                  //relation attr buffer start address
wire    [63 : 0]                            rel_attr_buf_start_align_addr;      //relation attr buffer aligned start address
wire    [63 : 0]                            rel_attr_buf_end_align_addr;        //relation attr buffer aligned end address
wire    [31 : 0]                            rel_attr_buf_size;                  //relation attr buffer size
reg     [63 : 0]                            rel_attr_buf_cur_axi_start_addr;    //relation attr buffer current axi read start address
wire    [63 : 0]                            rel_attr_buf_cur_axi_end_addr;      //relation attr buffer current axi read end address
wire    [7  : 0]                            rel_attr_buf_cur_axi_length;        //relation attr buffer current axi read length
wire    [63 : 0]                            rel_attr_buf_nxt_axi_4k_addr;       //relation attr buffer next axi read 4KB boundary address
wire                                        rel_attr_buf_axi_last_cmd;          //relation attr buffer last axi read command
//--- Page pointer buffer AXI read ---
wire    [63 : 0]                            tab0_pg_buf_end_addr;               //table0 page buffer end address
wire    [63 : 0]                            tab0_pg_buf_start_align_addr;       //table0 page buffer aligned start address
wire    [63 : 0]                            tab0_pg_buf_end_align_addr;         //table0 page buffer aligned end address
wire    [63 : 0]                            tab1_pg_buf_end_addr;               //table1 page buffer end address
wire    [63 : 0]                            tab1_pg_buf_start_align_addr;       //table1 page buffer aligned start address
wire    [63 : 0]                            tab1_pg_buf_end_align_addr;         //table1 page buffer aligned end address
wire    [63 : 0]                            pg_buf_addr;                        //page buffer start address
wire    [63 : 0]                            pg_buf_start_align_addr;            //page buffer aligned start address
wire    [63 : 0]                            pg_buf_end_align_addr;              //page buffer aligned end address
wire    [31 : 0]                            pg_buf_size;                        //page buffer size
reg     [63 : 0]                            pg_buf_cur_axi_start_addr;          //page buffer current axi read start address
wire    [63 : 0]                            pg_buf_cur_axi_end_addr;            //page buffer current axi read end address
wire    [7  : 0]                            pg_buf_cur_axi_length;              //page buffer current axi read length
wire                                        pg_buf_axi_last_cmd;                //page buffer last axi read command
wire                                        pg_buf_axi_last_cmd_done;           //page buffer last axi read command issue done
reg                                         pg_buf_axi_last_cmd_done_l;         //latch of page buffer last axi read command issue done
//--- Page data AXI read ---
wire    [63 : 0]                            pg_data_end_addr;                   //page data end address
wire    [63 : 0]                            pg_data_start_align_addr;           //page data aligned start address
wire    [63 : 0]                            pg_data_end_align_addr;             //page data aligned end address
reg     [63 : 0]                            pg_data_cur_axi_start_addr;         //page data current axi read start address
wire    [63 : 0]                            pg_data_cur_axi_end_addr;           //page data current axi read end address
wire    [7  : 0]                            pg_data_cur_axi_length;             //page data current axi read length
wire                                        pg_data_axi_last_cmd;               //page data last axi read command
wire                                        cur_pg_ptr_valid;                   //current page pointer is valid
wire    [63 : 0]                            cur_pg_ptr;                         //current page pointer
//--- AXI read data ---
wire    [AXI_MM_DATA_WIDTH-1 : 0]           axi_rdata_fifo_din;                 //AXI read data FIFO in
wire                                        axi_rdata_fifo_wr_en;               //AXI read data FIFO write enable
wire                                        axi_rdata_fifo_rd_en;               //AXI read data FIFO read enable
wire                                        axi_rdata_fifo_valid;               //AXI read data FIFO out valid
wire    [AXI_MM_DATA_WIDTH-1 : 0]           axi_rdata_fifo_dout;                //AXI read data FIFO out
wire                                        axi_rdata_fifo_full;                //AXI read data FIFO full
wire                                        axi_rdata_fifo_empty;               //AXI read data FIFO empty
wire    [AXI_MM_ID_WIDTH-1 : 0]             axi_rid_fifo_din;                   //AXI rid FIFO in
wire    [AXI_MM_ID_WIDTH-1 : 0]             axi_rid_fifo_dout;                  //AXI rid FIFO out
wire                                        axi_rdata_err;                      //AXI read data error
//--- Attr id AXI read data ---
wire                                        is_attr_id_axi_data;                //cuurent AXI read data is attr id
wire                                        attr_id_axi_rdata_fifo_rd_en;       //AXI read data FIFO read enable by attr id
wire                                        is_wr_last_attr_id;                 //write last attr id item
wire    [31 : 0]                            num_of_attr_id;                     //total number of attr id items
reg     [11 : 0]                            cur_axi2attr_id_lsb;                //current lsb on axi read data to extract attr id
wire    [11 : 0]                            nxt_axi2attr_id_lsb;                //next lsb on axi read data to extract attr id
wire    [3  : 0]                            attr_id_ram_addr;                   //attr id RAM address
reg     [3  : 0]                            attr_id_ram_waddr;                  //attr id RAM write address
wire    [3  : 0]                            attr_id_ram_raddr;                  //attr id RAM read address
wire    [ATTR_ID_WIDTH-1 : 0]               attr_id_ram_din;                    //attr id RAM data in
wire    [ATTR_ID_WIDTH-1 : 0]               attr_id_ram_dout;                   //attr id RAM data out
wire                                        attr_id_ram_we;                     //attr id RAM write enable
//--- Relation attr AXI read data ---
wire                                        is_rel_attr_axi_data;               //cuurent AXI read data is relation attr
wire                                        rel_attr_axi_rdata_fifo_rd_en;      //AXI read data FIFO read enable by relation attr
wire                                        is_last_rel_attr;                   //last relation attr item
wire    [31 : 0]                            num_of_rel_attr;                    //total number of relation attr items
reg     [11 : 0]                            cur_axi2rel_attr_lsb;               //current lsb on axi read data to extract relation attr
wire    [11 : 0]                            nxt_axi2rel_attr_lsb;               //next lsb on axi read data to extract relation attr
wire    [REL_ATTR_RAM_ADDR_WIDTH-1  : 0]    rel_attr_ram_addr;                  //relation attr RAM address
reg     [REL_ATTR_RAM_ADDR_WIDTH-1  : 0]    rel_attr_ram_waddr;                 //relation attr RAM write address
wire    [REL_ATTR_RAM_ADDR_WIDTH-1  : 0]    rel_attr_ram_raddr;                 //relation attr RAM read address
wire    [REL_ATTR_WIDTH-1 : 0]              rel_attr_ram_din;                   //relation attr RAM data in
wire    [REL_ATTR_WIDTH-1 : 0]              rel_attr_ram_dout;                  //relation attr RAM data out
wire                                        rel_attr_ram_we;                    //relation attr RAM write enable
//--- Page pointer AXI read data ---
wire                                        is_pg_ptr_axi_data;                 //cuurent AXI read data is page pointer
wire                                        pg_ptr_axi_rdata_fifo_rd_en;        //AXI read data FIFO read enable by page pointer
reg     [31 : 0]                            pg_ptr_wr_cnt;                      //page pointer write counter
wire                                        is_last_wr_pg_ptr;                  //last page pointer item write
wire    [31 : 0]                            num_of_pg_ptr;                      //total number of page pointer items
reg     [11 : 0]                            cur_axi2pg_ptr_lsb;                 //current lsb on axi read data to extract page pointer
wire    [11 : 0]                            nxt_axi2pg_ptr_lsb;                 //next lsb on axi read data to extract page pointer
wire    [PG_PTR_WIDTH-1 : 0]                pg_ptr_fifo_din;                    //page pionter FIFO in
wire                                        pg_ptr_fifo_wr_en;                  //page pionter FIFO write enable
wire                                        pg_ptr_fifo_rd_en;                  //page pionter FIFO read enable
wire                                        pg_ptr_fifo_valid;                  //page pionter FIFO out valid
wire    [PG_PTR_WIDTH-1 : 0]                pg_ptr_fifo_dout;                   //page pionter FIFO out
wire                                        pg_ptr_fifo_full;                   //page pionter FIFO full
wire                                        pg_ptr_fifo_empty;                  //page pionter FIFO empty
//--- Page data AXI read data ---
wire                                        is_pg_data_axi_data;                //cuurent AXI read data is page data
wire                                        pg_data_axi_rdata_fifo_rd_en;       //AXI read data FIFO read enable by page data
wire                                        is_last_pg_wr_data;                 //last page write data of one page
reg                                         is_wr_pg_data_ram0;                 //write page data into RAM0 or RAM1
wire                                        pg_data_ram_we;                     //page data RAM write enable
reg     [PG_RAM_WADDR_WIDTH-1 : 0]          pg_data_ram_waddr;                  //page data RAM write address
wire    [10 : 0]                            pg_data_ram_raddr;                  //page data RAM read address
wire    [31 : 0]                            pg_data_ram_dout;                   //page data RAM data out
wire    [10 : 0]                            pg_data_ram0_raddr;                 //page data RAM0 read address
wire    [10 : 0]                            pg_data_ram0_addr;                  //page data RAM0 address
wire                                        pg_data_ram0_we;                    //page data RAM0 write enable
wire    [AXI_MM_ID_WIDTH-1 : 0]             pg_data_ram0_din;                   //page data RAM0 data in
wire    [31 : 0]                            pg_data_ram0_dout;                  //page data RAM0 data out
reg                                         pg_data_ram0_full;                  //page data RAM0 data full
wire    [10 : 0]                            pg_data_ram1_raddr;                 //page data RAM1 read address
wire    [10 : 0]                            pg_data_ram1_addr;                  //page data RAM1 address
wire                                        pg_data_ram1_we;                    //page data RAM1 write enable
wire    [AXI_MM_ID_WIDTH-1 : 0]             pg_data_ram1_din;                   //page data RAM1 data in
wire    [31 : 0]                            pg_data_ram1_dout;                  //page data RAM1 data out
reg                                         pg_data_ram1_full;                  //page data RAM1 data full
//--- Scan FSM ---
reg     [3  : 0]                            scan_fsm_cur_state;                 //Scan FSM current state
reg     [3  : 0]                            scan_fsm_nxt_state;                 //Scan FSM next state
wire                                        scan_fsm_state_rd_pg_hdr;           //Scan FSM state RD_PG_HDR
wire                                        scan_fsm_state_rd_line_ptr;         //Scan FSM state RD_LINE_PTR
wire                                        scan_fsm_state_rd_line_hdr1;        //Scan FSM state RD_LINE_HDR1
wire                                        scan_fsm_state_rd_line_hdr2;        //Scan FSM state RD_LINE_HDR2
wire                                        scan_fsm_state_rd_line_hdr3;        //Scan FSM state RD_LINE_HDR3
wire                                        scan_fsm_state_attr_scan;           //Scan FSM state ATTR_SCAN
wire                                        scan_fsm_state_do_varlen;           //Scan FSM state DO_VARLEN
wire                                        scan_fsm_state_do_cstring;          //Scan FSM state DO_CSTRING
wire                                        scan_fsm_state_pre_out;             //Scan FSM state PRE_OUT
wire                                        scan_fsm_state_attr_out;            //Scan FSM state ATTR_OUT
wire                                        scan_fsm_state_attr_num_err;        //Scan FSM state ATTR_NUM_ERR
wire                                        scan_fsm_state_line_end_err;        //Scan FSM state LINE_END_ERR
wire                                        scan_fsm_state_toast_err;           //Scan FSM state TOAST_ERR
wire                                        scan_fsm_state_stream_err;          //Scan FSM state STREAM_ERR
wire                                        scan_fsm_nxt_state_attr_scan;       //Scan FSM next state ATTR_SCAN
//--- Page Header and Line Header read ---
reg                                         is_rd_pg_data_ram0;                 //read page data from RAM0 or RAM1
wire                                        pg_data_ram_rdone;                  //read page data RAM done
wire                                        is_empty_page;                      //page is empty, no valid line pointer 
wire                                        pg_data_ram_rready;                 //page data RAM0 or RAM1 read ready 
wire    [10 : 0]                            pg_hdr_raddr;                       //page header RAM read address
wire    [15 : 0]                            pg_hdr_pd_lower;                    //page header pd_lower 
reg     [15 : 0]                            pg_hdr_pd_lower_l;                  //page header pd_lower latch
reg     [10 : 0]                            pg_line_ptr_raddr;                  //page line pointer RAM read address
wire                                        is_pg_last_line;                    //last line of one page 
wire    [14 : 0]                            pg_lp_off;                          //page line offset 
reg     [14 : 0]                            pg_lp_off_l;                        //page line offset latch 
wire    [14 : 0]                            pg_lp_len;                          //page line length 
reg     [14 : 0]                            pg_lp_len_l;                        //page line length latch
wire    [10 : 0]                            pg_lh_infomask2_raddr;              //page line header infomask2 RAM read address
wire    [15 : 0]                            pg_lh_infomask2;                    //page line header infomask2 
wire    [15 : 0]                            pg_lh_attr_num;                     //page attr number 
reg     [15 : 0]                            pg_lh_attr_num_l;                   //page attr number latch 
wire                                        is_attr_num_err;                    //page attr number larger than relation attr number error
wire    [10 : 0]                            pg_lh_infomask_raddr;               //page line header infomask RAM read address
wire    [15 : 0]                            pg_lh_infomask;                     //page line header infomask 
wire    [7  : 0]                            pg_lh_off;                          //page line header t_hoff 
reg     [7  : 0]                            pg_lh_off_l;                        //page line header t_hoff latch
wire    [10 : 0]                            pg_lh_off_raddr;                    //page data RAM read address from t_hoff
wire    [10 : 0]                            pg_lh_off_l_raddr;                  //page data RAM read address from t_hoff latch
wire                                        pg_lh_has_null;                     //page line header has null attr 
reg                                         pg_lh_has_null_l;                   //page line header has null attr latch
wire    [MAX_REL_ATTR_NUM - 1  : 0]         pg_lh_bitmap_8b;                    //page line header t_bits[7:0]
wire    [MAX_REL_ATTR_NUM - 1  : 0]         pg_lh_bitmap_32b;                   //32bit of page line header t_bits
wire    [MAX_REL_ATTR_NUM - 1  : 0]         pg_lh_bitmap_all;                   //all page line header t_bits
reg     [MAX_REL_ATTR_NUM - 1  : 0]         pg_lh_bitmap_l;                     //all page line header t_bits latch
wire    [10 : 0]                            pg_lh_bitmap_raddr;                 //page line header t_bits RAM read address
reg     [10 : 0]                            pg_lh_bitmap_raddr_l;               //page line header t_bits RAM read address latch
wire    [10 : 0]                            pg_line_hdr3_raddr;                 //RD_LINE_HDR3 state RAM address
reg     [31 : 0]                            cur_bitmap_num;                     //current read t_bits number
wire                                        is_last_bitmap_data;                //last beat of t_bits data 
wire                                        rd_bitmap_done;                     //read t_bits done
//--- Column Scan ---
reg     [31 : 0]                            cur_attr_off;                       //current line offset from lp_off + t_hoff
wire    [31 : 0]                            off_after_attalign;                 //line offset after perform alignment based on attalign
wire    [31 : 0]                            attr_scan_nxt_attr_off;             //next attr line offset in ATTR_SCAN state
wire    [31 : 0]                            do_varlen_nxt_attr_off;             //next attr line offset in DO_VARLEN state
wire    [31 : 0]                            do_cstring_nxt_attr_off;            //next attr line offset in DO_CSTRING state
wire    [31 : 0]                            pre_out_nxt_attr_off;               //next attr line offset in PRE_OUT state
wire    [31 : 0]                            scan_out_nxt_attr_off;              //next attr line offset in SCAN_OUT state
wire    [10 : 0]                            pg_attr_scan_raddr;                 //ATTR_SCAN state RAM address
wire    [10 : 0]                            pg_do_varlen_raddr;                 //DO_VARLEN state RAM address
wire    [10 : 0]                            pg_do_cstring_raddr;                //DO_CSTRING state RAM address
wire    [10 : 0]                            pg_pre_out_raddr;                   //PRE_OUT state RAM address
wire    [10 : 0]                            pg_scan_out_raddr;                  //SCAN_OUT state RAM address
wire                                        is_attr_scan_line_end_err;          //ATTR_SCAN state unexpected line end error
wire                                        is_do_varlen_line_end_err;          //DO_VARLEN state unexpected line end error
wire                                        is_do_cstring_line_end_err;         //DO_CSTRING state unexpected line end error
wire                                        is_null_attr;                       //current attr is null
wire    [4  : 0]                            cur_attr_off_byte_index;            //current line offset first byte index 
wire    [7  : 0]                            cur_attr_first_byte;                //current line offset first byte data 
reg     [31 : 0]                            cur_attr_id;                        //current attr id in processing
reg     [REL_ATTR_RAM_ADDR_WIDTH - 1 : 0]   cur_rel_attr_ram_raddr;             //current relation attr RAM read address
wire    [REL_ATTR_RAM_ADDR_WIDTH - 1 : 0]   nxt_rel_attr_ram_raddr;             //next relation attr RAM read address
reg     [3  : 0]                            cur_attr_id_ram_raddr;              //current attr id RAM read address
wire    [3  : 0]                            nxt_attr_id_ram_raddr;              //next attr id RAM read address
wire                                        is_rd_last_attr_id;                 //read last attr id item
wire                                        is_expected_attr;                   //processing attr id match current expected attr id, need to output
wire                                        is_null_line_last_expected_attr;    //last attr of line is null and expected attr
wire                                        is_null_page_last_expected_attr;    //last attr of page is null and expected attr
wire    [7  : 0]                            cur_attr_align;                     //current attr attalign
wire    [31 : 0]                            cur_attr_len;                       //current attr attlen
wire                                        is_cstring_attr;                    //current attr is cstring attr
wire                                        is_varlen_attr;                     //current attr is varlen attr
wire                                        is_varlen_pad;                      //current byte is varlen attr padding byte
wire                                        is_varlen_toast;                    //current attr is TOAST attr
wire                                        is_varlen_1b;                       //current attr is varlen 1-byte attr
wire                                        is_varlen_4b;                       //current attr is varlen 4-byte attr
wire    [31 : 0]                            varlen_1b_len;                      //attr length of varlen 1-byte attr
wire    [31 : 0]                            varlen_4b_len;                      //attr length of varlen 4-byte attr
reg     [31 : 0]                            cstring_start_off;                  //starting line offset of cstring attr
reg     [31 : 0]                            cstring_len;                        //attr length of cstring attr
wire                                        is_cstring_end;                     //current byte is cstring end
//--- Column data generate ---
reg     [31 : 0]                            attr_out_length;                    //length of the output attr
reg     [31 : 0]                            attr_out_offset_end;                //offset end of the output attr
reg     [31 : 0]                            attr_out_start_off;                 //start offset of the output attr
wire    [4  : 0]                            attr_out_start_off_byte_index;      //output attr start offset first byte index 
reg     [31 : 0]                            attr_out_data_low;                  //attr out lower 32bit data
reg     [31 : 0]                            attr_out_data_beat_cnt;             //attr out beat counter for user data
reg     [31 : 0]                            attr_out_all_beat_cnt;              //attr out beat counter for all data including padding data to 512b
wire    [31 : 0]                            attr_out_padding_data;              //padding data for last beat of attr user data
wire                                        is_last_attr_out_data;              //last beat of attr user data
wire                                        is_512b_padding_data;               //current attr out data is 512b padding data
wire                                        is_last_attr_out_all;               //last beat of all attr data
wire    [63 : 0]                            attr_out_data_64b;                  //64bit attr out user data
wire    [31 : 0]                            attr_out_data_32b;                  //32bit attr out user data
wire    [31 : 0]                            attr_out_data;                      //attr out data
wire                                        attr_out_data_valid;                //attr out data valid
wire                                        attr_out_data_ready;                //attr out data ready
wire                                        attr_out_beat_done;                 //attr out one beat data done
wire                                        attr_out_data_beat_done;            //attr out one beat user data done
wire                                        attr_out_done;                      //one column data out done
wire                                        is_line_last_attr_done;             //one line all column data out done
wire                                        is_page_last_attr_done;             //one page all column data out done
wire                                        is_rel_last_attr_done;              //one relation all column data out done
reg                                         is_rel_last_attr_done_dl;           //delay of one relation all column data out done
reg     [31 : 0]                            pg_ptr_done_cnt;                    //page pointer scan done counter
wire                                        is_rel_last_page;                   //relation last page in scan
//--- Stream output ---
reg     [3  : 0]                            cur_channel_num;                    //current output channel number
wire                                        is_last_channel_num;                //last available channel number
reg     [3  : 0]                            channel_sel_bits;                   //channel select bitmap
reg                                         sel_tready;                         //selected stream data ready
reg     [7  : 0]                            column_sel_bits;                    //column select bitmap
wire                                        column0_tvalid;                     //column0 stream data valid
wire                                        column1_tvalid;                     //column1 stream data valid
wire                                        column2_tvalid;                     //column2 stream data valid
wire                                        column3_tvalid;                     //column3 stream data valid
wire                                        column4_tvalid;                     //column4 stream data valid
wire                                        column5_tvalid;                     //column5 stream data valid
wire                                        column6_tvalid;                     //column6 stream data valid
wire                                        column7_tvalid;                     //column7 stream data valid
wire    [7  : 0]                            channel0_tready_bits;               //channel0 stream data ready bitmap
wire                                        channel0_tready;                    //channel0 stream data ready
wire    [7  : 0]                            channel1_tready_bits;               //channel1 stream data ready bitmap
wire                                        channel1_tready;                    //channel1 stream data ready
wire    [7  : 0]                            channel2_tready_bits;               //channel2 stream data ready bitmap
wire                                        channel2_tready;                    //channel2 stream data ready
wire    [7  : 0]                            channel3_tready_bits;               //channel3 stream data ready bitmap
wire                                        channel3_tready;                    //channel3 stream data ready
wire                                        is_stream_timeout_err;              //stream port timeout error
reg     [31 : 0]                            st_timeout_cnt;                     //stream port timeout counter
//------------------------------------------------------------------------------
// Reset
//------------------------------------------------------------------------------
assign fifo_rst = ~(rst_n & scan_run);
//------------------------------------------------------------------------------
// Main FSM
//------------------------------------------------------------------------------
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    fsm_cur_state <= IDLE;
  else
    fsm_cur_state <= fsm_nxt_state;
end

// when scan_run asserted, start to read attr id and relation attr buffer
// (these two buffers read once only for one table)
// then read page buffer (axi length == 0 once) to fill page pointer FIFO
// start to read 8KB page data when page pointer available
// (two page data RAMs for ping-pong handling)
// then wait one page data column scan done, if page pointer FIFO has entry,
// to read a new page; if page pointer FIFO empty, and page buffer not read
// done, read page buffer once again from host memory and then read page data
// when all pages column scan done, to handle the second table if enabled
// otherwise back to idle when scan_run de-asserted
always@(*) begin
  case(fsm_cur_state)
    IDLE:
      if(scan_run)
        fsm_nxt_state = RD_ATTR_ID;
      else
        fsm_nxt_state = IDLE;
    RD_ATTR_ID:
      if(axi_rdata_err)
        fsm_nxt_state = RD_ERR;
      else if(rd_attr_id_done)
        fsm_nxt_state = RD_REL_ATTR;
      else
        fsm_nxt_state = RD_ATTR_ID;
    RD_REL_ATTR:
      if(axi_rdata_err)
        fsm_nxt_state = RD_ERR;
      else if(rd_rel_attr_done)
        fsm_nxt_state = RD_PG_PTR;
      else
        fsm_nxt_state = RD_REL_ATTR;
    RD_PG_PTR:
      if(axi_rdata_err)
        fsm_nxt_state = RD_ERR;
      else if(rd_pg_ptr_done | pg_buf_axi_last_cmd_done_l)
        fsm_nxt_state = WAIT_PG_PTR;
      else
        fsm_nxt_state = RD_PG_PTR;
    WAIT_PG_PTR:
      if(axi_rdata_err)
        fsm_nxt_state = RD_ERR;
      else if(cur_pg_ptr_valid)
        fsm_nxt_state = RD_PG_DATA;
      else
        fsm_nxt_state = WAIT_PG_PTR;
    RD_PG_DATA:
      if(axi_rdata_err)
        fsm_nxt_state = RD_ERR;
      else if(rd_pg_data_done)
        fsm_nxt_state = WAIT_PG_DONE;
      else
        fsm_nxt_state = RD_PG_DATA;
    WAIT_PG_DONE:
      if(axi_rdata_err)
        fsm_nxt_state = RD_ERR;
      else if(is_rel_last_attr_done)
        fsm_nxt_state = SCAN_DONE;
      else if((is_rel_first_pg_rd | is_page_last_attr_done) & ~pg_ptr_fifo_empty)
        fsm_nxt_state = RD_PG_DATA;
      else if((is_rel_first_pg_rd | is_page_last_attr_done) & pg_ptr_fifo_empty)
        fsm_nxt_state = RD_PG_PTR;
      else
        fsm_nxt_state = WAIT_PG_DONE;
    SCAN_DONE:
      if(~scan_run)
        fsm_nxt_state = IDLE;
      else if(tab1_en & ~table1_done)
        fsm_nxt_state = RD_ATTR_ID;
      else
        fsm_nxt_state = SCAN_DONE;
    RD_ERR:
      if(~scan_run)
        fsm_nxt_state = IDLE;
      else
        fsm_nxt_state = RD_ERR;
    default:
      fsm_nxt_state = IDLE;
  endcase
end

assign fsm_state_idle         = (fsm_cur_state == IDLE);
assign fsm_state_rd_attr_id   = (fsm_cur_state == RD_ATTR_ID);
assign fsm_state_rd_rel_attr  = (fsm_cur_state == RD_REL_ATTR);
assign fsm_state_rd_pg_ptr    = (fsm_cur_state == RD_PG_PTR);
assign fsm_state_rd_pg_data   = (fsm_cur_state == RD_PG_DATA);
assign fsm_state_wait_pg_done = (fsm_cur_state == WAIT_PG_DONE);
assign fsm_state_scan_done    = (fsm_cur_state == SCAN_DONE);
assign fsm_state_rd_err       = (fsm_cur_state == RD_ERR);

assign scan_busy = ~fsm_state_idle;
//------------------------------------------------------------------------------
// Attribute ID Buffer AXI read command
//------------------------------------------------------------------------------
// generate aligned addr
assign tab0_attr_id_buf_end_addr         = tab0_attr_id_buf_addr + tab0_attr_id_buf_size;
assign tab0_attr_id_buf_start_align_addr = {tab0_attr_id_buf_addr[63 : AXI_DATA_BYTE_WIDTH], {AXI_DATA_BYTE_WIDTH{1'b0}}};
assign tab0_attr_id_buf_end_align_addr   = (tab0_attr_id_buf_end_addr[AXI_DATA_BYTE_WIDTH-1 :0] == {AXI_DATA_BYTE_WIDTH{1'b0}}) ? tab0_attr_id_buf_end_addr
                                            : {tab0_attr_id_buf_end_addr[63 : AXI_DATA_BYTE_WIDTH] + 1'b1, {AXI_DATA_BYTE_WIDTH{1'b0}}};

assign tab1_attr_id_buf_end_addr         = tab1_attr_id_buf_addr + tab1_attr_id_buf_size;
assign tab1_attr_id_buf_start_align_addr = {tab1_attr_id_buf_addr[63 : AXI_DATA_BYTE_WIDTH], {AXI_DATA_BYTE_WIDTH{1'b0}}};
assign tab1_attr_id_buf_end_align_addr   = (tab1_attr_id_buf_end_addr[AXI_DATA_BYTE_WIDTH-1 :0] == {AXI_DATA_BYTE_WIDTH{1'b0}}) ? tab1_attr_id_buf_end_addr
                                            : {tab1_attr_id_buf_end_addr[63 : AXI_DATA_BYTE_WIDTH] + 1'b1, {AXI_DATA_BYTE_WIDTH{1'b0}}};

assign attr_id_buf_addr             = (tab1_en & table0_done) ? tab1_attr_id_buf_addr : tab0_attr_id_buf_addr;
assign attr_id_buf_size             = (tab1_en & table0_done) ? tab1_attr_id_buf_size : tab0_attr_id_buf_size;
assign attr_id_buf_start_align_addr = (tab1_en & table0_done) ? tab1_attr_id_buf_start_align_addr : tab0_attr_id_buf_start_align_addr;
assign attr_id_buf_end_align_addr   = (tab1_en & table0_done) ? tab1_attr_id_buf_end_align_addr : tab0_attr_id_buf_end_align_addr;

// AXI read addr: start from attr id buf addr, update after one cmd sent
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    attr_id_buf_cur_axi_start_addr <= 64'b0;
  else if((fsm_state_idle & scan_run) |
          (fsm_state_scan_done & tab1_en & ~table1_done))
    attr_id_buf_cur_axi_start_addr <= attr_id_buf_start_align_addr;
  else if(fsm_state_rd_attr_id & m_axi_arready)
    attr_id_buf_cur_axi_start_addr <= attr_id_buf_cur_axi_end_addr;
  else
    attr_id_buf_cur_axi_start_addr <= attr_id_buf_cur_axi_start_addr;
end

// Check axi end addr cross 4KB boundary
// generate axi length and next axi cmd addr
assign attr_id_buf_nxt_axi_4k_addr  = {attr_id_buf_cur_axi_start_addr[63:12] + 1'b1, 12'b0};
assign attr_id_buf_axi_last_cmd     = (attr_id_buf_end_align_addr < attr_id_buf_nxt_axi_4k_addr) | (attr_id_buf_end_align_addr == attr_id_buf_nxt_axi_4k_addr);
assign attr_id_buf_cur_axi_end_addr = attr_id_buf_axi_last_cmd ? attr_id_buf_end_align_addr : attr_id_buf_nxt_axi_4k_addr; 
assign attr_id_buf_cur_axi_length   = ((attr_id_buf_cur_axi_end_addr - attr_id_buf_cur_axi_start_addr) >> AXI_DATA_BYTE_WIDTH) - 1'b1;

assign rd_attr_id_done = attr_id_buf_axi_last_cmd & m_axi_arready;

// relation0 scan done
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    table0_done <= 1'b0;
  else if(fsm_state_idle & scan_run)
    table0_done <= 1'b0;
  else if(is_rel_last_attr_done)
    table0_done <= 1'b1;
  else
    table0_done <= table0_done;
end

// relation1 scan done
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    table1_done <= 1'b0;
  else if(fsm_state_idle & scan_run)
    table1_done <= 1'b0;
  else if(is_rel_last_attr_done & table0_done)
    table1_done <= 1'b1;
  else
    table1_done <= table1_done;
end
//------------------------------------------------------------------------------
// Relation Attribute Buffer AXI read command
//------------------------------------------------------------------------------
// generate aligned addr
assign tab0_rel_attr_buf_end_addr         = tab0_rel_attr_buf_addr + tab0_rel_attr_buf_size;
assign tab0_rel_attr_buf_start_align_addr = {tab0_rel_attr_buf_addr[63 : AXI_DATA_BYTE_WIDTH], {AXI_DATA_BYTE_WIDTH{1'b0}}};
assign tab0_rel_attr_buf_end_align_addr   = (tab0_rel_attr_buf_end_addr[AXI_DATA_BYTE_WIDTH-1 :0] == {AXI_DATA_BYTE_WIDTH{1'b0}}) ? tab0_rel_attr_buf_end_addr
                                             : {tab0_rel_attr_buf_end_addr[63 : AXI_DATA_BYTE_WIDTH] + 1'b1, {AXI_DATA_BYTE_WIDTH{1'b0}}};

assign tab1_rel_attr_buf_end_addr         = tab1_rel_attr_buf_addr + tab1_rel_attr_buf_size;
assign tab1_rel_attr_buf_start_align_addr = {tab1_rel_attr_buf_addr[63 : AXI_DATA_BYTE_WIDTH], {AXI_DATA_BYTE_WIDTH{1'b0}}};
assign tab1_rel_attr_buf_end_align_addr   = (tab1_rel_attr_buf_end_addr[AXI_DATA_BYTE_WIDTH-1 :0] == {AXI_DATA_BYTE_WIDTH{1'b0}}) ? tab1_rel_attr_buf_end_addr
                                             : {tab1_rel_attr_buf_end_addr[63 : AXI_DATA_BYTE_WIDTH] + 1'b1, {AXI_DATA_BYTE_WIDTH{1'b0}}};

assign rel_attr_buf_addr             = (tab1_en & table0_done) ? tab1_rel_attr_buf_addr : tab0_rel_attr_buf_addr;
assign rel_attr_buf_size             = (tab1_en & table0_done) ? tab1_rel_attr_buf_size : tab0_rel_attr_buf_size;
assign rel_attr_buf_start_align_addr = (tab1_en & table0_done) ? tab1_rel_attr_buf_start_align_addr : tab0_rel_attr_buf_start_align_addr;
assign rel_attr_buf_end_align_addr   = (tab1_en & table0_done) ? tab1_rel_attr_buf_end_align_addr : tab0_rel_attr_buf_end_align_addr;

// AXI read addr: start from relation attr buf addr, update after one cmd sent
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    rel_attr_buf_cur_axi_start_addr <= 64'b0;
  else if(fsm_state_rd_attr_id & rd_attr_id_done)
    rel_attr_buf_cur_axi_start_addr <= rel_attr_buf_start_align_addr;
  else if(fsm_state_rd_rel_attr & m_axi_arready)
    rel_attr_buf_cur_axi_start_addr <= rel_attr_buf_cur_axi_end_addr;
  else
    rel_attr_buf_cur_axi_start_addr <= rel_attr_buf_cur_axi_start_addr;
end

// Check axi end addr cross 4KB boundary
// generate axi length and next axi cmd addr
assign rel_attr_buf_nxt_axi_4k_addr  = {rel_attr_buf_cur_axi_start_addr[63:12] + 1'b1, 12'b0};
assign rel_attr_buf_axi_last_cmd     = (rel_attr_buf_end_align_addr < rel_attr_buf_nxt_axi_4k_addr) | (rel_attr_buf_end_align_addr == rel_attr_buf_nxt_axi_4k_addr);
assign rel_attr_buf_cur_axi_end_addr = rel_attr_buf_axi_last_cmd ? rel_attr_buf_end_align_addr : rel_attr_buf_nxt_axi_4k_addr; 
assign rel_attr_buf_cur_axi_length   = ((rel_attr_buf_cur_axi_end_addr - rel_attr_buf_cur_axi_start_addr) >> AXI_DATA_BYTE_WIDTH) - 1'b1;

assign rd_attr_id_done = rel_attr_buf_axi_last_cmd & m_axi_arready;
//------------------------------------------------------------------------------
// Page Buffer AXI read command
//------------------------------------------------------------------------------
// generate aligned addr
assign tab0_pg_buf_end_addr         = tab0_pg_buf_addr + tab0_pg_buf_size;
assign tab0_pg_buf_start_align_addr = {tab0_pg_buf_addr[63 : AXI_DATA_BYTE_WIDTH], {AXI_DATA_BYTE_WIDTH{1'b0}}};
assign tab0_pg_buf_end_align_addr   = (tab0_pg_buf_end_addr[AXI_DATA_BYTE_WIDTH-1 :0] == {AXI_DATA_BYTE_WIDTH{1'b0}}) ? tab0_pg_buf_end_addr
                                       : {tab0_pg_buf_end_addr[63 : AXI_DATA_BYTE_WIDTH] + 1'b1, {AXI_DATA_BYTE_WIDTH{1'b0}}};

assign tab1_pg_buf_end_addr         = tab1_pg_buf_addr + tab1_pg_buf_size;
assign tab1_pg_buf_start_align_addr = {tab1_pg_buf_addr[63 : AXI_DATA_BYTE_WIDTH], {AXI_DATA_BYTE_WIDTH{1'b0}}};
assign tab1_pg_buf_end_align_addr   = (tab1_pg_buf_end_addr[AXI_DATA_BYTE_WIDTH-1 :0] == {AXI_DATA_BYTE_WIDTH{1'b0}}) ? tab1_pg_buf_end_addr
                                       : {tab1_pg_buf_end_addr[63 : AXI_DATA_BYTE_WIDTH] + 1'b1, {AXI_DATA_BYTE_WIDTH{1'b0}}};

assign pg_buf_addr             = (tab1_en & table0_done) ? tab1_pg_buf_addr : tab0_pg_buf_addr;
assign pg_buf_size             = (tab1_en & table0_done) ? tab1_pg_buf_size : tab0_pg_buf_size;
assign pg_buf_start_align_addr = (tab1_en & table0_done) ? tab1_pg_buf_start_align_addr : tab0_pg_buf_start_align_addr;
assign pg_buf_end_align_addr   = (tab1_en & table0_done) ? tab1_pg_buf_end_align_addr : tab0_pg_buf_end_align_addr;

// AXI read addr: start from page buf addr, update one burst length once
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    pg_buf_cur_axi_start_addr <= 64'b0;
  else if(fsm_state_rd_rel_attr & rd_rel_attr_done)
    pg_buf_cur_axi_start_addr <= pg_buf_start_align_addr;
  else if(fsm_state_wait_pg_done & pg_ptr_fifo_empty & 
          (is_rel_first_pg_rd | is_page_last_attr_done) & ~is_rel_last_page)
    pg_buf_cur_axi_start_addr <= pg_buf_cur_axi_end_addr;
  else
    pg_buf_cur_axi_start_addr <= pg_buf_cur_axi_start_addr;
end

// generate axi length and next axi cmd addr
assign pg_buf_cur_axi_end_addr = pg_buf_cur_axi_start_addr + AXI_DATA_BYTE;
assign pg_buf_axi_last_cmd     = (pg_buf_end_align_addr == pg_buf_cur_axi_end_addr);
assign pg_buf_cur_axi_length   = 0;

assign rd_pg_ptr_done = fsm_state_rd_pg_ptr & m_axi_arready & ~pg_buf_axi_last_cmd_done_l;
assign pg_buf_axi_last_cmd_done = pg_buf_axi_last_cmd & rd_pg_ptr_done;

always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    pg_buf_axi_last_cmd_done_l <= 1'b0;
  else if(fsm_state_rd_attr_id)
    pg_buf_axi_last_cmd_done_l <= 1'b0;
  else if(pg_buf_axi_last_cmd_done)
    pg_buf_axi_last_cmd_done_l <= 1'b1;
  else
    pg_buf_axi_last_cmd_done_l <= pg_buf_axi_last_cmd_done_l;
end
//------------------------------------------------------------------------------
// Page Data AXI read command
//------------------------------------------------------------------------------
// generate aligned addr
assign pg_data_end_addr         = cur_pg_ptr + PAGE_SIZE;
assign pg_data_start_align_addr = {cur_pg_ptr[63 : AXI_DATA_BYTE_WIDTH], {AXI_DATA_BYTE_WIDTH{1'b0}}};
assign pg_data_end_align_addr   = (pg_data_end_addr[AXI_DATA_BYTE_WIDTH-1 :0] == {AXI_DATA_BYTE_WIDTH{1'b0}}) ? pg_data_end_addr
                                   : {pg_data_end_addr[63 : AXI_DATA_BYTE_WIDTH] + 1'b1, {AXI_DATA_BYTE_WIDTH{1'b0}}};

// AXI read addr: page pointer
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    pg_data_cur_axi_start_addr <= 64'b0;
  else if((fsm_state_wait_pg_ptr & cur_pg_ptr_valid) |
          (fsm_state_wait_pg_done & ~pg_ptr_fifo_empty & (is_rel_first_pg_rd | is_page_last_attr_done) & ~is_rel_last_page))
    pg_data_cur_axi_start_addr <= pg_data_start_align_addr;
  else if(fsm_state_rd_pg_data & m_axi_arready)
    pg_data_cur_axi_start_addr <= pg_data_cur_axi_end_addr;
  else
    pg_data_cur_axi_start_addr <= pg_data_cur_axi_start_addr;
end

// generate axi length and next axi cmd addr
assign pg_data_nxt_axi_4k_addr  = {pg_data_cur_axi_start_addr[63:12] + 1'b1, 12'b0};
assign pg_data_axi_last_cmd     = (pg_data_end_align_addr < pg_data_nxt_axi_4k_addr) | (pg_data_end_align_addr == pg_data_nxt_axi_4k_addr);
assign pg_data_cur_axi_end_addr = pg_data_axi_last_cmd ? pg_data_end_align_addr : pg_data_nxt_axi_4k_addr; 
assign pg_data_cur_axi_length   = ((pg_data_cur_axi_end_addr - pg_data_cur_axi_start_addr) >> AXI_DATA_BYTE_WIDTH) - 1'b1;

assign rd_pg_data_done = pg_data_axi_last_cmd & m_axi_arready;

// relation first time read page, try to read two pages
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    is_rel_first_pg_rd <= 1'b1;
  else if(fsm_state_rd_attr_id)
    is_rel_first_pg_rd <= 1'b1;
  else if(is_rel_first_pg_rd & fsm_state_wait_pg_done)
    is_rel_first_pg_rd <= 1'b0;
  else
    is_rel_first_pg_rd <= is_rel_first_pg_rd;
end
//------------------------------------------------------------------------------
// AXI read address channel signals
//------------------------------------------------------------------------------
assign m_axi_arvalid  = fsm_state_rd_attr_id | fsm_state_rd_rel_attr | fsm_state_rd_pg_data |
                        (fsm_state_rd_pg_ptr & ~pg_buf_axi_last_cmd_done_l) ;
assign m_axi_araddr   = fsm_state_rd_attr_id ? attr_id_buf_cur_axi_start_addr 
                          : (fsm_state_rd_rel_attr ? rel_attr_buf_cur_axi_start_addr
                            : (fsm_state_rd_pg_ptr ? pg_buf_cur_axi_start_addr
                              : (fsm_state_rd_pg_data ? pg_data_cur_axi_start_addr : 64'b0)));
assign m_axi_arlen    = fsm_state_rd_attr_id ? attr_id_buf_cur_axi_length 
                          : (fsm_state_rd_rel_attr ? rel_attr_buf_cur_axi_length
                            : (fsm_state_rd_pg_ptr ? pg_buf_cur_axi_length
                              : (fsm_state_rd_pg_data ? pg_data_cur_axi_length : 8'b0)));
assign m_axi_arid     = fsm_state_rd_attr_id ? ATTR_ID_AXI_ID 
                          : (fsm_state_rd_rel_attr ? REL_ATTR_AXI_ID
                            : (fsm_state_rd_pg_ptr ? PG_PTR_AXI_ID
                              : (fsm_state_rd_pg_data ? PG_DATA_AXI_ID : {AXI_MM_ID_WIDTH{1'b0}})));
assign m_axi_arsize   = AXI_DATA_BYTE_WIDTH;
assign m_axi_arburst  = 2'b01;
assign m_axi_aruser   = {AXI_MM_ARUSER_WIDTH{1'b0}};
assign m_axi_arregion = 4'b0;
assign m_axi_arqos    = 4'b0;
assign m_axi_arprot   = 3'b0;
assign m_axi_arlock   = 1'b0;
assign m_axi_arcache  = 4'b0;
//------------------------------------------------------------------------------
// AXI read data
//------------------------------------------------------------------------------
//---AXI read data FIFO(data width x 8 depth)
// Xilinx IP: FWFT fifo
fifo_fwft_axi_data_widthx8 axi_rdata_fifo (
  .clk          (clk                 ),
  .srst         (fifo_rst            ),
  .din          (axi_rdata_fifo_din  ),
  .wr_en        (axi_rdata_fifo_wr_en),
  .rd_en        (axi_rdata_fifo_rd_en),
  .valid        (axi_rdata_fifo_valid),
  .dout         (axi_rdata_fifo_dout ),
  .full         (axi_rdata_fifo_full ),
  .empty        (axi_rdata_fifo_empty)
);

fifo_fwft_axi_id_widthx8 axi_rid_fifo (
  .clk          (clk                 ),
  .srst         (fifo_rst            ),
  .din          (axi_rid_fifo_din    ),
  .wr_en        (axi_rdata_fifo_wr_en),
  .rd_en        (axi_rdata_fifo_rd_en),
  .valid        (                    ),
  .dout         (axi_rid_fifo_dout   ),
  .full         (                    ),
  .empty        (                    )
);

// AXI read data write into FIFO
assign axi_rid_fifo_din     = m_axi_rid;
assign axi_rdata_fifo_din   = m_axi_rdata;
assign axi_rdata_fifo_wr_en = m_axi_rvalid & ~axi_rdata_fifo_full;
assign m_axi_rready = ~axi_rdata_fifo_full;
assign axi_rdata_err = m_axi_rvalid & m_axi_rready & (m_axi_rresp != 2'b00);

// AXI data FIFO read enable
assign axi_rdata_fifo_rd_en = attr_id_axi_rdata_fifo_rd_en | rel_attr_axi_rdata_fifo_rd_en
                              | pg_ptr_axi_rdata_fifo_rd_en | pg_data_axi_rdata_fifo_rd_en;

// AXI read data error output
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    attr_id_buf_rd_err <= 1'b0;
  else if(axi_rdata_err & (m_axi_rid == ATTR_ID_AXI_ID))
    attr_id_buf_rd_err <= 1'b1;
  else if(fsm_state_rd_err & ~scan_run)
    attr_id_buf_rd_err <= 1'b0;
  else
    attr_id_buf_rd_err <= attr_id_buf_rd_err;
end

always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    rel_attr_buf_rd_err <= 1'b0;
  else if(axi_rdata_err & (m_axi_rid == REL_ATTR_AXI_ID))
    rel_attr_buf_rd_err <= 1'b1;
  else if(fsm_state_rd_err & ~scan_run)
    rel_attr_buf_rd_err <= 1'b0;
  else
    rel_attr_buf_rd_err <= rel_attr_buf_rd_err;
end

always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    pg_buf_rd_err <= 1'b0;
  else if(axi_rdata_err & (m_axi_rid == PG_PTR_AXI_ID))
    pg_buf_rd_err <= 1'b1;
  else if(fsm_state_rd_err & ~scan_run)
    pg_buf_rd_err <= 1'b0;
  else
    pg_buf_rd_err <= pg_buf_rd_err;
end

always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    pg_data_rd_err <= 1'b0;
  else if(axi_rdata_err & (m_axi_rid == PG_DATA_AXI_ID))
    pg_data_rd_err <= 1'b1;
  else if(fsm_state_rd_err & ~scan_run)
    pg_data_rd_err <= 1'b0;
  else
    pg_data_rd_err <= pg_data_rd_err;
end

//------------------------------------------------------------------------------
// Attribute ID data
// Note: 
// 1. support AXI data width larger than attr id width only
// 2. support attr id buffer address aligned with attr id width only
//    (can be unaligned with AXI data width)
//------------------------------------------------------------------------------
// the number of attr id items got from attr id buffer size
assign num_of_attr_id = attr_id_buf_size >> ATTR_ID_BYTE_WIDTH;

// attr id data started on 1st AXI read data is based on attr id buffer addr
// if unaligned, for the other beats, attr id always started on LSB
// axi read data LSB updated when one attr id written into distributed RAM
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    cur_axi2attr_id_lsb <= 12'b0;
  else if((fsm_state_idle & scan_run) |
          (fsm_state_scan_done & tab1_en & ~table1_done))
    cur_axi2attr_id_lsb <= (attr_id_buf_addr[AXI_DATA_BYTE_WIDTH-1 :0] << 3);
  else if(attr_id_ram_we)
    cur_axi2attr_id_lsb <= nxt_axi2attr_id_lsb;
  else
    cur_axi2attr_id_lsb <= cur_axi2attr_id_lsb;
end

// when current AXI read data beat attr id written done
// read a new AXI data from FIFO, and start attr id from bit0
// or all attr id items written done, pop the AXI data from FIFO
assign nxt_axi2attr_id_lsb = (cur_axi2attr_id_lsb + ATTR_ID_WIDTH == AXI_MM_DATA_WIDTH) ? 12'b0 
                              : (cur_axi2attr_id_lsb + ATTR_ID_WIDTH);
assign is_attr_id_axi_data = axi_rdata_fifo_valid & (axi_rid_fifo_dout == ATTR_ID_AXI_ID);
assign attr_id_axi_rdata_fifo_rd_en = ~axi_rdata_fifo_empty & is_attr_id_axi_data & 
                                      (is_wr_last_attr_id | (nxt_axi2attr_id_lsb == 12'b0));

// attr id RAM write when current AXI read data is attr id and the write number 
// not reach exceed the total number of attr id
assign is_wr_last_attr_id = ((attr_id_ram_waddr + 1'b1) == num_of_attr_id);
assign attr_id_ram_we     = is_attr_id_axi_data & (attr_id_ram_waddr < num_of_attr_id);
assign attr_id_ram_din    = axi_rdata_fifo_dout[cur_axi2attr_id_lsb +: ATTR_ID_WIDTH];
assign attr_id_ram_addr   = attr_id_ram_we ? attr_id_ram_waddr : attr_id_ram_raddr;

// attr id RAM write address update once one item written
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    attr_id_ram_waddr <= 4'b0;
  else if(fsm_state_rd_attr_id)
    attr_id_ram_waddr <= 4'b0;
  else if(attr_id_ram_we)
    attr_id_ram_waddr <= attr_id_ram_waddr + 1'b1;
  else
    attr_id_ram_waddr <= attr_id_ram_waddr;
end

//---Attr ID RAM(attr id width x 16 depth)
//---Note: 
//---support max 8 columns scan for one relation/table
//---attr id items must be in ascending order
// Xilinx IP: Distributed RAM (min depth is 16)
dist_ram_attr_id_widthx16 attr_id_ram (
  .clk  (clk              ),
  .a    (attr_id_ram_addr ),
  .we   (attr_id_ram_we   ),
  .d    (attr_id_ram_din  ),
  .spo  (attr_id_ram_dout )
);

//------------------------------------------------------------------------------
// Relation Attribute data
// Note: 
// 1. support AXI data width larger than relation attr width only
// 2. support relation attr buffer address aligned with relation attr width only
//    (can be unaligned with AXI data width)
//------------------------------------------------------------------------------
// the number of relation attr items got from rel attr buffer size
assign num_of_rel_attr = rel_attr_buf_size >> REL_ATTR_BYTE_WIDTH;

// relation attr data started on 1st AXI read data is based on rel attr buffer addr
// if unaligned, for the other beats, relation attr always started on LSB
// axi read data LSB updated when one relation attr written into distributed RAM
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    cur_axi2rel_attr_lsb <= 12'b0;
  else if(fsm_state_rd_attr_id & rd_attr_id_done)
    cur_axi2rel_attr_lsb <= (rel_attr_buf_addr[AXI_DATA_BYTE_WIDTH-1 :0] << 3);
  else if(rel_attr_ram_we)
    cur_axi2rel_attr_lsb <= nxt_axi2rel_attr_lsb;
  else
    cur_axi2rel_attr_lsb <= cur_axi2rel_attr_lsb;
end

// when current AXI read data beat relation attr written done
// read a new AXI data from FIFO, and start relation attr from bit0
// or all relation attr items written done, pop the AXI data from FIFO
assign nxt_axi2rel_attr_lsb = (cur_axi2rel_attr_lsb + REL_ATTR_WIDTH == AXI_MM_DATA_WIDTH) ? 12'b0 
                               : (cur_axi2rel_attr_lsb + REL_ATTR_WIDTH);
assign is_rel_attr_axi_data = axi_rdata_fifo_valid & (axi_rid_fifo_dout == REL_ATTR_AXI_ID);
assign rel_attr_axi_rdata_fifo_rd_en = ~axi_rdata_fifo_empty & is_rel_attr_axi_data & 
                                       (is_last_rel_attr | (nxt_axi2rel_attr_lsb == 12'b0));

// relation attr RAM write when current AXI read data is relation attr and the write number 
// not reach exceed the total number of relation attr
assign is_last_rel_attr  = ((&rel_attr_ram_waddr) | ((rel_attr_ram_waddr + 1'b1) == num_of_rel_attr));
assign rel_attr_ram_we   = is_rel_attr_axi_data & (rel_attr_ram_waddr < num_of_rel_attr);
assign rel_attr_ram_din  = axi_rdata_fifo_dout[cur_axi2rel_attr_lsb +: REL_ATTR_WIDTH];
assign rel_attr_ram_addr = rel_attr_ram_we ? rel_attr_ram_waddr : rel_attr_ram_raddr;

// relation attr RAM write address update once one item written
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    rel_attr_ram_waddr <= {REL_ATTR_RAM_ADDR_WIDTH{1'b0}};
  else if(fsm_state_rd_attr_id)
    rel_attr_ram_waddr <= {REL_ATTR_RAM_ADDR_WIDTH{1'b0}};
  else if(rel_attr_ram_we)
    rel_attr_ram_waddr <= rel_attr_ram_waddr + 1'b1;
  else
    rel_attr_ram_waddr <= rel_attr_ram_waddr;
end

//---Relation Attr RAM(rel attr width x max relation attr number)
//---Note: 
//---max supported attr number is defined in localparam MAX_REL_ATTR_NUM
//---Relation Attr Item : {padding(8'b0), attalign(8'b char), attlen(16'b int2)}
// Xilinx IP: Distributed RAM
dist_ram_rel_attr_width_max_attr_num rel_attr_ram (
  .clk  (clk               ),
  .a    (rel_attr_ram_addr ),
  .we   (rel_attr_ram_we   ),
  .d    (rel_attr_ram_din  ),
  .spo  (rel_attr_ram_dout )
);

//------------------------------------------------------------------------------
// Page Pointer data
// Note: 
// 1. support AXI data width larger than page pointer width only
// 2. support page buffer address aligned with page pointer width only
//    (can be unaligned with AXI data width)
//------------------------------------------------------------------------------
// the number of page pointer got from page buffer size
assign num_of_pg_ptr = pg_buf_size >> PG_PTR_BYTE_WIDTH;

// page pointer data started on 1st AXI read data is based on page buffer addr
// if unaligned, for the other beats, page pointer always started on LSB
// axi read data LSB updated when one page pointer written into FIFO
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    cur_axi2pg_ptr_lsb <= 12'b0;
  else if(fsm_state_rd_rel_attr & rd_rel_attr_done)
    cur_axi2pg_ptr_lsb <= (pg_buf_addr[AXI_DATA_BYTE_WIDTH-1 :0] << 3);
  else if(pg_ptr_fifo_wr_en)
    cur_axi2pg_ptr_lsb <= nxt_axi2pg_ptr_lsb;
  else
    cur_axi2pg_ptr_lsb <= cur_axi2pg_ptr_lsb;
end

// when current AXI read data beat page pointer written done
// read a new AXI data from FIFO, and start page pointer from bit0
// or all page pointer items written done, pop the AXI data from FIFO
assign nxt_axi2pg_ptr_lsb = (cur_axi2pg_ptr_lsb + PG_PTR_WIDTH == AXI_MM_DATA_WIDTH) ? 12'b0 
                               : (cur_axi2pg_ptr_lsb + PG_PTR_WIDTH);
assign is_pg_ptr_axi_data = axi_rdata_fifo_valid & (axi_rid_fifo_dout == PG_PTR_AXI_ID);
assign pg_ptr_axi_rdata_fifo_rd_en = ~axi_rdata_fifo_empty & is_pg_ptr_axi_data & 
                                       (is_last_wr_pg_ptr | (nxt_axi2pg_ptr_lsb == 12'b0));

// page pointer FIFO write when current AXI read data is page pointer and the write number 
// not reach exceed the total number of page pointer
assign is_last_wr_pg_ptr = ((pg_ptr_wr_cnt + 1'b1) == num_of_pg_ptr);
assign pg_ptr_fifo_wr_en = ~pg_ptr_fifo_full & is_pg_ptr_axi_data & (pg_ptr_wr_cnt < num_of_pg_ptr);
assign pg_ptr_fifo_din   = axi_rdata_fifo_dout[cur_axi2pg_ptr_lsb +: PG_PTR_WIDTH];

// page pointer counter update once one item written
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    pg_ptr_wr_cnt <= 32'b0;
  else if(fsm_state_rd_attr_id)
    pg_ptr_wr_cnt <= 32'b0;
  else if(pg_ptr_fifo_wr_en)
    pg_ptr_wr_cnt <= pg_ptr_wr_cnt + 1'b1;
  else
    pg_ptr_wr_cnt <= pg_ptr_wr_cnt;
end

//---Page Pointer FIFO(page ptr width x 16 depth)
// Xilinx IP: FWFT fifo
fifo_fwft_pg_ptr_widthx16 pg_ptr_fifo (
  .clk          (clk              ),
  .srst         (fifo_rst         ),
  .din          (pg_ptr_fifo_din  ),
  .wr_en        (pg_ptr_fifo_wr_en),
  .rd_en        (pg_ptr_fifo_rd_en),
  .valid        (pg_ptr_fifo_valid),
  .dout         (pg_ptr_fifo_dout ),
  .full         (pg_ptr_fifo_full ),
  .empty        (pg_ptr_fifo_empty)
);

assign cur_pg_ptr        = pg_ptr_fifo_dout; 
assign cur_pg_ptr_valid  = pg_ptr_fifo_valid;
assign pg_ptr_fifo_rd_en = ~pg_ptr_fifo_empty & rd_pg_data_done;
//------------------------------------------------------------------------------
// Page data
// Note: 
// support page address aligned with AXI data width only
//------------------------------------------------------------------------------
// page data RAM write when current AXI read data is page data and one of the RAMs is ready
// RAM write width equal AXI data width 
// when current AXI read data beat written done, read a new AXI data from FIFO
assign is_pg_data_axi_data = axi_rdata_fifo_valid & (axi_rid_fifo_dout == PG_DATA_AXI_ID);
assign pg_data_ram_we = is_pg_data_axi_data;
assign pg_data_axi_rdata_fifo_rd_en = ~axi_rdata_fifo_empty & pg_data_ram_we;
assign is_last_pg_wr_data = &pg_data_ram_waddr;

// Page data RAM write address update once one AXI data written
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    pg_data_ram_waddr <= {PG_RAM_WADDR_WIDTH{1'b0}};
  else if(pg_data_ram_we)
    pg_data_ram_waddr <= pg_data_ram_waddr + 1'b1;
  else
    pg_data_ram_waddr <= pg_data_ram_waddr;
end

// Write page data into RAM0/RAM1 ping-pong
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    is_wr_pg_data_ram0 <= 1'b1;
  else if(fsm_state_rd_attr_id)
    is_wr_pg_data_ram0 <= 1'b1;
  else if(pg_data_ram_we & is_last_pg_wr_data)
    is_wr_pg_data_ram0 <= ~is_wr_pg_data_ram0;
  else
    is_wr_pg_data_ram0 <= is_wr_pg_data_ram0;
end

// RAM0 full set to 1 when RAM0 write done, set to 0 when RAM0 read done
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    pg_data_ram0_full <= 1'b0;
  else if(pg_data_ram0_we & is_last_pg_wr_data)
    pg_data_ram0_full <= 1'b1;
  else if(pg_data_ram_rdone & is_rd_pg_data_ram0)
    pg_data_ram0_full <= 1'b0;
  else
    pg_data_ram0_full <= pg_data_ram0_full;
end

// RAM1 full set to 1 when RAM1 write done, set to 0 when RAM1 read done
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    pg_data_ram1_full <= 1'b0;
  else if(pg_data_ram1_we & is_last_pg_wr_data)
    pg_data_ram1_full <= 1'b1;
  else if(pg_data_ram_rdone & ~is_rd_pg_data_ram0)
    pg_data_ram1_full <= 1'b0;
  else
    pg_data_ram1_full <= pg_data_ram1_full;
end

// write into RAM0 first when RAM0 ready, otherwise write into RAM1
assign pg_data_ram0_we = pg_data_ram_we & is_wr_pg_data_ram0; 
assign pg_data_ram1_we = pg_data_ram_we & ~is_wr_pg_data_ram0; 
assign pg_data_ram0_din = axi_rdata_fifo_dout;
assign pg_data_ram1_din = axi_rdata_fifo_dout;

assign pg_data_ram0_addr = pg_data_ram0_we ? {pg_data_ram_waddr, {PG_RAM_WR_NO_USE_WIDTH{1'b0}}} : pg_data_ram0_raddr;
assign pg_data_ram1_addr = pg_data_ram1_we ? {pg_data_ram_waddr, {PG_RAM_WR_NO_USE_WIDTH{1'b0}}} : pg_data_ram1_raddr;

//---Page data RAM(8KB)
//---two RAMs for ping-pong handling
// Xilinx IP: single port Block RAM
// Write width: AXI data width
// Read width: 32-bit
bram_8k pg_data_ram0 (
  .clka  (clk               ),
  .addra (pg_data_ram0_addr ),
  .wea   (pg_data_ram0_we   ),
  .dina  (pg_data_ram0_din  ),
  .douta (pg_data_ram0_dout )
);

bram_8k pg_data_ram1 (
  .clka  (clk               ),
  .addra (pg_data_ram1_addr ),
  .wea   (pg_data_ram1_we   ),
  .dina  (pg_data_ram1_din  ),
  .douta (pg_data_ram1_dout )
);

// read RAM data
assign pg_data_ram_dout   = is_rd_pg_data_ram0 ? pg_data_ram0_dout : pg_data_ram1_dout;
assign pg_data_ram0_raddr = is_rd_pg_data_ram0 ? pg_data_ram_raddr : 11'b0;
assign pg_data_ram1_raddr = is_rd_pg_data_ram0 ? 11'b0 : pg_data_ram_raddr;

//------------------------------------------------------------------------------
// Scan FSM
//------------------------------------------------------------------------------
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    scan_fsm_cur_state <= RD_PG_HDR;
  else
    scan_fsm_cur_state <= scan_fsm_nxt_state;
end

// Note: The scan FSM assume all the RAMs read latency is one cycle
// first read page header to get pd_lower which is end of line pointer
// then start to read line pointer to get off and length
// use line off to read the line header
// first read infomask2 to check attribute number
// then read infomask to check whether has NULL attr and t_hoff
// if has NULL attr, read t_bits to get bitmap
// start to use t_hoff to access attr one by one using attalign and attlen 
// to perform alignment and increase line off
// if attr is null, do nothing, move to next attr
// if attr is varlen(attlen==-1), get the actual length based on varlen header
// report TOAST attribute error, if the varlen attr header flag bits is TOAST ptr
// if attr is cstring(attlen==-2), count the string length till '\0'
// if the attr is the required attr, start output the attr data on stream port
// when last attr of the line scan output done, read a new line pointer
// when last attr of the page scan output done, read a new page
always@(*) begin
  case(scan_fsm_cur_state)
    RD_PG_HDR:
      if(pg_data_ram_rready)
        scan_fsm_nxt_state = RD_LINE_PTR;
      else
        scan_fsm_nxt_state = RD_PG_HDR;
    RD_LINE_PTR:
      if(is_empty_page)
        scan_fsm_nxt_state = RD_PG_HDR;
      else
        scan_fsm_nxt_state = RD_LINE_HDR1;
    RD_LINE_HDR1:
      scan_fsm_nxt_state = RD_LINE_HDR2;
    RD_LINE_HDR2:
      if(is_attr_num_err)
        scan_fsm_nxt_state = ATTR_NUM_ERR;
      else
        scan_fsm_nxt_state = RD_LINE_HDR3;
    RD_LINE_HDR3:
      if(rd_bitmap_done)
        scan_fsm_nxt_state = ATTR_SCAN;
      else
        scan_fsm_nxt_state = RD_LINE_HDR3;
    ATTR_SCAN:
      if(is_attr_scan_line_end_err)
        scan_fsm_nxt_state = LINE_END_ERR;
      else if(is_varlen_toast)
        scan_fsm_nxt_state = TOAST_ERR;
      else if(is_varlen_pad)
        scan_fsm_nxt_state = DO_VARLEN;
      else if(is_cstring_attr)
        scan_fsm_nxt_state = DO_CSTRING;
      else if(is_expected_attr & ~is_null_attr)
        scan_fsm_nxt_state = PRE_OUT;
      else if(is_null_page_last_expected_attr)
        scan_fsm_nxt_state = RD_PG_HDR;
      else if(is_null_line_last_expected_attr)
        scan_fsm_nxt_state = RD_LINE_PTR;
      else
        scan_fsm_nxt_state = ATTR_SCAN;
    DO_VARLEN:
      if(is_do_varlen_line_end_err)
        scan_fsm_nxt_state = LINE_END_ERR;
      else if(is_varlen_toast)
        scan_fsm_nxt_state = TOAST_ERR;
      else if(is_expected_attr)
        scan_fsm_nxt_state = PRE_OUT;
      else
        scan_fsm_nxt_state = ATTR_SCAN;
    DO_CSTRING:
      if(is_do_cstring_line_end_err)
        scan_fsm_nxt_state = LINE_END_ERR;
      else if(is_cstring_end & is_expected_attr)
        scan_fsm_nxt_state = PRE_OUT;
      else if(is_cstring_end)
        scan_fsm_nxt_state = ATTR_SCAN;
      else
        scan_fsm_nxt_state = DO_CSTRING;
    PRE_OUT:
      scan_fsm_nxt_state = ATTR_OUT;
    ATTR_OUT:
      if(is_stream_timeout_err)
        scan_fsm_nxt_state = STREAM_ERR;
      else if(is_page_last_attr_done)
        scan_fsm_nxt_state = RD_PG_HDR;
      else if(is_line_last_attr_done)
        scan_fsm_nxt_state = RD_LINE_PTR;
      else if(attr_out_done)
        scan_fsm_nxt_state = ATTR_SCAN;
      else
        scan_fsm_nxt_state = ATTR_OUT;
    ATTR_NUM_ERR:
      if(~scan_run)
        scan_fsm_nxt_state = RD_PG_HDR;
      else
        scan_fsm_nxt_state = ATTR_NUM_ERR;
    LINE_END_ERR:
      if(~scan_run)
        scan_fsm_nxt_state = RD_PG_HDR;
      else
        scan_fsm_nxt_state = LINE_END_ERR;
    TOAST_ERR:
      if(~scan_run)
        scan_fsm_nxt_state = RD_PG_HDR;
      else
        scan_fsm_nxt_state = TOAST_ERR;
    STREAM_ERR:
      if(~scan_run)
        scan_fsm_nxt_state = RD_PG_HDR;
      else
        scan_fsm_nxt_state = STREAM_ERR;
    default:
      scan_fsm_nxt_state = RD_PG_HDR;
  endcase
end

assign scan_fsm_state_rd_pg_hdr    = (scan_fsm_cur_state == RD_PG_HDR);
assign scan_fsm_state_rd_line_ptr  = (scan_fsm_cur_state == RD_LINE_PTR);
assign scan_fsm_state_rd_line_hdr1 = (scan_fsm_cur_state == RD_LINE_HDR1);
assign scan_fsm_state_rd_line_hdr2 = (scan_fsm_cur_state == RD_LINE_HDR2);
assign scan_fsm_state_rd_line_hdr3 = (scan_fsm_cur_state == RD_LINE_HDR3);
assign scan_fsm_state_attr_scan    = (scan_fsm_cur_state == ATTR_SCAN);
assign scan_fsm_state_do_varlen    = (scan_fsm_cur_state == DO_VARLEN);
assign scan_fsm_state_do_cstring   = (scan_fsm_cur_state == DO_CSTRING);
assign scan_fsm_state_pre_out      = (scan_fsm_cur_state == PRE_OUT);
assign scan_fsm_state_attr_out     = (scan_fsm_cur_state == ATTR_OUT);
assign scan_fsm_state_attr_num_err = (scan_fsm_cur_state == ATTR_NUM_ERR);
assign scan_fsm_state_line_end_err = (scan_fsm_cur_state == LINE_END_ERR);
assign scan_fsm_state_toast_err    = (scan_fsm_cur_state == TOAST_ERR);
assign scan_fsm_state_stream_err   = (scan_fsm_cur_state == STREAM_ERR);

assign scan_fsm_nxt_state_attr_scan = (scan_fsm_nxt_state == ATTR_SCAN);

assign attr_num_err   = scan_fsm_state_attr_num_err;
assign line_end_err   = scan_fsm_state_line_end_err;
assign toast_attr_err = scan_fsm_state_toast_err;
//------------------------------------------------------------------------------
// Read Page Header and Line Header
//------------------------------------------------------------------------------
// Page RAM0/1 ping-pong handling indicator
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    is_rd_pg_data_ram0 <= 1'b1;
  else if(fsm_state_rd_attr_id)
    is_rd_pg_data_ram0 <= 1'b1;
  else if(pg_data_ram_rdone)
    is_rd_pg_data_ram0 <= ~is_rd_pg_data_ram0;
  else
    is_rd_pg_data_ram0 <= is_rd_pg_data_ram0;
end

assign pg_data_ram_rdone = ((scan_fsm_state_rd_line_ptr & is_empty_page) | 
                            (scan_fsm_state_attr_out & is_page_last_attr_done) |
                            (scan_fsm_state_attr_scan & is_null_page_last_expected_attr));

assign pg_data_ram_rready = (is_rd_pg_data_ram0 & pg_data_ram0_full) | (~is_rd_pg_data_ram0 & pg_data_ram1_full);

// pd_lower ram addr and data
assign pg_hdr_raddr = PG_PD_LOWER_RAM_ADDR;
assign pg_hdr_pd_lower = pg_data_ram_dout[15:0];
assign is_empty_page = (pg_hdr_pd_lower == PG_HDR_LEN);

always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    pg_hdr_pd_lower_l <= 16'b0;
  else if(scan_fsm_state_rd_line_ptr)
    pg_hdr_pd_lower_l <= pg_hdr_pd_lower;
  else
    pg_hdr_pd_lower_l <= pg_hdr_pd_lower_l;
end

// line pointer ram addr and data
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    pg_line_ptr_raddr <= 11'b0;
  else if(scan_fsm_state_rd_pg_hdr)
    pg_line_ptr_raddr <= PG_LP_START_RAM_ADDR;
  else if((scan_fsm_state_attr_out & is_line_last_attr_done) |
          (scan_fsm_state_attr_scan & is_null_line_last_expected_attr))
    pg_line_ptr_raddr <= pg_line_ptr_raddr + 1'b1;
  else
    pg_line_ptr_raddr <= pg_line_ptr_raddr;
end

assign is_pg_last_line = ((pg_line_ptr_raddr + 1'b1) == (pg_hdr_pd_lower_l >> 2));

assign pg_lp_off = pg_data_ram_dout[14: 0];
assign pg_lp_len = pg_data_ram_dout[31:17];

always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    pg_lp_off_l <= 15'b0;
    pg_lp_len_l <= 15'b0;
  end
  else if(scan_fsm_state_rd_line_hdr1) begin
    pg_lp_off_l <= pg_lp_off;
    pg_lp_len_l <= pg_lp_len;
  end
  else begin
    pg_lp_off_l <= pg_lp_off_l;
    pg_lp_len_l <= pg_lp_len_l;
  end
end

// line pointer always MAXALIGN(8byte for 64bit system or 4byte for 32bit system)
// line header infomask2 ram addr and data
assign pg_lh_infomask2_raddr = (pg_lp_off >> 2) + PG_INFOMASK2_RAM_OFF;
assign pg_lh_infomask2 = pg_data_ram_dout[31:16];
assign pg_lh_attr_num  = pg_lh_infomask2 & PG_NATTS_MASK;
assign is_attr_num_err = (pg_lh_attr_num > num_of_rel_attr) ? 1'b1 : 1'b0;

always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    pg_lh_attr_num_l <= 16'b0;
  else if(scan_fsm_state_rd_line_hdr2)
    pg_lh_attr_num_l <= pg_lh_attr_num;
  else
    pg_lh_attr_num_l <= pg_lh_attr_num_l;
end

// line header infomask and t_hoff ram addr and data
assign pg_lh_infomask_raddr = (pg_lp_off_l >> 2) + PG_INFOMASK_RAM_OFF;
assign pg_lh_infomask  = pg_data_ram_dout[15: 0];
assign pg_lh_off       = pg_data_ram_dout[23:16];
assign pg_lh_has_null  = pg_lh_infomask[0];
assign pg_lh_bitmap_8b = {{(MAX_REL_ATTR_NUM-8){1'b0}},pg_data_ram_dout[31:24]};

always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    pg_lh_off_l      <= 8'b0;
    pg_lh_has_null_l <= 1'b0;
  end
  else if(scan_fsm_state_rd_line_hdr3 & (cur_bitmap_num==32'd8)) begin
    pg_lh_off_l      <= pg_lh_off;
    pg_lh_has_null_l <= pg_lh_has_null;
  end
  else begin
    pg_lh_off_l      <= pg_lh_off_l;
    pg_lh_has_null_l <= pg_lh_has_null_l;
  end
end

// line header bitmap ram addr and data
assign pg_lh_bitmap_raddr = (pg_lp_off_l >> 2) + PG_BITMAP_RAM_OFF;
assign pg_lh_off_raddr    = (pg_lp_off_l >> 2) + {5'b0,pg_lh_off[7:2]};
assign pg_lh_off_l_raddr  = (pg_lp_off_l >> 2) + {5'b0,pg_lh_off_l[7:2]};
assign pg_line_hdr3_raddr = ((cur_bitmap_num==32'd8) & (~pg_lh_has_null | is_last_bitmap_data)) ? pg_lh_off_raddr
                             : (is_last_bitmap_data ? pg_lh_off_l_raddr : pg_lh_bitmap_raddr_l);

// bit num of bitmap which is read already
// first 8bit is read with infomask
// other bits is read 32bit once
always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    cur_bitmap_num       <= 32'b0;
    pg_lh_bitmap_raddr_l <= 11'b0;
  end
  else if(scan_fsm_state_rd_line_hdr2) begin
    cur_bitmap_num       <= 32'd8;
    pg_lh_bitmap_raddr_l <= pg_lh_bitmap_raddr;
  end
  else if(scan_fsm_state_rd_line_hdr3) begin
    cur_bitmap_num       <= cur_bitmap_num + 6'd32;
    pg_lh_bitmap_raddr_l <= pg_lh_bitmap_raddr_l + 1'b1;
  end
  else begin
    cur_bitmap_num       <= cur_bitmap_num;
    pg_lh_bitmap_raddr_l <= pg_lh_bitmap_raddr_l;
  end
end

assign pg_lh_bitmap_32b = {{(MAX_REL_ATTR_NUM-32){1'b0}},pg_data_ram_dout};
assign pg_lh_bitmap_all = (pg_lh_bitmap_32b << (cur_bitmap_num-32)) | pg_lh_bitmap_l;

always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    pg_lh_bitmap_l <= {MAX_REL_ATTR_NUM{1'b0}};
  else if(scan_fsm_state_rd_line_hdr3 & (cur_bitmap_num==32'd8))
    pg_lh_bitmap_l <= pg_lh_bitmap_8b;
  else if(scan_fsm_state_rd_line_hdr3)
    pg_lh_bitmap_l <= pg_lh_bitmap_all;
  else
    pg_lh_bitmap_l <= pg_lh_bitmap_l;
end

assign is_last_bitmap_data = ((cur_bitmap_num > pg_lh_attr_num_l) | (cur_bitmap_num == pg_lh_attr_num_l));
assign rd_bitmap_done = ((cur_bitmap_num==32'd8) & ~pg_lh_has_null) | is_last_bitmap_data;

//------------------------------------------------------------------------------
// Column scan (fixed length / varlen / cstring)
//------------------------------------------------------------------------------
// current page line offset from actual attr data(lp_off + t_hoff)
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    cur_attr_off <= 32'b0;
  else if(scan_fsm_state_rd_line_hdr3)
    cur_attr_off <= 32'b0;
  else if(scan_fsm_state_attr_scan)
    cur_attr_off <= attr_scan_nxt_attr_off;
  else if(scan_fsm_state_do_varlen)
    cur_attr_off <= do_varlen_nxt_attr_off;
  else if(scan_fsm_state_do_cstring)
    cur_attr_off <= do_cstring_nxt_attr_off;
  else if(scan_fsm_state_pre_out)
    cur_attr_off <= pre_out_nxt_attr_off;
  else if(scan_fsm_state_attr_out)
    cur_attr_off <= scan_out_nxt_attr_off;
  else
    cur_attr_off <= cur_attr_off;
end

// align the offset based on attalign
assign off_after_attalign = (cur_attr_align==8'h64) ? ((cur_attr_off + 7) & 32'hFFFFFFF8)      //ASCII 'd': double align
                             : ((cur_attr_align==8'h69) ? ((cur_attr_off + 3) & 32'hFFFFFFFC)  //ASCII 'i': int align
                              : ((cur_attr_align==8'h73) ? ((cur_attr_off + 1) & 32'hFFFFFFFE) //ASCII 's': short align
                               : cur_attr_off));                                               //char align

// next offset is current offset if is cstring attr or null attr
// next offset is current offset aligned if is valen padding byte or is expected att to output
// next offset is current offset aligned + current attr length
assign attr_scan_nxt_attr_off = (is_cstring_attr | is_null_attr) ? cur_attr_off   
                                  : ((is_varlen_pad | is_expected_attr) ? off_after_attalign : (off_after_attalign + cur_attr_len));
assign do_varlen_nxt_attr_off = is_expected_attr ? cur_attr_off : cur_attr_off + cur_attr_len;

// page data RAM read addr for ATTR_SCAN and DO_VARLEN state
assign pg_attr_scan_raddr = pg_lh_off_l_raddr + (attr_scan_nxt_attr_off >> 2); 
assign pg_do_varlen_raddr = pg_lh_off_l_raddr + (do_varlen_nxt_attr_off >> 2); 

// current attr end larger than line end error
assign is_attr_scan_line_end_err = ~is_varlen_pad & ~is_cstring_attr & ((pg_lh_off_l + off_after_attalign + cur_attr_len) > pg_lp_len_l);
assign is_do_varlen_line_end_err = ((pg_lh_off_l + cur_attr_off + cur_attr_len) > pg_lp_len_l);

// null attr if current attr id exceeds line header attr number 
// or has null and corresponding bit in bitmap is 0
assign is_null_attr = ((cur_attr_id > pg_lh_attr_num_l) | (cur_attr_id == pg_lh_attr_num_l))
                      | (pg_lh_has_null_l & (((pg_lh_bitmap_l >> cur_attr_id) & {{(MAX_REL_ATTR_NUM-1){1'b0}}, 1'b1})==0));

// first byte data to distinguish varlen types and cstring scan 
assign cur_attr_off_byte_index = {cur_attr_off[1:0],3'b0};
assign cur_attr_first_byte = pg_data_ram_dout[cur_attr_off_byte_index +: 8];

// current attr id in attr scan
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    cur_attr_id <= 32'b0;
  else if(scan_fsm_state_rd_line_hdr3)
    cur_attr_id <= 32'b0;
  else if(scan_fsm_nxt_state_attr_scan)
    cur_attr_id <= cur_attr_id + 1'b1;
  else
    cur_attr_id <= cur_attr_id;
end

// current relation attr descriptor read address
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    cur_rel_attr_ram_raddr <= {REL_ATTR_RAM_ADDR_WIDTH{1'b0}};
  else if(scan_fsm_state_rd_line_hdr3)
    cur_rel_attr_ram_raddr <= {REL_ATTR_RAM_ADDR_WIDTH{1'b0}};
  else
    cur_rel_attr_ram_raddr <= nxt_rel_attr_ram_raddr;
end

// read next relation attr descriptor if ready to scan next attr
assign nxt_rel_attr_ram_raddr = scan_fsm_nxt_state_attr_scan ? (cur_rel_attr_ram_raddr + 1'b1) : cur_rel_attr_ram_raddr;

// read first attr descriptor in read line header3 state
assign rel_attr_ram_raddr = scan_fsm_state_rd_line_hdr3 ? {REL_ATTR_RAM_ADDR_WIDTH{1'b0}} : nxt_rel_attr_ram_raddr;

// current expected attr id from RAM addr
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    cur_attr_id_ram_raddr <= 4'b0;
  else if(scan_fsm_state_rd_line_hdr3)
    cur_attr_id_ram_raddr <= 4'b0;
  else
    cur_attr_id_ram_raddr <= nxt_attr_id_ram_raddr;
end

// read next expected attr id if current expected attr is null or output done
assign nxt_attr_id_ram_raddr = ((scan_fsm_state_attr_scan & is_null_attr & is_expected_attr) | (scan_fsm_state_attr_out & attr_out_done)) 
                                ? (cur_attr_id_ram_raddr + 1'b1) : cur_attr_id_ram_raddr;
assign attr_id_ram_raddr = scan_fsm_state_rd_line_hdr3 ? 4'b0 : nxt_attr_id_ram_raddr;

// last expected attr id
assign is_rd_last_attr_id = ((cur_attr_id_ram_raddr + 1'b1) == num_of_attr_id);
assign is_expected_attr = (cur_attr_id == attr_id_ram_dout);

assign is_null_line_last_expected_attr = is_null_attr & is_expected_attr & is_rd_last_attr_id;
assign is_null_page_last_expected_attr = is_null_line_last_expected_attr & is_pg_last_line;

// attalign and attlen
assign cur_attr_align = rel_attr_ram_dout[23:16];
assign cur_attr_len   = is_varlen_1b ? varlen_1b_len : (is_varlen_4b ? varlen_4b_len : {16'b0,rel_attr_ram_dout[15: 0]});

assign is_cstring_attr = (rel_attr_ram_dout[15:0]==16'hFFFE); // cstring attr if attlen==-2
assign is_varlen_attr  = (rel_attr_ram_dout[15:0]==16'hFFFF); // varlen attr if attlen==-1

// varlen padding byte if first byte==0x00
assign is_varlen_pad = is_varlen_attr & (cur_attr_first_byte==8'h00);

// TOAST attr if varlen and first byte flag==0x01
assign is_varlen_toast = is_varlen_attr & (cur_attr_first_byte==8'h01);

// valen 1 byte attr if first byte flag!=0x01 and first byte flag&0x01==0x01
assign is_varlen_1b  = is_varlen_attr & (|cur_attr_first_byte[7:1]) & (cur_attr_first_byte[0]);
assign varlen_1b_len = {25'b0,cur_attr_first_byte[7:1]};

// valen 4 byte attr first byte flag[1:0]==00 or 10
assign is_varlen_4b  = is_varlen_attr & ((cur_attr_first_byte[1:0]==2'b00) | (cur_attr_first_byte[1:0]==2'b10));
assign varlen_4b_len = {2'b0,pg_data_ram_dout[31:2]};

// record cstring start off
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    cstring_start_off <= 32'b0;
  else if(scan_fsm_state_attr_scan & is_cstring_attr)
    cstring_start_off <= cur_attr_off;
  else
    cstring_start_off <= cstring_start_off;
end

// cstring length
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    cstring_len <= 32'b0;
  else if(scan_fsm_state_attr_scan & is_cstring_attr)
    cstring_len <= 32'b0;
  else if(scan_fsm_state_do_cstring)
    cstring_len <= cstring_len + 1'b1;
  else
    cstring_len <= cstring_len;
end

assign is_cstring_end = (cur_attr_first_byte==8'h00); // ASCII '\0'
assign is_do_cstring_line_end_err = ((pg_lh_off_l + cur_attr_off + 1'b1) > pg_lp_len_l);

// go back to cstring start if the cstring attr is end and expected to output
assign do_cstring_nxt_attr_off = (is_cstring_end & is_expected_attr) ? cstring_start_off : (cur_attr_off + 1'b1);
assign pg_do_cstring_raddr = pg_lh_off_l_raddr + (do_cstring_nxt_attr_off >> 2); 

//------------------------------------------------------------------------------
// Column output data generate
//------------------------------------------------------------------------------
// attr output length and target offset end
always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    attr_out_length     <= 32'b0;
    attr_out_offset_end <= 32'b0;
  end
  else if(scan_fsm_state_do_cstring & is_cstring_end & is_expected_attr) begin
    attr_out_length     <= cstring_len + 1'b1;
    attr_out_offset_end <= cur_attr_off + cstring_len + 1'b1;
  end
  else if((scan_fsm_state_attr_scan | scan_fsm_state_do_varlen) & is_expected_attr) begin
    attr_out_length     <= cur_attr_len;
    attr_out_offset_end <= cur_attr_off + cur_attr_len;
  end
  else begin
    attr_out_length     <= attr_out_length;
    attr_out_offset_end <= attr_out_offset_end;
  end
end

// record output attr start off
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    attr_out_start_off <= 32'b0;
  else if((scan_fsm_state_attr_scan | scan_fsm_state_do_varlen | scan_fsm_state_do_cstring) & is_expected_attr)
    attr_out_start_off <= cur_attr_off;
  else
    attr_out_start_off <= attr_out_start_off;
end

assign attr_out_start_off_byte_index = {attr_out_start_off[1:0],3'b0};

// attr out data low 32bit
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    attr_out_data_low <= 32'b0;
  else if(scan_fsm_state_pre_out | (scan_fsm_state_attr_out & attr_out_beat_done))
    attr_out_data_low <= pg_data_ram_dout;
  else
    attr_out_data_low <= attr_out_data_low;
end

// attr out beat counter for actual data
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    attr_out_data_beat_cnt <= 32'b0;
  else if(scan_fsm_state_pre_out)
    attr_out_data_beat_cnt <= (attr_out_length + 3) >> 2;
  else if(scan_fsm_state_attr_out & attr_out_data_beat_done)
    attr_out_data_beat_cnt <= attr_out_data_beat_cnt - 1'b1;
  else
    attr_out_data_beat_cnt <= attr_out_data_beat_cnt;
end

// attr out beat counter for all data including padding data to 512b
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    attr_out_all_beat_cnt <= 32'b0;
  else if(scan_fsm_state_pre_out)
    attr_out_all_beat_cnt <= ((attr_out_length + 63) & 32'hFFFFFFC0) >> 2;
  else if(scan_fsm_state_attr_out & attr_out_beat_done)
    attr_out_all_beat_cnt <= attr_out_all_beat_cnt - 1'b1;
  else
    attr_out_all_beat_cnt <= attr_out_all_beat_cnt;
end

// pre out state offset
assign pre_out_nxt_attr_off = cur_attr_off + 4;
assign pg_pre_out_raddr = pg_lh_off_l_raddr + (pre_out_nxt_attr_off >> 2); 

// padding data for last beat of attr data
assign attr_out_padding_data = (attr_out_length[1:0]==2'b01) ? 32'h000000FF
                                : ((attr_out_length[1:0]==2'b10) ? 32'h0000FFFF
                                  : ((attr_out_length[1:0]==2'b11) ? 32'h00FFFFFF : 32'hFFFFFFFF));

assign is_last_attr_out_data = (attr_out_data_beat_cnt == 32'd1);
assign is_512b_padding_data  = (attr_out_data_beat_cnt == 32'd0);
assign is_last_attr_out_all  = (attr_out_all_beat_cnt == 32'd1);

// attr out state offset
assign scan_out_nxt_attr_off = attr_out_done ? attr_out_offset_end 
                                : (attr_out_data_beat_done ? (cur_attr_off + 4) : cur_attr_off);
assign pg_scan_out_raddr = pg_lh_off_l_raddr + (scan_out_nxt_attr_off >> 2); 

// attr out data
assign attr_out_data_64b = {pg_data_ram_dout, attr_out_data_low};
assign attr_out_data_32b = attr_out_data_64b[attr_out_start_off_byte_index +: 32];
assign attr_out_data = is_512b_padding_data ? 32'b0 
                        : (is_last_attr_out_data ? (attr_out_data_32b & attr_out_padding_data) : attr_out_data_32b);

// attr out data valid and ready
assign attr_out_data_valid = scan_fsm_state_attr_out;
assign attr_out_data_ready = sel_tready; 

assign attr_out_beat_done      = attr_out_data_valid & attr_out_data_ready;
assign attr_out_data_beat_done = attr_out_beat_done & ~is_512b_padding_data;

assign attr_out_done = attr_out_beat_done & is_last_attr_out_all;
assign is_line_last_attr_done = attr_out_done & is_rd_last_attr_id;
assign is_page_last_attr_done = is_line_last_attr_done & is_pg_last_line;
assign is_rel_last_attr_done  = is_page_last_attr_done & is_rel_last_page;

always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    is_rel_last_attr_done_dl <= 1'b0;
  else
    is_rel_last_attr_done_dl <= is_rel_last_attr_done;
end

// page pointer counter update once one page scan done
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    pg_ptr_done_cnt <= 32'b0;
  else if(fsm_state_rd_attr_id)
    pg_ptr_done_cnt <= 32'b0;
  else if(is_page_last_attr_done)
    pg_ptr_done_cnt <= pg_ptr_done_cnt + 1'b1;
  else
    pg_ptr_done_cnt <= pg_ptr_done_cnt;
end

assign is_rel_last_page = ((pg_ptr_done_cnt + 1'b1) == num_of_pg_ptr);

// Page data RAM read address (potential critical path)
assign pg_data_ram_raddr = scan_fsm_state_attr_scan ? pg_attr_scan_raddr : 
                            scan_fsm_state_rd_line_hdr3 ? pg_line_hdr3_raddr :
                             scan_fsm_state_attr_out ? pg_scan_out_raddr :
                              scan_fsm_state_do_varlen ? pg_do_varlen_raddr :
                               scan_fsm_state_do_cstring ? pg_do_cstring_raddr :
                                scan_fsm_state_rd_line_ptr ? pg_line_ptr_raddr :
                                 scan_fsm_state_pre_out ? pg_pre_out_raddr :
                                  scan_fsm_state_rd_line_hdr1 ? pg_lh_infomask2_raddr :
                                   scan_fsm_state_rd_line_hdr2 ? pg_lh_infomask_raddr :
                                    scan_fsm_state_rd_pg_hdr ? pg_hdr_raddr : 11'b0;

//------------------------------------------------------------------------------
// Column data stream output
// Note:
// For now, column data is output on stream port directly
// 1. page data RAM read data width is same as stream data width 32bit
// 2. reduce output latency
// To make it reusable for various stream data width, add a FIFO with 
// non-symmetric aspect ratios enabled between column data and stream port
//------------------------------------------------------------------------------
// channel number 
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    cur_channel_num <= 4'b0;
  else if(attr_out_done)
    cur_channel_num <= 4'b0;
  else if(is_last_channel_num & attr_out_beat_done)
    cur_channel_num <= 4'b0;
  else if(attr_out_beat_done)
    cur_channel_num <= cur_channel_num + 1'b1;
  else
    cur_channel_num <= cur_channel_num;
end

assign is_last_channel_num = ((cur_channel_num + 1'b1)==`COL_OUT_CHAN_NUM);

// channel select
always@(*) begin
  case(cur_channel_num)
    4'd0: begin    
      channel_sel_bits = 4'b0001;
      sel_tready = channel0_tready;
    end
    4'd1: begin
      channel_sel_bits = 4'b0010;
      sel_tready = channel1_tready;
    end
    4'd2: begin
      channel_sel_bits = 4'b0100;
      sel_tready = channel2_tready;
    end
    4'd3: begin
      channel_sel_bits = 4'b1000;
      sel_tready = channel3_tready;
    end
    default: begin
      channel_sel_bits = 4'b0000;
      sel_tready = 1'b0;
    end
  endcase
end

// column select
always@(*) begin
  case(cur_attr_id_ram_raddr)
    4'd0:    column_sel_bits = 8'b00000001;
    4'd1:    column_sel_bits = 8'b00000010;
    4'd2:    column_sel_bits = 8'b00000100;
    4'd3:    column_sel_bits = 8'b00001000;
    4'd4:    column_sel_bits = 8'b00010000;
    4'd5:    column_sel_bits = 8'b00100000;
    4'd6:    column_sel_bits = 8'b01000000;
    4'd7:    column_sel_bits = 8'b10000000;
    default: column_sel_bits = 8'b00000000;
  endcase
end

assign column0_tvalid = attr_out_data_valid & column_sel_bits[0];
assign column1_tvalid = attr_out_data_valid & column_sel_bits[1];
assign column2_tvalid = attr_out_data_valid & column_sel_bits[2];
assign column3_tvalid = attr_out_data_valid & column_sel_bits[3];
assign column4_tvalid = attr_out_data_valid & column_sel_bits[4];
assign column5_tvalid = attr_out_data_valid & column_sel_bits[5];
assign column6_tvalid = attr_out_data_valid & column_sel_bits[6];
assign column7_tvalid = attr_out_data_valid & column_sel_bits[7];

`ifdef COL_OUT_CHAN_0_EN
assign tvalid_col0_ch0 = column0_tvalid & channel_sel_bits[0];
assign tvalid_col1_ch0 = column1_tvalid & channel_sel_bits[0];
assign tvalid_col2_ch0 = column2_tvalid & channel_sel_bits[0];
assign tvalid_col3_ch0 = column3_tvalid & channel_sel_bits[0];
assign tvalid_col4_ch0 = column4_tvalid & channel_sel_bits[0];
assign tvalid_col5_ch0 = column5_tvalid & channel_sel_bits[0];
assign tvalid_col6_ch0 = column6_tvalid & channel_sel_bits[0];
assign tvalid_col7_ch0 = column7_tvalid & channel_sel_bits[0];

assign tdata_col0_ch0 = attr_out_data;
assign tdata_col1_ch0 = attr_out_data;
assign tdata_col2_ch0 = attr_out_data;
assign tdata_col3_ch0 = attr_out_data;
assign tdata_col4_ch0 = attr_out_data;
assign tdata_col5_ch0 = attr_out_data;
assign tdata_col6_ch0 = attr_out_data;
assign tdata_col7_ch0 = attr_out_data;

assign channel0_tready_bits = {tready_col7_ch0,
                               tready_col6_ch0,
                               tready_col5_ch0,
                               tready_col4_ch0,
                               tready_col3_ch0,
                               tready_col2_ch0,
                               tready_col1_ch0,
                               tready_col0_ch0};
assign channel0_tready = |(channel0_tready_bits & column_sel_bits);

assign tlast_ch0 = is_rel_last_attr_done_dl; 
`endif

`ifdef COL_OUT_CHAN_1_EN
assign tvalid_col0_ch1 = column0_tvalid & channel_sel_bits[1];
assign tvalid_col1_ch1 = column1_tvalid & channel_sel_bits[1];
assign tvalid_col2_ch1 = column2_tvalid & channel_sel_bits[1];
assign tvalid_col3_ch1 = column3_tvalid & channel_sel_bits[1];
assign tvalid_col4_ch1 = column4_tvalid & channel_sel_bits[1];
assign tvalid_col5_ch1 = column5_tvalid & channel_sel_bits[1];
assign tvalid_col6_ch1 = column6_tvalid & channel_sel_bits[1];
assign tvalid_col7_ch1 = column7_tvalid & channel_sel_bits[1];

assign tdata_col0_ch1 = attr_out_data;
assign tdata_col1_ch1 = attr_out_data;
assign tdata_col2_ch1 = attr_out_data;
assign tdata_col3_ch1 = attr_out_data;
assign tdata_col4_ch1 = attr_out_data;
assign tdata_col5_ch1 = attr_out_data;
assign tdata_col6_ch1 = attr_out_data;
assign tdata_col7_ch1 = attr_out_data;

assign channel1_tready_bits = {tready_col7_ch1,
                               tready_col6_ch1,
                               tready_col5_ch1,
                               tready_col4_ch1,
                               tready_col3_ch1,
                               tready_col2_ch1,
                               tready_col1_ch1,
                               tready_col0_ch1};
assign channel1_tready = |(channel1_tready_bits & column_sel_bits);

assign tlast_ch1 = is_rel_last_attr_done_dl; 
`endif

`ifdef COL_OUT_CHAN_2_EN
assign tvalid_col0_ch2 = column0_tvalid & channel_sel_bits[2];
assign tvalid_col1_ch2 = column1_tvalid & channel_sel_bits[2];
assign tvalid_col2_ch2 = column2_tvalid & channel_sel_bits[2];
assign tvalid_col3_ch2 = column3_tvalid & channel_sel_bits[2];
assign tvalid_col4_ch2 = column4_tvalid & channel_sel_bits[2];
assign tvalid_col5_ch2 = column5_tvalid & channel_sel_bits[2];
assign tvalid_col6_ch2 = column6_tvalid & channel_sel_bits[2];
assign tvalid_col7_ch2 = column7_tvalid & channel_sel_bits[2];

assign tdata_col0_ch2 = attr_out_data;
assign tdata_col1_ch2 = attr_out_data;
assign tdata_col2_ch2 = attr_out_data;
assign tdata_col3_ch2 = attr_out_data;
assign tdata_col4_ch2 = attr_out_data;
assign tdata_col5_ch2 = attr_out_data;
assign tdata_col6_ch2 = attr_out_data;
assign tdata_col7_ch2 = attr_out_data;

assign channel2_tready_bits = {tready_col7_ch2,
                               tready_col6_ch2,
                               tready_col5_ch2,
                               tready_col4_ch2,
                               tready_col3_ch2,
                               tready_col2_ch2,
                               tready_col1_ch2,
                               tready_col0_ch2};
assign channel2_tready = |(channel2_tready_bits & column_sel_bits);

assign tlast_ch2 = is_rel_last_attr_done_dl; 
`endif

`ifdef COL_OUT_CHAN_3_EN
assign tvalid_col0_ch3 = column0_tvalid & channel_sel_bits[3];
assign tvalid_col1_ch3 = column1_tvalid & channel_sel_bits[3];
assign tvalid_col2_ch3 = column2_tvalid & channel_sel_bits[3];
assign tvalid_col3_ch3 = column3_tvalid & channel_sel_bits[3];
assign tvalid_col4_ch3 = column4_tvalid & channel_sel_bits[3];
assign tvalid_col5_ch3 = column5_tvalid & channel_sel_bits[3];
assign tvalid_col6_ch3 = column6_tvalid & channel_sel_bits[3];
assign tvalid_col7_ch3 = column7_tvalid & channel_sel_bits[3];

assign tdata_col0_ch3 = attr_out_data;
assign tdata_col1_ch3 = attr_out_data;
assign tdata_col2_ch3 = attr_out_data;
assign tdata_col3_ch3 = attr_out_data;
assign tdata_col4_ch3 = attr_out_data;
assign tdata_col5_ch3 = attr_out_data;
assign tdata_col6_ch3 = attr_out_data;
assign tdata_col7_ch3 = attr_out_data;

assign channel3_tready_bits = {tready_col7_ch3,
                               tready_col6_ch3,
                               tready_col5_ch3,
                               tready_col4_ch3,
                               tready_col3_ch3,
                               tready_col2_ch3,
                               tready_col1_ch3,
                               tready_col0_ch3};
assign channel3_tready = |(channel3_tready_bits & column_sel_bits);

assign tlast_ch3 = is_rel_last_attr_done_dl; 
`endif

// stream timeout counter decrease when tvalid and not tready
// when counter is 0, stream port timeout error happened
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    st_timeout_cnt <= 32'hFFFFFFFF;
  else if(fsm_state_idle & scan_run)
    st_timeout_cnt <= scan_stream_timer;
  else if(attr_out_data_valid & sel_tready)
    st_timeout_cnt <= scan_stream_timer;
  else if(attr_out_data_valid & ~sel_tready)
    st_timeout_cnt <= st_timeout_cnt - 1'b1;
end

assign is_stream_timeout_err = (st_timeout_cnt == 32'b0);
assign col0_st_timeout_err = scan_fsm_state_stream_err & column_sel_bits[0];
assign col1_st_timeout_err = scan_fsm_state_stream_err & column_sel_bits[1];
assign col2_st_timeout_err = scan_fsm_state_stream_err & column_sel_bits[2];
assign col3_st_timeout_err = scan_fsm_state_stream_err & column_sel_bits[3];
assign col4_st_timeout_err = scan_fsm_state_stream_err & column_sel_bits[4];
assign col5_st_timeout_err = scan_fsm_state_stream_err & column_sel_bits[5];
assign col6_st_timeout_err = scan_fsm_state_stream_err & column_sel_bits[6];
assign col7_st_timeout_err = scan_fsm_state_stream_err & column_sel_bits[7];

endmodule

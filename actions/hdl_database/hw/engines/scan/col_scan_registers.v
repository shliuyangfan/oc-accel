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

module col_scan_registers #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)
(
    input                        clk,                           //Clock
    input                        rst_n,                         //Reset, active low
    //----- AXI4 lite slave interface -----
    input                        s_axi_lite_arvalid,            //AXI lite slave read address valid
    input  [ADDR_WIDTH-1 : 0]    s_axi_lite_araddr,             //AXI lite slave read address
    output reg                   s_axi_lite_arready,            //AXI lite slave read address ready
    output                       s_axi_lite_rvalid,             //AXI lite slave read valid
    output [DATA_WIDTH-1 : 0]    s_axi_lite_rdata,              //AXI lite slave read data
    output [1 : 0]               s_axi_lite_rresp,              //AXI lite slave read response
    input                        s_axi_lite_rready,             //AXI lite slave read ready
    input                        s_axi_lite_awvalid,            //AXI lite slave write address valid
    input  [ADDR_WIDTH-1 : 0]    s_axi_lite_awaddr,             //AXI lite slave write address
    output reg                   s_axi_lite_awready,            //AXI lite slave write address ready
    input                        s_axi_lite_wvalid,             //AXI lite slave write valid
    input  [DATA_WIDTH-1 : 0]    s_axi_lite_wdata,              //AXI lite slave write data
    input  [DATA_WIDTH/8-1 : 0]  s_axi_lite_wstrb,              //AXI lite slave write strobes
    output reg                   s_axi_lite_wready,             //AXI lite slave write ready
    output                       s_axi_lite_bvalid,             //AXI lite slave write resp valid
    output [1 : 0]               s_axi_lite_bresp,              //AXI lite slave write resp response
    input                        s_axi_lite_bready,             //AXI lite slave write resp ready
    //----- AXI4 lite master interface -----
    output                       m_axi_lite_arvalid,            //AXI lite master read address valid
    output [ADDR_WIDTH-1 : 0]    m_axi_lite_araddr,             //AXI lite master read address
    input                        m_axi_lite_arready,            //AXI lite master read address ready
    input                        m_axi_lite_rvalid,             //AXI lite master read valid
    input  [DATA_WIDTH-1 : 0 ]   m_axi_lite_rdata,              //AXI lite master read data
    input  [1 : 0 ]              m_axi_lite_rresp,              //AXI lite master read response
    output reg                   m_axi_lite_rready,             //AXI lite master read ready
    output                       m_axi_lite_awvalid,            //AXI lite master write address valid
    output [ADDR_WIDTH-1 : 0]    m_axi_lite_awaddr,             //AXI lite master write address
    input                        m_axi_lite_awready,            //AXI lite master write address ready
    output                       m_axi_lite_wvalid,             //AXI lite master write valid
    output [DATA_WIDTH-1 : 0 ]   m_axi_lite_wdata,              //AXI lite master write data
    output [DATA_WIDTH/8-1 : 0]  m_axi_lite_wstrb,              //AXI lite master write strobes
    input                        m_axi_lite_wready,             //AXI lite master write ready
    input                        m_axi_lite_bvalid,             //AXI lite master write resp valid
    input  [1 : 0 ]              m_axi_lite_bresp,              //AXI lite master write resp response
    output reg                   m_axi_lite_bready,             //AXI lite master write resp ready
    //----- Scan lane interface -----
`ifdef COL_SCAN_LANE_0_EN
    output [63: 0]               scan0_tab0_pg_buf_addr,        //Scan lane0 table0 page point buffer start addr
    output [31: 0]               scan0_tab0_pg_buf_size,        //Scan lane0 table0 page point buffer size
    output [63: 0]               scan0_tab0_rel_attr_buf_addr,  //Scan lane0 table0 relation attribute buffer start addr
    output [31: 0]               scan0_tab0_rel_attr_buf_size,  //Scan lane0 table0 relation attribute buffer size
    output [63: 0]               scan0_tab0_attr_id_buf_addr,   //Scan lane0 table0 attribute id buffer start addr
    output [31: 0]               scan0_tab0_attr_id_buf_size,   //Scan lane0 table0 attribute id buffer size
    output                       scan0_tab1_en,                 //Scan lane0 table1 enable
    output [63: 0]               scan0_tab1_pg_buf_addr,        //Scan lane0 table1 page point buffer start addr
    output [31: 0]               scan0_tab1_pg_buf_size,        //Scan lane0 table1 page point buffer size
    output [63: 0]               scan0_tab1_rel_attr_buf_addr,  //Scan lane0 table1 relation attribute buffer start addr
    output [31: 0]               scan0_tab1_rel_attr_buf_size,  //Scan lane0 table1 relation attribute buffer size
    output [63: 0]               scan0_tab1_attr_id_buf_addr,   //Scan lane0 table1 attribute id buffer start addr
    output [31: 0]               scan0_tab1_attr_id_buf_size,   //Scan lane0 table1 attribute id buffer size
    output [31: 0]               scan0_stream_timer,            //Scan lane0 stream timeout timer
    input                        scan0_busy,                    //Scan lane0 is busy
    input                        scan0_pg_buf_rd_err,           //Scan lane0 page point buffer read error
    input                        scan0_rel_attr_buf_rd_err,     //Scan lane0 relation attribute buffer read error
    input                        scan0_attr_id_buf_rd_err,      //Scan lane0 attribute id buffer read error
    input                        scan0_pg_data_rd_err,          //Scan lane0 page data read error
    input                        scan0_attr_num_err,            //Scan lane0 attribute number error
    input                        scan0_line_end_err,            //Scan lane0 unexpected line end error
    input                        scan0_toast_attr_err,          //Scan lane0 unexpected TOAST attribute error
    input                        scan0_col0_st_timeout_err,     //Scan lane0 column0 stream timeout error
    input                        scan0_col1_st_timeout_err,     //Scan lane0 column1 stream timeout error
    input                        scan0_col2_st_timeout_err,     //Scan lane0 column2 stream timeout error
    input                        scan0_col3_st_timeout_err,     //Scan lane0 column3 stream timeout error
    input                        scan0_col4_st_timeout_err,     //Scan lane0 column4 stream timeout error
    input                        scan0_col5_st_timeout_err,     //Scan lane0 column5 stream timeout error
    input                        scan0_col6_st_timeout_err,     //Scan lane0 column6 stream timeout error
    input                        scan0_col7_st_timeout_err,     //Scan lane0 column7 stream timeout error
`endif
`ifdef COL_SCAN_LANE_1_EN
    output [63: 0]               scan1_tab0_pg_buf_addr,        //Scan lane1 table0 page point buffer start addr
    output [31: 0]               scan1_tab0_pg_buf_size,        //Scan lane1 table0 page point buffer size
    output [63: 0]               scan1_tab0_rel_attr_buf_addr,  //Scan lane1 table0 relation attribute buffer start addr
    output [31: 0]               scan1_tab0_rel_attr_buf_size,  //Scan lane1 table0 relation attribute buffer size
    output [63: 0]               scan1_tab0_attr_id_buf_addr,   //Scan lane1 table0 attribute id buffer start addr
    output [31: 0]               scan1_tab0_attr_id_buf_size,   //Scan lane1 table0 attribute id buffer size
    output                       scan1_tab1_en,                 //Scan lane1 table1 enable
    output [63: 0]               scan1_tab1_pg_buf_addr,        //Scan lane1 table1 page point buffer start addr
    output [31: 0]               scan1_tab1_pg_buf_size,        //Scan lane1 table1 page point buffer size
    output [63: 0]               scan1_tab1_rel_attr_buf_addr,  //Scan lane1 table1 relation attribute buffer start addr
    output [31: 0]               scan1_tab1_rel_attr_buf_size,  //Scan lane1 table1 relation attribute buffer size
    output [63: 0]               scan1_tab1_attr_id_buf_addr,   //Scan lane1 table1 attribute id buffer start addr
    output [31: 0]               scan1_tab1_attr_id_buf_size,   //Scan lane1 table1 attribute id buffer size
    output [31: 0]               scan1_stream_timer,            //Scan lane1 stream timeout timer
    input                        scan1_busy,                    //Scan lane1 is busy
    input                        scan1_pg_buf_rd_err,           //Scan lane1 page point buffer read error
    input                        scan1_rel_attr_buf_rd_err,     //Scan lane1 relation attribute buffer read error
    input                        scan1_attr_id_buf_rd_err,      //Scan lane1 attribute id buffer read error
    input                        scan1_pg_data_rd_err,          //Scan lane1 page data read error
    input                        scan1_attr_num_err,            //Scan lane1 attribute number error
    input                        scan1_line_end_err,            //Scan lane1 unexpected line end error
    input                        scan1_toast_attr_err,          //Scan lane1 unexpected TOAST attribute error
    input                        scan1_col0_st_timeout_err,     //Scan lane1 column0 stream timeout error
    input                        scan1_col1_st_timeout_err,     //Scan lane1 column1 stream timeout error
    input                        scan1_col2_st_timeout_err,     //Scan lane1 column2 stream timeout error
    input                        scan1_col3_st_timeout_err,     //Scan lane1 column3 stream timeout error
    input                        scan1_col4_st_timeout_err,     //Scan lane1 column4 stream timeout error
    input                        scan1_col5_st_timeout_err,     //Scan lane1 column5 stream timeout error
    input                        scan1_col6_st_timeout_err,     //Scan lane1 column6 stream timeout error
    input                        scan1_col7_st_timeout_err,     //Scan lane1 column7 stream timeout error
`endif
    //----- Config lane interface -----
    output [63: 0]               cfg_buf_addr,                  //Config lane data buffer start addr
    output [31: 0]               cfg_buf_size,                  //Config lane data buffer size
    output [31: 0]               cfg_stream_timer,              //Config lane stream timeout timer
    input                        cfg_busy,                      //Config lane is busy
    input                        cfg_buf_rd_err,                //Config lane data buffer read error
    input                        cfg_st_timeout_err,            //Config lane stream timeout error
    output                       engine_run                     //Engine start to run
);
//------------------------------------------------------------------------------
// Internal signals
//------------------------------------------------------------------------------
localparam  STRB_WIDTH  =   DATA_WIDTH/8;
//--- Bypass READ REQ FSM ---
localparam  READ_IDLE   =   4'b0001,
            READ_REQ    =   4'b0010,    //bypass read req to back-end engine
            WAIT_RD_RSP =   4'b0100,    //wait back-end engine read resp
            SEND_RD_RSP =   4'b1000;    //bypass read resp to host

//--- Bypass WRITE REQ FSM ---
parameter   WRITE_IDLE  =   6'b000001,
            WRITE_REQ   =   6'b000010,   //bypass write req to back-end engine
            GET_DATA    =   6'b000100,   //get write data from host
            WRITE_DATA  =   6'b001000,   //bypass write data to back-end engine
            WAIT_WR_RSP =   6'b010000,   //wait back-end engine write resp
            SEND_WR_RSP =   6'b100000;   //bypass write resp to host

reg  [3:0]                 rd_fsm_cur_state;            //read FSM current state
reg  [3:0]                 rd_fsm_nxt_state;            //read FSM next state
wire                       rd_fsm_state_read_idle;      //read FSM state idle
wire                       rd_fsm_state_read_req;       //read FSM state read req
wire                       rd_fsm_state_wait_rd_rsp;    //read FSM state wait read resp
wire                       rd_fsm_state_send_rd_rsp;    //read FSM state send read resp
reg  [5:0]                 wr_fsm_cur_state;            //write FSM current state
reg  [5:0]                 wr_fsm_nxt_state;            //write FSM next state
wire                       wr_fsm_state_write_idle;     //write FSM state idle
wire                       wr_fsm_state_write_req;      //write FSM state write req
wire                       wr_fsm_state_get_data;       //write FSM state get data
wire                       wr_fsm_state_write_data;     //write FSM state write data
wire                       wr_fsm_state_wait_wr_rsp;    //write FSM state wait read resp
wire                       wr_fsm_state_send_wr_rsp;    //write FSM state send read resp
reg  [ADDR_WIDTH-1: 0]     byp_axi_araddr;              //bypass axi read addr
reg  [DATA_WIDTH-1: 0]     byp_axi_rdata;               //bypass axi read data
reg  [1:0]                 byp_axi_rresp;               //bypass axi read resp
reg  [ADDR_WIDTH-1: 0]     byp_axi_awaddr;              //bypass axi write addr
reg  [DATA_WIDTH-1: 0]     byp_axi_wdata;               //bypass axi write data
reg  [STRB_WIDTH-1: 0]     byp_axi_wstrb;               //bypass axi write strobes
reg  [1:0]                 byp_axi_bresp;               //bypass axi write resp
wire                       byp_rd_req_valid;            //indicate read req bypass valid
wire                       scan_rd_req_valid;           //indicate read scan engine req valid
wire                       byp_wr_req_valid;            //indicate write req bypass valid
wire                       scan_wr_req_valid;           //indicate write scan engine req valid
reg                        scan_wr_req_valid_l;         //latch for scan_wr_req_valid
wire                       is_scan_araddr;              //read addr is scan engine space
wire                       is_scan_awaddr;              //write addr is scan engine space
wire                       is_scan_rd_req;              //indicate scan engine read req
wire                       is_scan_wr_req;              //indicate scan engine write req
wire                       is_byp_rd_req;               //indicate back-end engine read req
wire                       is_byp_wr_req;               //indicate back-end engine write req
reg  [ADDR_WIDTH-1: 0]     scan_axi_awaddr;             //scan engine axi write addr
wire [DATA_WIDTH-1: 0]     scan_axi_wr_mask;            //scan engine axi write mask
wire [DATA_WIDTH-1: 0]     scan_axi_wdata_mask;         //scan engine axi write data after mask
reg                        scan_axi_bvalid;             //scan engine axi write resp valid
reg                        scan_axi_rvalid;             //scan engine axi read data valid
reg  [DATA_WIDTH-1: 0]     scan_axi_rdata;              //scan engine axi read data
reg                        engine_run_bit_set;          //indicate engine control run bit set

//scan engine registers
`ifdef COL_SCAN_LANE_0_EN
reg  [31:0]                reg_scan0_tab0_pg_buf_addr_lo;
reg  [31:0]                reg_scan0_tab0_pg_buf_addr_hi;
reg  [31:0]                reg_scan0_tab0_pg_buf_len;
reg  [31:0]                reg_scan0_tab0_rel_attr_buf_addr_lo;
reg  [31:0]                reg_scan0_tab0_rel_attr_buf_addr_hi;
reg  [31:0]                reg_scan0_tab0_rel_attr_buf_len;
reg  [31:0]                reg_scan0_tab0_attr_id_buf_addr_lo;
reg  [31:0]                reg_scan0_tab0_attr_id_buf_addr_hi;
reg  [31:0]                reg_scan0_tab0_attr_id_buf_len;
reg  [31:0]                reg_scan0_tab1_pg_buf_addr_lo;
reg  [31:0]                reg_scan0_tab1_pg_buf_addr_hi;
reg  [31:0]                reg_scan0_tab1_pg_buf_len;
reg  [31:0]                reg_scan0_tab1_rel_attr_buf_addr_lo;
reg  [31:0]                reg_scan0_tab1_rel_attr_buf_addr_hi;
reg  [31:0]                reg_scan0_tab1_rel_attr_buf_len;
reg  [31:0]                reg_scan0_tab1_attr_id_buf_addr_lo;
reg  [31:0]                reg_scan0_tab1_attr_id_buf_addr_hi;
reg  [31:0]                reg_scan0_tab1_attr_id_buf_len;
reg  [31:0]                reg_scan0_status;
reg  [31:0]                reg_scan0_stream_timeout;
`endif
`ifdef COL_SCAN_LANE_1_EN
reg  [31:0]                reg_scan1_tab0_pg_buf_addr_lo;
reg  [31:0]                reg_scan1_tab0_pg_buf_addr_hi;
reg  [31:0]                reg_scan1_tab0_pg_buf_len;
reg  [31:0]                reg_scan1_tab0_rel_attr_buf_addr_lo;
reg  [31:0]                reg_scan1_tab0_rel_attr_buf_addr_hi;
reg  [31:0]                reg_scan1_tab0_rel_attr_buf_len;
reg  [31:0]                reg_scan1_tab0_attr_id_buf_addr_lo;
reg  [31:0]                reg_scan1_tab0_attr_id_buf_addr_hi;
reg  [31:0]                reg_scan1_tab0_attr_id_buf_len;
reg  [31:0]                reg_scan1_tab1_pg_buf_addr_lo;
reg  [31:0]                reg_scan1_tab1_pg_buf_addr_hi;
reg  [31:0]                reg_scan1_tab1_pg_buf_len;
reg  [31:0]                reg_scan1_tab1_rel_attr_buf_addr_lo;
reg  [31:0]                reg_scan1_tab1_rel_attr_buf_addr_hi;
reg  [31:0]                reg_scan1_tab1_rel_attr_buf_len;
reg  [31:0]                reg_scan1_tab1_attr_id_buf_addr_lo;
reg  [31:0]                reg_scan1_tab1_attr_id_buf_addr_hi;
reg  [31:0]                reg_scan1_tab1_attr_id_buf_len;
reg  [31:0]                reg_scan1_status;
reg  [31:0]                reg_scan1_stream_timeout;
`endif
reg  [31:0]                reg_cfg_buf_addr_lo;
reg  [31:0]                reg_cfg_buf_addr_hi;
reg  [31:0]                reg_cfg_buf_len;
reg  [31:0]                reg_engine_ctrl;
reg  [31:0]                reg_cfg_status;
reg  [31:0]                reg_cfg_stream_timeout;

//------------------------------------------------------------------------------
// Bypass request to back-end engine
//------------------------------------------------------------------------------
// Read command
//--------------------------------
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    rd_fsm_cur_state <= READ_IDLE;
  else
    rd_fsm_cur_state <= rd_fsm_nxt_state;
end

// if read req addr is not in scan engine space
// latch this read req and bypass to back-end engine
// latch back-end engine read resp when valid
// send resp back to host
always@(*) begin
  case(rd_fsm_cur_state)
    READ_IDLE:
      if(byp_rd_req_valid)
        rd_fsm_nxt_state = READ_REQ;
      else
        rd_fsm_nxt_state = READ_IDLE;
    READ_REQ:
      if(m_axi_lite_arready)
        rd_fsm_nxt_state = WAIT_RD_RSP;
      else
        rd_fsm_nxt_state = READ_REQ;
    WAIT_RD_RSP:
      if(m_axi_lite_rvalid & m_axi_lite_rready)
        rd_fsm_nxt_state = SEND_RD_RSP;
      else
        rd_fsm_nxt_state = WAIT_RD_RSP;
    SEND_RD_RSP:
      if(s_axi_lite_rready)
        rd_fsm_nxt_state = READ_IDLE;
      else
        rd_fsm_nxt_state = SEND_RD_RSP;
    default:
      rd_fsm_nxt_state = READ_IDLE;
  endcase
end

assign rd_fsm_state_read_idle   = rd_fsm_cur_state[0];
assign rd_fsm_state_read_req    = rd_fsm_cur_state[1];
assign rd_fsm_state_wait_rd_rsp = rd_fsm_cur_state[2];
assign rd_fsm_state_send_rd_rsp = rd_fsm_cur_state[3];

// find read addr is in scan engine space or not
assign is_scan_araddr    = ((s_axi_lite_araddr > `SCAN_MMIO_ADDR_START) | (s_axi_lite_araddr == `SCAN_MMIO_ADDR_START)) & (s_axi_lite_araddr < `SCAN_MMIO_ADDR_END);
assign is_scan_rd_req    = s_axi_lite_arvalid & is_scan_araddr; 
assign is_byp_rd_req     = s_axi_lite_arvalid & ~is_scan_araddr; 
assign byp_rd_req_valid  = is_byp_rd_req & s_axi_lite_arready;
assign scan_rd_req_valid = is_scan_rd_req & s_axi_lite_arready;

// latch bypassing read request/data
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    byp_axi_araddr <= {ADDR_WIDTH{1'b0}};
  else if(byp_rd_req_valid)
    byp_axi_araddr <= s_axi_lite_araddr;
  else
    byp_axi_araddr <= byp_axi_araddr;
end

always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    byp_axi_rdata <= {DATA_WIDTH{1'b0}};
    byp_axi_rresp <= 2'b0;
  end
  else if(rd_fsm_state_wait_rd_rsp & m_axi_lite_rvalid) begin
    byp_axi_rdata <= m_axi_lite_rdata;
    byp_axi_rresp <= m_axi_lite_rresp;
  end
  else begin
    byp_axi_rdata <= byp_axi_rdata;
    byp_axi_rresp <= byp_axi_rresp;
  end
end

// bypass read addr to back-end engine
assign m_axi_lite_arvalid = rd_fsm_state_read_req;
assign m_axi_lite_araddr  = byp_axi_araddr;

// data ready to back-end engine
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    m_axi_lite_rready <= 1'b0;
  else if(rd_fsm_state_wait_rd_rsp & m_axi_lite_rvalid)
    m_axi_lite_rready <= 1'b1;
  else if(m_axi_lite_rvalid & m_axi_lite_rready)
    m_axi_lite_rready <= 1'b0;
  else
    m_axi_lite_rready <= m_axi_lite_rready;
end

//--------------------------------
// Write command
//--------------------------------
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    wr_fsm_cur_state <= WRITE_IDLE;
  else
    wr_fsm_cur_state <= wr_fsm_nxt_state;
end

// if write req addr is not in scan engine space
// latch this write req and bypass to back-end engine
// then bypass write data to back-end engine
// latch back-end engine write resp when valid
// send resp back to host
always@(*) begin
  case(wr_fsm_cur_state)
    WRITE_IDLE:
      if(byp_wr_req_valid)
        wr_fsm_nxt_state = WRITE_REQ;
      else
        wr_fsm_nxt_state = WRITE_IDLE;
    WRITE_REQ:
      if(m_axi_lite_awready)
        wr_fsm_nxt_state = GET_DATA;
      else
        wr_fsm_nxt_state = WRITE_REQ;
    GET_DATA:
      if(s_axi_lite_wvalid)
        wr_fsm_nxt_state = WRITE_DATA;
      else
        wr_fsm_nxt_state = GET_DATA;
    WRITE_DATA:
      if(m_axi_lite_wready)
        wr_fsm_nxt_state = WAIT_WR_RSP;
      else
        wr_fsm_nxt_state = WRITE_DATA;
    WAIT_WR_RSP:
      if(m_axi_lite_bvalid & m_axi_lite_bready)
        wr_fsm_nxt_state = SEND_WR_RSP;
      else
        wr_fsm_nxt_state = WAIT_WR_RSP;
    SEND_WR_RSP:
      if(s_axi_lite_bready)
        wr_fsm_nxt_state = WRITE_IDLE;
      else
        wr_fsm_nxt_state = SEND_WR_RSP;
    default:
      wr_fsm_nxt_state = WRITE_IDLE;
  endcase
end

assign wr_fsm_state_write_idle   = wr_fsm_cur_state[0];
assign wr_fsm_state_write_req    = wr_fsm_cur_state[1];
assign wr_fsm_state_get_data     = wr_fsm_cur_state[2];
assign wr_fsm_state_write_data   = wr_fsm_cur_state[3];
assign wr_fsm_state_wait_wr_rsp  = wr_fsm_cur_state[4];
assign wr_fsm_state_send_wr_rsp  = wr_fsm_cur_state[5];

// find write addr is in scan engine space or not
assign is_scan_awaddr    = ((s_axi_lite_awaddr > `SCAN_MMIO_ADDR_START) | (s_axi_lite_awaddr == `SCAN_MMIO_ADDR_START)) & (s_axi_lite_awaddr < `SCAN_MMIO_ADDR_END);
assign is_scan_wr_req    = s_axi_lite_awvalid & is_scan_awaddr;
assign is_byp_wr_req     = s_axi_lite_awvalid & ~is_scan_awaddr;
assign byp_wr_req_valid  = is_byp_wr_req & s_axi_lite_awready;
assign scan_wr_req_valid = is_scan_wr_req & s_axi_lite_awready;

// latch scan engine write valid for resp valid generate
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    scan_wr_req_valid_l <= 1'b0;
  else if(scan_wr_req_valid)
    scan_wr_req_valid_l <= 1'b1;
  else if(s_axi_lite_wvalid & s_axi_lite_wready)
    scan_wr_req_valid_l <= 1'b0;
  else
    scan_wr_req_valid_l <= scan_wr_req_valid_l;
end

// latch bypassing write request/data
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    byp_axi_awaddr <= {ADDR_WIDTH{1'b0}};
  else if(byp_wr_req_valid)
    byp_axi_awaddr <= s_axi_lite_awaddr;
  else
    byp_axi_awaddr <= byp_axi_awaddr;
end

always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    byp_axi_wdata <= {DATA_WIDTH{1'b0}};
    byp_axi_wstrb <= {STRB_WIDTH{1'b0}};
  end
  else if(wr_fsm_state_get_data & s_axi_lite_wvalid) begin
    byp_axi_wdata <= s_axi_lite_wdata;
    byp_axi_wstrb <= s_axi_lite_wstrb;
  end
  else begin
    byp_axi_wdata <= byp_axi_wdata;
    byp_axi_wstrb <= byp_axi_wstrb;
  end
end

// bypass write addr & data to back-end engine
assign m_axi_lite_awvalid = wr_fsm_state_write_req;
assign m_axi_lite_awaddr  = byp_axi_awaddr;
assign m_axi_lite_wvalid  = wr_fsm_state_write_data;
assign m_axi_lite_wdata   = byp_axi_wdata;
assign m_axi_lite_wstrb   = byp_axi_wstrb;

// resp ready to back-end engine
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    m_axi_lite_bready <= 1'b0;
  else if(wr_fsm_state_wait_wr_rsp & m_axi_lite_bvalid)
    m_axi_lite_bready <= 1'b1;
  else if(m_axi_lite_bvalid & m_axi_lite_bready)
    m_axi_lite_bready <= 1'b0;
  else
    m_axi_lite_bready <= m_axi_lite_bready;
end

// latch write resp from back-end engine
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    byp_axi_bresp <= 2'b0;
  else if(wr_fsm_state_wait_wr_rsp & m_axi_lite_bvalid)
    byp_axi_bresp <= m_axi_lite_bresp;
  else
    byp_axi_bresp <= byp_axi_bresp;
end

//------------------------------------------------------------------------------
// Host Write Registers
//------------------------------------------------------------------------------
// write address capture
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    scan_axi_awaddr <= {ADDR_WIDTH{1'b0}};
  else if(scan_wr_req_valid)
    scan_axi_awaddr <= s_axi_lite_awaddr;
  else
    scan_axi_awaddr <= scan_axi_awaddr;
end

// write address ready
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    s_axi_lite_awready <= 1'b0;
  else if(wr_fsm_state_write_idle & s_axi_lite_awvalid)
    s_axi_lite_awready <= 1'b1;
  else if(s_axi_lite_awvalid & s_axi_lite_awready)
    s_axi_lite_awready <= 1'b0;
  else
    s_axi_lite_awready <= s_axi_lite_awready;
end

// write data ready
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    s_axi_lite_wready <= 1'b0;
  else if(s_axi_lite_awvalid & s_axi_lite_awready)
    s_axi_lite_wready <= 1'b1;
  else if(s_axi_lite_wvalid)
    s_axi_lite_wready <= 1'b0;
  else
    s_axi_lite_wready <= s_axi_lite_wready;
end

// write data strobes
assign scan_axi_wr_mask    = {{8{s_axi_lite_wstrb[3]}},{8{s_axi_lite_wstrb[2]}},{8{s_axi_lite_wstrb[1]}},{8{s_axi_lite_wstrb[0]}}};
assign scan_axi_wdata_mask = s_axi_lite_wdata & scan_axi_wr_mask;

always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    scan_axi_bvalid <= 1'b0;
  else if(scan_wr_req_valid_l & s_axi_lite_wvalid & s_axi_lite_wready)
    scan_axi_bvalid <= 1'b1;
  else if(s_axi_lite_bready)
    scan_axi_bvalid <= 1'b0;
  else
    scan_axi_bvalid <= scan_axi_bvalid;
end

// write resp valid
assign s_axi_lite_bvalid = scan_axi_bvalid | wr_fsm_state_send_wr_rsp;
assign s_axi_lite_bresp  = wr_fsm_state_send_wr_rsp ? byp_axi_bresp : 2'd0;

always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
`ifdef COL_SCAN_LANE_0_EN
    reg_scan0_tab0_pg_buf_addr_lo       <= 32'b0;     
    reg_scan0_tab0_pg_buf_addr_hi       <= 32'b0;     
    reg_scan0_tab0_pg_buf_len           <= 32'b0;     
    reg_scan0_tab0_rel_attr_buf_addr_lo <= 32'b0;     
    reg_scan0_tab0_rel_attr_buf_addr_hi <= 32'b0;     
    reg_scan0_tab0_rel_attr_buf_len     <= 32'b0;     
    reg_scan0_tab0_attr_id_buf_addr_lo  <= 32'b0;     
    reg_scan0_tab0_attr_id_buf_addr_hi  <= 32'b0;     
    reg_scan0_tab0_attr_id_buf_len      <= 32'b0;     
    reg_scan0_tab1_pg_buf_addr_lo       <= 32'b0;     
    reg_scan0_tab1_pg_buf_addr_hi       <= 32'b0;     
    reg_scan0_tab1_pg_buf_len           <= 32'b0;     
    reg_scan0_tab1_rel_attr_buf_addr_lo <= 32'b0;     
    reg_scan0_tab1_rel_attr_buf_addr_hi <= 32'b0;     
    reg_scan0_tab1_rel_attr_buf_len     <= 32'b0;     
    reg_scan0_tab1_attr_id_buf_addr_lo  <= 32'b0;     
    reg_scan0_tab1_attr_id_buf_addr_hi  <= 32'b0;     
    reg_scan0_tab1_attr_id_buf_len      <= 32'b0;     
    reg_scan0_stream_timeout            <= 32'hFFFFFFFF;     
`endif
`ifdef COL_SCAN_LANE_1_EN
    reg_scan1_tab0_pg_buf_addr_lo       <= 32'b0;     
    reg_scan1_tab0_pg_buf_addr_hi       <= 32'b0;     
    reg_scan1_tab0_pg_buf_len           <= 32'b0;     
    reg_scan1_tab0_rel_attr_buf_addr_lo <= 32'b0;     
    reg_scan1_tab0_rel_attr_buf_addr_hi <= 32'b0;     
    reg_scan1_tab0_rel_attr_buf_len     <= 32'b0;     
    reg_scan1_tab0_attr_id_buf_addr_lo  <= 32'b0;     
    reg_scan1_tab0_attr_id_buf_addr_hi  <= 32'b0;     
    reg_scan1_tab0_attr_id_buf_len      <= 32'b0;     
    reg_scan1_tab1_pg_buf_addr_lo       <= 32'b0;     
    reg_scan1_tab1_pg_buf_addr_hi       <= 32'b0;     
    reg_scan1_tab1_pg_buf_len           <= 32'b0;     
    reg_scan1_tab1_rel_attr_buf_addr_lo <= 32'b0;     
    reg_scan1_tab1_rel_attr_buf_addr_hi <= 32'b0;     
    reg_scan1_tab1_rel_attr_buf_len     <= 32'b0;     
    reg_scan1_tab1_attr_id_buf_addr_lo  <= 32'b0;     
    reg_scan1_tab1_attr_id_buf_addr_hi  <= 32'b0;     
    reg_scan1_tab1_attr_id_buf_len      <= 32'b0;     
    reg_scan1_stream_timeout            <= 32'hFFFFFFFF;
`endif     
    reg_cfg_buf_addr_lo                 <= 32'b0;     
    reg_cfg_buf_addr_hi                 <= 32'b0;     
    reg_cfg_buf_len                     <= 32'b0;     
    reg_engine_ctrl                     <= 32'b0;     
    reg_cfg_stream_timeout              <= 32'hFFFFFFFF;     
  end
  //write registers
  else if(s_axi_lite_wvalid & s_axi_lite_wready) begin
    case(scan_axi_awaddr)
`ifdef COL_SCAN_LANE_0_EN
      `SCAN0_TAB0_PG_BUF_ADDR_LO        : reg_scan0_tab0_pg_buf_addr_lo       <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab0_pg_buf_addr_lo);
      `SCAN0_TAB0_PG_BUF_ADDR_HI        : reg_scan0_tab0_pg_buf_addr_hi       <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab0_pg_buf_addr_hi);
      `SCAN0_TAB0_PG_BUF_LEN            : reg_scan0_tab0_pg_buf_len           <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab0_pg_buf_len);
      `SCAN0_TAB0_REL_ATTR_BUF_ADDR_LO  : reg_scan0_tab0_rel_attr_buf_addr_lo <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab0_rel_attr_buf_addr_lo);
      `SCAN0_TAB0_REL_ATTR_BUF_ADDR_HI  : reg_scan0_tab0_rel_attr_buf_addr_hi <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab0_rel_attr_buf_addr_hi);
      `SCAN0_TAB0_REL_ATTR_BUF_LEN      : reg_scan0_tab0_rel_attr_buf_len     <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab0_rel_attr_buf_len);
      `SCAN0_TAB0_ATTR_ID_BUF_ADDR_LO   : reg_scan0_tab0_attr_id_buf_addr_lo  <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab0_attr_id_buf_addr_lo);
      `SCAN0_TAB0_ATTR_ID_BUF_ADDR_HI   : reg_scan0_tab0_attr_id_buf_addr_hi  <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab0_attr_id_buf_addr_hi);
      `SCAN0_TAB0_ATTR_ID_BUF_LEN       : reg_scan0_tab0_attr_id_buf_len      <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab0_attr_id_buf_len);
      `SCAN0_TAB1_PG_BUF_ADDR_LO        : reg_scan0_tab1_pg_buf_addr_lo       <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab1_pg_buf_addr_lo);
      `SCAN0_TAB1_PG_BUF_ADDR_HI        : reg_scan0_tab1_pg_buf_addr_hi       <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab1_pg_buf_addr_hi);
      `SCAN0_TAB1_PG_BUF_LEN            : reg_scan0_tab1_pg_buf_len           <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab1_pg_buf_len);
      `SCAN0_TAB1_REL_ATTR_BUF_ADDR_LO  : reg_scan0_tab1_rel_attr_buf_addr_lo <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab1_rel_attr_buf_addr_lo);
      `SCAN0_TAB1_REL_ATTR_BUF_ADDR_HI  : reg_scan0_tab1_rel_attr_buf_addr_hi <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab1_rel_attr_buf_addr_hi);
      `SCAN0_TAB1_REL_ATTR_BUF_LEN      : reg_scan0_tab1_rel_attr_buf_len     <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab1_rel_attr_buf_len);
      `SCAN0_TAB1_ATTR_ID_BUF_ADDR_LO   : reg_scan0_tab1_attr_id_buf_addr_lo  <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab1_attr_id_buf_addr_lo);
      `SCAN0_TAB1_ATTR_ID_BUF_ADDR_HI   : reg_scan0_tab1_attr_id_buf_addr_hi  <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab1_attr_id_buf_addr_hi);
      `SCAN0_TAB1_ATTR_ID_BUF_LEN       : reg_scan0_tab1_attr_id_buf_len      <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_tab1_attr_id_buf_len);
      `SCAN0_STREAM_TIMEOUT             : reg_scan0_stream_timeout            <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan0_stream_timeout);
`endif
`ifdef COL_SCAN_LANE_1_EN
      `SCAN1_TAB0_PG_BUF_ADDR_LO        : reg_scan1_tab0_pg_buf_addr_lo       <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab0_pg_buf_addr_lo);
      `SCAN1_TAB0_PG_BUF_ADDR_HI        : reg_scan1_tab0_pg_buf_addr_hi       <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab0_pg_buf_addr_hi);
      `SCAN1_TAB0_PG_BUF_LEN            : reg_scan1_tab0_pg_buf_len           <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab0_pg_buf_len);
      `SCAN1_TAB0_REL_ATTR_BUF_ADDR_LO  : reg_scan1_tab0_rel_attr_buf_addr_lo <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab0_rel_attr_buf_addr_lo);
      `SCAN1_TAB0_REL_ATTR_BUF_ADDR_HI  : reg_scan1_tab0_rel_attr_buf_addr_hi <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab0_rel_attr_buf_addr_hi);
      `SCAN1_TAB0_REL_ATTR_BUF_LEN      : reg_scan1_tab0_rel_attr_buf_len     <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab0_rel_attr_buf_len);
      `SCAN1_TAB0_ATTR_ID_BUF_ADDR_LO   : reg_scan1_tab0_attr_id_buf_addr_lo  <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab0_attr_id_buf_addr_lo);
      `SCAN1_TAB0_ATTR_ID_BUF_ADDR_HI   : reg_scan1_tab0_attr_id_buf_addr_hi  <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab0_attr_id_buf_addr_hi);
      `SCAN1_TAB0_ATTR_ID_BUF_LEN       : reg_scan1_tab0_attr_id_buf_len      <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab0_attr_id_buf_len);
      `SCAN1_TAB1_PG_BUF_ADDR_LO        : reg_scan1_tab1_pg_buf_addr_lo       <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab1_pg_buf_addr_lo);
      `SCAN1_TAB1_PG_BUF_ADDR_HI        : reg_scan1_tab1_pg_buf_addr_hi       <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab1_pg_buf_addr_hi);
      `SCAN1_TAB1_PG_BUF_LEN            : reg_scan1_tab1_pg_buf_len           <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab1_pg_buf_len);
      `SCAN1_TAB1_REL_ATTR_BUF_ADDR_LO  : reg_scan1_tab1_rel_attr_buf_addr_lo <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab1_rel_attr_buf_addr_lo);
      `SCAN1_TAB1_REL_ATTR_BUF_ADDR_HI  : reg_scan1_tab1_rel_attr_buf_addr_hi <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab1_rel_attr_buf_addr_hi);
      `SCAN1_TAB1_REL_ATTR_BUF_LEN      : reg_scan1_tab1_rel_attr_buf_len     <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab1_rel_attr_buf_len);
      `SCAN1_TAB1_ATTR_ID_BUF_ADDR_LO   : reg_scan1_tab1_attr_id_buf_addr_lo  <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab1_attr_id_buf_addr_lo);
      `SCAN1_TAB1_ATTR_ID_BUF_ADDR_HI   : reg_scan1_tab1_attr_id_buf_addr_hi  <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab1_attr_id_buf_addr_hi);
      `SCAN1_TAB1_ATTR_ID_BUF_LEN       : reg_scan1_tab1_attr_id_buf_len      <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_tab1_attr_id_buf_len);
      `SCAN1_STREAM_TIMEOUT             : reg_scan1_stream_timeout            <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_scan1_stream_timeout);
`endif
      `CFG_BUF_ADDR_LO                  : reg_cfg_buf_addr_lo                 <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_cfg_buf_addr_lo);
      `CFG_BUF_ADDR_HI                  : reg_cfg_buf_addr_hi                 <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_cfg_buf_addr_hi);
      `CFG_BUF_LEN                      : reg_cfg_buf_len                     <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_cfg_buf_len);
      `ENGINE_CTRL                      : reg_engine_ctrl                     <= {31'b0, (scan_axi_wdata_mask[0] | (~scan_axi_wr_mask[0] & reg_engine_ctrl[0]))};
      `CFG_STREAM_TIMEOUT               : reg_cfg_stream_timeout              <= scan_axi_wdata_mask | (~scan_axi_wr_mask & reg_cfg_stream_timeout);
      default:;
    endcase
  end
end

//--------------------------------
//generate pulse of control register run bit setting
//--------------------------------
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    engine_run_bit_set <= 1'b0;
  else if(s_axi_lite_wvalid & s_axi_lite_wready & scan_axi_wdata_mask[0] & (scan_axi_awaddr == `ENGINE_CTRL))
    engine_run_bit_set <= 1'b1;
  else if(engine_run_bit_set)
    engine_run_bit_set <= 1'b0;
  else
    engine_run_bit_set <= engine_run_bit_set;
end

//--------------------------------
//status register
//--------------------------------
`ifdef COL_SCAN_LANE_0_EN
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    reg_scan0_status <= 32'b0;
  //reset on control register run bit setting
  else if(engine_run_bit_set)
    reg_scan0_status <= 32'b0;
  //write 1 clear, bit0 (busy bit RO)
  else if(s_axi_lite_wvalid & s_axi_lite_wready & (scan_axi_awaddr == `SCAN0_STATUS))
    reg_scan0_status <= {19'b0, (~scan_axi_wdata_mask[12:1] & reg_scan0_status[12:1]), reg_scan0_status[0]};
  //read clear
  else if(scan_rd_req_valid & (s_axi_lite_araddr == `SCAN0_STATUS_RC))
    reg_scan0_status <= 32'b0;
  //hw update
  else if(engine_run)
    reg_scan0_status <= {16'b0, 
                         scan0_col7_st_timeout_err,
                         scan0_col6_st_timeout_err,
                         scan0_col5_st_timeout_err,
                         scan0_col4_st_timeout_err,
                         scan0_col3_st_timeout_err,
                         scan0_col2_st_timeout_err,
                         scan0_col1_st_timeout_err,
                         scan0_col0_st_timeout_err,
                         scan0_toast_attr_err,
                         scan0_line_end_err,
                         scan0_attr_num_err,
                         scan0_pg_data_rd_err,
                         scan0_attr_id_buf_rd_err,
                         scan0_rel_attr_buf_rd_err,
                         scan0_pg_buf_rd_err,
                         scan0_busy};
  else
    reg_scan0_status <= reg_scan0_status;
end
`endif

`ifdef COL_SCAN_LANE_1_EN
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    reg_scan1_status <= 32'b0;
  //reset on control register run bit setting
  else if(engine_run_bit_set)
    reg_scan1_status <= 32'b0;
  //write 1 clear, bit0 (busy bit RO)
  else if(s_axi_lite_wvalid & s_axi_lite_wready & (scan_axi_awaddr == `SCAN1_STATUS))
    reg_scan1_status <= {19'b0, (~scan_axi_wdata_mask[12:1] & reg_scan1_status[12:1]), reg_scan1_status[0]};
  //read clear
  else if(scan_rd_req_valid & (s_axi_lite_araddr == `SCAN1_STATUS_RC))
    reg_scan1_status <= 32'b0;
  //hw update
  else if(engine_run)
    reg_scan1_status <= {16'b0, 
                         scan1_col7_st_timeout_err,
                         scan1_col6_st_timeout_err,
                         scan1_col5_st_timeout_err,
                         scan1_col4_st_timeout_err,
                         scan1_col3_st_timeout_err,
                         scan1_col2_st_timeout_err,
                         scan1_col1_st_timeout_err,
                         scan1_col0_st_timeout_err,
                         scan1_toast_attr_err,
                         scan1_line_end_err,
                         scan1_attr_num_err,
                         scan1_pg_data_rd_err,
                         scan1_attr_id_buf_rd_err,
                         scan1_rel_attr_buf_rd_err,
                         scan1_pg_buf_rd_err,
                         scan1_busy};
  else
    reg_scan1_status <= reg_scan1_status;
end
`endif

always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    reg_cfg_status <= 32'b0;
  //reset on control register run bit setting
  else if(engine_run_bit_set)
    reg_cfg_status <= 32'b0;
  //write 1 clear, bit0 (busy bit RO)
  else if(s_axi_lite_wvalid & s_axi_lite_wready & (scan_axi_awaddr == `CFG_STATUS))
    reg_cfg_status <= {29'b0, (~scan_axi_wdata_mask[2:1] & reg_cfg_status[2:1]), reg_cfg_status[0]};
  //read clear
  else if(scan_rd_req_valid & (s_axi_lite_araddr == `CFG_STATUS_RC))
    reg_cfg_status <= 32'b0;
  //hw update
  else if(engine_run)
    reg_cfg_status <= {29'b0, 
                       cfg_st_timeout_err,
                       cfg_buf_rd_err,
                       cfg_busy};
  else
    reg_cfg_status <= reg_cfg_status;
end

//------------------------------------------------------------------------------
// Host Read Registers
//------------------------------------------------------------------------------
// read address ready
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    s_axi_lite_arready <= 1'b0;
  else if(rd_fsm_state_read_idle & s_axi_lite_arvalid)
    s_axi_lite_arready <= 1'b1;
  else if(s_axi_lite_arvalid & s_axi_lite_arready)
    s_axi_lite_arready <= 1'b0;
  else
    s_axi_lite_arready <= s_axi_lite_arready;
end

// odma read data valid
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    scan_axi_rvalid <= 1'b0;
  else if(scan_rd_req_valid)
    scan_axi_rvalid <= 1'b1;
  else if(s_axi_lite_rready)
    scan_axi_rvalid <= 1'b0;
  else
    scan_axi_rvalid <= scan_axi_rvalid;
end

always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    scan_axi_rdata <= 32'd0;
  else if(scan_rd_req_valid)
    case(s_axi_lite_araddr)
`ifdef COL_SCAN_LANE_0_EN
      `SCAN0_TAB0_PG_BUF_ADDR_LO        : scan_axi_rdata <= reg_scan0_tab0_pg_buf_addr_lo;
      `SCAN0_TAB0_PG_BUF_ADDR_HI        : scan_axi_rdata <= reg_scan0_tab0_pg_buf_addr_hi;
      `SCAN0_TAB0_PG_BUF_LEN            : scan_axi_rdata <= reg_scan0_tab0_pg_buf_len;
      `SCAN0_TAB0_REL_ATTR_BUF_ADDR_LO  : scan_axi_rdata <= reg_scan0_tab0_rel_attr_buf_addr_lo;
      `SCAN0_TAB0_REL_ATTR_BUF_ADDR_HI  : scan_axi_rdata <= reg_scan0_tab0_rel_attr_buf_addr_hi;
      `SCAN0_TAB0_REL_ATTR_BUF_LEN      : scan_axi_rdata <= reg_scan0_tab0_rel_attr_buf_len;
      `SCAN0_TAB0_ATTR_ID_BUF_ADDR_LO   : scan_axi_rdata <= reg_scan0_tab0_attr_id_buf_addr_lo;
      `SCAN0_TAB0_ATTR_ID_BUF_ADDR_HI   : scan_axi_rdata <= reg_scan0_tab0_attr_id_buf_addr_hi;
      `SCAN0_TAB0_ATTR_ID_BUF_LEN       : scan_axi_rdata <= reg_scan0_tab0_attr_id_buf_len;
      `SCAN0_TAB1_PG_BUF_ADDR_LO        : scan_axi_rdata <= reg_scan0_tab1_pg_buf_addr_lo;
      `SCAN0_TAB1_PG_BUF_ADDR_HI        : scan_axi_rdata <= reg_scan0_tab1_pg_buf_addr_hi;
      `SCAN0_TAB1_PG_BUF_LEN            : scan_axi_rdata <= reg_scan0_tab1_pg_buf_len;
      `SCAN0_TAB1_REL_ATTR_BUF_ADDR_LO  : scan_axi_rdata <= reg_scan0_tab1_rel_attr_buf_addr_lo;
      `SCAN0_TAB1_REL_ATTR_BUF_ADDR_HI  : scan_axi_rdata <= reg_scan0_tab1_rel_attr_buf_addr_hi;
      `SCAN0_TAB1_REL_ATTR_BUF_LEN      : scan_axi_rdata <= reg_scan0_tab1_rel_attr_buf_len;
      `SCAN0_TAB1_ATTR_ID_BUF_ADDR_LO   : scan_axi_rdata <= reg_scan0_tab1_attr_id_buf_addr_lo;
      `SCAN0_TAB1_ATTR_ID_BUF_ADDR_HI   : scan_axi_rdata <= reg_scan0_tab1_attr_id_buf_addr_hi;
      `SCAN0_TAB1_ATTR_ID_BUF_LEN       : scan_axi_rdata <= reg_scan0_tab1_attr_id_buf_len;
      `SCAN0_STATUS                     : scan_axi_rdata <= reg_scan0_status;
      `SCAN0_STATUS_RC                  : scan_axi_rdata <= reg_scan0_status;
      `SCAN0_STREAM_TIMEOUT             : scan_axi_rdata <= reg_scan0_stream_timeout;
`endif
`ifdef COL_SCAN_LANE_1_EN
      `SCAN1_TAB0_PG_BUF_ADDR_LO        : scan_axi_rdata <= reg_scan1_tab0_pg_buf_addr_lo;
      `SCAN1_TAB0_PG_BUF_ADDR_HI        : scan_axi_rdata <= reg_scan1_tab0_pg_buf_addr_hi;
      `SCAN1_TAB0_PG_BUF_LEN            : scan_axi_rdata <= reg_scan1_tab0_pg_buf_len;
      `SCAN1_TAB0_REL_ATTR_BUF_ADDR_LO  : scan_axi_rdata <= reg_scan1_tab0_rel_attr_buf_addr_lo;
      `SCAN1_TAB0_REL_ATTR_BUF_ADDR_HI  : scan_axi_rdata <= reg_scan1_tab0_rel_attr_buf_addr_hi;
      `SCAN1_TAB0_REL_ATTR_BUF_LEN      : scan_axi_rdata <= reg_scan1_tab0_rel_attr_buf_len;
      `SCAN1_TAB0_ATTR_ID_BUF_ADDR_LO   : scan_axi_rdata <= reg_scan1_tab0_attr_id_buf_addr_lo;
      `SCAN1_TAB0_ATTR_ID_BUF_ADDR_HI   : scan_axi_rdata <= reg_scan1_tab0_attr_id_buf_addr_hi;
      `SCAN1_TAB0_ATTR_ID_BUF_LEN       : scan_axi_rdata <= reg_scan1_tab0_attr_id_buf_len;
      `SCAN1_TAB1_PG_BUF_ADDR_LO        : scan_axi_rdata <= reg_scan1_tab1_pg_buf_addr_lo;
      `SCAN1_TAB1_PG_BUF_ADDR_HI        : scan_axi_rdata <= reg_scan1_tab1_pg_buf_addr_hi;
      `SCAN1_TAB1_PG_BUF_LEN            : scan_axi_rdata <= reg_scan1_tab1_pg_buf_len;
      `SCAN1_TAB1_REL_ATTR_BUF_ADDR_LO  : scan_axi_rdata <= reg_scan1_tab1_rel_attr_buf_addr_lo;
      `SCAN1_TAB1_REL_ATTR_BUF_ADDR_HI  : scan_axi_rdata <= reg_scan1_tab1_rel_attr_buf_addr_hi;
      `SCAN1_TAB1_REL_ATTR_BUF_LEN      : scan_axi_rdata <= reg_scan1_tab1_rel_attr_buf_len;
      `SCAN1_TAB1_ATTR_ID_BUF_ADDR_LO   : scan_axi_rdata <= reg_scan1_tab1_attr_id_buf_addr_lo;
      `SCAN1_TAB1_ATTR_ID_BUF_ADDR_HI   : scan_axi_rdata <= reg_scan1_tab1_attr_id_buf_addr_hi;
      `SCAN1_TAB1_ATTR_ID_BUF_LEN       : scan_axi_rdata <= reg_scan1_tab1_attr_id_buf_len;
      `SCAN1_STATUS                     : scan_axi_rdata <= reg_scan1_status;
      `SCAN1_STATUS_RC                  : scan_axi_rdata <= reg_scan1_status;
      `SCAN1_STREAM_TIMEOUT             : scan_axi_rdata <= reg_scan1_stream_timeout;
`endif
      `CFG_BUF_ADDR_LO                  : scan_axi_rdata <= reg_cfg_buf_addr_lo;
      `CFG_BUF_ADDR_HI                  : scan_axi_rdata <= reg_cfg_buf_addr_hi;
      `CFG_BUF_LEN                      : scan_axi_rdata <= reg_cfg_buf_len;
      `ENGINE_CTRL                      : scan_axi_rdata <= reg_engine_ctrl;
      `CFG_STATUS                       : scan_axi_rdata <= reg_cfg_status;
      `CFG_STATUS_RC                    : scan_axi_rdata <= reg_cfg_status;
      `CFG_STREAM_TIMEOUT               : scan_axi_rdata <= reg_cfg_stream_timeout;
      default                           : scan_axi_rdata <= 32'hdeadbeef;
    endcase
end

// read data valid
assign s_axi_lite_rvalid = scan_axi_rvalid | rd_fsm_state_send_rd_rsp;
assign s_axi_lite_rdata  = rd_fsm_state_send_rd_rsp ? byp_axi_rdata : scan_axi_rdata;
assign s_axi_lite_rresp  = rd_fsm_state_send_rd_rsp ? byp_axi_rresp : 2'd0;

//------------------------------------------------------------------------------
// Registers outputs
//------------------------------------------------------------------------------
`ifdef COL_SCAN_LANE_0_EN
assign scan0_tab0_pg_buf_addr       = {reg_scan0_tab0_pg_buf_addr_hi, reg_scan0_tab0_pg_buf_addr_lo};
assign scan0_tab0_pg_buf_size       = reg_scan0_tab0_pg_buf_len;
assign scan0_tab0_rel_attr_buf_addr = {reg_scan0_tab0_rel_attr_buf_addr_hi, reg_scan0_tab0_rel_attr_buf_addr_lo};
assign scan0_tab0_rel_attr_buf_size = reg_scan0_tab0_rel_attr_buf_len;
assign scan0_tab0_attr_id_buf_addr  = {reg_scan0_tab0_attr_id_buf_addr_hi, reg_scan0_tab0_attr_id_buf_addr_lo};
assign scan0_tab0_attr_id_buf_size  = reg_scan0_tab0_attr_id_buf_len;
assign scan0_tab1_en                = reg_engine_ctrl[1];
assign scan0_tab1_pg_buf_addr       = {reg_scan0_tab1_pg_buf_addr_hi, reg_scan0_tab1_pg_buf_addr_lo};
assign scan0_tab1_pg_buf_size       = reg_scan0_tab1_pg_buf_len;
assign scan0_tab1_rel_attr_buf_addr = {reg_scan0_tab1_rel_attr_buf_addr_hi, reg_scan0_tab1_rel_attr_buf_addr_lo};
assign scan0_tab1_rel_attr_buf_size = reg_scan0_tab1_rel_attr_buf_len;
assign scan0_tab1_attr_id_buf_addr  = {reg_scan0_tab1_attr_id_buf_addr_hi, reg_scan0_tab1_attr_id_buf_addr_lo};
assign scan0_tab1_attr_id_buf_size  = reg_scan0_tab1_attr_id_buf_len;
assign scan0_stream_timer           = reg_scan0_stream_timeout;
`endif

`ifdef COL_SCAN_LANE_1_EN
assign scan1_tab0_pg_buf_addr       = {reg_scan1_tab0_pg_buf_addr_hi, reg_scan1_tab0_pg_buf_addr_lo};
assign scan1_tab0_pg_buf_size       = reg_scan1_tab0_pg_buf_len;
assign scan1_tab0_rel_attr_buf_addr = {reg_scan1_tab0_rel_attr_buf_addr_hi, reg_scan1_tab0_rel_attr_buf_addr_lo};
assign scan1_tab0_rel_attr_buf_size = reg_scan1_tab0_rel_attr_buf_len;
assign scan1_tab0_attr_id_buf_addr  = {reg_scan1_tab0_attr_id_buf_addr_hi, reg_scan1_tab0_attr_id_buf_addr_lo};
assign scan1_tab0_attr_id_buf_size  = reg_scan1_tab0_attr_id_buf_len;
assign scan1_tab1_en                = reg_engine_ctrl[2];
assign scan1_tab1_pg_buf_addr       = {reg_scan1_tab1_pg_buf_addr_hi, reg_scan1_tab1_pg_buf_addr_lo};
assign scan1_tab1_pg_buf_size       = reg_scan1_tab1_pg_buf_len;
assign scan1_tab1_rel_attr_buf_addr = {reg_scan1_tab1_rel_attr_buf_addr_hi, reg_scan1_tab1_rel_attr_buf_addr_lo};
assign scan1_tab1_rel_attr_buf_size = reg_scan1_tab1_rel_attr_buf_len;
assign scan1_tab1_attr_id_buf_addr  = {reg_scan1_tab1_attr_id_buf_addr_hi, reg_scan1_tab1_attr_id_buf_addr_lo};
assign scan1_tab1_attr_id_buf_size  = reg_scan1_tab1_attr_id_buf_len;
assign scan1_stream_timer           = reg_scan1_stream_timeout;
`endif

assign cfg_buf_addr     = {reg_cfg_buf_addr_hi, reg_cfg_buf_addr_lo};
assign cfg_buf_size     = reg_cfg_buf_len;
assign cfg_stream_timer = reg_cfg_stream_timeout;

assign engine_run = reg_engine_ctrl[0];

endmodule

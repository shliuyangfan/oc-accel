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

module col_scan_cfg_lane #(
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
    //----- Stream master interface -----
    output                              m_st_tvalid,            //Stream data valid
    input                               m_st_tready,            //Stream data ready
    output [HLS_ST_DATA_WIDTH-1 : 0]    m_st_tdata,             //Stream data
    output reg                          m_st_tlast,             //Stream data last, assert one cycle after last data
    //----- Register interface -----
    input  [63: 0]                      cfg_buf_addr,           //Config lane data buffer start addr
    input  [31: 0]                      cfg_buf_size,           //Config lane data buffer size
    input  [31: 0]                      cfg_stream_timer,       //Config lane stream timeout timer
    output                              cfg_busy,               //Config lane is busy
    output                              cfg_buf_rd_err,         //Config lane data buffer read error
    output                              cfg_st_timeout_err,     //Config lane stream timeout error
    input                               engine_run,             //Engine start to run
    //----- Scan lane interface -----
    output                              scan_run                //Scan lane start to run
);
//------------------------------------------------------------------------------
// Internal signals
//------------------------------------------------------------------------------
localparam  AXI_DATA_BYTE_WIDTH = `BIT2BYTE_LOG(AXI_MM_DATA_WIDTH);
localparam  ST_DATA_BYTE  = HLS_ST_DATA_WIDTH >> 3;
//--- FSM ---
localparam  IDLE = 3'b000,
            READ = 3'b001,    //issue axi read cmd
            DATA = 3'b010,    //receive axi data and generate stream data out
            DONE = 3'b011,    //finish stream data output
            DERR = 3'b100,    //axi read data error
            TERR = 3'b101;    //stream timeout error

reg     [2  : 0]                    fsm_cur_state;                  //FSM current state
reg     [2  : 0]                    fsm_nxt_state;                  //FSM next state
wire                                fsm_state_idle;                 //FSM state idle
wire                                fsm_state_read;                 //FSM state read
wire                                fsm_state_data;                 //FSM state data
wire                                fsm_state_done;                 //FSM state done
wire                                fsm_state_derr;                 //FSM state axi error
wire                                fsm_state_terr;                 //FSM state stream error
wire    [63 : 0]                    cfg_buf_end_addr;               //config buffer end address
wire    [63 : 0]                    cfg_buf_start_align_addr;       //config buffer aligned start address
wire    [63 : 0]                    cfg_buf_end_align_addr;         //config buffer aligned end address
reg     [63 : 0]                    cur_axi_start_addr;             //current axi read command start address
wire    [63 : 0]                    cur_axi_end_addr;               //current axi read command end address
wire    [7  : 0]                    cur_axi_length;                 //current axi read command length
wire    [63 : 0]                    nxt_axi_4k_addr;                //next axi read command 4KB boundary address
wire                                axi_last_cmd;                   //config buffer last axi read command
wire    [AXI_MM_DATA_WIDTH-1 : 0]   rdata_fifo_din;                 //AXI read data FIFO in
wire                                rdata_fifo_wr_en;               //AXI read data FIFO write enable
wire                                rdata_fifo_rd_en;               //AXI read data FIFO read enable
wire                                rdata_fifo_valid;               //AXI read data FIFO out valid
wire    [AXI_MM_DATA_WIDTH-1 : 0]   rdata_fifo_dout;                //AXI read data FIFO out
wire                                rdata_fifo_full;                //AXI read data FIFO full
wire                                rdata_fifo_empty;               //AXI read data FIFO empty
wire                                axi_rdata_err;                  //config buffer axi read data error
reg     [11 : 0]                    cur_axi2st_data_lsb;            //current lsb on axi read data to generate stream data
wire    [11 : 0]                    nxt_axi2st_data_lsb;            //next lsb on axi read data to generate stream data
reg     [31 : 0]                    st_data_length_left;            //remaining data length in byte for stream data output
wire                                st_last_data;                   //config buffer last stream data beat
wire                                st_timeout_err;                 //stream port timeout error
reg     [31 : 0]                    st_timeout_cnt;                 //stream port timeout counter
//------------------------------------------------------------------------------
// FSM
//------------------------------------------------------------------------------
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    fsm_cur_state <= IDLE;
  else
    fsm_cur_state <= fsm_nxt_state;
end

// when engine_run asserted, start to issue axi read cmd
// receive axi read data and generate stream data out
// when stream data output done, wait engine_run de-asserted
// when axi read data error, stop data transfer, wait engine_run de-asserted
// when stream port timeout error, stop data transfer, wait engine_run de-asserted
always@(*) begin
  case(fsm_cur_state)
    IDLE:
      if(engine_run)
        fsm_nxt_state = READ;
      else
        fsm_nxt_state = IDLE;
    READ:
      if(axi_rdata_err)
        fsm_nxt_state = DERR;
      else if(st_timeout_err)
        fsm_nxt_state = TERR;
      else if(axi_last_cmd & m_axi_arready)
        fsm_nxt_state = DATA;
      else
        fsm_nxt_state = READ;
    DATA:
      if(axi_rdata_err)
        fsm_nxt_state = DERR;
      else if(st_timeout_err)
        fsm_nxt_state = TERR;
      else if(st_last_data & m_st_tready)
        fsm_nxt_state = DONE;
      else
        fsm_nxt_state = DATA;
    DONE:
      if(~engine_run)
        fsm_nxt_state = IDLE;
      else
        fsm_nxt_state = DONE;
    DERR:
      if(~engine_run)
        fsm_nxt_state = IDLE;
      else
        fsm_nxt_state = DERR;
    TERR:
      if(~engine_run)
        fsm_nxt_state = IDLE;
      else
        fsm_nxt_state = TERR;
    default:
      fsm_nxt_state = IDLE;
  endcase
end

assign fsm_state_idle = (fsm_cur_state == IDLE);
assign fsm_state_read = (fsm_cur_state == READ);
assign fsm_state_data = (fsm_cur_state == DATA);
assign fsm_state_done = (fsm_cur_state == DONE);
assign fsm_state_derr = (fsm_cur_state == DERR);
assign fsm_state_terr = (fsm_cur_state == TERR);

//------------------------------------------------------------------------------
// AXI read command
//------------------------------------------------------------------------------
// generate aligned addr and length
assign cfg_buf_end_addr         = cfg_buf_addr + cfg_buf_size;
assign cfg_buf_start_align_addr = {cfg_buf_addr[63 : AXI_DATA_BYTE_WIDTH], {AXI_DATA_BYTE_WIDTH{1'b0}}};
assign cfg_buf_end_align_addr   = (cfg_buf_end_addr[AXI_DATA_BYTE_WIDTH-1 :0] == {AXI_DATA_BYTE_WIDTH{1'b0}}) ? cfg_buf_end_addr
                                   : {cfg_buf_end_addr[63 : AXI_DATA_BYTE_WIDTH] + 1'b1, {AXI_DATA_BYTE_WIDTH{1'b0}}};

// AXI read addr: start from cfg buf addr, update after one cmd sent
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    cur_axi_start_addr <= 64'b0;
  else if(fsm_state_idle & engine_run)
    cur_axi_start_addr <= cfg_buf_start_align_addr;
  else if(fsm_state_read & m_axi_arready)
    cur_axi_start_addr <= cur_axi_end_addr;
  else
    cur_axi_start_addr <= cur_axi_start_addr;
end

// Check axi end addr cross 4KB boundary
// generate axi length and next axi cmd addr
assign nxt_axi_4k_addr  = {cur_axi_start_addr[63:12] + 1'b1, 12'b0};
assign axi_last_cmd     = (cfg_buf_end_align_addr < nxt_axi_4k_addr) | (cfg_buf_end_align_addr == nxt_axi_4k_addr);
assign cur_axi_end_addr = axi_last_cmd ? cfg_buf_end_align_addr : nxt_axi_4k_addr; 
assign cur_axi_length   = ((cur_axi_end_addr - cur_axi_start_addr) >> AXI_DATA_BYTE_WIDTH) - 1'b1;

// AXI read address channel signals
assign m_axi_arvalid  = fsm_state_read;
assign m_axi_araddr   = cur_axi_start_addr;
assign m_axi_arlen    = cur_axi_length;
assign m_axi_arsize   = AXI_DATA_BYTE_WIDTH;
assign m_axi_arburst  = 2'b01;
assign m_axi_arid     = `CFG_DATA_AXI_ID;
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
fifo_fwft_axi_dwidthx8 rdata_fifo (
  .clk          (clk             ),
  .srst         (~rst_n          ),
  .din          (rdata_fifo_din  ),
  .wr_en        (rdata_fifo_wr_en),
  .rd_en        (rdata_fifo_rd_en),
  .valid        (rdata_fifo_valid),
  .dout         (rdata_fifo_dout ),
  .full         (rdata_fifo_full ),
  .empty        (rdata_fifo_empty)
);

// AXI read data write into FIFO
assign rdata_fifo_din   = m_axi_rdata;
assign rdata_fifo_wr_en = m_axi_rvalid & ~rdata_fifo_full;
assign m_axi_rready = ~rdata_fifo_full;
assign axi_rdata_err = m_axi_rvalid & m_axi_rready & (m_axi_rresp != 2'b00);

//------------------------------------------------------------------------------
// Generate stream data output
// Note: 
// 1. support AXI data width larger than stream data width only
// 2. support config buffer address aligned with stream data width only
//    (can be unaligned with AXI data width)
//------------------------------------------------------------------------------
// stream data started on 1st AXI read data is based on cfg buffer addr if unaligned
// for the other beats, stream data always started on LSB
// axi read data LSB updated when one stream data sent out done
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    cur_axi2st_data_lsb <= 12'b0;
  else if(fsm_state_idle & engine_run)
    cur_axi2st_data_lsb <= (cfg_buf_addr[AXI_DATA_BYTE_WIDTH-1 :0] << 3);
  else if(m_st_tvalid & m_st_tready)
    cur_axi2st_data_lsb <= nxt_axi2st_data_lsb;
  else
    cur_axi2st_data_lsb <= cur_axi2st_data_lsb;
end

// when current AXI read data beat generate stream data output done
// read a new AXI data from FIFO, and start stream data output from bit0
assign nxt_axi2st_data_lsb = (cur_axi2st_data_lsb + HLS_ST_DATA_WIDTH == AXI_MM_DATA_WIDTH) 
                               ? 12'b0 : (cur_axi2st_data_lsb + HLS_ST_DATA_WIDTH);
assign rdata_fifo_rd_en = ~rdata_fifo_empty & m_st_tvalid & m_st_tready & (nxt_axi2st_data_lsb == 12'b0);

// remaining stream length update once one stream data beat output
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    st_data_length_left <= 32'b0;
  else if(fsm_state_idle & engine_run)
    st_data_length_left <= cfg_buf_size;
  else if(m_st_tvalid & m_st_tready)
    st_data_length_left <= st_data_length_left - ST_DATA_BYTE;
  else
    st_data_length_left <= st_data_length_left;
end

assign st_last_data = (st_data_length_left == ST_DATA_BYTE);

// stream data valid when AXI read data valid 
// and output length not equal with cfg buffer size
assign m_st_tvalid = (fsm_state_read | fsm_state_data) & rdata_fifo_valid & (st_data_length_left != 32'b0);
assign m_st_tdata  = rdata_fifo_dout[cur_axi2st_data_lsb +: HLS_ST_DATA_WIDTH];

// generate tlast: one cycle after last stream data done
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    m_st_tlast <= 1'b0;
  else if(m_st_tlast)
    m_st_tlast <= 1'b0;
  else if(st_last_data & m_st_tready)
    m_st_tlast <= 1'b1;
end

// stream timeout counter decrease when tvalid and not tready
// when counter is 0, stream port timeout error happened
always@(posedge clk or negedge rst_n) begin
  if(~rst_n)
    st_timeout_cnt <= 32'hFFFFFFFF;
  else if(fsm_state_idle & engine_run)
    st_timeout_cnt <= cfg_stream_timer;
  else if(m_st_tvalid & m_st_tready)
    st_timeout_cnt <= cfg_stream_timer;
  else if(m_st_tvalid & ~m_st_tready)
    st_timeout_cnt <= st_timeout_cnt - 1'b1;
end

assign st_timeout_err = (st_timeout_cnt == 32'b0);
//------------------------------------------------------------------------------
// Status output to Register module
//------------------------------------------------------------------------------
assign cfg_busy = fsm_state_read | fsm_state_data;
assign cfg_buf_rd_err = fsm_state_derr;
assign cfg_st_timeout_err = fsm_state_terr;

//------------------------------------------------------------------------------
// Scan run to Scan lane module
//------------------------------------------------------------------------------
assign scan_run = fsm_state_done;

endmodule

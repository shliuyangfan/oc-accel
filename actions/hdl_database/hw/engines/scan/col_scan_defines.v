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

//------------------------------------------------------------------------------
// Scan lanes and Column channels config
//------------------------------------------------------------------------------
`define COL_SCAN_LANE_1
//`define COL_SCAN_LANE_2

//`define COL_OUT_CHAN_1
//`define COL_OUT_CHAN_2
//`define COL_OUT_CHAN_3
`define COL_OUT_CHAN_4

`ifdef COL_SCAN_LANE_1
    `define COL_SCAN_LANE_NUM   1
    `define COL_SCAN_LANE_0_EN
`elsif COL_SCAN_LANE_2
    `define COL_SCAN_LANE_NUM   2
    `define COL_SCAN_LANE_0_EN
    `define COL_SCAN_LANE_1_EN
`endif

`ifdef COL_OUT_CHAN_1
    `define COL_OUT_CHAN_NUM    1
    `define COL_OUT_CHAN_0_EN
`elsif COL_OUT_CHAN_2
    `define COL_OUT_CHAN_NUM    2
    `define COL_OUT_CHAN_0_EN
    `define COL_OUT_CHAN_1_EN
`elsif COL_OUT_CHAN_3
    `define COL_OUT_CHAN_NUM    3
    `define COL_OUT_CHAN_0_EN
    `define COL_OUT_CHAN_1_EN
    `define COL_OUT_CHAN_2_EN
`elsif COL_OUT_CHAN_4
    `define COL_OUT_CHAN_NUM    4
    `define COL_OUT_CHAN_0_EN
    `define COL_OUT_CHAN_1_EN
    `define COL_OUT_CHAN_2_EN
    `define COL_OUT_CHAN_3_EN
`endif

//------------------------------------------------------------------------------
// AXI IDs
//------------------------------------------------------------------------------
`define CFG_DATA_AXI_ID        0
`define ATTR_ID_BUF_AXI_ID     1
`define REL_ATTR_BUF_AXI_ID    2
`define PAGE_BUF_AXI_ID        3
`define PAGE_DATA_AXI_ID       4

//------------------------------------------------------------------------------
// log2 function
//------------------------------------------------------------------------------
`define LOCAL_LOG2(x) \
    (x == 2)    ? 1  : \
    (x == 4)    ? 2  : \
    (x == 8)    ? 3  : \
    (x == 16)   ? 4  : \
    (x == 32)   ? 5  : \
    (x == 64)   ? 6  : \
    (x == 128)  ? 7  : \
    (x == 256)  ? 8  : \
    (x == 512)  ? 9  : \
    (x == 1024) ? 10 : 0

//------------------------------------------------------------------------------
// Convert bit width to byte log width
//------------------------------------------------------------------------------
`define BIT2BYTE_LOG(x) \
    (x == 8)    ? 0 : \
    (x == 16)   ? 1 : \
    (x == 32)   ? 2 : \
    (x == 64)   ? 3 : \
    (x == 128)  ? 4 : \
    (x == 256)  ? 5 : \
    (x == 512)  ? 6 : \
    (x == 1024) ? 7 : 0

//------------------------------------------------------------------------------
// Regitster address
//------------------------------------------------------------------------------
`define SCAN_MMIO_ADDR_START                32'h00000000
`define SCAN_MMIO_ADDR_END                  32'h00010000
`define SCAN0_TAB0_PG_BUF_ADDR_LO           32'h00000000
`define SCAN0_TAB0_PG_BUF_ADDR_HI           32'h00000004
`define SCAN0_TAB0_PG_BUF_LEN               32'h00000008
`define SCAN0_TAB0_REL_ATTR_BUF_ADDR_LO     32'h0000000C
`define SCAN0_TAB0_REL_ATTR_BUF_ADDR_HI     32'h00000010
`define SCAN0_TAB0_REL_ATTR_BUF_LEN         32'h00000014
`define SCAN0_TAB0_ATTR_ID_BUF_ADDR_LO      32'h00000018
`define SCAN0_TAB0_ATTR_ID_BUF_ADDR_HI      32'h0000001C
`define SCAN0_TAB0_ATTR_ID_BUF_LEN          32'h00000020
`define SCAN0_TAB1_PG_BUF_ADDR_LO           32'h00000040
`define SCAN0_TAB1_PG_BUF_ADDR_HI           32'h00000044
`define SCAN0_TAB1_PG_BUF_LEN               32'h00000048
`define SCAN0_TAB1_REL_ATTR_BUF_ADDR_LO     32'h0000004C
`define SCAN0_TAB1_REL_ATTR_BUF_ADDR_HI     32'h00000050
`define SCAN0_TAB1_REL_ATTR_BUF_LEN         32'h00000054
`define SCAN0_TAB1_ATTR_ID_BUF_ADDR_LO      32'h00000058
`define SCAN0_TAB1_ATTR_ID_BUF_ADDR_HI      32'h0000005C
`define SCAN0_TAB1_ATTR_ID_BUF_LEN          32'h00000060
`define SCAN1_TAB0_PG_BUF_ADDR_LO           32'h00000080
`define SCAN1_TAB0_PG_BUF_ADDR_HI           32'h00000084
`define SCAN1_TAB0_PG_BUF_LEN               32'h00000088
`define SCAN1_TAB0_REL_ATTR_BUF_ADDR_LO     32'h0000008C
`define SCAN1_TAB0_REL_ATTR_BUF_ADDR_HI     32'h00000090
`define SCAN1_TAB0_REL_ATTR_BUF_LEN         32'h00000094
`define SCAN1_TAB0_ATTR_ID_BUF_ADDR_LO      32'h00000098
`define SCAN1_TAB0_ATTR_ID_BUF_ADDR_HI      32'h0000009C
`define SCAN1_TAB0_ATTR_ID_BUF_LEN          32'h000000A0
`define SCAN1_TAB1_PG_BUF_ADDR_LO           32'h000000C0
`define SCAN1_TAB1_PG_BUF_ADDR_HI           32'h000000C4
`define SCAN1_TAB1_PG_BUF_LEN               32'h000000C8
`define SCAN1_TAB1_REL_ATTR_BUF_ADDR_LO     32'h000000CC
`define SCAN1_TAB1_REL_ATTR_BUF_ADDR_HI     32'h000000D0
`define SCAN1_TAB1_REL_ATTR_BUF_LEN         32'h000000D4
`define SCAN1_TAB1_ATTR_ID_BUF_ADDR_LO      32'h000000D8
`define SCAN1_TAB1_ATTR_ID_BUF_ADDR_HI      32'h000000DC
`define SCAN1_TAB1_ATTR_ID_BUF_LEN          32'h000000E0
`define CFG_BUF_ADDR_LO                     32'h00000100
`define CFG_BUF_ADDR_HI                     32'h00000104
`define CFG_BUF_LEN                         32'h00000108
`define ENGINE_CTRL                         32'h00000110
`define SCAN0_STATUS                        32'h00000200
`define SCAN0_STATUS_RC                     32'h00000204
`define SCAN0_STREAM_TIMEOUT                32'h00000208
`define SCAN1_STATUS                        32'h00000210
`define SCAN1_STATUS_RC                     32'h00000214
`define SCAN1_STREAM_TIMEOUT                32'h00000218
`define CFG_STATUS                          32'h00000220
`define CFG_STATUS_RC                       32'h00000224
`define CFG_STREAM_TIMEOUT                  32'h00000228

#
# Copyright 2019 International Business Machines
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and 
# limitations under the License.
#

#set_property MAX_FANOUT 50 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_o/u_NV_NVDLA_cdp/u_dp/u_NV_NVDLA_CDP_DP_intp/u_interp_X./interp_in_shift_d1_reg*]
#set_property MAX_FANOUT 50 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_c/u_NV_NVDLA_csc/u_dl/dat_l0c0_dummy_reg*]
#set_property MAX_FANOUT 60 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_p/u_NV_NVDLA_sdp/u_core/u_bn_dppack/x_prelu_mul*]
#set_property MAX_FANOUT 60 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_p/u_NV_NVDLA_sdp/u_reg/lut_int_addr_reg*]
#set_property MAX_FANOUT 50 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_p/u_NV_NVDLA_sdp/u_core/cfg_bn_mul_bypass_reg*]
#set_property MAX_FANOUT 65 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_o/u_NV_NVDLA_pdp/u_reg/dp2reg_consumer_reg*]
#set_property MAX_FANOUT 65 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_mb/u_NV_NVDLA_cmac/u_core/u_active/dat_actv_data_reg*]
#set_property MAX_FANOUT 65 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_ma/u_NV_NVDLA_cmac/u_core/u_active/wt_pre_sel_reg*]
#set_property MAX_FANOUT 70 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_o/u_NV_NVDLA_cdp/u_wdma/pipe_skid_cdp_dp2wdma_pd_reg*]
#set_property MAX_FANOUT 70 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_o/u_NV_NVDLA_pdp/u_core/u_cal1d/unit1d_0/pipe_dp_*]
#set_property MAX_FANOUT 70 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_o/u_NV_NVDLA_cdp/u_dp/u_NV_NVDLA_CDP_DP_intp/u_interp_X./int_add*]
#set_property MAX_FANOUT 85 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_o/u_NV_NVDLA_cdp/u_dp/u_NV_NVDLA_CDP_DP_intp/u_interp_X./interp_in_shift_d1_reg*]
#set_property MAX_FANOUT 85 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_p/u_NV_NVDLA_sdp/u_core/u_ew/u_lut/pipe_p2/pipe_skid_lut_out_pd_reg*]
#set_property MAX_FANOUT 90 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_mb/u_NV_NVDLA_cmac/u_core/u_mac_12/pp_pvld_d0_d1_reg*]
#set_property MAX_FANOUT 10 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_ma/u_NV_NVDLA_cmac/u_core/u_active/dat_pre_nz_reg*]
#set_property MAX_FANOUT 91 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_o/u_NV_NVDLA_pdp/u_core/u_cal1d/unit1d_0/pooling_cnt*]
#set_property MAX_FANOUT 92 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_p/u_NV_NVDLA_sdp/u_core/cfg_bs_alu_bypass_reg*]
#set_property MAX_FANOUT 130 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_c/u_NV_NVDLA_cbuf/bank2_ram0_data_rd_en_d2_reg*]
#set_property MAX_FANOUT 140 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_c/u_NV_NVDLA_cbuf/bank0_wr0_en_d1_reg*]
#set_property MAX_FANOUT 165 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_mb/u_NV_NVDLA_cmac/u_core/u_active/dat_pre_pvld_reg*]
#set_property MAX_FANOUT 16 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_c/u_NV_NVDLA_cbuf/cdma2buf_wr_data0_d1_reg*]
#set_property MAX_FANOUT 40 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_p/u_NV_NVDLA_sdp/u_core/cfg_bn_alu_operand_reg*]
#set_property MAX_FANOUT 17 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_p/u_NV_NVDLA_sdp/u_core/u_bn/u_sdp_x_alu_.*/x_alu_shiftleft_su/left_shift_sat_carry*]
#set_property MAX_FANOUT 180 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_a/u_NV_NVDLA_cacc/u_delivery_buffer/rd_data_mask_reg*] 
#set_property MAX_FANOUT 50 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_o/u_NV_NVDLA_cdp/u_rdma/u_reg/dp2reg_consumer_reg*]
#set_property MAX_FANOUT 210 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_o/u_NV_NVDLA_cdp/u_rdma/u_reg/u_dual_reg_d1/ram_ff0_reg*]
#set_property MAX_FANOUT 36 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_p/u_NV_NVDLA_sdp/u_core/cfg_bs_mul_src_reg*]
#set_property MAX_FANOUT 30 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_p/u_NV_NVDLA_sdp/u_core/cfg_bs_alu_bypass_reg*]
#set_property MAX_FANOUT 24 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_p/u_NV_NVDLA_sdp/u_core/u_c/c_int_1/sdp_hls_cint_mul*]
#set_property MAX_FANOUT 27 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_c/u_NV_NVDLA_csc/u_sg/u_dat_fifo/dat_pkg_w_offset*]
#set_property MAX_FANOUT 35 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_mb/u_NV_NVDLA_cmac/u_core/u_active/dat_pre_stripe_st_reg*]
##set_property MAX_FANOUT 290 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_mb/u_NV_NVDLA_cmac/u_core/u_active/wt10_actv_data*]
#set_property MAX_FANOUT 35 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_mb/u_NV_NVDLA_cmac/u_core/u_active/wt.*_actv_pvld*]
#set_property MAX_FANOUT 35 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_mb/u_NV_NVDLA_cmac/u_core/u_active/wt.*_sd_pvld_reg*]
#set_property MAX_FANOUT 38 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_a/u_NV_NVDLA_cacc/u_calculator/u_cell_int8_28/i_sum_pd_reg*]
#set_property MAX_FANOUT 50 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_c/u_NV_NVDLA_cdma/u_cvt/cfg_truncate_reg*]
#set_property MAX_FANOUT 50 [get_cells a0/action_w/nvdla_0/nvdla/u_partition_o/u_NV_NVDLA_pdp/u_core/u_cal1d/unit1d_./pipe_dp_1*]
##set_property MAX_FANOUT 50 [get_cells ]

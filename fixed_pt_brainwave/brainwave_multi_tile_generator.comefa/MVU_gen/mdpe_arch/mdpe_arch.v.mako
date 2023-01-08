<%!
    import includes
%>\

module mdpe_arch (
    input clk,
    input rst,
    input start,
    input [`mdpe_vrf_awdith-1:0] vec_wr_addr,
    input [`mdpe_vrf_dwdith-1:0] vec_wr_data,
    input we,
    output layer_done,
    output mdpe_group_out_vld,
    output [`mdpe_group_out_used_dwidth-1:0] mdpe_group_out_data
);


    wire get_src1_addr_sel, get_a0_a1_addr;
    wire [15:0] meta_data;
    wire [`mdpe_num_mvm_ram_per_mdpe-1:0] is_non_zero;
    wire [2*`mdpe_num_mvm_ram_per_mdpe-1:0] src1_addr_sel;

    fsm_top u_fsm_top (
        .clk(clk),
        .rst(rst),
        .start(start),
        .get_src1_addr_sel(get_src1_addr_sel),
        .get_a0_a1_addr(get_a0_a1_addr),
        .vec_wr_addr(vec_wr_addr),
        .wr_vec(vec_wr_data),
        .we(we),
        .layer_done(layer_done),
        .src1_addr_sel(src1_addr_sel),
        .is_non_zero(is_non_zero),
        .meta_data(meta_data)
    );

    wire [`mdpe_group_out_dwidth-1:0] mdpe_group_out_actual_data;
    mdpe_group u_mdpe_group (
        .clk(clk),
        .rst(rst),
        .start(start),
        .meta_data(meta_data),
        .src1_addr_sel(src1_addr_sel),
        .is_non_zero(is_non_zero),
        .get_a0_a1_addr(get_a0_a1_addr),
        .get_src1_addr_sel(get_src1_addr_sel),
        .done(layer_done),
        .out_vld(mdpe_group_out_vld),
        .out_data(mdpe_group_out_actual_data)
    );

//Separate out results from each mdpe
//And then extract only the relevant portion
% for ii in range(includes.num_mdpe):

wire [`mdpe_out_dwidth-1:0] result_mdpe${ii};
assign result_mdpe${ii} = mdpe_group_out_actual_data[(${ii}+1)*`mdpe_out_dwidth-1:${ii}*`mdpe_out_dwidth];

wire [`mdpe_out_used_dwidth-1:0] result_mdpe_used${ii};
  % for jj in range(includes.mdpe_bram_dwidth):
assign result_mdpe_used${ii}[${jj+1}*${includes.mdpe_precision}-1:${jj}*${includes.mdpe_precision}] = result_mdpe${ii}[((${jj}*${includes.result_width})+${includes.mdpe_precision})-1:${jj}*${includes.result_width}];
  % endfor
% endfor 

assign mdpe_group_out_data = {
% for ii in range(includes.num_mdpe):
  % if ii==includes.num_mdpe-1:
  result_mdpe_used${ii}};
  % else:
  result_mdpe_used${ii},
  % endif
% endfor

endmodule


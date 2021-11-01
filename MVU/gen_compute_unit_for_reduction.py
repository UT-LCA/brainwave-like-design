import os
import re
import argparse
import math

#Only tested for the fixed16 dtype
class generate_compute_unit():
  def __init__(self, num_inputs, dtype="float16"):
    self.num_inputs = num_inputs
    self.dtype = dtype
    #find if the num_inputs is a power of 2
    if ((self.num_inputs-1) & self.num_inputs) != 0:
      raise SystemError("the design only supports number of inputs = power of 2")
    #Example num_inputs = 16, actual inputs = 17
    self.total_number_of_inps_for_reduction_unit = self.num_inputs + 1 #1 is for exp_inp
    #For num_inputs = 16, num_compute_stages_in_reduction_unit = 5 (5,4,3,2,1)
    self.num_compute_stages_in_reduction_unit = int(math.log(self.num_inputs,2)) + 1 
    #For num_inputs = 16, num_flop_stages_in_reduction_unit = 5 (includes the input stage. so really in this module, there should be only 4 set of flops generated)
    self.num_flop_stages_in_reduction_unit = self.num_compute_stages_in_reduction_unit
    # self.printit()
  
  def printit(self):
    float_match = re.search(r'float', self.dtype)
    fixed_match = re.search(r'fixed', self.dtype)
    adder_tree_input_gen = ''''''
    for i in range(0, 4):
        adder_tree_input_gen_temp = '''
  input [`DSP_USED_OUTPUT_WIDTH-1:0] inp{i},'''.format(i=i)
        adder_tree_input_gen += adder_tree_input_gen_temp

    adder_tree1 = '''
module adder_tree(
  input clk,
  input rst,'''

    adder_tree2 = '''
  output [`DSP_USED_OUTPUT_WIDTH-1:0] outp
);
'''
    adder_tree = adder_tree1 + adder_tree_input_gen + adder_tree2
    # print(adder_tree)
    # print("")
    # print("module reduction_unit(")
    # print("  clk,")
    # print("  reset,")
    # for iter in range(self.num_inputs):
    #   print("  inp%d, " % iter)
    # print("")
    # print("  mode,")
    # print("  outp")
    # print(");")
    # print("")

    # print("  input clk;")
    # print("  input reset;")
    # for iter in range(self.num_inputs):
    #   print("  input  [`DWIDTH-1 : 0] inp%d; " % iter)
    # print("  input [1:0] mode;")
    # print("  output [`DWIDTH+`LOGDWIDTH-1 : 0] outp;")
    # print("")
    compute_stages_gen = ''''''
    for i in reversed(range(self.num_compute_stages_in_reduction_unit)):
      stageN = i;
      if i == 0:
        # print("  wire   [`DWIDTH+`LOGDWIDTH-1 : 0] compute0_out_stage0;")
        compute_stage0 = '''
  wire   [`DSP_USED_OUTPUT_WIDTH-1 : 0] compute0_out_stage0;'''
        computer_gen += compute_stage0
        compute_stages_gen_temp = compute_stage0
        compute_stages_gen += compute_stages_gen_temp
        break
      else:
        num_computers_in_stageN = int(1<<(i-1))
      computer_gen = ''''''
      for num_computer in range(num_computers_in_stageN):
        computer_gen_temp = '''
  wire   [`DSP_USED_OUTPUT_WIDTH-1 : 0] compute{i}_out_stage{j};
  reg    [`DSP_USED_OUTPUT_WIDTH-1 : 0] compute{i}_out_stage{j}_reg;'''.format(i=num_computer, j=stageN)
        computer_gen += computer_gen_temp
      #   print("  wire   [`DWIDTH+`LOGDWIDTH-1 : 0] compute%d_out_stage%d;" % (num_computer, stageN))
      #   print("  reg    [`DWIDTH+`LOGDWIDTH-1 : 0] compute%d_out_stage%d_reg;" % (num_computer, stageN))
      # print("")
      compute_stages_gen_temp = computer_gen
      compute_stages_gen += compute_stages_gen_temp
    # print(compute_stages_gen)
    compute_out = '''
  reg    [`DSP_USED_OUTPUT_WIDTH-1 : 0] outp;'''
    compute = compute_stages_gen + compute_out
    # print(compute)
    # print("  reg    [`DWIDTH+`LOGDWIDTH-1 : 0] outp;")
    # print("")


#-----------------internal control logic------------------#
    internal_ctrl_logic = '''
  always @(posedge clk) begin
    if (rst) begin
      outp <= 0;'''
    # print("  always @(posedge clk) begin") 
    # print("    if (reset) begin")
    # print("      outp <= 0;")
    for i in reversed(range(self.num_compute_stages_in_reduction_unit)):
      stageN = i;
      if i == 0:
        break
      else:
        num_computers_in_stageN = int(1<<(i-1))
      computer_gen = ''''''
      for num_computer in range(num_computers_in_stageN):
        computer_gen_temp = '''
      compute{i}_out_stage{j}_reg <= 0;'''.format(i=num_computer, j=stageN)
        computer_gen += computer_gen_temp
      # print(computer_gen)
        # print("      compute%d_out_stage%d_reg <= 0;" % (num_computer, stageN))
      internal_ctrl_logic += computer_gen
    # print(internal_ctrl_logic)
    internal_ctrl_logic_else = '''
    end
    else begin
    '''
    internal_ctrl_logic += internal_ctrl_logic_else
    # print("    end")
    # print("")
    # print("    else begin")
    compute_stages_gen = ''''''
    for i in reversed(range(self.num_compute_stages_in_reduction_unit)):
      stageN = i;
      if i == 0:
        # print("      outp <= compute0_out_stage0;")  
        # print("")
        compute_stage0 = '''
      outp <= compute0_out_stage0;'''
        computer_gen += compute_stage0
        compute_stages_gen_temp = compute_stage0
        compute_stages_gen += compute_stages_gen_temp
      else:
        num_computers_in_stageN = int(1<<(i-1))
        computer_gen = ''''''
        for num_computer in range(num_computers_in_stageN):
          # print("      compute%d_out_stage%d_reg <= compute%d_out_stage%d;" %(num_computer, stageN, num_computer, stageN))
          computer_gen_temp = '''
      compute{i}_out_stage{j}_reg <= compute{i}_out_stage{j};'''.format(i=num_computer, j=stageN)
          computer_gen += computer_gen_temp
        #   print("  wire   [`DWIDTH+`LOGDWIDTH-1 : 0] compute%d_out_stage%d;" % (num_computer, stageN))
        #   print("  reg    [`DWIDTH+`LOGDWIDTH-1 : 0] compute%d_out_stage%d_reg;" % (num_computer, stageN))
        # print("")
        compute_stages_gen_temp = computer_gen
        compute_stages_gen += compute_stages_gen_temp
    internal_ctrl_logic += compute_stages_gen
        # print("")
    internal_ctrl_logic_end = '''
    end
  end
    '''
    # print("    end")
    # print("  end")
    # print("")
    internal_ctrl_logic += internal_ctrl_logic_end
    # print(internal_ctrl_logic)

#-----------------Instantiate and connect blocks------------------#
    adder_gen = ''''''
    for stage in reversed(range(self.num_compute_stages_in_reduction_unit)):
      #for the right most stage
      if stage == 0:
        if(self.num_compute_stages_in_reduction_unit > 1):
          if float_match is not None:
            adder_gen_temp = '''
  float_compute #(`MANTISSA, `EXPONENT, `IEEE_COMPLIANCE) compute0_stage0(.a(outp),       .b(compute0_out_stage1_reg),      .z(compute0_out_stage0),     .status());'''
            # print("  float_compute #(`MANTISSA, `EXPONENT, `IEEE_COMPLIANCE) compute0_stage0(.a(outp),       .b(compute0_out_stage1_reg),      .z(compute0_out_stage0),     .status());")
          elif fixed_match is not None:
            adder_gen_temp = '''
  myadder compute0_stage0(
    .a(outp), 
    .b(compute0_out_stage1_reg), 
    .sum(compute0_out_stage0)
  );'''
            # print("  myadder #(`DWIDTH+`LOGDWIDTH,`DWIDTH+`LOGDWIDTH) compute0_stage0(.a(outp),       .b(compute0_out_stage1_reg),     .sum(compute0_out_stage0));")
          else:
            raise SystemExit("Incorrect value passed for dtype. Given = %s. Supported = float16, float32, fixed16, fixed32" % (self.dtype))
        else:
          if float_match is not None:
            adder_gen_temp = '''
  float_compute #(`MANTISSA, `EXPONENT, `IEEE_COMPLIANCE) compute0_stage0(.a(outp),       .b(inp0),      .z(compute0_out_stage0), .status());'''
            # print("  float_compute #(`MANTISSA, `EXPONENT, `IEEE_COMPLIANCE) compute0_stage0(.a(outp),       .b(inp0),      .z(compute0_out_stage0), .status());")
          elif fixed_match is not None:
            adder_gen_temp = '''
  myadder compute0_stage0(
    .a(outp),
    .b(inp0),
    .sum(compute0_out_stage0)
  );'''
            # print("  myadder #(`DWIDTH+`LOGDWIDTH,`DWIDTH+`LOGDWIDTH) compute0_stage0(.a(outp),       .b(inp0),     .sum(compute0_out_stage0));")
          else:
            raise SystemExit("Incorrect value passed for dtype. Given = %s. Supported = float16, float32, fixed16, fixed32" % (self.dtype))
        # print("")
        adder_gen += adder_gen_temp
        # print(adder_gen)
        continue
     
      num_computers_in_current_stage = int(1<<(stage-1))
      num_computer_cur_stage = 0
      num_computer_last_stage = 0

      #for the left most stage
      if stage == self.num_compute_stages_in_reduction_unit - 1:
        inp_num = 0
        for num_computer in range(num_computers_in_current_stage):
          if float_match is not None:
            adder_gen_temp = '''
  float_compute #(`MANTISSA, `EXPONENT, `IEEE_COMPLIANCE) compute{a}_stage{b}(.a(inp{c}),       .b(inp{d}),      .z(compute{a}_out_stage{b}),     .status());'''.format(a=num_computer_cur_stage,b=stage,c=inp_num,d=inp_num+1)
            # print("  float_compute #(`MANTISSA, `EXPONENT, `IEEE_COMPLIANCE) compute%d_stage%d(.a(inp%d),       .b(inp%d),      .z(compute%d_out_stage%d),     .status());" % (num_computer_cur_stage, stage, inp_num, inp_num+1, num_computer_cur_stage, stage))
          elif fixed_match is not None:
            adder_gen_temp = '''
  myadder compute{a}_stage{b}(
    .a(inp{c}),
    .b(inp{d}),
    .sum(compute{a}_out_stage{b})
  );'''.format(a=num_computer_cur_stage,b=stage,c=inp_num,d=inp_num+1)
            # print("  myadder #(`DWIDTH,`DWIDTH+`LOGDWIDTH) compute%d_stage%d(.a(inp%d),       .b(inp%d),    .sum(compute%d_out_stage%d));" % (num_computer_cur_stage, stage, inp_num, inp_num+1, num_computer_cur_stage, stage))
          else:
            raise SystemExit("Incorrect value passed for dtype. Given = %s. Supported = float16, float32, fixed16, fixed32" % (self.dtype))
          inp_num = inp_num + 2
          num_computer_cur_stage = num_computer_cur_stage + 1
        # print("")
          adder_gen += adder_gen_temp
        continue

      #for the stages in the middle
      for num_computer in range(num_computers_in_current_stage):
        if float_match is not None:
          adder_gen_temp = '''
  float_compute #(`MANTISSA, `EXPONENT, `IEEE_COMPLIANCE) compute{a}_stage{b}(.a(compute{a}_out_stage{c}_reg),       .b(compute{d}_out_stage{c}_reg),      .z(compute{a}_out_stage{b}),    .status());'''.format(a=num_computer_cur_stage, b=stage, c=stage+1, d=num_computer_cur_stage+1)
          # print("  float_compute #(`MANTISSA, `EXPONENT, `IEEE_COMPLIANCE) compute%d_stage%d(.a(compute%d_out_stage%d_reg),       .b(compute%d_out_stage%d_reg),      .z(compute%d_out_stage%d),    .status());" % (num_computer_cur_stage, stage, num_computer_last_stage, stage+1, num_computer_last_stage+1, stage+1, num_computer_cur_stage, stage))
        elif fixed_match is not None:
          adder_gen_temp = '''
  myadder compute{a}_stage{b}(
    .a(compute{a}_out_stage{c}_reg),
    .b(compute{d}_out_stage{c}_reg),
    .sum(compute{a}_out_stage{b})
  );'''.format(a=num_computer_cur_stage, b=stage, c=stage+1, d=num_computer_cur_stage+1)
          # print("  myadder #(`DWIDTH+`LOGDWIDTH,`DWIDTH+`LOGDWIDTH) compute%d_stage%d(.a(compute%d_out_stage%d_reg),       .b(compute%d_out_stage%d_reg),    .sum(compute%d_out_stage%d));" % (num_computer_cur_stage, stage, num_computer_last_stage, stage+1, num_computer_last_stage+1, stage+1, num_computer_cur_stage, stage))
        else:
          raise SystemExit("Incorrect value passed for dtype. Given = %s. Supported = float16, float32, fixed16, fixed32" % (self.dtype))
        num_computer_cur_stage = num_computer_cur_stage + 1
        num_computer_last_stage = num_computer_last_stage + 2
      # print("")
        adder_gen += adder_gen_temp

    adder_gen += '''
endmodule
'''
    # print(adder_gen)
    # print("endmodule")
    # print("")
    return adder_tree + compute + internal_ctrl_logic + adder_gen

def generate_instance(num):
  for i in range(0,num):
    print(".inp{a}(bram_in_rdata[{b}*`DWIDTH-1:{a}*`DWIDTH]),".format(a=i, b=i+1))
#  .inp27(bram_in_rdata[28*`DWIDTH-1:27*`DWIDTH]), 

def generate_buffer(num):
  for i in range(0, num):
    print('''
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      q[{j}*`DWIDTH-1 : `DWIDTH*{i}] <= 0;
    end
    else if (en[{i}]) begin
      q[{j}*`DWIDTH-1 : `DWIDTH*{i}] <= d;
    end 
  end  
    '''.format(i=i, j=i+1))

   
# ###############################################################
# main()
# ###############################################################
if __name__ == "__main__":
  generate_compute_unit(4, 'fixed16')
  generate_instance(4)
  #generate_buffer(512)

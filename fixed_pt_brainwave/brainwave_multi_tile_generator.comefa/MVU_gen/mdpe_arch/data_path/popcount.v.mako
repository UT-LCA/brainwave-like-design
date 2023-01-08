<%!
    import math
    import includes
    from includes import depth, log_depth, num_rams_in_mdpe, result_width, popcount_width 
    input_size = num_rams_in_mdpe
    output_size = result_width
%>\

`define DEPTH ${depth}
`define LOG_DEPTH ${log_depth}
`define WIDTH ${num_rams_in_mdpe}
`define RESULT_WIDTH ${result_width}
`define POPCOUNT_WIDTH ${popcount_width}

module popcount(
    clk, rst, 
    inp_vld, outp_vld,
    inp,
    sum
);
    input   clk;
    input   rst;
    input   inp_vld;
    output  outp_vld;

    input   [${input_size-1}:0]     inp;
    output  [${output_size-1}:0]    sum;

/////////////////////////////////////
// Inputs are layer 0
// Format of variables: reduce_layer<layer_number><element_number>
/////////////////////////////////////

% for g in range(0, input_size):
    wire    reduce_layer0${g};
    assign reduce_layer0${g} = inp[${g}];
% endfor

<%
    idx = 1
    layer_inputs = input_size
%>\
% while layer_inputs > 1:
<%
    layer_outputs = math.ceil(layer_inputs / 2)
    odd_input = not (layer_inputs / 2).is_integer()
%>\

/////////////////////////////////////
// Layer ${idx}
/////////////////////////////////////

// Adders
% for g in range(0, layer_outputs - (1 if odd_input else 0)):
    wire    [${idx}:0]  w_reduce_layer${idx}${g};
% endfor

% for g in range(0, layer_outputs - (1 if odd_input else 0)):
    assign w_reduce_layer${idx}${g} = reduce_layer${idx-1}${2*g} + reduce_layer${idx-1}${2*g+1};
% endfor

// Registers
% for g in range(0, layer_outputs - (1 if odd_input else 0)):
    reg     [${idx}:0]  reduce_layer${idx}${g};
% endfor

    always @(posedge clk) begin
      if (rst) begin
% for g in range(0, layer_outputs - (1 if odd_input else 0)):
        reduce_layer${idx}${g} <= 0;
% endfor
      end
      else begin
% for g in range(0, layer_outputs - (1 if odd_input else 0)):
        reduce_layer${idx}${g} <= w_reduce_layer${idx}${g};
% endfor
      end
    end

// Odd input
% if odd_input:
    wire    [${idx}:0]  w_reduce_layer${idx}${layer_outputs-1};
    reg     [${idx}:0]  reduce_layer${idx}${layer_outputs-1};
% if odd_input:
    assign w_reduce_layer${idx}${layer_outputs-1} = reduce_layer${idx-1}${layer_inputs-1};
% endif
    always @(posedge clk) begin
      if (rst) begin
        reduce_layer${idx}${layer_outputs-1} <= 0;
      end
      else begin
        reduce_layer${idx}${layer_outputs-1} <= w_reduce_layer${idx}${layer_outputs-1};
      end
    end
% else:
// N.A.
% endif

<%
    layer_inputs = layer_outputs
    idx += 1
%>\
% endwhile

wire start;
assign start = inp_vld;

reg done;

reg [`POPCOUNT_WIDTH-1:0] popcount;
assign popcount = reduce_layer${idx-1}0;


//now add the popcount value to the accumulator
wire [`RESULT_WIDTH-1:0] accumulator;
reg [`RESULT_WIDTH-1:0] temp_result;
assign accumulator = popcount + temp_result;

reg [`LOG_DEPTH-1:0] count;
reg in_progress;

//now circular shift the result calculated above and flop it
always @(posedge clk) begin
    if (rst) begin
        temp_result <= 0;
        count <= 0;
        done <= 0;
        in_progress <= 0;
    end
    else if (start) begin
        temp_result <= {accumulator[0], accumulator[`RESULT_WIDTH-1:1]};
        count <= count + 1;
        in_progress <= 1;
        done <= 0;
    end
    else if (in_progress) begin
        temp_result <= {accumulator[0], accumulator[`RESULT_WIDTH-1:1]};
        if (count == `DEPTH) begin
            in_progress <= 0;
            done <= 1;
            count <= 0;
        end
        else begin
            in_progress <= 1;
            done <= 0;
            count <= count + 1;
        end
    end
end

assign outp_vld = done;

//in count cycles, the LSB of the result hasn't reached the LSB yet. Some of the supposed-to-be MSB bits are
//near the LSB and need to be moved to the MSB side.
assign sum = {temp_result[`POPCOUNT_WIDTH-1:0], temp_result[`RESULT_WIDTH-1:`POPCOUNT_WIDTH]};

endmodule




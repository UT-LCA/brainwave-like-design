#!/bin/bash

# comments start with a '#"

python3 ./render_template.py -i ./controller_gen/controller.v.mako -o ./controller_gen.v
python3 ./render_template.py -i ./includes_gen/includes.v.mako -o ./includes_gen.v
python3 ./render_template.py -i ./MFU_gen/mfu.v.mako -o ./mfu_gen.v
python3 ./render_template.py -i ./MVU_gen/mvu.v.mako -o ./mvu_gen.v
python3 ./render_template.py -i ./NPU_gen/npu.v.mako -o ./npu_gen.v
python3 ./render_template.py -i asymmetric_fifo.v.mako -o ./asymmetric_fifo.v
python3 ./render_template.py -i program.bwave.mako -o ./program_gen.bwave
#python3 assembler_brainwave.py 
cat ./includes_gen.v ./asymmetric_fifo.v ./npu_gen.v ./controller_gen.v ./mvu_gen.v ./mfu_gen.v > brainwave_1x32x16.v

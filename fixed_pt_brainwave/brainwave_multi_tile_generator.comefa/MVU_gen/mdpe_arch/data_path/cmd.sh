#!/usr/bin/bash
rm -rf data_path.vtr.v
python3 ../render_template.py ../includes.v.mako ./includes.vtr.v
python3 ../render_template.py mdpe_fsm.v.mako ./mdpe_fsm.vtr.v
python3 ../render_template.py mdpe.v.mako ./mdpe.vtr.v
python3 ../render_template.py popcount.v.mako ./popcount.vtr.v
cat includes.vtr.v > data_path.vtr.v
cat mdpe_fsm.vtr.v >> data_path.vtr.v
cat mdpe.vtr.v >> data_path.vtr.v
cat popcount.vtr.v >> data_path.vtr.v

if [[ $1 == "true" ]]; then
    if [[ $2 == "true" ]]; then
        nohup python3 /mnt/ampere2/aman/vtr_aman2/vtr-verilog-to-routing/vtr_flow/scripts/run_vtr_task.py ./vtr_runs > nohup.log &
    else
        python3 /mnt/ampere2/aman/vtr_aman2/vtr-verilog-to-routing/vtr_flow/scripts/run_vtr_task.py ./vtr_runs
    fi 
fi

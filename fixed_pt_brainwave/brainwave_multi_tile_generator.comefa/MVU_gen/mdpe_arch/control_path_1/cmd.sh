#!/usr/bin/bash
rm -rf control_path.vtr.v
python3 ../render_template.py fsm.v.mako ./fsm.vtr.v
python3 ../render_template.py ../includes.v.mako ./includes.vtr.v
cat includes.vtr.v > control_path.vtr.v
cat ../../../simple_dual_port.v >> control_path.vtr.v 
cat fsm.vtr.v >> control_path.vtr.v

if [[ $1 == "true" ]]; then
    if [[ $2 == "true" ]]; then
        nohup python3 /mnt/ampere2/aman/vtr_aman2/vtr-verilog-to-routing/vtr_flow/scripts/run_vtr_task.py ./vtr_runs > nohup.log &
    else
        python3 /mnt/ampere2/aman/vtr_aman2/vtr-verilog-to-routing/vtr_flow/scripts/run_vtr_task.py ./vtr_runs
    fi 
fi

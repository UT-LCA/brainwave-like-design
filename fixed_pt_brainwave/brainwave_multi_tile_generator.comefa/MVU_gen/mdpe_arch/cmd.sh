#!/usr/bin/bash

rm -rf mdpe_arch.vtr.v

python3 render_template.py includes.v.mako ./includes.vtr.v
cat includes.vtr.v > mdpe_arch.vtr.v

cat ../../simple_dual_port.v  >> mdpe_arch.vtr.v

python3 render_template.py mdpe_arch.v.mako ./temp_mdpe_arch.vtr.v
cat temp_mdpe_arch.vtr.v >> mdpe_arch.vtr.v

cd ./control_path_1
bash ./cmd.sh
cat fsm.vtr.v >> ../mdpe_arch.vtr.v

cd ..

cd ./data_path
bash ./cmd.sh
cat mdpe_fsm.vtr.v >> ../mdpe_arch.vtr.v
cat mdpe.vtr.v >> ../mdpe_arch.vtr.v
cat popcount.vtr.v >> ../mdpe_arch.vtr.v

cd ..


if [[ $1 == "true" ]]; then
    if [[ $2 == "true" ]]; then
        nohup python3 /mnt/ampere2/aman/vtr_aman2/vtr-verilog-to-routing/vtr_flow/scripts/run_vtr_task.py ./vtr_runs > nohup.log &
    else
        python3 /mnt/ampere2/aman/vtr_aman2/vtr-verilog-to-routing/vtr_flow/scripts/run_vtr_task.py ./vtr_runs
    fi 
fi

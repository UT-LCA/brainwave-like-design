export VCS_HOME /usr/local/packages/synopsys_2018/vcs-mx/O-2018.09-SP1

all: compile run

FILES=brainwave.v testbench_npu.v
#FILES=includes_gen.v asymmetric_fifo.v

compile:
	$(VCS_HOME)/bin/vcs -full64 \
	${FILES} \
	-sverilog \
	-debug_access+all \
	-timescale=1ns/1ns \
 	-y /misc/linuxws/packages/synopsys_2018/syn/O-2018.06-SP5/dw/sim_ver \
	-v /misc/linuxws/packages/synopsys_2018/syn/O-2018.06-SP5/dw/sim_ver \
	+libext+.v \
	-l compile.log 


run:
	./simv

waves:
	$(VCS_HOME)/bin/dve -full64 -vpd vcdplus.vpd

clean:
	\rm -rf csrc DVEFiles simv.daidir simv ucli.key vcdplus.vpd *.syn *.pvl *.mr *.svf command.log

#Paths when not using LRC machines
#export VCS_HOME /home/tools/vcs/mx-2017.12-SP1-1
#-y /home/tools/synopsys/syn_2017.09/dw/sim_ver \
#-v /home/tools/synopsys/syn_2017.09/dw/sim_ver \


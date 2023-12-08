SHELL := /bin/bash

moduleName = serial_loopback
hardwareDir = ./hardware
part = xc7a100tcsg324-1
hwTarget = */xilinx_tcf/Digilent/210319B57CBBA

.PHONY: all
all: $(moduleName)

obj_dir/V$(moduleName).cpp: $(moduleName).v
	verilator -Wall --trace -cc $(moduleName).v

obj_dir/V$(moduleName)__ALL.a: obj_dir/V$(moduleName).cpp
	make -C obj_dir -f V$(moduleName).mk

$(moduleName): $(moduleName).cpp obj_dir/V$(moduleName)__ALL.a
	g++ -I /usr/share/verilator/include -I obj_dir/ \
		/usr/share/verilator/include/verilated.cpp \
		/usr/share/verilator/include/verilated_vcd_c.cpp \
		$(moduleName).cpp obj_dir/V$(moduleName)__ALL.a \
		-o $(moduleName)

hardware/post_synth.dcp: $(moduleName).v $(moduleName).xdc
	source /opt/Xilinx/Vivado/2017.2/settings64.sh
	/opt/Xilinx/Vivado/2017.2/bin/vivado -mode batch -source tcl/synthesis.tcl -tclargs $(hardwareDir) $(moduleName) $(part)
	mkdir -p hardware/logs/
	mv *.log *.jou hardware/logs/

hardware/post_route.dcp: hardware/post_synth.dcp
	source /opt/Xilinx/Vivado/2017.2/settings64.sh
	vivado -mode batch -source tcl/implementation.tcl -tclargs $(hardwareDir)

hardware/$(moduleName).bit: hardware/post_route.dcp
	source /opt/Xilinx/Vivado/2017.2/settings64.sh
	vivado -mode batch -source tcl/bitstream.tcl -tclargs $(hardwareDir) "$(moduleName).bit"

.PHONY: synth
synth: hardware/post_synth.dcp

.PHONY: impl
impl: hardware/post_route.dcp

.PHONY: bitstream
bitstream: hardware/$(moduleName).bit

.PHONY: load
load: hardware/$(moduleName).bit
	source /opt/Xilinx/Vivado/2017.2/settings64.sh
	vivado -mode batch -source tcl/program_device.tcl -tclargs $(hardwareDir) "$(moduleName).bit" $(hwTarget)

.PHONY: clean
clean:
	rm -rf obj_dir/ $(moduleName)

set outputDir [lindex $argv 0]
set moduleName [lindex $argv 1]
set part [lindex $argv 2]
file mkdir $outputDir

read_verilog $moduleName.v
read_xdc $moduleName.xdc

synth_design -top $moduleName -part $part
write_checkpoint -force $outputDir/post_synth
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_power -file $outputDir/post_synth_power.rpt

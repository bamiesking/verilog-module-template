set outputDir [lindex $argv 0]
set bitstreamFile [lindex $argv 1]
set hardwareTarget [lindex $argv 2]

open_hw
connect_hw_server -url localhost:3121
current_hw_target [get_hw_targets $hardwareTarget]
open_hw_target
current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device -update_hw_probes false [linde [get_hw_devices] 0]
set_property PROGRAM.FILE $outputDir/$bitstreamFile [lindex [get_hw_devices] 0]
program_hw_devices [lindex [get_hw_devices] 0]
refresh_hw_device [lindex [get_hw_devices] 0]

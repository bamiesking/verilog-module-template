set outputDir [lindex $argv 0]
set bitstreamFile [lindex $argv 1]
file mkdir $outputDir

open_checkpoint $outputDir/post_route.dcp

write_bitstream -force $outputDir/$bitstreamFile

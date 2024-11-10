onerror {resume}
quietly virtual function -install /DE1_SoC_testbench -env /DE1_SoC_testbench/#INITIAL#73 { &{/DE1_SoC_testbench/LEDR[2], /DE1_SoC_testbench/LEDR[1], /DE1_SoC_testbench/LEDR[0] }} Lights
quietly virtual function -install /DE1_SoC_testbench -env /DE1_SoC_testbench/#INITIAL#73 { &{/DE1_SoC_testbench/SW[1], /DE1_SoC_testbench/SW[0] }} Wind
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_testbench/CLOCK_50
add wave -noupdate {/DE1_SoC_testbench/KEY[0]}
add wave -noupdate /DE1_SoC_testbench/Wind
add wave -noupdate /DE1_SoC_testbench/Lights
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {283 ps} 0} {{Cursor 2} {1647 ps} 0} {{Cursor 3} {1688 ps} 0} {{Cursor 4} {1728 ps} 0} {{Cursor 5} {1728 ps} 0} {{Cursor 6} {1770 ps} 0} {{Cursor 7} {1770 ps} 0} {{Cursor 8} {1811 ps} 0} {{Cursor 9} {1811 ps} 0} {{Cursor 10} {1811 ps} 0} {{Cursor 11} {1851 ps} 0} {{Cursor 12} {1892 ps} 0}
quietly wave cursor active 12
configure wave -namecolwidth 178
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1605 ps} {3863 ps}

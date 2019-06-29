onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /tb_fifo/clk
add wave -noupdate /tb_fifo/rst
add wave -noupdate /tb_fifo/wr_req
add wave -noupdate -radix hexadecimal /tb_fifo/wr_data
add wave -noupdate /tb_fifo/rd_req
add wave -noupdate -radix hexadecimal /tb_fifo/rd_data
add wave -noupdate /tb_fifo/rd_data_rdy
add wave -noupdate /tb_fifo/empty
add wave -noupdate /tb_fifo/full
add wave -noupdate -radix unsigned /tb_fifo/duv/level
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {330 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {50 ns} {1050 ns}

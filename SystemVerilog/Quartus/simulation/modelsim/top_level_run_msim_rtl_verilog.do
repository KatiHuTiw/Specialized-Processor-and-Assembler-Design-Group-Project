transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog {C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog/top_level.sv}
vlog -sv -work work +incdir+C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog {C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog/register_mapper.sv}
vlog -sv -work work +incdir+C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog {C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog/reg_file.sv}
vlog -sv -work work +incdir+C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog {C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog/PC_Controller.sv}
vlog -sv -work work +incdir+C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog {C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog/PC.sv}
vlog -sv -work work +incdir+C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog {C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog/MUX2x1.sv}
vlog -sv -work work +incdir+C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog {C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog/immediate_Controller.sv}
vlog -sv -work work +incdir+C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog {C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog/half_byte_parser.sv}
vlog -sv -work work +incdir+C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog {C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog/decoder.sv}
vlog -sv -work work +incdir+C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog {C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog/dat_mem.sv}
vlog -sv -work work +incdir+C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog {C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog/Control.sv}
vlog -sv -work work +incdir+C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog {C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog/alu.sv}
vlog -sv -work work +incdir+C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog {C:/Users/Hurl3/Desktop/CSE141LTermProject/Verilog/instr_ROM.sv}


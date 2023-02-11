module PC_Controller #(parameter D=12)(
	input       [1:0] immOrLUT,   // Decide to use immediate or LUT value
	input       [ 3:0] pc_ctrl_input,	   // 4 bits = 16 different LUT value
	output logic[D-1:0] target
);

/*
  always_comb case(addr)
    0: target = -5;   // go back 5 spaces
	1: target = 20;   // go ahead 20 spaces
	2: target = '1;   // go back 1 space   1111_1111_1111
	default: target = 'b0;  // hold PC  
  endcase */

endmodule
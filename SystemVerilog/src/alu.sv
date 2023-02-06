// combinational -- no clock
// sample -- change as desired
module alu(
  input[4:0] alu_cmd,    // ALU instructions, at least 5 bits
  input[7:0] inA, inB,	 // 8-bit wide data path for the 2 values
  output logic[7:0] rslt,
  output logic doBranch,     // conduct branch for that BEQ instrucion
);

always_comb begin 
  // case(alu_cmd)
    
  // endcase
end
   
endmodule
module milestone2_quicktest_tb();

bit clk, reset;
wire done;
logic error[2];

top_level dut(
  .clk,
  .reset,
  .done);


always begin
  #5 clk = 1;
  #5 clk = 0;
end

initial begin
  dut.dm1.core[0] = 8'b11110000;
  dut.dm1.core[1] = 8'b11001100;
  dut.dm1.core[3] =	8'b11000011;
  dut.dm1.core[4] = 8'b01010101;
  // Show an increase in the PC's register
  dut.instructions.core[0] = 9'b000000000;
  dut.instructions.core[1] = 9'b000000001;
  dut.instructions.core[2] = 9'b000000010;
  dut.instructions.core[3] = 9'b000000011;
  dut.instructions.core[4] = 9'b000000100;
  dut.instructions.core[5] = 9'b000000101;
  dut.instructions.core[6] = 9'b000000110;
  dut.instructions.core[7] = 9'b000000111;
  dut.instructions.core[8] = 9'b000001000;
  // Generate a done signal
  dut.instructions.core[9] = 9'b100100000;
  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);
  #10 error[0] = (8'b11110000 ^ 8'b11001100) != dut.dm1.core[2];
  #10 error[1] = (8'b11000011 & 8'b01010101) != dut.dm1.core[5];
  #10 $display(error[0],,,error[1]);
  $stop;
end    

endmodule
module mux_2x1(
  input logic [7:0] in1, in2,
  input logic selector,
  output logic [7:0] out
);
  always_comb
  begin
      // student to add code here
      if (selector == 0) out = in1;
      else out = in2;

  end
endmodule
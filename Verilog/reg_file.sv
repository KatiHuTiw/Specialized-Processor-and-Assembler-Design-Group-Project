// cache memory/register file
// default address pointer width = 4, for 16 registers 
module reg_file (
  input[7:0] dat_in,
  input      clk,
  input      wr_en,           // write enable
  input[1:0] wr_addr,		  // write address pointer
              rd_addrA,		  // read address pointers
			  rd_addrB,
  output logic[7:0] datA_out, // read data
                    datB_out
                    );

  logic[7:0] core[4];    // 2-dim array  8 wide  16 deep

// reads are combinational
  assign datA_out = core[rd_addrA];
  assign datB_out = core[rd_addrB];
  
// writes are sequential (clocked)
// Added sequential swap.
  always_ff @(posedge clk) begin
    if(wr_en)				   // anything but stores or no ops
      core[wr_addr] <= dat_in;
		
	end
endmodule


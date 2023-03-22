module Register_Mapper(
  input [1:0] reg1, reg2, reg_write,
  input clk, reset, doSWAP,
  output logic [1:0] reg1_mapped, reg2_mapped, reg0_mapped, reg_write_mapped
);

logic [1:0] register_mappings_reg[4];
logic [1:0] register_mappings_next[4];

// Sequential logic, assigning reg mapper values
always_ff @(negedge clk) begin
    if(!reset) begin
        for (int i = 0; i < 4; i++) begin
            register_mappings_reg[i] <= register_mappings_next[i];
        end
    end
    else begin
        // Initially all regitsers point to themselves
        register_mappings_reg[0] <= 2'b00;
        register_mappings_reg[1] <= 2'b01;
        register_mappings_reg[2] <= 2'b10;
        register_mappings_reg[3] <= 2'b11;
    end
end
always_comb begin
    // On default no swap
    for (int i = 0; i < 4; i++) begin
        register_mappings_next[i] = register_mappings_reg[i];
    end
    // Only swap when SWAP command is used
    if(doSWAP) begin
        register_mappings_next[reg1] = register_mappings_reg[reg2];
        register_mappings_next[reg2] = register_mappings_reg[reg1];
    end
    // Output the mapper values of the registers
    reg1_mapped = register_mappings_reg[reg1];
    reg2_mapped = register_mappings_reg[reg2];
    reg0_mapped = register_mappings_reg[0];
	reg_write_mapped = register_mappings_reg[reg_write];
end

endmodule

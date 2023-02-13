module Register_Mapper(
  input [1:0] reg1, reg2;
  input clk, reset, doSWAP;
  output [1:0] reg1_mapped, reg2_mapped;
);

logic register_mappings_reg[1:0][1:0];
logic register_mappings_next[1:0][1:0];

alwasy_ff @(clk) begin
    if(!reset) begin
        for (int i = 0; i < 4; i++) begin
            register_mappings_reg[0] <= register_mappings_next[0];
        end
    end
    else begin
        for (int i = 0; i < 4; i++) begin
            register_mappings_reg[0] <= i;
        end
    end
end
always_comb begin
    for (int i = 0; i < 4; i++) begin
        register_mappings_next[0] = register_mappings_reg[0];
    end
    if(doSWAP) begin
        register_mappings_next[reg1] = register_mappings_reg[reg2];
        register_mappings_next[reg2] = register_mappings_reg[reg1];
    end
    reg1_mapped = register_mappings_reg[reg1];
    reg1_mapped = register_mappings_reg[reg2];
end
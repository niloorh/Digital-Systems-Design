module mano_core_tb;
  reg clk_t = 0, rst_t = 1;
  reg [7:0] inpr_t = 8'b01000100;
  wire [7:0] outr_t;
  integer i;

  always #5 clk_t = ~clk_t;
  
  mano_core U1 (clk_t, rst_t, inpr_t, outr_t);

  initial
  begin
    rst_t = 1;

    #10
    U1.mem[0] = 16'h2005;
    U1.mem[1] = 16'hF800;
    U1.mem[2] = 16'hF400;
    U1.mem[3] = 16'h7001;
    U1.mem[5] = 16'h0121;

    #30 rst_t = 0;

  end

endmodule

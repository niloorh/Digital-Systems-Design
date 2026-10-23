`timescale 1ns/1ps


module karatsuba128 (
    input  wire [127:0] A,
    input  wire [127:0] B,
    output wire [255:0] P
);
 
    //dividing A and B
    wire [63:0] A1 = A[127:64];
    wire [63:0] A0 = A[63:0];
    wire [63:0] B1 = B[127:64];
    wire [63:0] B0 = B[63:0];
   

    // making z1 and z2
    wire [127:0] Z1 = A1 * B1;
    wire [127:0] Z2 = A0 * B0;

   //to make z3 
    wire [64:0] SA = {1'b0, A1} + {1'b0, A0};
    wire [64:0] SB = {1'b0, B1} + {1'b0, B0};
    wire [129:0] Z3raw = SA * SB;             

  
    wire [129:0] Z1_w = {2'b00, Z1};          
    wire [129:0] Z2_w = {2'b00, Z2};
    wire [129:0] Z3   = Z3raw - Z1_w - Z2_w;  

    //vasl kardan
    wire [255:0] part_hi  = {Z1, 128'b0};
    wire [255:0] part_mid = {Z3, 64'b0};
    wire [255:0] part_lo  = {{128{1'b0}}, Z2};

    assign P = part_hi + part_mid + part_lo;
endmodule


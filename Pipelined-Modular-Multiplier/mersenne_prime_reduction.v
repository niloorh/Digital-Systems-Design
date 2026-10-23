`timescale 1ns/1ps

module pipelined_mod_mul (
    input  wire [127:0] A,
    input  wire [127:0] B,
    input  wire         clk,
    output reg  [220:0] result
);
  
    // for cycle 1
    wire [255:0] product_comb; 
    
    // for cycle 2
    reg  [255:0] product_reg; 

    
    karatsuba128 u_karatsuba (
        .A(A),
        .B(B),
        .P(product_comb)
    );

    // save res in posEdge clk (1st cycle)
    always @(posedge clk) begin
        product_reg <= product_comb;
    end

    // Pseudo Mersenne Reduction
    // unrolled loop
    wire [221:0] X_iter1_comb;
    wire [221:0] X_iter2_comb;
    wire [221:0] X_iter3_comb;
    wire [220:0] X_final_prered;
    wire [220:0] result_comb;

    wire [34:0]  X1_iter1 = product_reg[255:221];
    wire [220:0] X0_iter1 = product_reg[220:0];

    assign X_iter1_comb = ({1'b0, X1_iter1} * 3'd3) + {1'b0, X0_iter1};

    wire         X1_iter2 = X_iter1_comb[221];
    wire [220:0] X0_iter2 = X_iter1_comb[220:0];

    assign X_iter2_comb = ({221'b0, X1_iter2} * 3'd3) + {1'b0, X0_iter2};

    wire         X1_iter3 = X_iter2_comb[221];
    wire [220:0] X0_iter3 = X_iter2_comb[220:0];
    assign X_iter3_comb = ({221'b0, X1_iter3} * 3'd3) + {1'b0, X0_iter3};
    assign X_final_prered = X_iter3_comb[220:0];

    wire [220:0] p_plus_2 = {221{1'b1}};
    wire [220:0] p_plus_1 = {{220{1'b1}}, 1'b0};

    assign result_comb = (X_final_prered == p_plus_2) ? 221'd2 : // (p+2) mod p = 2
                         (X_final_prered == p_plus_1) ? 221'd1 : // (p+1) mod p = 1
                         X_final_prered;                        

    always @(posedge clk) begin
        result <= result_comb;
    end
endmodule 
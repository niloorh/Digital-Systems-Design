module mux2 (
    input  wire d0,
    input  wire d1,   
    input  wire sel,  
    output wire y
);
    assign y = sel ? d1 : d0;
endmodule

module barrel_shifter_left_8 (
    input  wire [7:0] a,     
    input  wire [2:0] b,     
    output wire [7:0] y      
);
    wire [7:0] s1, s2, s4;   
    genvar i;

    
    generate
        for (i = 0; i < 8; i = i + 1) begin : STAGE1
            wire d0 = a[i];
            wire d1 = (i >= 1) ? a[i-1] : 1'b0;
            mux2 u_mux1 (.d0(d0), .d1(d1), .sel(b[0]), .y(s1[i]));
        end
    endgenerate

   
    generate
        for (i = 0; i < 8; i = i + 1) begin : STAGE2
            wire d0 = s1[i];
            wire d1 = (i >= 2) ? s1[i-2] : 1'b0;
            mux2 u_mux2 (.d0(d0), .d1(d1), .sel(b[1]), .y(s2[i]));
        end
    endgenerate

   
    generate
        for (i = 0; i < 8; i = i + 1) begin : STAGE3
            wire d0 = s2[i];
            wire d1 = (i >= 4) ? s2[i-4] : 1'b0;
            mux2 u_mux3 (.d0(d0), .d1(d1), .sel(b[2]), .y(s4[i]));
        end
    endgenerate

    assign y = s4;  

endmodule


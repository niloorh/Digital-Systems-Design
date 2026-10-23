module karatsuba #(parameter N = 128) (
    input  wire [N-1:0] A,
    input  wire [N-1:0] B,
    output wire [(2*N)-1:0] P
);
    // we'll use this param a lot
    localparam HALF = N/2;

    // nesf kardan haye A va B
    wire [HALF-1:0] A1 = A[N-1:HALF];
    wire [HALF-1:0] A0 = A[HALF-1:0];
    wire [HALF-1:0] B1 = B[N-1:HALF];
    wire [HALF-1:0] B0 = B[HALF-1:0];

    // zarb haye avalie
    wire [(2*HALF)-1:0] Z1 = A1 * B1;
    wire [(2*HALF)-1:0] Z2 = A0 * B0;

    // raw Z3
    wire [HALF:0] SA = {1'b0, A1} + {1'b0, A0};
    wire [HALF:0] SB = {1'b0, B1} + {1'b0, B0};
    wire [(2*(HALF+1))-1:0] Z3raw = SA * SB;

    // adding two 0s before the Zs for the previous va jadid calcs
    wire [(2*(HALF+1))-1:0] Z1_w = {{2{1'b0}}, Z1};
    wire [(2*(HALF+1))-1:0] Z2_w = {{2{1'b0}}, Z2};
    wire [(2*(HALF+1))-1:0] Z3 = Z3raw - Z1_w - Z2_w;

    //vasl kardane nahayi
    wire [(2*N)-1:0] part_hi  = {Z1, {(2*HALF){1'b0}}};
    wire [(2*N)-1:0] part_mid = {Z3, {HALF{1'b0}}};
    wire [(2*N)-1:0] part_lo  = {{(2*N)-(2*HALF){1'b0}}, Z2};

    assign P = part_hi + part_mid + part_lo;
endmodule


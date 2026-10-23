`timescale 1ns/1ps

module tb_karatsuba128;


    reg  [127:0] A, B;
    wire [255:0] P;

    karatsuba128 dut (.A(A), .B(B), .P(P));

    // zarb bedune karatsuba
    reg [255:0] refP;

    integer errors;

    task apply_and_check;
        input [127:0] a;
        input [127:0] b;
        begin
            A = a;
            B = b;
            #1; 
            refP = {128'd0, A} * {128'd0, B};  
            if (P !== refP) begin
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;

        // 1) A = 0 , B = 2^116
        A = 128'd0;
        B = (128'd1 << 116);
        apply_and_check(A, B);

        // 2) A = 2^127 , B = 2^127
        A = (128'd1 << 127);
        B = (128'd1 << 127);
        apply_and_check(A, B);

        // 3) A = 2^128 - 1 , B = 2^128 - 1
        A = {128{1'b1}};
        B = {128{1'b1}};
        apply_and_check(A, B);

        // 4) A = 2^66 , B = 2^65
        A = (128'd1 << 66);
        B = (128'd1 << 65);
        apply_and_check(A, B);


        // 5) A = 2^63 , B = 2^63
        A = (128'd1 << 63);
        B = (128'd1 << 63);
        apply_and_check(A, B);

       // 6) A = 2^50 , B = 2^50
        A = (128'd1 << 50);
        B = (128'd1 << 50);
        apply_and_check(A, B);



    end

endmodule


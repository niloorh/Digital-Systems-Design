`timescale 1ns/1ps

module tb_karatsuba128;

    reg  [127:0] A, B;
    wire [255:0] P;

    karatsuba #(128) dut (.A(A), .B(B), .P(P));

    reg [255:0] refP;

    integer errors;

    task apply_and_check;
        input [127:0] a;
        input [127:0] b;
        begin
            A = a;
            B = b;
            #1; // small delta for combinational settle
            refP = {128'd0, A} * {128'd0, B};  
            if (P !== refP) begin

                errors = errors + 1;
            end
            else begin
            end
        end
    endtask

    initial begin
        errors = 0;

        A = 128'd0;
        B = (128'd1 << 116);
        apply_and_check(A, B);

        // A = 2^127 , B = 2^127
        A = (128'd1 << 127);
        B = (128'd1 << 127);
        apply_and_check(A, B);

        // A = 2^128 - 1 , B = 2^128 - 1
        A = {128{1'b1}};
        B = {128{1'b1}};
        apply_and_check(A, B);

        // A = 2^66 , B = 2^65
        A = (128'd1 << 66);
        B = (128'd1 << 65);
        apply_and_check(A, B);

      
        A = 128'h0000_0000_0000_0001_0000_0000_0000_0000; // bit 64 set
        B = 128'h0000_0000_0000_0000_0000_0000_0000_0003;
        apply_and_check(A, B);


    end

endmodule


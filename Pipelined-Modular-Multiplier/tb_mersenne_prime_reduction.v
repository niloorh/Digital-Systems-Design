`timescale 1ns/1ps

module tb_pipelined_mod_mul;

    reg [127:0] A;
    reg [127:0] B;
    reg         clk;

    wire [220:0] result;

    pipelined_mod_mul uut (
        .A(A),
        .B(B),
        .clk(clk),
        .result(result)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        A = 0;
        B = 0;
        #20;
	
	// wanted
        A = 128'd0;
        B = 128'd1 << 116;
        #100;

        A = 128'd1 << 127;
        B = 128'd1 << 127;
        #100;

        A = {128{1'b1}};
        B = {128{1'b1}};
        #100;

        A = 128'd1 << 111;
        B = 128'd1 << 110;
        #100;

        // others
        A = 128'd1;
        B = 128'd2;
        //expected_result = 221'd2;
        #100;

        A = 128'd1;
        B = 128'd1;
        //expected_result = 221'd1;
        #100;

        A = 128'd5;
        B = 128'd1;
        //expected_result = 221'd5;
        #100;

        A = 128'd1 << 100;
        B = 128'd1 << 120;
        //expected_result = 221'd1 << 220; // 2^220
        #100;
    end

endmodule
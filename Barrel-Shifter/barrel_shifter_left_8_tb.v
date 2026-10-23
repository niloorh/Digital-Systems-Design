`timescale 1ns/1ps

module barrel_shifter_left_8_tb;

    reg  [7:0] a;
    reg  [2:0] b;
    wire [7:0] y;


    barrel_shifter_left_8 dut (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin

        a = 8'b11010110; b = 3'd0; #10;
        a = 8'b11010110; b = 3'd1; #10;
        a = 8'b11010110; b = 3'd2; #10;
        a = 8'b11010110; b = 3'd3; #10;
        a = 8'b00001111; b = 3'd4; #10;
        a = 8'b10101010; b = 3'd7; #10;
        a = 8'b11110000; b = 3'd8; #10; //bayad b=0 begire

    end

endmodule


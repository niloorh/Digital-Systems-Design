`timescale 1ns / 1ps

/// Remote FPGA Tester Designed by Ali Jahanian

module SerialRFT
    #(parameter int unsigned DIVIDER = 0) 
    (
      input  mclk, 
      input  rst, 
      input  rx, 
      output tx,
      output led0,
      output led1
    );


    wire tx_start, rx_ready, tx_ready; 
    wire [7:0] data_lb_uart, data_uart_lb;
 //   reg led1_temp = 0;
     //************************************
     //  Cuitsuit Under Test Signals
     //************************************
    wire cut_clk;
    wire [127:0] cut_A;
    wire [127:0] cut_B;
    reg [255:0] cut_P;
//    wire cut_rst;
//    wire cut_en;
//    wire [7:0] cut_din;
//    wire [7:0] cut_dout;
    reg [31:0] cntr;
  assign led0 = cntr[24];
  assign led1 = cntr[26];
  
  always @(posedge mclk)
  begin
    cntr = cntr + 1;
//    if (rx_done)
//        led1_temp = !led1_temp;
  end
  
  uart UART (
    .clk(mclk), 
    .rst(rst), 
    .start(tx_start), 
    .din(data_lb_uart), 
    .dout(data_uart_lb), 
    .rx_done(rx_ready), 
    .tx_rdy(tx_ready), 
    .rx(rx), 
    .tx(tx)
  );

  //------------------------------------------
  // Port Mapping of  loop_back_device
  // Should be updated
  //------------------------------------------
  loop_back_device LBD (
    .rst(rst), 
    .clk(mclk), 
    .tx_start(tx_start), 
    .tx_data(data_lb_uart), 
    .rx_data(data_uart_lb), 
    .rx_ready(rx_ready), 
    .tx_ready(tx_ready), 
    .rx_rcv_done(rx_done), // activated when a complete input string is received
    .cut_clk(cut_clk), 
//    .cut_rst(cut_rst), 
//    .cut_en(cut_en), 
    .cut_din({cut_A, cut_B}), 
    .cut_dout(cut_P)
  );
  
  //------------------------------------------
  // Port Mapping of  Circuit_Under_Test
  // Should be updated
  //------------------------------------------
//  reg8 CUT (
//    .clk(cut_clk), 
//    .rst(rst), 
//    .en(cut_en), 
//    .din(cut_din), 
//    .dout(cut_dout)
//  );
    karatsuba128 CUT(
        .clk(cut_clk),
        .A(cut_A),
        .B(cut_B),
        .P(cut_P)
    );

endmodule
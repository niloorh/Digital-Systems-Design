module mano_core(
    input clk,
    input rst,
    input reg [7:0] inpr,
    output reg [7:0] outr
  );

  //*********************
  // Control signals
  //*********************
  reg ar_ld, ar_clr, ar_inr;
  reg ac_ld, ac_clr, ac_inr;
  reg dr_ld, dr_clr, dr_inr;
  reg tr_ld, tr_clr;
  reg pc_ld, pc_clr, pc_inr;
  reg ir_ld;
  reg i_ld;
  reg e_clr;
  reg hlt;
  reg sc_clr;
  reg wr, rd;
  reg [2:0] sc;
  reg [3:0] bus_sel;
  reg [3:0] alu_func;
  
  //***********************
  // Registers and busses
  //***********************
  wire [15:0] mem_out;
  reg  [15:0] alu_out, abus, dr, ac, tr, ir;
  reg  [11:0] pc = 0, ar;
  reg  [15:0] mem [0:1023];
  reg  i, e;

  
  //*********************
  // 4096x16 Memory
  //*********************
  always @(posedge clk)
  begin
    if (wr == 1)
      mem[ar] = abus;
    // mem[100] = 16'b0111100000000000; // CLA
    // mem[101] = 16'b0010000000000101; // LDA
    // mem[102] = 16'b1010000000000101; // LDA Indirect
  end
  assign mem_out = mem[ar];

  //*********************
  // Sequantial state machine
  //*********************
  always @(posedge clk)
  begin
    if (rst == 1)
    begin
      sc = 3'b000;
      // pc = 100;
      pc = 0;
      hlt = 0;
    end
    else if (!hlt) begin
      if (sc_clr == 1)
        sc = 0;
      else  
        sc = sc + 1;
      
      if (i_ld == 1)
        i = ir[15];
        
      if (ac_clr == 1)
        ac = 0;
      else if (ac_ld == 1)  
        ac = alu_out;

      if (ar_clr == 1)
        ar = 0;
      else if (ar_inr == 1)  
        ar = ar + 1;
      else if (ar_ld == 1)  
        ar = abus;

      if (dr_clr == 1)
        dr = 0;
      else if (dr_inr == 1)  
        dr = dr + 1;
      else if (dr_ld == 1)  
        dr = abus;

      if (pc_clr == 1)
        pc = 0;
      else if (pc_ld == 1)  
        pc = abus;
      else if (pc_inr == 1)  
        pc = pc + 1;

      if (ir_ld == 1)
        ir = abus;

      if (e_clr == 1)
        e = 0;
    end
  end 

//***********************
// Combinational state machine always
//***********************
  always @(*)
  begin
    ar_ld = 0;
    ar_clr = 0;
    ar_inr = 0;
    ac_ld = 0;
    ac_clr = 0;
    ac_inr = 0;
    dr_ld = 0;
    dr_inr = 0;
    dr_clr = 0;
    tr_ld = 0;
    tr_clr = 0;
    pc_ld = 0;
    pc_clr = 0;
    pc_inr = 0;
    ir_ld = 0;
    sc_clr = 0;
    wr = 0;
    rd = 0;
    i_ld = 0;

    case (sc)
      3'b000:  // T0
      begin 
        ar_ld = 1; 
        bus_sel = 3'b010;  //PC
      end
      3'b001:  // T1
      begin 
        pc_inr = 1; 
        bus_sel = 3'b000;  //mem
        ir_ld = 1;
      end
      3'b010:  // T2
      begin 
        bus_sel = 3'b101;  //IR
        ar_ld = 1;
        i_ld = 1;
      end
      3'b011: // T3 
      begin 
        if(ir[14:12] == 3'b111) // IO or REG
        begin
          if (i == 0) // REG
          begin
            if (ir[11] == 1)
            begin
              ac_clr = 1;
              sc_clr = 1;
            end
            else if (ir[10] == 1)
            begin
              e_clr = 1;
              sc_clr = 1;
            end
            else if (ir[9] == 1)
            begin
              alu_func = 3'b011;
              ac_ld = 1;
              sc_clr = 1;
            end
            else if (ir[8] == 1)
            begin
              alu_func = 3'b110;
              sc_clr = 1;
            end
            else if (ir[7] == 1)
            begin
              alu_func = 3'b100;
              ac_ld = 1;
              sc_clr = 1;
            end
            else if (ir[6] == 1)
            begin
              alu_func = 3'b101;
              ac_ld = 1;
              sc_clr = 1;
            end
            else if (ir[5] == 1)
            begin
              ac_inr = 1;
              sc_clr = 1;
            end
            else if (ir[4] == 1)
            begin
              if (ac[15] == 0)
                pc_inr = 1;
              sc_clr = 1;
            end
            else if (ir[3] == 1)
            begin
              if (ac[15] == 1)
                pc_inr = 1;
              sc_clr = 1;
            end
            else if (ir[2] == 1)
            begin
              if (dr == 16'b0000000000000000)
                pc_inr = 1;
              sc_clr = 1;
            end
            else if (ir[1] == 1)
            begin
              if (e == 0)
                pc_inr = 1;
              sc_clr = 1;
            end
            else if (ir[0] == 1)
            begin
              hlt = 1;
            end
          end
          else  // I/O
          begin
            if (ir[11] == 1)
            begin
              alu_func = 3'b111;
              ac_ld = 1;
              sc_clr = 1;
            end
            else if (ir[10] == 1)
            begin
              outr = ac;
              sc_clr = 1;
            end
            // else if (ir[9] == 1)
            // begin
            //   e_clr = 1;
            //   sc_clr = 1;
            // end
            // else if (ir[8] == 1)
            // begin
            //   e_clr = 1;
            //   sc_clr = 1;
            // end
            // else if (ir[7] == 1)
            // begin
            //   e_clr = 1;
            //   sc_clr = 1;
            // end
            // else if (ir[6] == 1)
            // begin
            //   e_clr = 1;
            //   sc_clr = 1;
            // end
          end
        end
        else
        begin // MEM
          if (i == 1)
          begin
            ar_ld = 1;
            bus_sel = 3'b000; // MEM
          end
        end
      end
      3'b100:   // T4
      begin 
        if(ir[14:12] == 3'b000)  // AND
        begin
          dr_ld = 1;
          bus_sel = 3'b000;
        end
        else if(ir[14:12] == 3'b001)
        begin
          dr_ld = 1;
          bus_sel = 3'b000;
        end
        else if(ir[14:12] == 3'b010)
        begin
          dr_ld = 1;
          bus_sel = 3'b000;
        end
        else if(ir[14:12] == 3'b011)
        begin
          bus_sel = 3'b100;
          wr = 1;
          sc_clr = 1;
        end
        else if(ir[14:12] == 3'b100)
        begin
          bus_sel = 3'b001;
          pc_ld = 1;
          sc_clr = 1;
        end
        else if(ir[14:12] == 3'b101)
        begin
          bus_sel = 3'b010;
          wr = 1;
          ar_inr = 1;
        end
        else if(ir[14:12] == 3'b110)
        begin
          dr_ld = 1;
          bus_sel = 3'b000;
        end
      end
      3'b101:   // T5
      begin 
        if(ir[14:12] == 3'b000)  // AND
        begin
          alu_func = 3'b001;
          ac_ld = 1;
          sc_clr = 1;
        end
        else if(ir[14:12] == 3'b001)
        begin
          alu_func = 3'b010;
          ac_ld = 1;
          sc_clr = 1;
        end
        else if(ir[14:12] == 3'b010)
        begin
          alu_func = 3'b000;
          ac_ld = 1;
          sc_clr = 1;
        end
        // else if(ir[14:12] == 3'b011)
        // begin
        //   bus_sel = 3'b100;
        //   wr = 1;
        //   sc_clr = 1;
        // end
        // else if(ir[14:12] == 3'b100)
        // begin
        //   bus_sel = 3'b001;
        //   pc_ld = 1;
        //   sc_clr = 1;
        // end
        else if(ir[14:12] == 3'b101)
        begin
          bus_sel = 3'b001;
          pc_ld = 1;
          sc_clr = 1;
        end
        else if(ir[14:12] == 3'b110)
        begin
          dr_inr = 1;
        end
      end
      3'b110:   // T6
      begin
        if(ir[14:12] == 3'b110)
        begin
          if(dr == 16'b0000000000000000)
            pc_inr = 1;
          wr = 1;
          bus_sel = 3'b011;
          sc_clr = 1;
        end
      end
    endcase
  end

//***********************
// BUS MUX
//***********************
  always @(*)
  begin
    case (bus_sel)
      3'b001: abus = ar;
      3'b010: abus = pc;
      3'b011: abus = dr;
      3'b100: abus = ac;
      3'b101: abus = ir;
      3'b110: abus = tr;
      3'b111: abus = inpr;
      default:abus = mem_out;
    endcase
  end
 
//***********************
// ALU
//***********************
  always @(*)
  begin
    case (alu_func)
      3'b000: begin
        alu_out = dr;
        e = 0;
      end
      3'b001: begin
        alu_out = dr & ac;
        e = 0;
      end
      3'b010: {e, alu_out} = dr + ac;
      3'b011: alu_out = ~ac;
      3'b100: begin
        {e, alu_out} = {ac[0], e, ac[15:1]};
      end
      3'b101: begin
        {e, alu_out} = {ac, e};
      end
      3'b110: e = ~e;
      3'b111: alu_out = inpr;
      default: alu_out = 16'b00000000000000000;
    endcase
  end
endmodule

`timescale 1ns/1ns

program testcase(input wire clk,
                 output logic [7:0] din,
                 input logic [7:0] dout,
                 output logic [7:0] addr,
                 output logic ce,
                 output logic we
                );
  
  //clocking block
  default clocking ramcb @(posedge clk);
    	input #1 dout=testbench.iram.dout;
    	output #0 din, addr, ce, we;
    
  endclocking
  
  initial begin 
    
    //initialize program block outputs
    ramcb.addr <= 0;
    ramcb.din <= 0;
    ramcb.ce <= 0;
    ramcb.we <= 0;
    
    // ========= Write Operations to RAM ========
    $display("===== Write Operation to RAM =====");
    
    for (int i = 0; i < 4; i++) begin
      
      repeat (2) @(ramcb);
      
      ramcb.addr <= i;
      ramcb.din <= $urandom_range(0,255);
      ramcb.ce <= 1; //ce=1 --> chip enable 
      ramcb.we <= 1; //we=1 --> Write enable 
      
      repeat (2) @(ramcb);
      ramcb.ce <= 0;
      
      $display("t=%5t: WRITE: addr=%2h, din=%2h, dout=%2h, we=%2h, ce=%2h", $time, addr, din, dout, we, ce);
    end
    
    // ====== Read operation from RAM ======
    $display("\n");
    $display("===== READ OPERATION FROM RAM =====");
    
    for (int i = 0; i < 4; i++) begin
      
      repeat (1) @(ramcb);
      ramcb.addr <= i;
      ramcb.ce <= 1;
      ramcb.we <= 0; //we=0 --> read is enabled 
      
      repeat (3) @(ramcb);
      ramcb.ce <= 0;
      
      $display("t=%5t: READ : addr=%2h, din=%2h, dout=%2h, we=%2h, ce=%2h", $time, addr, din,dout,we,ce);
    end

    repeat(10) @(clk) $finish;
  end
endprogram
module tb_fifo;
 logic clk=0,rst_n=0,s_valid=0,m_ready=0;
 always #5 clk=~clk;
 logic s_ready,m_valid;
 logic [15:0] s_data=0,m_data;
 logic [2:0] occupancy;
 mesh_fifo #(.W(16),.DEPTH(4)) dut(.*);
 initial begin
   repeat(3) @(negedge clk);rst_n=1;
   // Fill all four entries while output stalled.
   for (int i=0;i<4;i++) begin
     @(negedge clk);s_valid=1;s_data=16'(i+10);
     #1;assert(s_ready) else $fatal(1,"premature full");
   end
   @(negedge clk);s_valid=0;
   #1;assert(!s_ready && m_valid && occupancy==4 && m_data==10)
     else $fatal(1,"full/first element");
   // Drain and check FIFO order.
   for (int i=0;i<4;i++) begin
     m_ready=1;
     #1;assert(m_valid && m_data==16'(i+10)) else $fatal(1,"order %0d",i);
     @(negedge clk);
   end
   m_ready=0;
   #1;assert(!m_valid && occupancy==0) else $fatal(1,"empty");
   $display("PASS: FIFO fill, stall, drain, ordering");$finish;
 end
endmodule

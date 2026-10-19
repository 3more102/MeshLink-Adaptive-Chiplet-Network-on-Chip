module tb_mesh_2x2;
 logic clk=0,rst_n=0;
 always #5 clk=~clk;
 logic [3:0] inj_valid,inj_ready,eject_valid,eject_ready;
 logic [3:0][31:0] inj_data,eject_data;
 mesh_2x2 dut(.*);
 initial begin
   inj_valid='0;inj_data='0;eject_ready='1;
   repeat(3) @(negedge clk);rst_n=1;
   // 0=(0,0) -> 3=(1,1): east, then north.
   @(negedge clk);
   inj_data[0]=32'h1100_CAFE;inj_valid[0]=1;
   #1;
   assert(inj_ready[0] && eject_valid[3] && eject_data[3]==32'h1100_CAFE)
     else $fatal(1,"0->3 failed");
   @(negedge clk);inj_valid='0;
   // 3=(1,1) -> 0=(0,0): west, then south.
   @(negedge clk);
   inj_data[3]=32'h0000_BEEF;inj_valid[3]=1;
   #1;
   assert(inj_ready[3] && eject_valid[0] && eject_data[0]==32'h0000_BEEF)
     else $fatal(1,"3->0 failed");
   @(negedge clk);inj_valid='0;
   // Backpressure propagates across two hops.
   @(negedge clk);
   eject_ready[3]=0;inj_data[0]=32'h1100_DEAD;inj_valid[0]=1;
   #1;
   assert(eject_valid[3] && !inj_ready[0])
     else $fatal(1,"mesh backpressure failed");
   @(negedge clk);eject_ready[3]=1;
   #1;
   assert(inj_ready[0]) else $fatal(1,"mesh release failed");
   @(negedge clk);inj_valid='0;
   $display("PASS: 2x2 routing and backpressure");$finish;
 end
endmodule

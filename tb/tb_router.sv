module tb_router;
 logic clk=0, rst_n=0;
 always #5 clk=~clk;
 logic [4:0] in_valid,in_ready,out_valid,out_ready;
 logic [4:0][31:0] in_data,out_data;
 mesh_router #(.X(1),.Y(1)) dut(.*);
 initial begin
   in_valid='0; in_data='0; out_ready='1;
   repeat(3) @(negedge clk); rst_n=1;
   // Send east to destination (2,1)
   @(negedge clk); in_data[0]=32'h2100_1234; in_valid[0]=1;
   #1; assert(out_valid[2] && out_data[2]==32'h2100_1234 && in_ready[0]) else $fatal(1,"east route failed");
   @(negedge clk); in_valid='0;
   // Backpressure must hold valid, not consume input.
   out_ready[2]=0; in_data[0]=32'h2100_5678; in_valid[0]=1;
   #1; assert(out_valid[2] && !in_ready[0]) else $fatal(1,"backpressure failed");
   @(negedge clk); out_ready[2]=1;
   #1; assert(in_ready[0]) else $fatal(1,"release failed");
   @(negedge clk); in_valid='0;
   $display("PASS: XY route and backpressure"); $finish;
 end
endmodule

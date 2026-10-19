module mesh_router #(
 parameter int X=0, Y=0, W=32
)(
 input logic clk, rst_n,
 input logic [4:0] in_valid,
 input logic [4:0][W-1:0] in_data,
 output logic [4:0] in_ready,
 output logic [4:0] out_valid,
 output logic [4:0][W-1:0] out_data,
 input logic [4:0] out_ready
);
 // Port order: local=0, north=1, east=2, south=3, west=4.
 // Header: destination X=data[W-1:W-4], Y=data[W-5:W-8].
 // Single-flit, ready/valid, deterministic XY baseline.
 logic [4:0][2:0] route;
 logic [4:0] grant;
 logic [4:0][2:0] winner;
 logic [4:0][2:0] rr;
 integer i,j,k,idx;
 always_comb begin
   for (int a=0;a<5;a++) begin
     if (in_data[a][W-1 -: 4] > X) route[a]=2;
     else if (in_data[a][W-1 -: 4] < X) route[a]=4;
     else if (in_data[a][W-5 -: 4] > Y) route[a]=1;
     else if (in_data[a][W-5 -: 4] < Y) route[a]=3;
     else route[a]=0;
   end
   in_ready='0; out_valid='0; out_data='0; grant='0; winner='0;
   for (int o=0;o<5;o++) begin
     for (int t=0;t<5;t++) begin
       int c;
       c=(int'(rr[o])+t)%5;
       if (!out_valid[o] && in_valid[c] && route[c]==o) begin
         out_valid[o]=1'b1;
         out_data[o]=in_data[c];
         winner[o]=3'(c);
         in_ready[c]=out_ready[o];
         grant[o]=out_ready[o];
       end
     end
   end
 end
 always_ff @(posedge clk or negedge rst_n) begin
   if (!rst_n) rr<='0;
   else for (int o=0;o<5;o++) if (grant[o]) rr[o] <= (winner[o]==4) ? 0 : winner[o]+3'd1;
 end
 initial begin
   assert (W>=8) else $fatal(1,"W must be >=8");
   assert (X>=0 && X<16 && Y>=0 && Y<16) else $fatal(1,"Coordinates out of range");
 end
endmodule

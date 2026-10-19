// Four-router mesh, node index = y*2+x. Single-flit XY baseline.
// All inter-router links are combinational ready/valid (no pipeline stages).
module mesh_2x2 #(parameter int W=32)(
 input logic clk, rst_n,
 input logic [3:0] inj_valid,
 input logic [3:0][W-1:0] inj_data,
 output logic [3:0] inj_ready,
 output logic [3:0] eject_valid,
 output logic [3:0][W-1:0] eject_data,
 input logic [3:0] eject_ready
);
 logic [3:0][4:0] iv,ir,ov,orr;
 logic [3:0][4:0][W-1:0] id,od;
 for (genvar n=0;n<4;n++) begin: routers
   localparam int X=n%2, Y=n/2;
   mesh_router #(.X(X),.Y(Y),.W(W)) router(
     .clk(clk),.rst_n(rst_n),
     .in_valid(iv[n]),.in_data(id[n]),.in_ready(ir[n]),
     .out_valid(ov[n]),.out_data(od[n]),.out_ready(orr[n])
   );
   assign iv[n][0]=inj_valid[n];
   assign id[n][0]=inj_data[n];
   assign inj_ready[n]=ir[n][0];
   assign eject_valid[n]=ov[n][0];
   assign eject_data[n]=od[n][0];
   assign orr[n][0]=eject_ready[n];
   // North port: neighbor y+1, opposite south port.
   if (Y==0) begin
     assign iv[n][1]=ov[n+2][3];
     assign id[n][1]=od[n+2][3];
     assign orr[n][1]=ir[n+2][3];
   end else begin
     assign iv[n][1]=1'b0;
     assign id[n][1]='0;
     assign orr[n][1]=1'b0;
   end
   // East port: neighbor x+1, opposite west port.
   if (X==0) begin
     assign iv[n][2]=ov[n+1][4];
     assign id[n][2]=od[n+1][4];
     assign orr[n][2]=ir[n+1][4];
   end else begin
     assign iv[n][2]=1'b0;
     assign id[n][2]='0;
     assign orr[n][2]=1'b0;
   end
   // South port: neighbor y-1, opposite north port.
   if (Y==1) begin
     assign iv[n][3]=ov[n-2][1];
     assign id[n][3]=od[n-2][1];
     assign orr[n][3]=ir[n-2][1];
   end else begin
     assign iv[n][3]=1'b0;
     assign id[n][3]='0;
     assign orr[n][3]=1'b0;
   end
   // West port: neighbor x-1, opposite east port.
   if (X==1) begin
     assign iv[n][4]=ov[n-1][2];
     assign id[n][4]=od[n-1][2];
     assign orr[n][4]=ir[n-1][2];
   end else begin
     assign iv[n][4]=1'b0;
     assign id[n][4]='0;
     assign orr[n][4]=1'b0;
   end
 end
endmodule

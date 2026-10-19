// Single-clock synchronous FIFO, ready/valid interface.
// DEPTH must be >=2. No fall-through bypass: output valid only after a write.
module mesh_fifo #(
 parameter int W=32,
 parameter int DEPTH=4
)(
 input logic clk, rst_n,
 input logic s_valid,
 output logic s_ready,
 input logic [W-1:0] s_data,
 output logic m_valid,
 input logic m_ready,
 output logic [W-1:0] m_data,
 output logic [$clog2(DEPTH+1)-1:0] occupancy
);
 localparam int AW=$clog2(DEPTH);
 logic [W-1:0] mem [0:DEPTH-1];
 logic [AW-1:0] rd_ptr,wr_ptr;
 logic push,pop;
 assign s_ready=(occupancy<DEPTH) || (m_valid && m_ready);
 assign m_valid=(occupancy!=0);
 assign m_data=mem[rd_ptr];
 assign push=s_valid && s_ready;
 assign pop=m_valid && m_ready;
 always_ff @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
     rd_ptr<='0;wr_ptr<='0;occupancy<='0;
   end else begin
     if (push) begin
       mem[wr_ptr]<=s_data;
       wr_ptr <= (wr_ptr==DEPTH-1) ? '0 : wr_ptr+1'b1;
     end
     if (pop) rd_ptr <= (rd_ptr==DEPTH-1) ? '0 : rd_ptr+1'b1;
     case ({push,pop})
       2'b10:occupancy<=occupancy+1'b1;
       2'b01:occupancy<=occupancy-1'b1;
       default:occupancy<=occupancy;
     endcase
   end
 end
 initial begin
   assert(DEPTH>=2) else $fatal(1,"DEPTH must be >=2");
 end
endmodule

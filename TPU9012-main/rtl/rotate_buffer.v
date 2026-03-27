`ifndef __ROTATE_BUFFER__
`define __ROTATE_BUFFER__

module rotate_buffer #(parameter      WAY = 8,
		       parameter WIRE = 8,
		       parameter      MEM_SIZE = WAY*WIRE,
		       parameter      BUF_SIZE = MEM_SIZE + WIRE
)(input			     i_clk,
  input			     i_rst_n,
  input [BUF_SIZE-1:0]	     i_prev,
  input			     i_transfer,
  input			     i_rotate,
  output reg [BUF_SIZE-1:0] o_data);

    always @(posedge i_clk)
	begin
	    if (!i_rst_n)
		o_data <= {BUF_SIZE{1'b0}};
	    else if (i_transfer)
		o_data <= i_prev;
	    else if (i_rotate)
		o_data <= {o_data[WIRE-1:0], o_data[BUF_SIZE-1:WIRE]};
	    else if (~i_rotate)
		o_data <= {o_data[2*WIRE-1:0], o_data[BUF_SIZE-1:2*WIRE]};
	end
endmodule

`endif

`ifndef __SHIFT_WINDOW__
`define __SHIFT_WINDOW__

`include "cpt.v"
`include "line_buffer.v"
`include "window_mask.v"

// Fenêtre glissante 3x3 sur flux série
// WAY+1 cycles par ligne : WAY data + 1 transfert

module shift_window #(
    parameter	   WAY = 8,
    parameter      WIRE = 8,
    parameter	   KERNEL_CELLS = 9,
    parameter	   KERNEL_SIZE = KERNEL_CELLS * WIRE,
    parameter	   KERNEL_LINE = 3 * WIRE
)(input			  i_clk,
  input			  i_rst_n,
  input [WIRE-1:0]	  i_data,
  input [KERNEL_SIZE-1:0] i_kernel,
  output reg [WIRE-1:0]	  o_result);

    wire		       w_transfer;
    wire		       w_rotate;
    wire [KERNEL_LINE-1:0]     w_L1, w_L2, w_L3;

    cpt #(.WAY(WAY))
    cpt(.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.o_transfer(w_transfer),
	.o_rotate(w_rotate));

    line_buffer #(.WAY(WAY), .WIRE(WIRE), .KERNEL_LINE(KERNEL_LINE))
    line_buffer(.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.i_data(i_data),
	.i_transfer(w_transfer),
	.i_rotate(w_rotate),
	.o_L1(w_L1),
	.o_L2(w_L2),
	.o_L3(w_L3));

    wire [WIRE-1:0] w_result;

    window_mask #(.WIRE(WIRE), .KERNEL_LINE(KERNEL_LINE))
    window_mask(.i_L1(w_L1),
	.i_L2(w_L2),
	.i_L3(w_L3),
	.i_kernel(i_kernel),
	.o_result(w_result));

    always @(posedge i_clk)
	begin
	    if (!i_rst_n)
		o_result <= {WIRE{1'b0}};
	    else
		o_result <= w_result;
	end

endmodule

`endif

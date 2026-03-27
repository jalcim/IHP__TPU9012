`ifndef __LINE_BUFFER__
`define __LINE_BUFFER__

`include "shift_buffer.v"
`include "rotate_buffer.v"

// Buffer de lignes avec rotation/transfert
// L0 : écriture (shift)
// L1, L2, L3 : lecture (rotation ou transfert)

module line_buffer #(parameter WAY = 8,
                      parameter WIRE = 8,
                      parameter	MEM_SIZE = WAY*WIRE,
                      parameter	BUF_SIZE = MEM_SIZE + WIRE,
                      parameter	KERNEL_LINE = 3*WIRE
)(input			   i_clk,
  input			   i_rst_n,
  input [WIRE-1:0]	   i_data,
  input			   i_transfer,
  input			   i_rotate,
  output [KERNEL_LINE-1:0] o_L1,
  output [KERNEL_LINE-1:0] o_L2,
  output [KERNEL_LINE-1:0] o_L3);

    //////////////////////////////
    // Arbre de buffers : réduction de fanout
    //
    //       i_transfer              i_rotate
    //       /        \              /       \
    //   buf_t_L   buf_t_R      buf_r_L   buf_r_R
    //    /   \     /   \          |        /   \
    //  L0   L1   L2   L3        L1      L2   L3
    //////////////////////////////
    wire w_t_L, w_t_R;
    wire w_transfer_L0, w_transfer_L1, w_transfer_L2, w_transfer_L3;
    buf buf_t_L(w_t_L, i_transfer);
    buf buf_t_R(w_t_R, i_transfer);
    buf buf_t_L0(w_transfer_L0, w_t_L);
    buf buf_t_L1(w_transfer_L1, w_t_L);
    buf buf_t_L2(w_transfer_L2, w_t_R);
    buf buf_t_L3(w_transfer_L3, w_t_R);

    wire w_r_L, w_r_R;
    wire w_rotate_L1, w_rotate_L2, w_rotate_L3;
    buf buf_r_L(w_r_L, i_rotate);
    buf buf_r_R(w_r_R, i_rotate);
    buf buf_r_L1(w_rotate_L1, w_r_L);
    buf buf_r_L2(w_rotate_L2, w_r_R);
    buf buf_r_L3(w_rotate_L3, w_r_R);

    //////////////////////////////
    // L0 : shift-register d'écriture
    //////////////////////////////
    wire [MEM_SIZE-1:0] w_L0;

    shift_buffer #(.WAY(WAY), .WIRE(WIRE))
    L0(.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.i_data(i_data),
	.i_shift(w_transfer_L0),
	.o_data(w_L0));

    //////////////////////////////
    // L1, L2, L3 : rotation ou transfert
    //////////////////////////////
    wire [BUF_SIZE-1:0] w_L1;
    rotate_buffer #(.WAY(WAY), .WIRE(WIRE))
    L1(.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.i_prev({w_L0, {WIRE{1'b0}}}),
	.i_transfer(w_transfer_L1),
	.i_rotate(w_rotate_L1),
	.o_data(w_L1));
    assign o_L1 = w_L1[KERNEL_LINE-1:0];

    wire [BUF_SIZE-1:0] w_L2;
    rotate_buffer #(.WAY(WAY), .WIRE(WIRE))
    L2(.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.i_prev(w_L1),
	.i_transfer(w_transfer_L2),
	.i_rotate(w_rotate_L2),
	.o_data(w_L2));
    assign o_L2 = w_L2[KERNEL_LINE-1:0];

    wire [BUF_SIZE-1:0] w_L3;
    rotate_buffer #(.WAY(WAY), .WIRE(WIRE))
    L3(.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.i_prev(w_L2),
	.i_transfer(w_transfer_L3),
	.i_rotate(w_rotate_L3),
	.o_data(w_L3));
    assign o_L3 = w_L3[KERNEL_LINE-1:0];

endmodule

`endif

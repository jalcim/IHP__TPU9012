`default_nettype none

`include "src/shift_window.v"

module chip_core #(parameter WAY = 28,
                   parameter WIRE = 8,
                   parameter KERNEL_CELLS = 9
   )(input wire		      clk,
     input wire		      rst_n,
     input wire [WIRE-1:0]    data_in,
     input wire		      kernel_we,
     output wire [WIRE-1:0]   result);

   // Kernel shift register : KERNEL_CELLS * WIRE bits
   // WIRE bits par cycle via data_in
   localparam KERNEL_SIZE = KERNEL_CELLS * WIRE;
   wire [KERNEL_SIZE-1:0] kernel_reg;
   shift_buffer #(.WAY(KERNEL_CELLS), .WIRE(WIRE))
   kernel(.i_clk(clk),
	  .i_rst_n(rst_n),
	  .i_data(data_in),
	  .i_shift(~kernel_we),
	  .o_data(kernel_reg));

   wire [WIRE-1:0] sw_data = kernel_we ? {WIRE{1'b0}} : data_in;

   shift_window #(.WAY(WAY), .WIRE(WIRE),
		  .KERNEL_CELLS(KERNEL_CELLS))
   i_shift_window (.i_clk    (clk),
		   .i_rst_n  (rst_n),
		   .i_data   (sw_data),
		   .i_kernel (kernel_reg),
		   .o_result (result));

endmodule

`default_nettype wire

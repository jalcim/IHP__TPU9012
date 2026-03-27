`ifndef __SHIFT_BUFFER__
 `define __SHIFT_BUFFER__

module shift_buffer #(parameter WAY = 8,
                      parameter WIRE = 8
   )(input		      i_clk,
     input		      i_rst_n,
     input [WIRE-1:0]	      i_data,
     input		      i_shift,
     output reg [MEM_SIZE-1:0] o_data);

    localparam MEM_SIZE = WAY*WIRE;
    always @(posedge i_clk)
        begin
	    if (!i_rst_n)
	        o_data <= {MEM_SIZE{1'b0}};
	    else if (!i_shift)
	        o_data <= {i_data, o_data[MEM_SIZE-1:WIRE]};
        end
endmodule

`endif

`ifndef __WINDOW_MASK__
 `define __WINDOW_MASK__

 `include "src/adder_tree.v"

// Extraction et masquage de la fenêtre 3x3
// Masque horizontal selon cpt pour padding gauche/droite

module window_mask #(parameter WIRE = 8,
                     parameter KERNEL_CELLS = 9,
                     parameter KERNEL_SIZE = KERNEL_CELLS * WIRE,
                     parameter KERNEL_LINE = KERNEL_SIZE / 3
   )(input [KERNEL_LINE-1:0] i_L1,
     input [KERNEL_LINE-1:0] i_L2,
     input [KERNEL_LINE-1:0] i_L3,
     input [KERNEL_SIZE-1:0] i_kernel,
     output [WIRE-1:0]	      o_result);

   //////////////////////////////
   // Extraction fenêtre brute
   //////////////////////////////
   wire [KERNEL_SIZE-1:0] w_raw;
   assign w_raw = {i_L3, i_L2, i_L1};

   //////////////////////////////
   // Application du kernel
   //////////////////////////////
   wire [KERNEL_SIZE-1:0]	w_window;
   genvar			g_cpt;
   generate
      for (g_cpt = 0; g_cpt < KERNEL_CELLS; g_cpt = g_cpt + 1)
	begin : prod_loop
	   localparam START = g_cpt * WIRE;
	   localparam END   = (g_cpt+1) * WIRE - 1;

	   wire [WIRE-1:0] w_raw_elem;
	   wire [WIRE-1:0] w_kernel_elem;

	   assign w_raw_elem    = w_raw[END:START];
	   assign w_kernel_elem = i_kernel[END:START];

	   assign w_window[END:START] = w_raw_elem * w_kernel_elem;
	end
   endgenerate

   //////////////////////////////
   // Somme des produits (arbre)
   //////////////////////////////
   adder_tree #(.WAY(KERNEL_CELLS), .WIRE(WIRE))
   sum_tree(.datain(w_window), .dataout(o_result));

endmodule

`endif

`ifndef __CPT2__
`define __CPT2__

// Compteur binaire paramétrable
// Compte de 0 à WAY, revient à 0
// État WAY = cycle de transfert

module cpt #(parameter WAY = 8
)(input	 i_clk,
  input	 i_rst_n,
  output o_transfer,
  output o_rotate
);

    localparam WIDTH = $clog2(WAY + 1);

    /* verilator lint_off WIDTHTRUNC */
    localparam [WIDTH-1:0] LIMIT = WAY;
    /* verilator lint_on WIDTHTRUNC */

    reg [WIDTH-1:0]	   r_cpt;

    always @(posedge i_clk)
	begin
	    if (~i_rst_n)
		r_cpt <= 0;
	    else if (r_cpt == LIMIT)
		r_cpt <= 0;
	    else
		r_cpt <= r_cpt + 1;
	end

    assign o_transfer = r_cpt == LIMIT;
    assign o_rotate = r_cpt < LIMIT-1;

endmodule

`endif

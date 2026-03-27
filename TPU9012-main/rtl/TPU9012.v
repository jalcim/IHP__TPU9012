`default_nettype none

`include "chip_core.v"

module TPU9012 #(
     parameter IO_SIZE = 8
)(
`ifdef USE_POWER_PINS
    inout wire VDD,
    inout wire VSS,
    inout wire IOVDD,
    inout wire IOVSS,
`endif
    inout wire       clk_PAD,
    inout wire       rst_n_PAD,
    inout wire [IO_SIZE-1:0] data_in_PAD,
    inout wire       kernel_we_PAD,
    inout wire [IO_SIZE-1:0] result_PAD,
    inout wire   alive_PAD
);

    wire       clk_p2c;
    wire       rst_n_p2c;
    wire [IO_SIZE-1:0] data_in_p2c;
    wire	       kernel_we_p2c;
    wire [IO_SIZE-1:0] result_c2p;

    // Power pads
    (* keep *) sg13g2_IOPadVdd
	vdd_pad_s (
`ifdef USE_POWER_PINS
		   .vss(VSS),
		   .vdd(VDD),
		   .iovss(IOVSS),
		   .iovdd(IOVDD)
`endif
	       );

    (* keep *) sg13g2_IOPadVss
	vss_pad_s (
`ifdef USE_POWER_PINS
		   .vss(VSS),
		   .vdd(VDD),
		   .iovss(IOVSS),
		   .iovdd(IOVDD)
`endif
	       );

    (* keep *) sg13g2_IOPadVdd
	vdd_pad_n (
`ifdef USE_POWER_PINS
		   .vss(VSS),
		   .vdd(VDD),
		   .iovss(IOVSS),
		   .iovdd(IOVDD)
`endif
	       );

    (* keep *) sg13g2_IOPadVss
	vss_pad_n (
`ifdef USE_POWER_PINS
		   .vss(VSS),
		   .vdd(VDD),
		   .iovss(IOVSS),
		   .iovdd(IOVDD)
`endif
	       );

    (* keep *) sg13g2_IOPadIOVdd
	iovdd_pad_e (
`ifdef USE_POWER_PINS
		   .vss(VSS),
		   .vdd(VDD),
		   .iovss(IOVSS),
		   .iovdd(IOVDD)
`endif
	       );

    (* keep *) sg13g2_IOPadIOVss
	iovss_pad_e (
`ifdef USE_POWER_PINS
		   .vss(VSS),
		   .vdd(VDD),
		   .iovss(IOVSS),
		   .iovdd(IOVDD)
`endif
	       );

    (* keep *) sg13g2_IOPadIOVdd
	iovdd_pad_w (
`ifdef USE_POWER_PINS
		   .vss(VSS),
		   .vdd(VDD),
		   .iovss(IOVSS),
		   .iovdd(IOVDD)
`endif
	       );

    // Alive pad (constant high, debug)
    supply1 s_alive;

    (* keep *) sg13g2_IOPadOut30mA
	alive_pad (
`ifdef USE_POWER_PINS
	.vss(VSS),
	.vdd(VDD),
	.iovss(IOVSS),
	.iovdd(IOVDD),
`endif
	.c2p(s_alive),
	.pad(alive_PAD));

    (* keep *) sg13g2_IOPadIOVss
	iovss_pad_w (
`ifdef USE_POWER_PINS
		   .vss(VSS),
		   .vdd(VDD),
		   .iovss(IOVSS),
		   .iovdd(IOVDD)
`endif
	       );

    // Input pads
    sg13g2_IOPadIn
	clk_pad (
`ifdef USE_POWER_PINS
	.vss(VSS),
	.vdd(VDD),
	.iovss(IOVSS),
	.iovdd(IOVDD),
`endif
	.p2c(clk_p2c),
	.pad(clk_PAD));

    sg13g2_IOPadIn
	rst_n_pad (
`ifdef USE_POWER_PINS
	.vss(VSS),
	.vdd(VDD),
	.iovss(IOVSS),
	.iovdd(IOVDD),
`endif
	.p2c(rst_n_p2c),
	.pad(rst_n_PAD));

    sg13g2_IOPadIn
	kernel_we_pad (
`ifdef USE_POWER_PINS
	.vss(VSS),
	.vdd(VDD),
	.iovss(IOVSS),
	.iovdd(IOVDD),
`endif
	.p2c(kernel_we_p2c),
	.pad(kernel_we_PAD));

    genvar i;

    generate
	for (i = 0; i < 8; i++)
	    begin : data_in_pads
		sg13g2_IOPadIn
		    data_in_pad (
`ifdef USE_POWER_PINS
		    .vss(VSS),
		    .vdd(VDD),
		    .iovss(IOVSS),
		    .iovdd(IOVDD),
`endif
		    .p2c(data_in_p2c[i]),
		    .pad(data_in_PAD[i]));
	    end
    endgenerate

    // Output pads
    generate
	for (i = 0; i < 8; i++)
	    begin : result_pads
		sg13g2_IOPadOut30mA
		    result_pad (
`ifdef USE_POWER_PINS
		    .vss(VSS),
		    .vdd(VDD),
		    .iovss(IOVSS),
		    .iovdd(IOVDD),
`endif
		    .c2p(result_c2p[i]),
		    .pad(result_PAD[i]));
	    end
    endgenerate

    // Core
    (* keep *) chip_core
    i_chip_core (.clk       (clk_p2c),
		   .rst_n     (rst_n_p2c),
		   .data_in   (data_in_p2c),
		   .kernel_we (kernel_we_p2c),
		   .result    (result_c2p));

    // Logo
    (* keep *) logo_nebula logo_nebula ();

endmodule

`default_nettype wire

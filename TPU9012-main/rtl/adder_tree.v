`ifndef __ADDER_TREE__
 `define __ADDER_TREE__

module adder_tree #(parameter WAY = 4,
                    parameter WIRE = 32
)(input [SIZE - 1 : 0] datain,
  output [WIRE-1 : 0]  dataout);
    localparam SIZE = WAY * WIRE;
    localparam N1 = ((WAY / 2) + (WAY % 2));
    localparam N2 = (WAY / 2);

    if (WAY == 1)
        begin : gen_passthrough
	    assign dataout = datain;
        end
    else if (WAY == 2)
        begin : gen_pair
	    assign dataout = datain[2*WIRE-1:WIRE] + datain[WIRE-1:0];
        end
    else
        begin : gen_recurse
	    wire [WIRE-1:0] out1, out2;

	    adder_tree #(.WAY(N1), .WIRE(WIRE))
	    adder1(datain[SIZE - 1 : SIZE - N1*WIRE], out1);//287:128

	    adder_tree #(.WAY(N2), .WIRE(WIRE))
	    adder2(datain[N2*WIRE - 1 : 0], out2);//127:0

	    assign dataout = out1 + out2;
        end

endmodule

`endif

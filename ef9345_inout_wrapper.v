`include "ef9345.v"

module ef9345_inout_wrapper(
	output [7:0] data_bus_out,
	input [7:0] data_bus_in,
	input data_bus_in_en,
	input as,
	input ds,
	input rw,
	input cs_,
	input clk_in,
	output clk_out
	);

wire [7:0] data_bus;

ef9345 vdp(
	.data_bus(data_bus),
	.as(as),
	.ds(ds),
	.rw(rw),
	.cs_(cs_),
	.clk_in(clk_in),
	.clk_out(clk_out));

assign data_bus_out = data_bus;
assign data_bus = data_bus_in_en ? data_bus_in : 8'bz;

endmodule

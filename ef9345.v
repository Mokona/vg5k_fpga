module ef9345(
	inout [7:0] data_bus,
	input as,
	input ds,
	input rw,
	input cs_,
	input clk_in,
	output clk_out
	);

reg [7:0] latched_addr;
reg latched_cs_;
reg intel_mode; // DS
reg [1:0] clk_div;

always@(posedge clk_in) begin
	clk_div <= clk_div + 1;
end

// clk_in / 4
assign clk_out = clk_div[1];

always@(negedge as) begin
	intel_mode <= ds;
	latched_cs_ <= cs_;
	latched_addr <= data_bus;
end

always@(posedge reg_write) begin
	if (latched_addr[7:4] == 2) begin
		case (latched_addr & 7)
			0: R0 <= data_bus;
			1: R1 <= data_bus;
			2: R2 <= data_bus;
			3: R3 <= data_bus;
			4: R4 <= data_bus;
			5: R5 <= data_bus;
			6: R6 <= data_bus;
			7: R7 <= data_bus;
		endcase
	end
end

reg [7:0] addressed_reg;

always@(latched_addr or R0 or R1 or R2 or R3 or R4 or R5 or R6 or R7) begin
	case (latched_addr & 7)
		0: addressed_reg = R0;
		1: addressed_reg = R1;
		2: addressed_reg = R2;
		3: addressed_reg = R3;
		4: addressed_reg = R4;
		5: addressed_reg = R5;
		6: addressed_reg = R6;
		7: addressed_reg = R7;
	endcase
end

assign data_bus = reg_read ? addressed_reg : 8'bz;

wire reg_write = !latched_cs_ && !rw && (intel_mode ? 1 : ds);
wire reg_read = !latched_cs_ && (latched_addr[7:4] == 2) && (intel_mode ? ~ds : (rw & ds));

reg [7:0] R0;
reg [7:0] R1;
reg [7:0] R2;
reg [7:0] R3;
reg [7:0] R4;
reg [7:0] R5;
reg [7:0] R6;
reg [7:0] R7;

endmodule




`include "test.sv"

module top();	

	reg clock;

	counter_if DUV_IF(clock);

	test t_h;

	counter_rtl DUV(.clock(clock),
			.reset(DUV_IF.reset),
			.load(DUV_IF.load),
			.data_in(DUV_IF.data_in),
			.upd(DUV_IF.upd),
			.count(DUV_IF.count));

	initial
	begin
		clock = 1'b0;
		forever
		#10 clock = ~clock;
	end

	initial
	begin
		t_h = new(DUV_IF, DUV_IF, DUV_IF);
		t_h.build_and_run();
	end
endmodule: top

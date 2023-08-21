interface counter_if(input bit clock);

	logic reset;
	logic load;
	logic [3:0] data_in;
	logic upd;

	logic [3:0] count;

	//write driver clocking block
	clocking wr_bfm_cb@(posedge clock);
		default input #1 output #1;
		output load;
		output data_in;
		output upd;
		output reset;
	endclocking: wr_bfm_cb

	//write monitor clocking block
	clocking wr_mon_cb@(posedge clock);
		default input #1 output #1;
		input load;
		input data_in;
		input upd;
		input reset;
	endclocking: wr_mon_cb

	//read monitor clocking block
	clocking rd_mon_cb@(posedge clock);
		default input #1 output #1;
		input count;
	endclocking: rd_mon_cb

	//modport declarations
	//write driver modport
	modport WR_BFM(clocking wr_bfm_cb);

	//write monitor modport
	modport WR_MON(clocking wr_mon_cb);

	//Read monitor modport
	modport RD_MON(clocking rd_mon_cb);

endinterface: counter_if

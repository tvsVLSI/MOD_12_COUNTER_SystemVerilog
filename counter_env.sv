class counter_env;

	virtual counter_if.WR_BFM wr_bfm_if;
	virtual counter_if.WR_MON wr_mon_if;
	virtual counter_if.RD_MON rd_mon_if;

	mailbox #(counter_trans) gen2wr_bfm = new();
	mailbox #(counter_trans) wr_mon2rm = new();
	mailbox #(counter_trans) rd_mon2sb = new();
	mailbox #(counter_trans) rm2sb = new();

	counter_gen gen_h;
	counter_write_mon wr_mon_h;
	counter_write_bfm dri_h;
	counter_read_mon rd_mon_h;
	counter_sb sb_h;
	counter_model mod_h;

	function new(virtual counter_if.WR_BFM wr_bfm_if,
		     virtual counter_if.WR_MON wr_mon_if,
		     virtual counter_if.RD_MON rd_mon_if);
		this.wr_bfm_if = wr_bfm_if;
		this.wr_mon_if = wr_mon_if;
		this.rd_mon_if = rd_mon_if;
	endfunction: new

	virtual task build();
		gen_h = new(gen2wr_bfm);
		dri_h = new(wr_bfm_if, gen2wr_bfm);
		wr_mon_h = new(wr_mon_if, wr_mon2rm);
		rd_mon_h = new(rd_mon_if, rd_mon2sb);
		mod_h = new(wr_mon2rm, rm2sb);
		sb_h = new(rm2sb, rd_mon2sb);
	endtask: build

	virtual task reset_duv();
		@(wr_bfm_if.wr_bfm_cb);
			wr_bfm_if.wr_bfm_cb.reset <= 1'b1;
				@(wr_bfm_if.wr_bfm_cb);
					wr_bfm_if.wr_bfm_cb.reset <= 1'b0;
				@(wr_bfm_if.wr_bfm_cb);
	endtask: reset_duv

	virtual task start();
		gen_h.start();
		dri_h.start();
		wr_mon_h.start();
		rd_mon_h.start();
		mod_h.start();
		sb_h.start();
	endtask: start

	virtual task stop();
		wait(sb_h.DONE.triggered);
	endtask: stop

	virtual task run();
		reset_duv();
		start();
		stop();
		sb_h.report();
	endtask: run

endclass: counter_env

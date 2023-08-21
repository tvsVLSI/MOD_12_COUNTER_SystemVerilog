class counter_write_bfm;

	virtual counter_if.WR_BFM wr_bfm_if;

	counter_trans data2duv;

	mailbox #(counter_trans) gen2wr_bfm;

	function new(virtual counter_if.WR_BFM wr_bfm_if, mailbox #(counter_trans) gen2wr_bfm);
		begin
			this.wr_bfm_if = wr_bfm_if;
			this.gen2wr_bfm = gen2wr_bfm;
		end
	endfunction: new

	virtual task drive();
	begin
		@(wr_bfm_if.wr_bfm_cb);
			wr_bfm_if.wr_bfm_cb.load <= data2duv.load;
			wr_bfm_if.wr_bfm_cb.data_in <= data2duv.data_in;
			wr_bfm_if.wr_bfm_cb.upd <= data2duv.upd;
			wr_bfm_if.wr_bfm_cb.reset <= data2duv.reset;
			repeat(2)
				@(wr_bfm_if.wr_bfm_cb);
					wr_bfm_if.wr_bfm_cb.load <= '0;
					wr_bfm_if.wr_bfm_cb.reset <= '0;
	end
	endtask: drive

	virtual task start();
		fork
			forever
				begin
					gen2wr_bfm.get(data2duv);
					drive();
				end
		join_none
	endtask: start
endclass: counter_write_bfm	

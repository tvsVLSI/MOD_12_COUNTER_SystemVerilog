import counter_pkg :: *;

class counter_trans_extnd1 extends counter_trans;

endclass: counter_trans_extnd1

class test;

	virtual counter_if.WR_BFM wr_bfm_if;
	virtual counter_if.WR_MON wr_mon_if;
	virtual counter_if.RD_MON rd_mon_if;

	counter_env env_h;

		counter_trans_extnd1 data_h1;

	function new(virtual counter_if.WR_BFM wr_bfm_if, 
		     virtual counter_if.WR_MON wr_mon_if, 
		     virtual counter_if.RD_MON rd_mon_if);
		this.wr_bfm_if = wr_bfm_if;
		this.wr_mon_if = wr_mon_if;
		this.rd_mon_if = rd_mon_if;
	
		env_h = new(wr_bfm_if, wr_mon_if, rd_mon_if);
	endfunction: new

	task build_and_run();	
			if($test$plusargs("TEST1"))
				begin
					no_of_transactions = 200;
					env_h.build();
					env_h.run();
					$finish;
				end

			if($test$plusargs("TEST2"))
				begin
					data_h1 = new;
					no_of_transactions = 50;
					env_h.build();
					env_h.gen_h.trans_h = data_h1;
					env_h.run();
					$finish;
				end
	endtask: build_and_run

endclass: test

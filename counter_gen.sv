class counter_gen;
	counter_trans trans_h;
	counter_trans data2send;

	mailbox #(counter_trans) gen2wr_bfm;

	function new(mailbox #(counter_trans) gen2wr_bfm);
		this.gen2wr_bfm = gen2wr_bfm;
		this.trans_h = new;
	endfunction: new

	virtual task start();
		fork
			begin
				for(int i = 0; i < no_of_transactions; i++)
				begin
					assert(trans_h.randomize());
					data2send = new trans_h;
					gen2wr_bfm.put(data2send);
				end
			end
		join_none
	endtask: start
endclass: counter_gen

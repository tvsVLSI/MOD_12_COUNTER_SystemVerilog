class counter_model;

	counter_trans mon_data;

	static logic [3:0] ref_count = 0;

	mailbox #(counter_trans) wr_mon2rm;
	mailbox #(counter_trans) rm2sb;

	function new(mailbox #(counter_trans) wr_mon2rm, mailbox #(counter_trans) rm2sb);
		this.wr_mon2rm = wr_mon2rm;
		this.rm2sb = rm2sb;
	endfunction: new

	virtual task counter_mod(counter_trans mon_data);
		if(mon_data.reset)
			ref_count <= 4'b0;

		else if(mon_data.load == 1)
			ref_count <= mon_data.data_in;

		wait(mon_data.load == 0)
		begin
			if(mon_data.upd == 1)
			begin
				if(ref_count >= 4'd11)
					ref_count <= 4'b0;
				else
					ref_count <= ref_count + 4'b0001;
			end

			else
			begin
				if(ref_count <= 4'b0)
					ref_count <= 4'd11;
				else
					ref_count <= ref_count - 4'b0001;
			end
		end
	endtask: counter_mod

	virtual task start();
		fork
			begin
				forever
					begin
						wr_mon2rm.get(mon_data);
						counter_mod(mon_data);
						mon_data.count = ref_count;
						rm2sb.put(mon_data);
					end
			end
		join_none
	endtask: start
endclass: counter_model

class counter_read_mon;

	virtual counter_if.RD_MON rd_mon_if;

	counter_trans rd_data;

	mailbox #(counter_trans) rd_mon2sb;

	function new(virtual counter_if.RD_MON rd_mon_if, mailbox #(counter_trans) rd_mon2sb);
		begin
			this.rd_mon_if = rd_mon_if;
			this.rd_mon2sb = rd_mon2sb;
			this.rd_data = new();
		end
	endfunction: new

	task monitor();
		begin
			@(rd_mon_if.rd_mon_cb);
			begin
				rd_data.count = rd_mon_if.rd_mon_cb.count;
				rd_data.display("DATA FROM READ MONITOR");
			end
		end
	endtask: monitor

	task start();
		fork
			forever
				begin
					monitor();
					rd_mon2sb.put(rd_data);
				end
		join_none
	endtask: start
endclass: counter_read_mon

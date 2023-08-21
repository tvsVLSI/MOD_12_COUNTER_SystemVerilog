class counter_write_mon;

	virtual counter_if.WR_MON wr_mon_if;

	counter_trans wr_data;
	counter_trans cov_data;

	mailbox #(counter_trans) wr_mon2rm;

	covergroup counter_coverage;
		option.per_instance = 1;

		LOAD: coverpoint cov_data.load{
			bins BIN0 = {0};
			bins BIN1 = {1};
			}

		DATA_INPUT: coverpoint cov_data.data_in{
			bins ZERO = {0};
			bins BIN1 = {[1:5]};
			bins BIN2 = {[6:10]};
			bins MAX = {11};
		}

		UPD: coverpoint cov_data.upd{
			bins bin0 = {0};
			bins bin1 = {1};
		}

		RESET: coverpoint cov_data.reset{
			bins HIGH = {1};
		}

		LOADXDATA_IN: cross LOAD, DATA_INPUT;
	endgroup: counter_coverage

	function new(virtual counter_if.WR_MON wr_mon_if, mailbox #(counter_trans) wr_mon2rm);
		begin
			this.wr_mon_if = wr_mon_if;
			this.wr_mon2rm = wr_mon2rm;
			this.wr_data = new();
			counter_coverage = new();
		end
	endfunction: new

	virtual task monitor();
		begin
			@(wr_mon_if.wr_mon_cb);
			begin
				wr_data.load = wr_mon_if.wr_mon_cb.load;
				wr_data.upd = wr_mon_if.wr_mon_cb.upd;
				wr_data.data_in = wr_mon_if.wr_mon_cb.data_in;
				wr_data.reset = wr_mon_if.wr_mon_cb.reset;
				wr_data.display("DATA FROM WRITE MONITOR");
			end
		end
	endtask: monitor

	virtual task start();
		fork
			forever
				begin
					monitor();
					cov_data =wr_data;
					counter_coverage.sample();
					wr_mon2rm.put(wr_data);
				end
		join_none
	endtask: start
endclass: counter_write_mon

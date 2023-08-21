class counter_sb;

	event DONE;

	counter_trans rm_data;
	counter_trans sb_data;
	counter_trans cov_data;

	//static int ref_data, mon_count, data_verified, count_verified;
	int count_verified = 0;
	int refmodel_count = 0;
	int mon_count = 0;

	mailbox #(counter_trans) rm2sb;     //reference model to score board
	mailbox #(counter_trans) rd_mon2sb; //read monitor to score board

	covergroup counter_coverage;
		option.per_instance = 1;

		COUNT: coverpoint cov_data.count {  //4 bins
			bins ZERO = {0};
			bins BIN1 = {[1:5]};
			bins BIN2 = {[6:10]};
			bins MAX = {11};
			}

		/*DATA_IN: coverpoint cov_data.data_in{  //4 bins
			bins ZERO = {0};
                        bins BIN1 = {[1:5]};
                        bins BIN2 = {[6:10]};
                        bins MAX = {11};
                        }
		*/

		UPD: coverpoint cov_data.upd{  //2 bins
			bins bin0 = {0};
			bins bin1 = {1};
			}

		/*RESET: coverpoint cov_data.reset{
			bins ZER0 = {1};
			}
		*/

		/*LOAD: coverpoint cov_data.load{  //1 bin
			bins bin0 = {1};
			bins bin1 = {0};
			}
		*/

		COUNTXUPD: cross COUNT, UPD;  //8 bins

		//LOADXDATA_IN: cross LOAD, DATA_IN;  //4 bins

	endgroup: counter_coverage

	function new(mailbox #(counter_trans) rm2sb, mailbox #(counter_trans) rd_mon2sb);
		this.rm2sb = rm2sb;
		this.rd_mon2sb = rd_mon2sb;
		counter_coverage = new();
	endfunction: new

	virtual task start();
		fork
			forever
				begin
					rm2sb.get(rm_data);
					refmodel_count++;

					rd_mon2sb.get(sb_data);
					mon_count++;
	
					check(sb_data);
				end
		join_none
	endtask: start

	virtual task check(counter_trans rdata);

			if(rm_data.count == rdata.count)
				$display("COUNT MATCHED");
			else
				$display("********COUNT MISMATCH***********");

		cov_data = rm_data;
		counter_coverage.sample();

		count_verified++;
		if(count_verified >= no_of_transactions)
			begin
				-> DONE;
			end
	endtask: check

	virtual function void report();
		$display("--------------------------SCORE BOARD REPORT--------------");
		$display("Number of times data transferred from Reference Model to Score Board: %0d", refmodel_count);
		$display("Number of times data is transferred from Read Monitot to Score Board: %0d", mon_count);
		$display("Number of times count verified: %0d", count_verified);
		$display("----------------------------------------------------------");
	endfunction: report
endclass: counter_sb

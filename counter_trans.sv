class counter_trans;

	//input signals
	rand logic reset;
	rand logic load;
	rand logic [3:0] data_in;
	rand logic upd;

	//output signals
	 logic [3:0] count;

	static int trans_id;

	//constraint declarations
	constraint VALID_DATA{data_in inside {[0:11]};}
//	constraint LOAD_DISTRIBUTION{load dist {1 := 30, 0 := 70};}
//	constraint UPD_DISTRIBUTION{upd dist {1 := 50, 0 := 50};}

	function void post_randomize();
		trans_id++;
		this.display("\tRANDOMIZED DATA");
	endfunction: post_randomize

	//display function for displaying the properties
	virtual function void display(input string s);
	begin
		$display("----------------------------------");
		$display("%s", s);
		if(s == "\tRANDOMIZED DATA")
		begin
			$display("\t_________________________________");
			$display("\ttransaction number: %0d", trans_id);
			$display("\t_________________________________");
		end
		$display("reset: %0d", reset);
		$display("Load: %0d", load);
		$display("data_in: %0d", data_in);
		$display("upd: %0d", upd);
		$display("count: %0d", count);
		$display("----------------------------------");
	end
	endfunction: display
endclass: counter_trans

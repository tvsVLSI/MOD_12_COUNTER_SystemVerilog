package counter_pkg;

	int no_of_transactions = 200;

	`include "counter_trans.sv"
        `include "counter_gen.sv"
        `include "counter_write_bfm.sv"
        `include "counter_write_mon.sv"
        `include "counter_read_mon.sv"
        `include "counter_model.sv"
        `include "counter_sb.sv"
        `include "counter_env.sv"
        `include "test.sv"

endpackage: counter_pkg

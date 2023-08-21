# Makefile for Memory - Regression Testing - Lab10
RTL= ../rtl/*.v
work= work #library name
SVTB1= ../env_lib/counter_if.sv ../test/top.sv
INC = +incdir+../env +incdir+../env_lib +incdir+../test
SVTB2 = ../test/counter_pkg.sv
COVOP = -coveropt 3 +cover=bcft
VSIMOPT= -vopt -voptargs=+acc 
VSIMCOV= -coverage -sva 
VSIMBATCH1= -c -do  " log -r /* ;coverage save -onexit mem_cov1;run -all; exit"
VSIMBATCH2= -c -do  " log -r /* ;coverage save -onexit mem_cov2;run -all; exit"
VSIMBATCH3= -c -do  " log -r /* ;coverage save -onexit mem_cov3;run -all; exit"
VSIMBATCH4= -c -do  " log -r /* ;coverage save -onexit mem_cov4;run -all; exit"

help:
	@echo ===========================================================================================================
	@echo " USAGE   	--  make target                             										"
	@echo " clean   	=>  clean the earlier log and intermediate files.       							"
	@echo " sv_cmp    	=>  Create library and compile the code.                   							"
	@echo " TC1       	=>  To compile and run the testcase1 in batch mode.									" 
	@echo " TC2        	=>  To compile and run the testcase2 in batch mode.									" 
	@echo " TC3       	=>  To compile and run the testcase3 in batch mode.									" 
	@echo " regress_12  	=>  clean, compile and run testcases TC1 and TC2 in batch mode.						" 
	@echo " report_12    =>  To merge coverage reports for testcases TC1, TC2 and  convert to html format.	" 
	@echo " regress_123  =>  clean, compile and run testcases TC1,TC2,TC3 in batch mode.						" 
	@echo " report_123   =>  To merge coverage reports for testcases TC1,TC2,TC3 and convert to html format.	"														   
	@echo " cov_report  =>  To view the coverage report.													"
	@echo ===========================================================================================================

sv_cmp:
	vlib $(work)
	vmap work $(work)
	vlog -work $(work) $(RTL) $(INC) $(SVTB2) $(SVTB1) $(COVOP)
	
	
TC1:sv_cmp
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1)  -wlf wave_file1.wlf -l test1.log  -sv_seed random work.top +TEST1  
	vcover report  -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov1


TC2:sv_cmp
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2)  -wlf wave_file2.wlf -l test2.log  -sv_seed random work.top +TEST2 
	vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov2
	
TC3:sv_cmp
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH3)  -wlf wave_file3.wlf -l test3.log  -sv_seed random  work.top +TEST3 
	vcover report -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov3
	
report_12:
	vcover merge mem_cov mem_cov1 mem_cov2
	vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov

regress_12: clean sv_cmp TC1 TC2 report_12
 
report_123:
	vcover merge mem_cov mem_cov1 mem_cov2 mem_cov3 
	vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov

regress_123: clean sv_cmp TC1 TC2 TC3 report_123

cov_report:
	 firefox covhtmlreport/index.html&
	
clean:
	rm -rf transcript* *log*  vsim.wlf fcover* covhtml* mem_cov* *.wlf modelsim.ini
	clear
	
	


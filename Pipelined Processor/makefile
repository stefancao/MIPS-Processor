#########################################################
# Copyright TeamName 2016 - All Rights Reserved         
# 							
# Description:        				        
#    makefile for VHDL Test Bench  					  	
#	this makefile assumes that you already have	  
#	cds.lib, hdl.var, and run.cmd in the working 	
#	directory					
#							
# History:						
#    Date	Update Description       Developer	
# ------------ ------------------------- -------------- 
# 1/9/2016	Created			  SC		
#							
#							
#########################################################


# change these parameters 
PROJECT = processor
TB_TOP = processor_tb
TB_TOP_OPT = processor_tb_opt


all: $(PROJECT)

$(PROJECT): 
	vcom -64 -f rtl.cfg
	vlog -64 -sv -f tb.cfg
	vopt -64 $(TB_TOP) +acc=mpr -o $(TB_TOP_OPT) 
	vsim -64 -l simulation.log -do sim.do -c $(TB_TOP_OPT)
	vsim -view waveform.wlf
	
clean:
	rm -rf work
	rm *.log
	rm *.key
	rm -rf *.shm	

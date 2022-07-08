`timescale 1ns / 1ps
module electro_control(
              input clk,
				  input [7:0]cur_node,
				  output reg control_sig = 1				  
				  );
	 
   always@ (posedge clk)
	begin
	 if (cur_node == 8'h69 || cur_node == 8'h11)
	    control_sig = 0 ;
		 
    if (cur_node == 8'h91 || cur_node == 8'h31)
     	 control_sig = 1 ;
	end			  
endmodule

//

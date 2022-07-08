`timescale 1ns / 1ps
module path_planner_mod(
    input clk,
    input [7:0] next_node,
    input [7:0] current_node,
    output reg [7:0] source ,
    output reg [7:0] destination 
    );
      
    reg [7:0] dest_array[0:4]; 
    integer i = 0 ; 
    initial
    begin
	 
	   source = 8'h60 ;
      destination = 8'h11 ;
		dest_array[0] = 8'h18 ; 
		dest_array[1] = 8'h68 ;
      dest_array[2] = 8'h63 ;	
	   dest_array[3] = 8'h31 ;
		dest_array[4] = 8'h16 ;
		
//		dest_array[0] = destn[7:0] ;
//      dest_array[1] = destn[15:8] ;
//      dest_array[2] = destn[23:16] ;
//      dest_array[3] = destn[31:24] ;
//      dest_array[4] = destn[39:32] ;
//      dest_array[5] = destn[47:40] ;
//      dest_array[6] = destn[55:48] ;
//      dest_array[7] = destn[63:56] ;
//      dest_array[8] = destn[71:64] ;
//      dest_array[9] = destn[79:72] ;
//      dest_array[10]= destn[87:80] ;
//      dest_array[11]= destn[95:88] ;
    end
    
    always@ (posedge clk)
    begin
      if (next_node == destination)
        begin
          source = destination ;
          destination = dest_array[i];
          i = i + 1 ;
        end  
    end
    
endmodule



  //source = 8'h60 ;
//      destination = 8'h18 ;
//		dest_array[0] = 8'h68 ; 
//		dest_array[1] = 8'h63 ;
//      dest_array[2] = 8'h31 ;	
//	   dest_array[3] = 8'h16 ;
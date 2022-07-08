`timescale 1ns / 1ps
module coordinator_mod(
    input clk,
    input [95:0] path_info,
    input [2:0] ip_from_ls,
    input path_ready_sig,
    input [7:0] src,
    input [7:0] dest,
	 input obj_det,
    output reg [7:0] current_node = 8'h60,
	 output reg [7:0] next_node = 8'h61,
    output reg stop = 0,
    output reg [1:0] dir_info = 2'b00  //00 - straight ; 01 - right ; 10 - left ; 11 - 180 degree turn
    );
    
    reg [95:0] local_path_info = 0 ;
    //tells bot's current direction
    reg [1:0] direction_array = 2'd1;  // 3 - west ; 2 - south ; 1 - east ; 0 - north  // right turn : +1  ; left turn : -1  ; full 180 turn - +2
    localparam value = 25000000 ; //0.5 sec
    integer counter = 0 ;
    reg [7:0] temp_2 = 8'h60 ;
    reg start = 0 ;
    reg [3:0] i = 12 ;
    reg [3:0] j = 0 ;
    reg [3:0] src_position = 0 ;
    reg [7:0] temp = 0 ;
	 reg [7:0] x_temp = 8'h60 ;
	 integer stop_counter = 1 ;
    integer k = 0 ;
    reg state = 0 ;
    always@ (posedge clk)
    begin
      if (path_ready_sig && temp != src)
         begin
         local_path_info = path_info ;  //0 - 0 - source - x - x - x - dest
         i = i - 1 ;
         if(local_path_info[8*i+:8] == src)
               begin
               src_position = i ; 
               //i = 12 ;
					i = 8 ;
               j = src_position - 1 ;
               temp = src ;
               end  
         end
      if (ip_from_ls == 3'b111 && counter == 0)  //executes once when a new node is detected
        begin
          start = 1 ;
          if(temp_2 != src)
          begin
            current_node = local_path_info[8*(src_position) +:8];     
            next_node = local_path_info[8*(j) +:8];
            temp_2 = src ;
          end 
          else
          begin 
            current_node = next_node ;
            next_node = local_path_info[8*(j-1) +:8];
            j = j - 1 ;
          end  
        
     
       if (current_node[7:4] > next_node[7:4])  //next node is above the current node
           case(direction_array)
            2'd0 : dir_info = 2'b00 ; 
            2'd1 : dir_info = 2'b10 ;
            2'd2 : dir_info = 2'b11 ;
            2'd3 : dir_info = 2'b01 ;
           endcase
       if (current_node[7:4] < next_node[7:4])  //next node is below the current node
           case(direction_array)
            2'd0 : dir_info = 2'b11 ; 
            2'd1 : dir_info = 2'b01 ;
            2'd2 : dir_info = 2'b00 ;
            2'd3 : dir_info = 2'b10 ;
           endcase  
       if (current_node[3:0] > next_node[3:0])  //next node is to the left of the current node
           case(direction_array)
            2'd0 : dir_info = 2'b10 ; 
            2'd1 : dir_info = 2'b11 ;
            2'd2 : dir_info = 2'b01 ;
            2'd3 : dir_info = 2'b00 ;
           endcase
       if (current_node[3:0] < next_node[3:0])  //next node is  to the right of the current node
           case(direction_array)
            2'd0 : dir_info = 2'b01 ; 
            2'd1 : dir_info = 2'b00 ;
            2'd2 : dir_info = 2'b10 ;
            2'd3 : dir_info = 2'b11 ;
           endcase
        case(dir_info)
        2'b00 : direction_array = direction_array;
        2'b01 : direction_array = direction_array + 1;
        2'b10 : direction_array = direction_array - 1;
        2'b11 : direction_array = direction_array - 2;
       endcase               
     end       
	  if (start == 1)
	    counter = counter + 1 ;
	  if (counter == value)
	     begin
	      start = 0 ;
	      counter = 0 ;
	     end        
     end
endmodule

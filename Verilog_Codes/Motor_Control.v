`timescale 1ns / 1ps
module motor_control(
    input clk,
    input [2:0] ip_from_ls,
    input stop_signal,
    input [7:0] current_node,
    input [1:0] directions ,   //00 - straight ; 01 - right ; 10 - left ; 11 - 180 degree turn
    output [1:0] a, 
	 output [1:0] b 
      );
    
 // Input A[1] - high ; Input A[0] - low : anticlockwise Direction of motor A  (bot moves forward)
 // PWM output will be given to Input A[1]  
 // 00 - Straight ; 01 - Go right ; 10 - Go left ; 11 - node detected 
 // A - Right motor ; B - Left motor
 reg [1:0] A; reg [1:0] B ;
 reg [6:0] DS_A = 100 , DS_B = 100 ;
 assign a = A ;
 assign b = B ;
 //reg straight = 0 ;
 reg turn_left = 0, turn_right = 0, full_turn = 0 ;
 reg [7:0] temp = 0 ;
 reg [7:0] temp2 = 0 ;
 reg [7:0] temp3 = 0 ;
 integer wait_counter = 0 ;
 integer wait_counter1 = 0 ;
 integer wait_counter3 = 0 ;
 reg turn_left_signal = 0 ;
 reg turn_right_signal = 0 ;
 reg full_turn_signal = 0 ;
always@ (posedge clk)
 begin
//  case(ip_from_ls)
//	 3'b100 : begin
//            DS_B = 65 ;
//            DS_A = 80 ;
//            end 
//	 3'b110 : begin
//				DS_B = 70 ;
//				DS_A = 85 ;
//				end 
//    3'b010 : begin
//            DS_B = 70 ;
//            DS_A = 70 ;
//            end 
//	 3'b011 : begin
//            DS_B = 85 ;
//            DS_A = 70 ;
//            end
//    3'b001 : begin
//            DS_B = 80 ;
//            DS_A = 65 ;
//            end
//	 3'b111: begin
//				DS_A = 70 ; 
//            DS_B = 70 ;
//				end
//  endcase
 case(ip_from_ls)
	 3'b100 : begin
            DS_B = 68 ; //all -2
            DS_A = 83 ;
            end 
	 3'b110 : begin
				DS_B = 73 ;
				DS_A = 88 ;
				end 
    3'b010 : begin
            DS_B = 73 ;
            DS_A = 73 ;
            end 
	 3'b011 : begin
            DS_B = 88 ;
            DS_A = 73 ;
            end
    3'b001 : begin
            DS_B = 83 ;
            DS_A = 68 ;
            end
	 3'b111: begin
				DS_A = 73 ; 
            DS_B = 73 ;
				end
  endcase
  case (directions)  //00 - straight ; 01 - right ; 10 - left ; 11 - 180 degree turn
   2'b00 : begin
            //straight = 1 ;
            turn_left = 0 ;
            turn_right = 0 ;
            full_turn = 0 ;
           end
   2'b01 : begin
            //straight = 0 ;
            turn_left = 0 ;
            turn_right = 1 ;
            full_turn = 0 ;
           end
   2'b10 : begin
           //  straight = 0 ;
            turn_left = 1 ;
            turn_right = 0 ;
            full_turn = 0 ;
           end
   2'b11 : begin
           // straight = 0 ;
            turn_left = 0 ;
            turn_right = 0 ;
            full_turn = 1 ;
           end                        
  endcase
 end
 
//PWM code for motor A 
integer k_A = 1;
integer k_t_A = 1 ;

always@ (posedge clk)
begin

// if (full_turn && temp2 != current_node)
//          begin
//            if (wait_counter3>=27500000 && wait_counter3 <= 70000000)  //1 sec         
//               begin
//                full_turn_signal = 1 ;
//               end 
//            if (wait_counter3 <= 70000000) 
//             begin
//             wait_counter3 = wait_counter3 + 1 ;
//             end
//            else
//              begin
//              wait_counter3 = 0 ;
//              temp2 = current_node ;
//              full_turn_signal = 0 ;
//              end
//          end       
			 
  if (turn_left && temp != current_node)
          begin
            if (wait_counter>=20000000 && wait_counter <= 45000000)  //0.5 sec         
               begin
                turn_left_signal = 1 ;
               end 
            if (wait_counter <= 45000000) 
             begin
             wait_counter = wait_counter + 1 ;
             end
            else
              begin
              wait_counter = 0 ;
              temp = current_node ;
              turn_left_signal = 0 ;
              end
          end
    
   
          
    if (turn_right && temp3 != current_node)
          begin
            if (wait_counter1>=12000000 && wait_counter1 <= 37000000)           
               begin
                turn_right_signal = 1 ;
               end 
            if (wait_counter1 <= 37000000) 
             begin
             wait_counter1 = wait_counter1 + 1 ;
             end
            else
              begin
              wait_counter1 = 0 ;
              temp3 = current_node;
              turn_right_signal = 0 ;
              end
          end             
end

always @(posedge clk)
begin
if (turn_left_signal )
begin
   if (k_t_A > (87 * 500))             
     begin
      A[1] <= 1 ;
      A[0] <= 0 ;
     end
   else
     begin
      A[1] <= 0 ;
      A[0] <= 1 ;
     end
end

else if (turn_right_signal || full_turn_signal)
begin
   if (k_t_A > (85 * 500))             
     begin
      A[1] <= 0 ;
      A[0] <= 1 ;
     end
   else
     begin
      A[1] <= 1 ;
      A[0] <= 0 ;
     end
end

//else if(stop_signal)
//begin
//  A[1] <= 1 ;
//  A[0] <= 1 ;
//end

else
begin
 if (k_A > (DS_A * 500))
	    begin
	    A[1] <= 0 ;
	    A[0] <= 1 ;
	    end
	   else
        begin
        A[1] <= 1 ;
        A[0] <= 0 ;
        end
end

            
end

always @(posedge clk)
begin
	if(k_A < 50000)
	  k_A = k_A + 1 ;
	else
	  k_A = 1 ;  
end

always @(posedge clk)
begin
	if(k_t_A < 50000)
	  k_t_A = k_t_A + 1 ;
	else
	  k_t_A = 1 ;  
end

//PWM code for motor B
integer k_B = 1;
integer k_t_B = 1 ;

always @(posedge clk)
begin
if (turn_left_signal )
begin 
    if (k_t_B > (87 * 500))    //was 78 initially
      begin
       B[1] <= 0 ;
       B[0] <= 1 ;
      end
    else
      begin
       B[1] <= 1 ;
       B[0] <= 0 ;
      end 
end 

else if (turn_right_signal || full_turn_signal)
begin 
    if (k_t_B > (85 * 500)) 
      begin
       B[1] <= 1 ;
       B[0] <= 0 ;
      end
    else
      begin
       B[1] <= 0 ;
       B[0] <= 1 ;
      end 
end 

//else if(stop_signal)
//begin
//  B[1] <= 1 ;
//  B[0] <= 1 ;
//end

else
begin
 if (k_B > (DS_B * 500))
	  begin
	  B[1] <= 0 ;
	  B[0] <= 1 ;
	  end
	 else
      begin
      B[1] <= 1 ;
      B[0] <= 0 ;
      end
end
          
end

always @(posedge clk)
begin
	if(k_B < 50000)
	  k_B = k_B + 1 ;
	else
	  k_B = 1 ;  
end

always @(posedge clk)
begin
	if(k_t_B < 50000)
	  k_t_B = k_t_B + 1 ;
	else
	  k_t_B = 1 ;  
end

endmodule

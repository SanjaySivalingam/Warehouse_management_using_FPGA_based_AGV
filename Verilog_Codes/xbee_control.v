`timescale 1ns / 1ps
// RX pin36 bank0
module xbee_control(
    input RX,
    input clk,
    output [7:0] data_read 
    );
   
parameter IDLE=1'b0,START=1'b1;

integer cpb=0; //clocks per bit
integer cc=1; //bits inside data packet
reg state=IDLE;
reg [7:0] data_out = 8'b0 ;
reg prev_RX = 1;
reg [2:0] i = 0 ;
reg [7:0] temp_read ;
reg [7:0] d_r ;
always@ (posedge clk)
begin
  if (prev_RX == 1'b1 && RX == 1'b0 && state == IDLE)
    begin
      state = START ;
    end
  prev_RX = RX ;
  if (state == START)
   begin
     cpb<= (cpb==434)? 1:(cpb+1);
     if(cpb==433)
        cc<=cc+1;
     if (cc >= 2 && cc <=9)
        data_out[cc - 2] = RX ;
     if (cc == 11 && cpb == 433)
        begin
        cc <= 1 ;
        //data_out = data_out - 8'b00110000 ; //ASCII to decimal  
		  temp_read[i] = data_out[0] ; //LSB tells whether its 1 or 0
//		  i = i + 1 ;
		  if (i == 7)
		    d_r = temp_read ;
		  i = i + 1 ;
        state <= IDLE ;
        end      
   end  
end  
assign data_read = d_r ; 
endmodule


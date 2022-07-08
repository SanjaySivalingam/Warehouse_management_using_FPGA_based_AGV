`timescale 1ns / 1ps
module data_map(
input clk,
input[7:0]data_in,
output reg [95:0]destn
);
reg [7:0]dincopy=8'hff;
reg [2:0]i=5;
reg [5:0]array_out ;
reg [3:0]j=0;
reg [7:0] dest_array [0:11];

initial
    begin
        dest_array[0]=8'b0;
        dest_array[1]=8'b0;
        dest_array[2]=8'b0;
        dest_array[3]=8'b0;
        dest_array[4]=8'b0;
        dest_array[5]=8'b0;
        dest_array[6]=8'b0;
        dest_array[7]=8'b0;
        dest_array[8]=8'b0;
        dest_array[9]=8'b0;
        dest_array[10]=8'b0;
        dest_array[11]=8'b0;
    end
always @ (posedge clk)
begin
if(dincopy!=data_in)
begin
dincopy=data_in;
array_out[i]=data_in[4];
array_out[i-1]=data_in[0];
i=i-2;
i=(i==0)? 5:i;
end
if(array_out[5]==1)
begin
dest_array[j]=8'h06;
dest_array[j+1]=8'h30;
  j=j+2;
end
if(array_out[4]==1)
begin
dest_array[j]=8'h22;
dest_array[j+1]=8'h30;
  j=j+2;
end
if(array_out[3]==1)
begin
dest_array[j]=8'h52;
dest_array[j+1]=8'h30;
  j=j+2;
end
if(array_out[2]==1)
begin
dest_array[j]=8'h56;
dest_array[j+1]=8'h90;
  j=j+2;
end
if(array_out[1]==1)
begin
dest_array[j]=8'h82;
dest_array[j+1]=8'h90;
  j=j+2;
end
if(array_out[0]==1)
begin
dest_array[j]=8'ha6;
dest_array[j+1]=8'h90;
  j=j+2;
end
  destn[7:0] = dest_array[0] ;
  destn[15:8] = dest_array[1] ;
  destn[23:16] = dest_array[2] ;
  destn[31:24] = dest_array[3] ;
  destn[39:32] = dest_array[4] ;
  destn[47:40] = dest_array[5] ;
  destn[55:48] = dest_array[6] ;
  destn[63:56] = dest_array[7] ;
  destn[71:64] = dest_array[8] ;
  destn[79:72] = dest_array[9] ;
  destn[87:80] = dest_array[10] ;
  destn[95:88] = dest_array[11] ;
  

end
endmodule

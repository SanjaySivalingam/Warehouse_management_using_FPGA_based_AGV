`timescale 1ns / 1ps
module adc_control(
	input  clk_50,				//50 MHz clock
	input  dout,				//digital output from ADC128S022 (serial 12-bit)
	output adc_cs_n,			//ADC128S022 Chip Select
	output din,					//Ch. address input to ADC128S022 (serial)
	output adc_sck,			//2.5 MHz ADC clock
    output [2:0] data_to_linesensor	  // 0 - left ; 1 - centre ; 2 - right
);

reg adc_clock = 0;
reg [3:0] fc = 0;
reg [3:0] i = 0 ;
reg data_in = 0 ;
reg [1:0] data_frame_counter = 0 ; 
reg [2:0] c_select ;
reg [11:0] parallel_data = 0;
reg [11:0] d_out_0=0;
reg [11:0] d_out_1=0;
reg [11:0] d_out_2=0;
reg [2:0] data_to_ls = 0 ;
reg adc_cs = 0 ;
localparam Threshold = 12'b010011011010 ;  //1V



assign adc_sck = adc_clock ;
always@ (negedge clk_50)
begin
  i <= (i == 10)? 1 : i + 1 ;
  if (i == 10)
    begin
    adc_clock <= ~adc_clock ;
    end
 end

assign adc_cs_n = adc_cs ;
 
 always@ (posedge adc_clock)
 begin
  fc <=  fc + 1 ;
  if (fc == 0 ) //changed from fc==1
    data_frame_counter <= (data_frame_counter == 3) ? 1 : data_frame_counter + 1 ;
    
  if (fc >= 4 && !adc_cs_n)
  begin
    parallel_data = parallel_data << 1 ;
    parallel_data[0] = dout ;
  end
end

assign din = data_in;

always@ (negedge adc_clock)
begin
  if (fc == 1)//changed from fc==2 
   case (data_frame_counter)
      0 : c_select = 0 ;
      1 : c_select = 0 ;
      2 : c_select = 1 ;
      3 : c_select = 2 ;
   endcase
  if (fc >= 2 && !adc_cs_n )
   begin
     data_in <= c_select[2] ;
     c_select <= c_select << 1 ;
   end   
  if (fc == 0)
    begin
     case(data_frame_counter)
       1 : begin
           d_out_2 = parallel_data ;
           if (d_out_2 > Threshold)  //Detected a black line
              data_to_ls[2] = 1; 
           else  //Detected a white area
              data_to_ls[2] = 0 ;    
           end
       2 : begin
           d_out_0 = parallel_data ;
           if (d_out_0 > Threshold)  //Detected a black line
              data_to_ls[0] = 1 ; 
           else  //Detected a white area
              data_to_ls[0] = 0 ;
           end
       3 : begin
           d_out_1 = parallel_data ;
           if (d_out_1 > Threshold)  //Detected a black line
              data_to_ls[1] = 1 ; 
           else  //Detected a white area
              data_to_ls[1] = 0 ;
           end
     endcase
    end
end

assign data_to_linesensor = data_to_ls ;
endmodule

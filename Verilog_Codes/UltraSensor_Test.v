// echo - Pin 40 (B 12); Trigger - Pin 39 (D 12)
module UltraSensor_Test(
    input clk,
    input echo,
    output trig,
    output obj_det
    );
    reg [8:0] ten_us_count = 0 ;  //100 counts = 100 * 20 ns = 10 us
    reg [20:0] cycle_count = 0 ;     //1900000 counts (38 ms)
    reg [10:0] cycle_no = 1 ;
    reg [10:0] temp = 0;
    reg trigger = 0 ;
    reg object_det = 0 ;
    integer dist_counter = 0 ;
    integer distance ;
    localparam Threshold = 100000000 ; //10 cm
    assign trig = trigger ;
    assign obj_det = object_det ;
    always@ (posedge clk)
    begin
      if (temp != cycle_no)
         begin
         trigger = 1 ;  
         dist_counter = 0 ;
         temp = cycle_no ;
         end 
      ten_us_count = (ten_us_count == 500)? 1 : ten_us_count + 1 ;
      cycle_count = (cycle_count == 1900000)? 1 : cycle_count + 1 ;
      cycle_no = (cycle_count == 1900000)? cycle_no + 1 : cycle_no ;
      if (ten_us_count == 500)
         trigger = 0 ;
      if(echo == 1)
        dist_counter = dist_counter + 1 ;
      if (echo == 0 && dist_counter > 1)  
       begin
         //distance = 0.0172 * dist_counter * 20 * 0.001; //distance in cm
         distance = 172 * 20 * dist_counter ; //dist_counter * 20ns = time(in ns) | * 0.001 = time(in us)
         //distance in nm
         if (distance < Threshold) //less than 10 cm (100000000 nm)
           object_det = 1 ;
         else
           object_det = 0 ;  
       end
    end
endmodule

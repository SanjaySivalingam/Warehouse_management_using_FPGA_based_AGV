`timescale 1ns / 1ps
module Warehouse_topmodule(
    input FPGA_clk,    //FPGA clock
    input data_from_adc,
	 input echo_signal,
    output adc_cs,
    output adc_channel_ip,
    output adc_clk,
	 output trigger_signal,
    output [1:0] motor_A ,  //right
    output [1:0] motor_B ,   //left
    output object_det,
	 output [2:0] data_ls_mc,
	 output el_sig
    );
    
 
 wire [7:0] cur_node_info  ;
 wire [7:0] next_node_info ;
 wire bot_stop ;
 wire [1:0] dir ;
 wire [7:0] src, dest ;
 wire [95:0] path ;
 wire path_rdy ;

 
    
 adc_control m1(
	.clk_50(FPGA_clk),				//50 MHz clock
	.dout(data_from_adc),				//digital output from ADC128S022 (serial 12-bit)
	.adc_cs_n(adc_cs),			//ADC128S022 Chip Select
	.din(adc_channel_ip),					//Ch. address input to ADC128S022 (serial)
	.adc_sck(adc_clk),			//2.5 MHz ADC clock
    .data_to_linesensor(data_ls_mc)	  // 0 - left ; 1 - centre ; 2 - right
    );   
      
 UltraSensor_Test m2(
    .clk(FPGA_clk),
    .echo(echo_signal),
    .trig(trigger_signal),
    .obj_det(object_det)
    );		
 
 electro_control m3(
              .clk(FPGA_clk),
				  .cur_node(cur_node_info),
				  .control_sig(el_sig)			  
				  );	 
    
  motor_control m4(
    .clk(FPGA_clk),
    .ip_from_ls(data_ls_mc),
    .stop_signal(bot_stop),
	 .current_node(cur_node_info),
    .directions(dir) ,
    .a(motor_A),.b(motor_B) 
      );
      
  dijkstra_mod m5(
    .clk(FPGA_clk),
    .src(src),
    .dest(dest),
    .path_ready(path_rdy),
    .path(path) //can accompany 12 nodes including src and dest
    );    
   
   path_planner_mod m6(
    .clk(FPGA_clk),
    .current_node(cur_node_info),
    .next_node(next_node_info),
    .source(src) ,
    .destination(dest) 
    );  
    
    coordinator_mod m7(  //includes node detection
    .clk(FPGA_clk),
    .path_info(path),
    .ip_from_ls(data_ls_mc),
    .path_ready_sig(path_rdy),
    .current_node(cur_node_info),
    .next_node(next_node_info),
    .src(src),
    .dest(dest),
	 .obj_det(object_det),
    .stop(bot_stop),
    .dir_info(dir)  //00 - straight ; 01 - right ; 10 - left ; 11 - 180 degree turn
	 ); 
	 
	data_map m8(
       .clk(FPGA_clk),
       .data_in(data_read),
       .destn()
		 );
		 

   xbee_control m9(
    .RX(),
    .clk(FPGA_clk),
    .data_read(data_read) 
    ); 

       
endmodule

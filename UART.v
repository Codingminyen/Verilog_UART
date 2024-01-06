`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2023 05:31:46 PM
// Design Name: 
// Module Name: UART_template
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_template(
input rx, clk, start,
input [7:0] tx_input,
output [7:0] rx_output,
output reg tx,
output txDone, rxDone
);

reg [9:0] txData;


parameter clk_freq= 100_000;//100khz 
parameter baudrate = 9600;//9600 baudrate

parameter wait_count = clk_freq/baudrate; 
parameter idle = 0, send = 1, check = 2;
integer count=0;
reg bitDone=1'b0;
integer bitIndex = 0;
reg [1:0] state= idle;
reg state_cnt = idle;
reg [9:0] shift_index;

// bitDone Singal // 
always@(posedge clk)
begin
if (state != idle)
    begin
        if(count < wait_count)	 
            begin
                count<= count +1;
                bitDone<=1'b0;        
            end 
        else 
            begin 
                count<=0;
                bitDone<=1'b1;
            end
    end
else
    begin
        count <=0;
    end
end
    ///////////////////

//tx logic
always@(posedge clk)
begin
case(state)
idle:
	begin
	if (start==1'b1)
		begin
			bitIndex = 0;
			state = send;
			txData = {1'b0, tx_input, 1'b1}; // start data end
		end
	else
	begin
	   state= idle;
	end
	end
send:
	begin 
        //$display("state_send");
        //$display(state);
	if (bitDone == 1'b1)
		begin
		        //$display("bitDone");
			tx<= txData[bitIndex];
			state = check;
			shift_index[bitIndex] <= {txData[bitIndex], shift_index[9:1]}; 
		end
	//$display("Send");
	end
	
// check if all bits are sent
check:
	begin
        //$display("state_check");
        //$display(state);
		if (bitIndex==9)
		begin
			state = idle;
		end
		else
		begin 
			bitIndex <=bitIndex+1;
			state<=send;
		end
	end
default: state <= idle;
endcase
end
assign txDone = (bitDone ==1 & bitIndex==9 );




parameter ridle=0, rwait=1, rcheck = 2;
reg   [1:0]rstate = ridle;
reg   [9:0] rxData=0;
integer   rindex= 0;

 // rx bit counter
integer rcount = 0;
reg recv_flag = 1'b0;
reg r_bitDone = 1'b0;


always@(posedge clk)
begin 
	if(rstate!= ridle)
    begin
        if(rcount< wait_count)
            begin
                rcount <= rcount+1;
                r_bitDone <=1'b0;
            end
        else
            begin
                rcount <= 0;
                r_bitDone <=1'b1;

            end    
    end
    else
    begin
    		rcount <= 0;
    end
end 
// rx logic
always@(posedge clk)
begin 
case(rstate)
ridle:
	begin
	   //$display("State:",rstate);
		if (rx==1'b1)
			begin
			rstate <= rwait;
			rindex<=0;
			end
		else
			rstate <= ridle;
	end	
	
rwait:
	begin 
       //$display("State:",rstate);
		if(rcount < wait_count/2)	
			rstate <= rwait; // stay at the wait state
		else
		begin
		    //$display("rx value:", rx);
            rxData[rindex]<= rx;
    		rstate <= rcheck;
	   end
	end
rcheck:
	begin
	//$display("State:",rstate);
    if (r_bitDone == 1'b1 )
			begin 

                if (rindex==9)
                    begin
                        rstate<=ridle;
                    end
                else
                    begin
					
						rstate <= rwait;
						rindex <= rindex+1;
					end
			end
	end


endcase
end
///
assign rx_output= rxData[8:1];
assign rxDone = ( r_bitDone==1 & rindex==9 );



endmodule


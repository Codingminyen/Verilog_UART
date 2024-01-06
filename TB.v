`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2023 10:26:38 PM
// Design Name: 
// Module Name: TB
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


module TB;
    reg clk = 0;
	reg start_A = 0;
    reg [7:0] txin_A;
    wire [7:0] rxout_A;
	wire rxdone_A, txdone_A;

	
	reg start_B = 0;
    reg [7:0] txin_B;
    wire [7:0] rxout_B;
	wire rxdone_B, txdone_B;


	wire txArxB, rxAtxB;

 
 /*
 
module UART_template(
input rx, clk, start,
input [7:0] tx_input,
output [7:0] rx_output,
output reg tx,
output txDone, rxDone
);
 */
UART_template uA(rxAtxB, clk, start_A, txin_A, rxout_A, txArxB , txdone_A,  rxdone_A );
UART_template uB(txArxB, clk, start_B, txin_B, rxout_B, rxAtxB , txdone_B,   rxdone_B );



 integer i = 0;
 
 initial 
 begin
 
 for(i = 0; i < 10; i = i + 1)
 begin
  txin_A = $urandom_range(10 , 200);
 #10start_A = 1;
 #20 start_A=0;
 @(posedge txdone_A);
 @(posedge rxdone_B);

 end
 $stop; 
 end
 
 always #5 clk = ~clk;
 
endmodule

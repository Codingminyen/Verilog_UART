`timescale 1ns / 1ps

module Tx(


);

parameter fqclk = 1000000; //1MHz
parameter b_rate = 9600; //9600Hz
parameter wait_clk = fqclk/b_rate;

initial begin
$display("Wait_clk");
$display(wait_clk);
end

endmodule

`timescale 1ns/1ps

module sim_cpu ();
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg[23:0] switch2N4 = 24'h4C0000;
    wire[23:0] led_out;
    
    cpu_top cpu (clk, rst, switch2N4, led_out);
    
    initial begin
        #7000 rst = 1'b0;
    end
    
    always #10 clk = ~clk;
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2019 01:58:02 PM
// Design Name: 
// Module Name: sim_demem32
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


module sim_demem32();
    wire[31:0] read_data;
    
    reg[31:0] address = 32'h00000014;
    reg write_data;
    
    reg clock = 1'b1;
    reg memWrite = 1'b0;
    
    dmemory32 mem (read_data, address, write_data, memWrite, clock);
    
    initial begin
    
    end
    
    always #10 clock = ~clock;
    
    always #40 address = address + 4;
endmodule

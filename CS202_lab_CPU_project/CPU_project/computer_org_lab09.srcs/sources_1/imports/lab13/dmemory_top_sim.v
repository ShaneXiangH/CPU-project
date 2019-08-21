`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/21 01:07:46
// Design Name: 
// Module Name: dmemory_top_sim
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


module dmemory_top_sim( );
    reg clk, reset;                          // 时钟和复位信号
    reg  memwrite, memread, iowrite, ioread; // 来自控制单元的控制信号
    reg [31:0]  caddress;                    // 来自 executs32 的 alu_result 
    reg [23:0]  switch_in;                   // 拨码开关输入
    reg [31:0]  wdata;                       // 从译码单元拿到的data，要写进memory或者IO输出
    wire [31:0] rdata;                       // 从memory或者IO读进来的data，要给译码单元写入寄存器
    wire [23:0] ledout;                      // led灯输出
    
    dmemory_top u(clk, reset, memwrite, memread, iowrite, ioread, caddress, switch_in, wdata, rdata, ledout);
    
    initial begin
    clk = 0;
    reset = 1;
    caddress = 32'h00000010;
    memread = 1'b1;
    memwrite = 1'b0;
    ioread = 1'b0; 
    iowrite = 1'b0 ;
    
    #5    reset = 1'b0;
    #195   begin  switch_in = {{4{1'b1}}, {4{1'b0}}, {8{1'b1}}}; caddress = 32'hfffffc70;memwrite = 1'b0;memread = 1'b0;ioread = 1'b1;end;
    #400   begin  caddress = 32'h00000001;wdata = 32'h00000007;memwrite = 1'b1;ioread = 1'b0;end;
    #200   begin  caddress = 32'h00000001;memwrite = 1'b0;memread = 1'b1;end;        
    #200   begin  caddress = 32'hfffffc60;iowrite=1'b1;memread = 1'b0; end;        
    end
    always #50 clk = ~clk;
endmodule

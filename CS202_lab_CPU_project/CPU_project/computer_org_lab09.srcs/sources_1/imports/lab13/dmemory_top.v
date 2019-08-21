`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/20 21:45:15
// Design Name: 
// Module Name: dmemory_top
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


module dmemory_top(clk, reset, memwrite, memread, iowrite, ioread, caddress, switch_in, wdata, rdata, ledout);
    input clk, reset;                          // 时钟和复位信号
    input  memwrite, memread, iowrite, ioread; // 来自控制单元的控制信号
    input [31:0]  caddress;                    // 来自 executs32 的 alu_result 
    input [23:0]  switch_in;                   // 拨码开关输入
    input [31:0]  wdata;                       // 从译码单元拿到的data，要写进memory或者IO输出
    output [31:0] rdata;                       // 从memory或者IO读进来的data，要给译码单元写入寄存器
    output [23:0] ledout;                      // led灯输出
    
    // 中间变量
    wire [31:0] mread_data, address, write_data;
    wire LEDCtrl, SwitchCtrl;
    wire [15:0] 
        switchrdata, ioread_data;
    
    //module memorio(caddress,address,memread,memwrite,ioread,iowrite,mread_data,ioread_data,wdata,rdata,write_data,LEDCtrl,SwitchCtrl);
    memorio u1(caddress,address,memread,memwrite,ioread,iowrite,mread_data,ioread_data,wdata,rdata,write_data,LEDCtrl,SwitchCtrl);
    //module dmemory32(read_data,address,write_data,Memwrite,clock);
    dmemory32 u2(mread_data,address,write_data,memwrite,clk);
    //module ioread(reset,ior,switchctrl,ioread_data 16 bits,ioread_data_switch);
    ioread u3(reset,ioread,SwitchCtrl,ioread_data, switchrdata);
    //module leds(led_clk, ledrst, ledwrite, ledcs, ledaddr,ledwdata, ledout);
    leds u4(clk, reset, LEDCtrl, LEDCtrl, address[1:0], write_data, ledout);
    //module switchs(switclk, switrst, switchread, switchcs,switchaddr, switchrdata, switch_i);
    switchs u5(clk, reset, SwitchCtrl, SwitchCtrl,address[1:0], switchrdata, switch_in);
    
endmodule

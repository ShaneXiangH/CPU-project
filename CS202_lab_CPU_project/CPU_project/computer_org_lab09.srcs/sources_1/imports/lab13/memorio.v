`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module memorio(caddress,address,memread,memwrite,ioread,iowrite,mread_data,ioread_data,wdata,rdata,write_data,LEDCtrl,SwitchCtrl);
    input[31:0] caddress;       // from alu_result in executs32
    input memread;				// read memory, from control32
    input memwrite;				// write memory, from control32
    input ioread;				// read IO, from control32
    input iowrite;				// write IO, from control32
    input[31:0] mread_data;		// data from memory
    input[15:0] ioread_data;	// data from io,16 bits
    input[31:0] wdata;			// the data from idecode32,that want to write memory or io
    output[31:0] rdata;			// data from memory or IO that want to read into register
    output[31:0] write_data;    // data to memory or I/O
    output[31:0] address;       // address to mAddress and I/O
	
    output LEDCtrl;				// LED CS
    output SwitchCtrl;          // Switch CS
    
    reg[31:0] write_data;
//    wire iorw;//这个用来干啥？？？？？
    
    assign  address = caddress;
    assign  rdata = (memread) ? mread_data : {{16'b0},ioread_data};
//    assign  iorw = (iowrite||ioread);
	
	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	assign	LEDCtrl = iowrite && (caddress[31:4] == 28'hfffffc6); // 写入     Minisys开发板上有24个led灯：首地址为0xFFFFFC60，基于该地址可做16bit数据的写入操作，剩余的8bit数据（24-16）基于0xFFFFFC62进行写入
	assign	SwitchCtrl = ioread && (caddress[31:4] == 28'hfffffc7); // 读出   Minisys开发板上有24个拨码开关：首地址为0xFFFFFC70，基于该地址可做16bit数据的读出操作，剩余的8bit数据（24-16）基于0xFFFFFC72进行读出
							
    always @* begin
        if((memwrite == 1) || (iowrite == 1)) begin
            write_data = (memwrite == 1) ? wdata : {{16'b0}, wdata[15:0]};
        end
        else begin
            write_data = 32'hZZZZZZZZ;
        end
    end
endmodule
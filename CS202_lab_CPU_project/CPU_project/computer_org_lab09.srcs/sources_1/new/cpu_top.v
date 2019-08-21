`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2019 07:45:48 AM
// Design Name: 
// Module Name: cpu_top
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


module cpu_top(
    input clk, // 100MHz
    input rst,
    input[23:0] switch2N4,
    input[23:0] led2N4
    );
    
    wire clock;
    
    //----------------------idecode32 out signal-----------------------
    wire[31:0] read_data_1, read_data_2;
    wire[31:0] Sign_extend;
    //----------------------idecode32 out signal-----------------------
    
    // --------------------control out signal---------------------
    wire jrn;
    wire regDST;
    wire ALUSrc;
    wire memorIOtoReg;
    wire regWrite;
    wire memWrite, memRead;
    wire ioWrite, ioRead;
    wire branch, nBranch;
    wire jmp, jal;
    wire i_format;
    wire sftmd;
    wire[1:0] ALUOp;
    // --------------------control out signal---------------------
    
    // --------------------exe out signal -------------------------
    wire zero;
    wire[31:0] ALU_Result;
    wire[31:0] add_Result;
    // --------------------exe out signal -------------------------
    
    // ---------------------ifetc32 out signal----------------------------
    wire[31:0] instruction;
    wire[31:0] pc_plus_4;
    wire[31:0] opcplus4;
    wire[31:0] next_PC;
    wire[31:0] PC;
    //----------------------ifetc32 out signal----------------------------
    
    //----------------------memoryIO out signal---------------------------
    wire[31:0] rdata, write_data, address;
    wire LEDCtrl, switchCtrl;
    //----------------------memoryIO out signal---------------------------
    
    //----------------------io read------------------------
    wire[15:0] ioRead_data;
    
    //---------------------memory--------------------------
    wire[31:0] read_data;
    
    //---------------------switch output----------------------
    wire[15:0] switchrdata;
    
    cpuclk cpuclk (
        .clk_in1(clk),   // 100MHz
        .clk_out1(clock) // cpu clock
    );
    
    Ifetc32 ifetch (
        .Instruction  (instruction),
        .PC_plus_4_out(pc_plus_4),
        .Add_result   (add_Result),
        .Read_data_1  (read_data_1),
        .Branch       (branch),
        .nBranch      (nBranch),
        .Jmp          (jmp),
        .Jrn          (jrn),
        .Jal          (jal),
        .Zero         (zero),
        .clock        (clock),
        .reset        (rst),
        .opcplus4     (opcplus4),
        .next_PC      (next_PC),
        .PC           (PC)
    );
    
    Idecode32 idecode (
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .Instruction(instruction),
        .read_data  (rdata), // from data ram or I/O port
        .ALU_result (ALU_Result), // from execute section
        .Jal        (jal), // from control
        .RegWrite   (regWrite),
        .MemtoReg   (memorIOtoReg),
        .RegDst     (regDST), // from control
        .Sign_extend(Sign_extend),
        .clock      (clock),
        .reset      (rst),
        .opcplus4   (opcplus4)
    );
    
    control32 control (
        .Opcode(instruction[31:26]),
        .Function_opcode(instruction[5:0]),
        .Alu_resultHigh(ALU_Result[31:10]),
        .Jrn(jrn),
        .RegDST(regDST),
        .ALUSrc(ALUSrc),
        .MemorIOtoReg(memorIOtoReg),
        .RegWrite(regWrite),
        .MemRead(memRead),
        .MemWrite(memWrite),
        .IORead(ioRead),
        .IOWrite(ioWrite),
        .Branch(branch),
        .nBranch(nBranch),
        .Jmp(jmp),
        .Jal(jal),
        .I_format(i_format),
        .Sftmd(sftmd),
        .ALUOp(ALUOp)
    );
    
    Executs32 execute ( // Ok
        .Read_data_1(read_data_1),
        .Read_data_2(read_data_2),
        .Sign_extend(Sign_extend),
        .Function_opcode(instruction[5:0]),
        .Exe_opcode(instruction[31:26]),
        .ALUOp(ALUOp),
        .Shamt(instruction[10:6]),
        .Sftmd(sftmd),
        .ALUSrc(ALUSrc),
        .I_format(i_format),
        .Jrn(jrn),
        .Zero(zero),
        .ALU_Result(ALU_Result),
        .Add_Result(add_Result),
        .PC_plus_4(pc_plus_4)
    );
    
    dmemory32 memory (
        .read_data(read_data),
        .address(address),
        .write_data(read_data_2),
        .Memwrite(memWrite),
        .clock(clock)
    );
    
    memorio memio(
        .caddress(ALU_Result),
        .address(address),
        .memread(memRead),
        .memwrite(memWrite),
        .ioread(ioRead),
        .iowrite(ioWrite),
        .mread_data(read_data),
        .ioread_data(ioRead_data),
        .wdata(read_data_2),
        .rdata(rdata),
        .write_data(write_data),
        .LEDCtrl(LEDCtrl),
        .SwitchCtrl(switchCtrl)
    );
    
    ioread multiioread(
        .reset(rst),
        .ior(ioRead),
        .switchctrl(switchCtrl),
        .ioread_data(ioRead_data),
        .ioread_data_switch(switchrdata)
    );
    
    leds led24(
        .led_clk(clock),
        .ledrst(rst),
        .ledwrite(LEDCtrl),
        .ledcs(LEDCtrl),
        .ledaddr(address[1:0]),
        .ledwdata(write_data[15:0]),
        .ledout(led2N4)
    );
    
    switchs switch24(
        .switclk(clock),
        .switrst(rst),
        .switchcs(switchCtrl),
        .switchaddr(address[1:0]),
        .switchread(switchCtrl),
        .switchrdata(switchrdata),
        .switch_i(switch2N4)
    );
endmodule

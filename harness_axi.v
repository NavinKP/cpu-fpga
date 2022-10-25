`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2022 01:49:52 PM
// Design Name: 
// Module Name: harness_axi
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


module harness_axi(
        input clk,
		input reset,
		output [31:0] iaddr,
		input [31:0] idata0,
		input [31:0] idata1,
		input [31:0] idata2,
		input [31:0] idata3,
		input [31:0] idata4,
		input [31:0] idata5,
		input [31:0] idata6,
		input [31:0] idata7,
		input [31:0] idata8,
		input [31:0] idata9,
		input [31:0] idata10,
		input [31:0] idata11,
		input [31:0] idata12,
		input [31:0] idata13,
		input [31:0] idata14,
		input [31:0] idata15,
		input [31:0] idata16,
		input [31:0] idata17,
		input [31:0] idata18,
		input [31:0] idata19,
		input [31:0] idata20,
		input [31:0] idata21,
		input [31:0] idata22,
		input [31:0] idata23,
		input [31:0] idata24,
		input [31:0] idata25,
		input [31:0] idata26,
		input [31:0] idata27,
		input [31:0] idata28,
		input [31:0] idata29,
		input [31:0] idata30,
		input [31:0] idata31,
		output [31:0] reg0,
		output [31:0] reg1,
		output [31:0] reg2,
		output [31:0] reg3,
		output [31:0] reg4,
		output [31:0] reg5,
		output [31:0] reg6,
		output [31:0] reg7,
		output [31:0] reg8,
		output [31:0] reg9,
		output [31:0] reg10,
		output [31:0] reg11,
		output [31:0] reg12,
		output [31:0] reg13,
		output [31:0] reg14,
		output [31:0] reg15,
		output [31:0] reg16,
		output [31:0] reg17,
		output [31:0] reg18,
		output [31:0] reg19,
		output [31:0] reg20,
		output [31:0] reg21,
		output [31:0] reg22,
		output [31:0] reg23,
		output [31:0] reg24,
		output [31:0] reg25,
		output [31:0] reg26,
		output [31:0] reg27,
		output [31:0] reg28,
		output [31:0] reg29,
		output [31:0] reg30,
		output [31:0] reg31
    );
    reg [31:0] idata;
    wire [31:0] daddr, drdata, dwdata;
    wire [31:0] iaddr;
    wire [3:0] dwe;
    always@(*) begin
		if(reset)
			idata <= 0;
		else begin
        case(iaddr[6:2])
            5'd0 : idata <= idata0;
            5'd1 : idata <= idata1;
            5'd2 : idata <= idata2;
            5'd3 : idata <= idata3;
            5'd4 : idata <= idata4;
            5'd5 : idata <= idata5;
            5'd6 : idata <= idata6;
            5'd7 : idata <= idata7;
            5'd8 : idata <= idata8;
            5'd9 : idata <= idata9;
            5'd10 : idata <= idata10;
            5'd11 : idata <= idata11;
            5'd12 : idata <= idata12;
            5'd13 : idata <= idata13;
            5'd14 : idata <= idata14;
            5'd15 : idata <= idata15;
            5'd16 : idata <= idata16;
            5'd17 : idata <= idata17;
            5'd18 : idata <= idata18;
            5'd19 : idata <= idata19;
            5'd20 : idata <= idata20;
            5'd21 : idata <= idata21;
            5'd22 : idata <= idata22;
            5'd23 : idata <= idata23;
            5'd24 : idata <= idata24;
            5'd25 : idata <= idata25;
            5'd26 : idata <= idata26;
            5'd27 : idata <= idata27;
            5'd28 : idata <= idata28;
            5'd29 : idata <= idata29;
            5'd30 : idata <= idata30;
            5'd31 : idata <= idata31;
            default: idata <= 0;
        endcase
		end
   end
   
   wire [32*32-1:0] registers;
   assign {reg31, reg30, reg29, reg28, reg27, reg26, reg25, reg24, reg23, reg22, reg21, reg20, reg19, reg18, reg17, reg16, reg15, reg14, reg13, reg12, reg11, reg10, reg9, reg8, reg7, reg6, reg5, reg4, reg3, reg2, reg1, reg0} 
           = registers;
   cpu u1(
        .clk(clk),
        .reset(reset),
        .iaddr(iaddr),
        .idata(idata),
        .daddr(daddr),
        .drdata(drdata),
        .dwdata(dwdata),
        .dwe(dwe),
        .registers(registers)
    );
    dmem u3(
        .clk(clk),
        .daddr(daddr),
        .drdata(drdata),
        .dwdata(dwdata),
        .dwe(dwe)
    );
endmodule

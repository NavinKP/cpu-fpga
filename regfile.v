/*
  Author: navin kp- EE20B088 
  Regfile module
  Description: Declare 32 registers of width 32-bits and initialise them by reading from a .mem file
               Implement Synchronous Write to and asynchronous read from the regfile
*/


`define INIT_MEM "init_regfile.mem"
module regfile(
    input [4:0] rs1,     // address of first operand to read - 5 bits
    input [4:0] rs2,     // address of second operand
    input [4:0] rd,      // address of value to write
    input we,            // should write update occur
    input [31:0] wdata,  // value to be written
    output [31:0] rv1,   // First read value
    output [31:0] rv2,   // Second read value
    input clk,            // Clock signal - all changes at clock posedge
    output [32*32-1 :0] registers
);
    // Desired function
    // rv1, rv2 are combinational outputs - they will update whenever rs1, rs2 change
    // on clock edge, if we=1, regfile entry for rd will be updated
    reg [31:0] x [0:31];
    initial begin       // synthesised as Distributed RAM using LUTs
      $readmemh(`INIT_MEM, x);
    end
    //Synchronous Write to reg
    always @(posedge clk) begin
    if(we) begin
      if(rd == 5'b0)  x[0] <= 32'b0;
      else            x[rd] <= wdata;
    end
    end
    //Async read
    assign registers = {x[31], x[30], x[29], x[28], x[27], x[26], x[25], x[24], x[23], x[22], x[21], x[20], x[19], x[18], x[17], x[16], x[15], x[14], x[13], x[12], x[11], x[10], x[9], x[8], x[7], x[6], x[5], x[4], x[3], x[2], x[1], x[0]};
    assign rv1 = x[rs1];
    assign rv2 = x[rs2];
endmodule

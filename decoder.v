/*
  Author: navin kp - EE20B088
  Single Cycle CPU Implementation- ALU, Load and Store Instructions, Branching Instructions for RV32I ISA
  Decoder module
  Description: Split 32 bit instruction into rs1, rs2, 7 bit instr opcode, funct 3 and funct7
               Use redundancies in RV32I instructions to generate a 6 bit op which can be used as control signals
                to trigger particular instruction in the ALU or control modules
               Illegal instructions set to 32'b0, which triggers default cases in ALU and control modules
                NOTE: Sequences such as 6'b0 and 6'b3F are not allotted to the 6 bit op to avoid an unintended
                      reset from triggering a module
*/

module decoder(
    input [31:0] instr,  // Full 32-b instruction
    output [5:0] op,     // some operation encoding of your choice
    output [4:0] rs1,    // First operand
    output [4:0] rs2,    // Second operand
    output [4:0] rd,     // Output reg
    input  [31:0] r_rv2, // From RegFile
    output [31:0] rv2,   // To ALU
    output [31:0] imm_val // Immediate used as relative address in Branching and as upper imm in LUI
);
reg [31:0] rv2;
reg [5:0] op;
reg [4:0] rs1, rs2, rd;
reg [6:0] instr_opcode;
reg [2:0] funct3;
reg [6:0] funct7;
reg [31:0] imm_val;
//  Decode instructions for ALU, Load/Store, Branch and Upper Immediate instructions in RV32I (FENCE and ECALL to be done later)
always @(instr) begin
  rs1 = instr[19:15];
  rs2 = instr[24:20];
  rd = instr[11:7];
  //
  instr_opcode = instr[6:0];
  funct3 = instr[14:12];
  funct7 = instr[31:25];
  //
  if (instr == 32'b0)  op = 6'b0;   // Instr == 00 treated as NOP (no op corr to 6'b0, no changes made)
  else if ({instr_opcode[4], instr_opcode[2]} == 2'b10) begin
    // Instruction is ALU type
     op[3] = 1;
     op[5] = instr_opcode[5];  // instruction type: reg (1) or imm (0)
     op[2:0] = funct3;         // three bits encoding the instruction

     // op[5] behaves like alu_src control signal
     // setting op[4] and rv2
     if (op[5] == 1'b1) begin
       rv2 = r_rv2;        // source 2 is value returned by regfile
       op[4] = funct7[5];  // encode add/sub and srl/sra
     end
     else if (op[1:0] == 2'b01) begin  // => the operation is a shift immediate
       rv2 = {{27{instr[24]}}, instr[24:20]}; //sign extend shamt;
                                         //alu considers only lower 5 bits of imm for shift
       op[4] = funct7[5];     // srli/srai
     end
     else begin
       rv2 = {{20{instr[31]}}, instr[31:20]}; //sign extend immediate
       op[4] = 1'b0;
     end
  end
  else begin
    // Instruction is Load/Store or Branch type (neglecting FENCE and ECALL for now)
    op[3] = 0;
    op[4] = ({instr_opcode[6], instr_opcode[4]} == 2'b00);  // LOAD-STORE : 1; else: 0
    if (op[4]) begin
      // Load-store instructions
      op[5] = instr_opcode[5];  // 1: store, 0: LOAD
      op[2:0] = funct3;         // three bits encoding the instruction
      if (op[5] == 0)   rv2 = {{20{instr[31]}}, instr[31:20]};              // load
      else              rv2 = {{20{instr[31]}}, instr[31:25], instr[11:7]};  // store
      // differentiating between diff types of load and store done by op[2:0] (= funct3)
    end else begin
      op[5] = ({instr_opcode[6:5], instr_opcode[2]} == 3'b110); // 1: conditional branch, 0: JAL, JALR, AUIPC or LUI
      if (op[5]) begin    // Conditional Branch Instructions
      op[2:0] = funct3;         // three bits encoding the instruction
      rv2 = r_rv2;              // alu to compute val(rs1) - val(rs2)
      imm_val = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
      // sign_ext(imm[12], imm[11], imm[10:5], imm[4:1], 0)
      end else begin  // JALR, JAL, LUI, AUIPC
          op[2:0] = instr_opcode[5:3];
          case(op[2:0])
            3'b100 :  rv2 =  {{20{instr[31]}}, instr[31:20]};             // JALR
            3'b101 :  imm_val =  {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; // JAL
            3'b010 :  imm_val = {instr[31:12], 12'b0};    // AUIPC
            3'b110 :  imm_val = {instr[31:12], 12'b0};    // LUI
            // Don't care about default, if op doesnt match any of the 4 above values, it is illegal
            // which is taken care of by the default cases in control and alu modules
          endcase
          end
    end
    end
  end
endmodule

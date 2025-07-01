module RISC_CPU (
    input clk_i,
    input reset_i,
);


wire [63:0] PC_plus4;
wire [63:0] PCMuxOut;
two_1Mux64 PCinMux
(.a(PC_plus4),//pc + 4
.b(BranchALUXpipe_out),//pc + branch offset
.sel(),//branch taken logic
.out(PCMuxOut));

wire PC_w;
ProgCount Program_Counter
(.clk_i,
.reset_i,
.PC_i(PCMuxOut),
.PC_o(PC_w));


PC_ALU PC_ALU
(.PC_in(PC_w),
.PC_next(PC_plus4));

wire [31:0] InstructionMem_out;
Instruction_Memory InstructionMem
 (.clk_i,
 .reset_i,
 .rd_valid_i(),//figure out logic(could be always one)
 .rd_addr_i(PC_w),
 .rd_data_o(InstructionMem_out));

wire [31:0] InstructionFPipe_out;
wire [63:0] PCFPipe_out;
FD_pipeline FDPipe
(.clk_i,
.reset_i,
.pipeline_flush(),
.instruction_i(InstructionMem_out),
.PC_i(PC_w),
.valid_i(),
.ready_o(),
.valid_o(),
.ready_i(),
.instruction_o(InstructionFPipe_out),
.PC_o(PCFPipe_out));

wire [3:0] rd,rs1,rs2,
wire [2:0] funct3,
wire [6:0] opcode,
wire [6:0] funct7,
wire [$clog2(6)-1:0] I_Type
Instruction_Parser Instruction_Parser
(.Instruction(InstructionPFipe_out),
.rd(rd),
.rs1(rs1),
.rs2(rs2),
.funct3(funct3),
.opcode(opcode),
.funct7(funct7),
.I_Type(I_Type));

wire [63:0] immediate64bit;
immediateParser immediateParser
(.Instruction(InstructionPFipe_out),
.I_Type(I_Type),
.constant(immediate64bit));

wire [31:0] rs1Out, rs2Out;
mem_Register Registers
(.clk_i,
.reset_i,
.wr_valid_i(),
.wr_data_i(MemToRegMuxOut[31:0]),//write data
.wr_addr_i(rd_mpipe_out),//rd
.rs1_valid_i(),
.rs1_addr_i(rs1),
.rs1_data_o(rs1Out),
.rs2_valid_i(),
.rs2_addr_i(rs2),
.rs2_data_o(rs2Out));

wire RegWrite, MemRead, MemWrite, ALUSrc, MemToReg;
wire [2:0] ALUOp;
Control CtrlUnit
(.funct3(funct3),
.opcode(opcode),
.funct7(funct7),
.I_Type(I_Type),
.RegWrite(RegWrite),
.MemRead(MemRead),
.MemWrite(MemWrite),
.MemToReg(MemToReg),
.ALUSrc(ALUSrc),
.ALUOp(ALUOp));

wire [63:0] PCDPipe_out;
wire [63:0] immediateDPipe_out;
wire [31:0] rs1DPipe_out, rs2DPipe_out;
wire [3:0] rd_adrOut,rs1_adrOut,rs2_adrOut,
wire RegWrite_Dpipe, MemRead_Dpipe, MemWrite_Dpipe, ALUSrc_Dpipe, MemToReg_Dpipe;
wire [2:0] ALUOp_Dpipe;
DX_pipeline DX_pipe
(.clk_i,
 .reset_i,
 .pipeline_flush(),
 .readData1_i(rs1Out),
 .readData2_i(rs2Out),
 .immediate_i(immediate64bit),
 .PC_i(PCFPipe_out),
 .rd_i(rd),
 .rs1_i(rs1),
 .rs2_i(rs2),
 .RegWrite_i(RegWrite),
 .MemWrite_i(MemWrite),
 .MemRead_i(MemRead),
 .MemToReg_i(MemToReg),
 .ALUSrc_i(ALUSrc),
 .ALUOp_i(ALUOp),
 .immediate_o(immediateDPipe_out),
 .PC_o(PCDPipe_out),
 .readData1_o(rs1DPipe_out),
 .readData2_o(rs2DPipe_out),
 .rd_o(rd_adrOut),
 .rs1_o(rs1_adrOut),
 .rs2_o(rs2_adrOut),
 .RegWrite_o(RegWrite_Dpipe),
 .MemWrite_o(MemWrite_Dpipe),
 .MemRead_o(MemRead_Dpipe),
 .MemToReg_o(MemToReg_Dpipe),
 .ALUSrc_o(ALUSrc_Dpipe),
 .ALUOp_o(ALUOp_Dpipe),
 .valid_i(),
 .ready_o(),
 .valid_o(),
 .ready_i());

wire [63:0] BranchALU_out;
BranchALU BranchALU
(.PC_val(PCDPipe_out),
.immediate(immediateDPipe_out),
.ALU_out(BranchALU_out));

//POTENTIAL FOR FORWARDING PATHS HERE


two_1Mux64 rs2Mux
wire [63:0] rs2ImmediateMuxOut;
(.a(immediateDPipe_out),//immediate
.b(rs2DPipe_out),//rs2
.sel(ALUSrc_Dpipe),
.out(rs2ImmediateMuxOut));


wire zeroSignal;
wire [63:0] ALUresultOut;
mainALU mainALU
(.op1(rs1DPipe_out),
.op2(rs2ImmediateMuxOut),
.operand(ALUOp_Dpipe),
.out(ALUresultOut),
.zero(zeroSignal));


wire [63:0] BranchALUXpipe_out;
wire [63:0] ALU_resultXpipe;
wire RegWrite_Xpipe, MemRead_Xpipe, MemWrite_Xpipe, MemToReg_Xpipe;
wire zero_xpipe;
wire [3:0] rd_xpipeout;
wire [31:0] rs2XPipe_out;
XM_pipeleine XM_pipe
(.clk_i,
.reset_i,
.pipeline_flush(),
.zero_i(zeroSignal),
.BranchPC_i(BranchALU_out),
.result_i(ALUresultOut),
.MuxRes_i(rs2DPipe_out),//rs2 (could be changed when forwarding implemented)
.rd_i(rd_adrOut),
.RegWrite_i(RegWrite_Dpipe),
.MemWrite_i(MemWrite_Dpipe),
.MemRead_i(MemRead_Dpipe),
.MemToReg_i(MemToReg_Dpipe),
.zero_o(zero_xpipe),
.BranchPC_o(BranchALUXpipe_out),
.result_o(ALU_resultXpipe),
.MuxRes_o(rs2XPipe_out),
.rd_o(rd_xpipeout),
.RegWrite_o(RegWrite_Xpipe),
.MemWrite_o(MemWrite_Xpipe),
.MemRead_o(MemRead_Xpipe),
.MemToReg_o(MemToReg_Xpipe),
.valid_i(),
.ready_o(),
.valid_o(),
.ready_i());

wire [31:0] mem_data_o
mem_Rsync DataMemory
(.clk_i,
.reset_i,
.wr_valid_i(MemWrite_Xpipe),
.wr_data_i(MemRead_Xpipe),
.wr_addr_i(ALU_resultXpipe),
.rd_valid_i(MemRead_Xpipe),
.rd_addr_i(ALU_resultXpipe),
.rd_data_o(mem_data_o));

wire [31:0] mem_dataM_pipe;
wire [31:0] mem_adrM_pipe;
wire [3:0] rd_mpipe_out;
wire RegWrite_Mpipe, MemToReg_Mpipe;
MW_pipeline MW_pipe
(.clk_i,
.reset_i,
.pipeline_flush(),//do something with this
.mem_data_i(mem_data_o),
.rd_i(rd_xpipeout),
.mem_address_i(ALU_resultXpipe),
.RegWrite_i(RegWrite_Xpipe),
.MemToReg_i(MemToReg_Xpipe),
.mem_data_o(mem_dataM_pipe),
.mem_address_o(mem_adrM_pipe),
.rd_o(rd_mpipe_out),
.RegWrite_o(RegWrite_Mpipe),
.MemToReg_o(MemToReg_Mpipe),
.valid_i(),
.ready_o(),
.valid_o(),
.ready_i());

wire [63:0] MemToRegMuxOut;
two_1Mux64 MemToRegMux
(.a(mem_adrM_pipe),
.b(mem_dataM_pipe),
.sel(MemToReg_Mpipe),
.out(MemToRegMuxOut));



endmodule

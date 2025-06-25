module RISC_CPU (
    input clk_i,
    input reset_i,
);


wire PC_w;
ProgCount Program_Counter
(.clk_i,
.reset_i,
.PC_i(),
.PC_o(PC_w));



PC_ALU PC_ALU
(.PC_in(PC_w),
.PC_next());


Instruction_Memory InstructionMem
 (.clk_i,
 .reset_i,
 .rd_valid_i(),
 .rd_addr_i(),
 .rd_data_o());


FD_pipeline FDPipe
(.clk_i,
.reset_i,
.pipeline_flush(),
.instruction_i(),
.PC_i(),
.valid_i(),
.ready_o(),
.valid_o(),
.ready_i(),
.instruction_o(),
.PC_o());


Instruction_Parser Instruction_Parser
(.Instruction(),
.rd(),
.rs1(),
.rs2(),
.funct3(),
.opcode(),
.funct7(),
.I_Type());

immediateParser immediateParser
(.Instruction(),
.I_Type(),
.constant());

mem_Register Registers
(.clk_i,
.reset_i,
.wr_valid_i(),
.wr_data_i(),
.wr_addr_i(),
.rd_valid_i(),
.rd_addr_i(),
.rd_data_o(),
.rs1_valid_i(),
.rs1_addr_i(),
.rs1_data_o(),
.rs2_valid_i(),
.rs2_addr_i(),
.rs2_data_o());


Control CtrlUnit
(.funct3(),
.opcode(),
.funct7(),
.I_Type(),
.RegWrite(),
.MemRead(),
.MemWrite(),
.ALUSrc(),
.ALUOp());

DX_pipeline DX_pipe
(.clk_i,
 .reset_i,
 .pipeline_flush(),
 .readData1_i(),
 .readData2_i(),
 .immediate_i(),
 .PC_i(),
 .rd_i(),
 .rs1_i(),
 .rs2_i(),
 .RegWrite_i(),
 .MemWrite_i(),
 .MemRead_i(),
 .ALUSrc_i(),
 .ALUOp_i(),
 .immediate_o(),
 .PC_o(),
 .readData1_o(),
 .readData2_o(),
 .rd_o(),
 .rs1_o(),
 .rs2_o(),
 .RegWrite_o(),
 .MemWrite_o(),
 .MemRead_o(),
 .ALUSrc_o(),
 .ALUOp_o(),
 .valid_i(),
 .ready_o(),
 .valid_o(),
 .ready_i());


BranchALU BranchALU
(.PC_val(),
.immediate(),
.ALU_out());

mainALU mainALU
(.op1(),
.op2(),
.operand(),
.out(),
.zero());

XM_pipeleine XM_pipe
(.clk_i,
.reset_i,
.pipeline_flush(),
.zero_i(),
.immediate_i(),
.PC_i(),
.result_i(),
.MuxRes_i(),
.immRes_i(),
.rd_i(),
.RegWrite_i(),
.MemWrite_i(),
.MemRead_i(),
.zero_o(),
.immediate_o(),
.PC_o(),
.result_o(),
.MuxRes_o(),
.immRes_o(),
.rd_o(),
.RegWrite_o(),
.MemWrite_o(),
.MemRead_o(),
.valid_i(),
.ready_o(),
.valid_o(),
.ready_i());


mem_Rsync DataMemory
(.clk_i,
.reset_i,
.wr_valid_i(),
.wr_data_i(),
.wr_addr_i(),
.rd_valid_i(),
.rd_addr_i(),
.rd_data_o());

MW_pipeline MW_pipe
(.clk_i,
.reset_i,
.pipeline_flush(),//do something with this
.mem_data_i(),
.rd_i(),
.mem_address_i(),
.RegWrite_i(),
.mem_data_o(),
.mem_address_o(),
.rd_o(),
.RegWrite_o(),
.valid_i(),
.ready_o(),
.valid_o(),
.ready_i());



endmodule

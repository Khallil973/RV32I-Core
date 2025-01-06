//`include "src/fetch_cycle.v"
//`include "src/decode_cycle.v"
//`include "src/execute_cycle.v"
//`include "src/memory_cycle.v"
//`include "src/write_cycle.v"
//`include "src/program_counter.v"
//`include "src/instruction_memory.v"
//`include "src/register_files.v"
//`include "src/sign_extend.v"
//`include "src/alu.v"
//`include "src/control_unit_top.v"
//`include "src/pc_adder.v"
//`include "src/data_memory.v"
//`include "src/mux.v"
//`include "src/hazard_unit.v"
//`include "src/stall_hazard.v"
//`include "src/branch_hazard.v"

module pipeline_top(clk,rst);
    //Declaring I/O
    input clk,rst;
    //Declaring Interim Wires
    wire PCSrcE,RegWriteW,RegWriteE,ALUSrcE,MemWriteE,RegWriteM,MemWriteM,JumpE,ZeroE;
    wire [3:0] ALUControlE;
    wire [4:0] RD_E,RD_M,RD_W;
    wire [31:0] PCTargetE, InstrD,PCD,PCPlus4D,ResultW,RD1_E,RD2_E,Imm_Ext_E,PCE,PCPlus4E,PCPlus4M,WriteDataM,ALU_ResultM;
    wire [31:0] PCPlus4W,ALU_ResultW,ReadDataW;
    wire [4:0] RS1_E,RS2_E;
    wire [1:0] ForwardAE,ForwardBE,ResultSrcE,ResultSrcM,ResultSrcW;
    wire [5:0] Branch;
    wire [4:0] Load;
    wire [4:0] RS1_D = InstrD[19:15];
    wire [4:0] RS2_D = InstrD[24:20];
    wire StallF,StallD,FlushE,FlushD;

    //Modules Initiation 
    //Fetch Cycle
    fetch_cycle fetch   (
                    .clk(clk),
                    .rst(rst),
                    .PCSrcE(PCSrcE),
                    .PCTargetE(PCTargetE),
                    .InstrD(InstrD),
                    .PCD(PCD),
                    .PCPlus4D(PCPlus4D),
                    .EN1(~StallF),
                    .EN2(~StallD),
                    .FlushD(FlushD)
                    
    );

    //Decode Cycle
    decode_cycle decode  (
                    .clk(clk),
                    .rst(rst),
                    .InstrD(InstrD),
                    .PCD(PCD),
                    .PCPlus4D(PCPlus4D),
                    .RegWriteW(RegWriteW),
                    .RD_W(RD_W),
                    .ResultW(ResultW),
                    .RegWriteE(RegWriteE),
                    .MemWriteE(MemWriteE),
                    .ResultSrcE(ResultSrcE),
                    .ALUSrcE(ALUSrcE),
                    .Branch(Branch),
                    .Load(Load),
                    .ALUControlE(ALUControlE),
                    .RD1_E(RD1_E),
                    .RD2_E(RD2_E),
                    .Imm_Ext_E(Imm_Ext_E),
                    .RD_E(RD_E),
                    .PCE(PCE),
                    .PCPlus4E(PCPlus4E),
                    .RS1_E(RS1_E),
                    .RS2_E(RS2_E),
                    .RS1_D(RS1_D),
                    .RS2_D(RS2_D),
                    .FlushE(FlushE),
                    .JumpE(JumpE),
                    .ZeroE(ZeroE)
                    
);

//Excute Cycle
execute_cycle execute  (
                    .clk(clk),
                    .rst(rst),
                    .RegWriteE(RegWriteE),
                    .MemWriteE(MemWriteE),
                    .ResultSrcE(ResultSrcE),
                    .ALUSrcE(ALUSrcE),
                    .Branch(Branch),
                    .ALUControlE(ALUControlE),
                    .RD1_E(RD1_E),
                    .RD2_E(RD2_E),
                    .Imm_Ext_E(Imm_Ext_E),
                    .RD_E(RD_E),
                    .PCE(PCE),
                    .PCSrcE(PCSrcE),
                    .PCPlus4E(PCPlus4E),
                    .PCTargetE(PCTargetE),
                    .RegWriteM(RegWriteM),
                    .MemWriteM(MemWriteM),
                    .ResultSrcM(ResultSrcM),
                    .RD_M(RD_M),
                    .WriteDataM(WriteDataM),
                    .PCPlus4M(PCPlus4M),
                    .ALU_ResultM(ALU_ResultM),
                    .ResultW(ResultW),
                    .ForwardAE(ForwardAE),
                    .ForwardBE(ForwardBE),
                    .JumpE(JumpE),
                    .ZeroE(ZeroE)
                    
);

//Memory Cycle
memory_cycle memory   (
                    .clk(clk),
                    .rst(rst),
                    .RegWriteM(RegWriteM),
                    .MemWriteM(MemWriteM),
                    .ResultSrcM(ResultSrcM),
                    .PCPlus4M(PCPlus4M),
                    .RD_M(RD_M),
                    .ALU_ResultM(ALU_ResultM),
                    .WriteDataM(WriteDataM),
                    .RegWriteW(RegWriteW),
                    .ResultSrcW(ResultSrcW),
                    .RD_W(RD_W),
                    .PCPlus4W(PCPlus4W),
                    .ALU_ResultW(ALU_ResultW),
                    .ReadDataW(ReadDataW)
                    
);

//Write Back Stage
write_cycle write   (
                    .clk(clk),
                    .rst(rst),
                    .ResultSrcW(ResultSrcW),
                    .PCPlus4W(PCPlus4W),
                    .ALU_ResultW(ALU_ResultW),
                    .ReadDataW(ReadDataW),
                    .ResultW(ResultW)
                    
);

//Hazard Unit
hazard_unit  Forwarding_block(
                    .rst(rst),
                    .RegWriteM(RegWriteM),
                    .RegWriteW(RegWriteW),
                    .RD_M(RD_M),
                    .RD_W(RD_W),
                    .RS1_E(RS1_E),
                    .RS2_E(RS2_E),
                    .ForwardAE(ForwardAE),
                    .ForwardBE(ForwardBE)
                    
);

stalls_hazard stall (
                    .ResultSrcE(ResultSrcE),
                    .RS1_D(RS1_D),
                    .RS2_D(RS2_D),
                    .RD_E(RD_E),
                    .StallF(StallF),
                    .StallD(StallD),
                    .FlushE(FlushE)
                    
);

branch_hazard branch(
                        .ResultSrcE(ResultSrcE), // Used for load dependency
                        .PCSrcE(PCSrcE), // Branch taken signal from Execute stage
                        .RD_E(RD_E), // Destination register from Execute stage
                        .RS1_D(RS1_D),
                        .RS2_D(RS2_D), // Source registers from Decode stage
                        .FlushD(FlushD),
                        .FlushE(FlushE) // Flush signals for Decode and Execute stages
); 

endmodule
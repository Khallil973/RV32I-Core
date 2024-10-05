//`include "ALU.v"
//`include "PC_Adder.v"
//`include "Mux.v"


module execute_cycle(clk,rst,ZeroE,RegWriteE,MemWriteE,ResultSrcE,ALUSrcE,Branch,ALUControlE,RD1_E,RD2_E,Imm_Ext_E,RD_E,PCE,PCSrcE,PCPlus4E,PCTargetE,RegWriteM,MemWriteM,ResultSrcM,RD_M,WriteDataM,PCPlus4M,ALU_ResultM,ResultW,ForwardAE,ForwardBE,JumpE);

    //Declaration Of Inputs/Outputs
    input clk,rst,RegWriteE,MemWriteE,ALUSrcE,JumpE;
    input [2:0] ALUControlE;
    input [4:0] RD_E;
    input [31:0] RD1_E,RD2_E,Imm_Ext_E;
    input [31:0] PCE,PCPlus4E;
    input [31:0] ResultW;
    input [1:0] ForwardAE,ForwardBE,ResultSrcE;
    input [5:0] Branch;


    output RegWriteM,MemWriteM,ZeroE; 
    output [4:0] RD_M;
    output [31:0] PCPlus4M,ALU_ResultM,WriteDataM;
    output [31:0] PCTargetE;
    output [1:0] ResultSrcM;
    output reg PCSrcE;

    //Declaration Of Interim Wires
    wire [31:0] Scr_A,Scr_B,Scr_B_interim;
    wire [31:0] Result_E;   
   // wire ZeroE;
   wire N,C;
 

    //Declaration Of Registers
    reg RegWriteE_r,MemWriteE_r;
    reg [1:0] ResultSrcE_r;
    reg [4:0] RD_E_r;
    reg [31:0] RD2_E_r,PCPlus4E_r,Result_E_r;   


    //Declaration Of Modules
    //3 BY MUX
    mux_3_by_1 srcA (
                .a(RD1_E),
                .b(ResultW),
                .c(ALU_ResultM),
                .s(ForwardAE),
                .d(Scr_A)
    );

    mux_3_by_1 srcB (
                .a(RD2_E),
                .b(ResultW),
                .c(ALU_ResultM),
                .s(ForwardBE),
                .d(Scr_B_interim)
    );

    //ALU source Mux
    mux alu_src_mux (
                .a(Scr_B_interim),
                .b(Imm_Ext_E),
                .s(ALUSrcE),
                .c(Scr_B)
    );

    //ALU Unit
    ALU alu (
                .A(Scr_A),
                .B(Scr_B),
                .ALUControl(ALUControlE),
                .Result(Result_E),
                .Zero(ZeroE),
                .N(N),
                .V(),
                .C(C)
    );
    
    //Adder
    pc_adder branch_adder (
                .a(PCE),
                .b(Imm_Ext_E),
                .c(PCTargetE)
    );

    //Register Logic
    always @ (posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
                RegWriteE_r <= 1'b0;
                MemWriteE_r <= 1'b0;
                ResultSrcE_r <= 2'b00;
                RD_E_r  <= 5'h00;
                RD2_E_r <= 32'h00000000;
                PCPlus4E_r <= 32'h00000000;
                Result_E_r <= 32'h00000000;    
        end
        else begin
                RegWriteE_r <= RegWriteE;
                MemWriteE_r <= MemWriteE;
                ResultSrcE_r <= ResultSrcE;
                RD_E_r  <= RD_E;
                RD2_E_r <= Scr_B_interim;
                PCPlus4E_r <= PCPlus4E;
                Result_E_r <= Result_E; 
        end
    end


// For PCSource
always @(*) begin
    PCSrcE = 1'b0; 

    case (Branch)
        6'b000001: // BEQ
            if (ZeroE == 1'b1)
                PCSrcE = 1'b1;
        6'b000010: // BNE
            if (ZeroE == 1'b0)
                PCSrcE = 1'b1;
        6'b000100: // BLT
            if (N == 1'b1)  
                PCSrcE = 1'b1;
        6'b000101: // BGE
            if (N == 1'b0 || ZeroE == 1'b1)  
                PCSrcE = 1'b1;
        6'b001000: // BLTU
            if (C == 1'b0)  
                PCSrcE = 1'b1;
        6'b001001: // BGEU
            if (C == 1'b1 || ZeroE == 1'b1) 
                PCSrcE = 1'b1;
    endcase

    // Jump condition check
    if (JumpE) begin
        PCSrcE = 1'b1; 
    end
end


    assign RegWriteM = RegWriteE_r;
    assign MemWriteM = MemWriteE_r;
    assign ResultSrcM = ResultSrcE_r; 
    assign RD_M  = RD_E_r;
    assign WriteDataM = RD2_E_r;
    assign PCPlus4M = PCPlus4E_r;
    assign ALU_ResultM = Result_E_r; 

endmodule
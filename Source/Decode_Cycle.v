//`include "Source/Control_Unit_Top.v"
//`include "Source/Register_Files.v"
//`include "Source/Sign_Extend.v"

module decode_cycle (clk,rst,,RS1_D,RS2_D,InstrD,PCD,PCPlus4D,RegWriteW,RD_W,ResultW,RegWriteE,MemWriteE,ResultSrcE,ALUSrcE,Branch,ALUControlE,RD1_E,RD2_E,Imm_Ext_E,RD_E,PCE,PCPlus4E,RS1_E,RS2_E,FlushE,JumpE,ZeroE,Load,Store);

    //Delcaring I/O
    input clk,FlushE,rst,RegWriteW,PCSrc,ZeroE;
    input [4:0] RD_W;
    input [31:0] InstrD,PCD,PCPlus4D,ResultW;
    input [4:0] RS1_D,RS2_D; 

    //Output
    output RegWriteE,MemWriteE,ALUSrcE,JumpE;
    output [3:0] ALUControlE;
    output [1:0] ResultSrcE;
    output [5:0] Branch;
    output [4:0] Load;
    output [2:0] Store;

  //  output [1:0] ResultSrcE;
    output [4:0] RD_E,RS1_E,RS2_E;
    output [31:0] RD1_E,RD2_E,Imm_Ext_E;
    output [31:0] PCE,PCPlus4E;


    //Declare Interim Wires
    //wire [4:0] Load;
    wire RegWriteD,MemWriteD,ALUSrcD,JumpD;
    wire [1:0] ImmSrcD,ResultSrcD;
    wire [3:0] ALUControlD;
    wire [31:0] RD1_D, RD2_D,Imm_Ext_D;
    wire [5:0] BranchD;
    wire [4:0] LoadD;
    wire [2:0] StoreD;
        //Extract RS1D & RS2D from InstrD
   // assign  RS1_D = InstrD[19:15];
   // assign  RS2_D = InstrD[24:20];

    //Declare Of Interim Register 
    reg RegWriteD_r,MemWriteD_r,ALUSrcD_r,JumpD_r;
    reg [3:0] ALUControlD_r;
    reg [1:0] ResultSrcD_r;
    reg [4:0] RD_r,RS1_D_r,RS2_D_r;
    reg [31:0] RD1_D_r,RD2_D_r,Imm_Ext_D_r;
    reg [31:0] PCD_r,PCPlus4D_r,Result_r; 
    reg [5:0] BranchD_r;
    reg [4:0] LoadD_r;
    reg [2:0] StoreD_r;

    //Initiate the Modules
    //Control Unit
    control_unit_top control (
                        .op(InstrD[6:0]),
                        .RegWrite(RegWriteD),
                        .MemWrite(MemWriteD),
                        .ResultSrc(ResultSrcD),
                        .ALUSrc(ALUSrcD),
                        .Branch(BranchD),
                        .ImmSrc(ImmSrcD),
                        .func3(InstrD[14:12]),
                        .func7(InstrD[31:25]),
                        .ALUControl(ALUControlD),
                        .Zero(ZeroE),
                        .PCSrc(PCSrc),
                        .Jump(JumpD),
                        .Load(Load),
                        .Store(Store)                      
    );

    //Register Files
    register_file register (
                        .clk(clk),
                        .rst(rst),
                        .A1(InstrD[19:15]),
                        .A2(InstrD[24:20]),
                        .A3(RD_W),
                        .WD3(ResultW),
                        .WE3(RegWriteW),
                        .RD1(RD1_D),
                        .RD2(RD2_D)
                        
    );

    //Sign Extension
    sign_extend sign(
                        .In(InstrD[31:0]),
                        .ImmSrc(ImmSrcD),
                        .Imm_Ext(Imm_Ext_D)
                        
    );

    //Declaring Register Logic
    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0  || FlushE) begin
                RegWriteD_r <= 1'b0;
                MemWriteD_r <= 1'b0;
                ResultSrcD_r <= 1'b0;
                ALUSrcD_r <= 1'b0;
                BranchD_r <= 6'b000000;
                ALUControlD_r <= 4'b0000;
                JumpD_r <= 1'b0;
                RD1_D_r <= 32'h00000000;
                RD2_D_r <= 32'h00000000;
                Imm_Ext_D_r <= 32'h00000000;     
                RD_r <= 5'h00;               
                PCD_r <= 32'h00000000;
                PCPlus4D_r <= 32'h00000000;
                RS1_D_r <= 32'h00000000;
                RS2_D_r <= 32'h00000000;
                LoadD_r <= 32'h00000000;
                StoreD_r <= 32'h00000000;
        end
        else begin
                RegWriteD_r <= RegWriteD;
                MemWriteD_r <= MemWriteD;
                ResultSrcD_r <= ResultSrcD;
                ALUSrcD_r <= ALUSrcD;
                BranchD_r <= BranchD;
                JumpD_r <= JumpD;
                ALUControlD_r <= ALUControlD;
                RD1_D_r <= RD1_D;
                RD2_D_r <= RD2_D;
                Imm_Ext_D_r <= Imm_Ext_D;     
                RD_r <= InstrD[11:7];               
                PCD_r <= PCD;
                PCPlus4D_r <= PCPlus4D; 
                RS1_D_r <= InstrD[19:15];
                RS2_D_r <= InstrD[24:20];
                LoadD_r <= LoadD;
                StoreD_r <= StoreD;
        end
    end 

    //Output Assign Statements
    assign RegWriteE = RegWriteD_r;
    assign MemWriteE = MemWriteD_r;
    assign ResultSrcE = ResultSrcD_r;
    assign ALUSrcE = ALUSrcD_r;
    assign Branch = BranchD_r;
    assign JumpE = JumpD_r;
    assign ALUControlE = ALUControlD_r;
    assign RD1_E = RD1_D_r;
    assign RD2_E = RD2_D_r;
    assign Imm_Ext_E = Imm_Ext_D_r;     
    assign RD_E = RD_r;               
    assign PCE = PCD_r;
    assign PCPlus4E = PCPlus4D_r;
    assign RS1_E = RS1_D_r;
    assign RS2_E = RS2_D_r;
    assign Load = LoadD;
    assign Store = StoreD;


endmodule
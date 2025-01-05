//`include "Source/data_memory.v"
module memory_cycle(clk,rst,RegWriteM,MemWriteM,ResultSrcM,RD_M,PCPlus4M,ALU_ResultM,WriteDataM,RegWriteW,ResultSrcW,RD_W,PCPlus4W,ALU_ResultW,ReadDataW);
    //Declaring I/O
    input clk,rst,RegWriteM,MemWriteM;
    input [4:0] RD_M;
    input [31:0] PCPlus4M,ALU_ResultM,WriteDataM;
    input [1:0] ResultSrcM;
    output RegWriteW;
    output [4:0] RD_W;
    output[31:0] PCPlus4W,ALU_ResultW,ReadDataW;
    output [1:0] ResultSrcW;
    //Declaration Of Interim Wires
    wire [31:0] ReadDataM;
    //Declaration Of Interim Registers
    reg RegWriteM_r,MemWriteM_r;
    reg [4:0] RD_M_r;
    reg [31:0] PCPlus4M_r,ALU_ResultM_r,ReadDataM_r;
    reg [1:0] ResultSrcM_r;

    //Declaration Of Module Initiation
    data_memory data   (
                            .A(ALU_ResultM),
                            .clk(clk),
                            .rst(rst),
                            .WE(MemWriteM),
                            .WD(WriteDataM),
                            .RD(ReadDataM)

    );
    //Memory Stage Registers Logic
    always @ (posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            RegWriteM_r <= 1'b0;
            ResultSrcM_r <= 1'b0;
            RD_M_r <= 5'h00;
            PCPlus4M_r <= 32'h00000000;
            ALU_ResultM_r <= 32'h00000000;
            ReadDataM_r <= 32'h00000000;
        end
        else begin
            RegWriteM_r <= RegWriteM;
            ResultSrcM_r <= ResultSrcM;
            RD_M_r <= RD_M;
            PCPlus4M_r <= PCPlus4M;
            ALU_ResultM_r <= ALU_ResultM;
            ReadDataM_r <= ReadDataM;
        end
    end

    //Declaration Of Output Statements
    assign RegWriteW = RegWriteM_r;
    assign ResultSrcW = ResultSrcM_r;
    assign RD_W = RD_M_r;
    assign PCPlus4W = PCPlus4M_r;
    assign ALU_ResultW = ALU_ResultM_r;
    assign ReadDataW = ReadDataM_r;

endmodule

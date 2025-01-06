//`include "src/main_decoder.v"
//`include "src/alu_decoder.v"

module control_unit_top(op,RegWrite,MemWrite,ResultSrc,ALUSrc,Branch,ImmSrc,func3,func7,ALUOp,ALUControl,PCSrc,Jump,Zero,Load,Store);

    input [6:0]op,func7;
    input Zero;
    input [2:0]func3;
    output RegWrite,ALUSrc,MemWrite,PCSrc,Jump;
    output [1:0]ImmSrc,ALUOp,ResultSrc;
    output [3:0]ALUControl;
    output [5:0] Branch;
    output [4:0] Load;
    output [2:0] Store;

    wire [1:0] ALUOp;

    main_decoder main (
                    .op(op),
                    .Zero(Zero),
                    .RegWrite(RegWrite),
                    .MemWrite(MemWrite),
                    .ResultSrc(ResultSrc),
                    .ALUSrc(ALUSrc), 
                    .ImmSrc(ImmSrc),
                    .ALUOp(ALUOp), 
                    .Branch(Branch),
                    .PCSrc(PCSrc),
                    .Jump(Jump),
                    .func3(func3),
                    .Load(Load),
                    .Store(Store)
    );

    Alu_decoder Alu(
                    .func3(func3),
                    .func7(func7),
                    .ALUOp(ALUOp),
                    .ALUControl(ALUControl),
                    .op(op)
             
    );

endmodule

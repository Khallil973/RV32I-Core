module tb_control_unit_top();
    reg [6:0] op, func7;
    reg [2:0] func3;
    wire RegWrite, ALUSrc, MemWrite, ResultSrc, Branch;
    wire [1:0] ImmSrc, ALUOp;
    wire [2:0] ALUControl;

    // Instantiate the Unit Under Test (UUT)
    control_unit_top uut (
        .op(op),
        .func7(func7),
        .func3(func3),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl)
    );

    initial begin
        // Test SUB Instruction
        op = 7'b0110011;    // Opcode for R-type instructions
        func7 = 7'b0100000; // func7 for SUB
        func3 = 3'b000;     // func3 for SUB

        // Wait for signals to stabilize
        #10;

        // Display Results
        $display("Testing SUB Instruction:");
        $display("op = %b", op);
        $display("func7 = %b", func7);
        $display("func3 = %b", func3);
        $display("ALUControl = %b", ALUControl);
        $display("ALUOp = %b", ALUOp);       // Added to print ALUOp
        $display("RegWrite = %b", RegWrite);
        $display("MemWrite = %b", MemWrite);
        $display("ResultSrc = %b", ResultSrc);
        $display("ALUSrc = %b", ALUSrc);
        $display("Branch = %b", Branch);
        $display("ImmSrc = %b", ImmSrc);

        // Finish simulation
        #10;
        $finish;
    end
endmodule

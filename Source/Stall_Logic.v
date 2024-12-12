module stalls_hazard(ResultSrcE,RS1_D,RS2_D,RD_E,StallF,StallD,FlushD,FlushE);

    //Declare I/Os
    input PCSrcE;
    input [4:0] RD_E;
    input [4:0] RS1_D,RS2_D;
    output StallF,StallD,FlushD,FlushE;
    input [1:0] ResultSrcE;

    //Extract RS1D & RS2D from InstrD
   // wire [4:0] RS1_D = InstrD[19:15];
    //wire [4:0] RS2_D = InstrD[24:20];

    // Compute lwStall based on load word dependency
    wire lwStall;
    //Logic
    assign lwStall = (ResultSrcE == 2'b01) & ((RS1_D == RD_E) | (RS2_D == RD_E));
    assign StallF = lwStall;
    assign StallD = lwStall;
  
endmodule
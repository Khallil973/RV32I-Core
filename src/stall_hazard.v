module stalls_hazard(ResultSrcE,RS1_D,RS2_D,RD_E,StallF,StallD,FlushD,FlushE);
    //Declare I/Os
    input PCSrcE;
    input [4:0] RD_E;
    input [4:0] RS1_D,RS2_D;
    output StallF,StallD,FlushD,FlushE;
    input [1:0] ResultSrcE;
    // Compute lwStall based on load word dependency
    wire lwStall;
    //Logic
    assign lwStall = (ResultSrcE == 2'b01) & ((RS1_D == RD_E) | (RS2_D == RD_E));
    assign StallF = lwStall;
    assign StallD = lwStall;
  
endmodule
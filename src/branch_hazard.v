module branch_hazard(ResultSrcE,PCSrcE,RD_E,RS1_D,RS2_D,FlushD,FlushE);
    input [1:0] ResultSrcE; // Used for load dependency
    input PCSrcE;   // Branch taken signal from Execute stage
    input [4:0] RD_E; // Destination register from Execute stage
    input [4:0] RS1_D, RS2_D; // Source registers from Decode stage
    output FlushD, FlushE; // Flush signals for Decode and Execute stages

    // Compute if there is a stall due to a load-use dependency (LwStall)
    wire lwStall;
    assign lwStall = (ResultSrcE == 2'b01) & ((RS1_D == RD_E) | (RS2_D == RD_E));

    assign FlushD = PCSrcE;
    assign FlushE = lwStall | PCSrcE;

endmodule    
 
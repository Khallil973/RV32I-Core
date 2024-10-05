module fetch_cycle_tb;

  // Declare testbench signals
  reg clk, rst;
  reg PCSrcE;
  reg [31:0] PCTargetE;
  wire [31:0] InstrD;
  wire [31:0] PCD, PCPlus4D;
  reg EN1, EN2, FlushD;
  
  // Instantiate the fetch cycle module
  fetch_cycle uut (
    .clk(clk),
    .rst(rst),
    .PCSrcE(PCSrcE),
    .PCTargetE(PCTargetE),
    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D),
    .EN1(EN1),
    .EN2(EN2),
    .FlushD(FlushD)
  );

  // Clock signal generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns clock period
  end

  // Test procedure
  initial begin
    // Initialize signals
    rst = 1;
    PCSrcE = 0;
    PCTargetE = 32'h00000010;  // Set a jump target address
    EN1 = 1; EN2 = 1; FlushD = 0;
    
    // Reset the system
    rst = 0;
    #10;  // Wait for reset propagation
    rst = 1;
    
    // Check initial values after reset
    #10;
    $display("After reset:");
    $display("PCD: %h, InstrD: %h, PCPlus4D: %h", PCD, InstrD, PCPlus4D);
    
    // Simulate normal instruction fetch (no jump)
    #20;
    PCSrcE = 0;
    $display("Normal fetch:");
    $display("PCD: %h, InstrD: %h, PCPlus4D: %h", PCD, InstrD, PCPlus4D);
    
    // Simulate jump instruction
    #20;
    PCSrcE = 1;  // Set PCSrcE to 1 to simulate jump
    PCTargetE = 32'h00000010;  // Example jump target address
    $display("After jump:");
    $display("PCD: %h, InstrD: %h, PCPlus4D: %h", PCD, InstrD, PCPlus4D);

    // End of simulation
    #20;
    $finish;
  end

endmodule

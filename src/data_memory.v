module data_memory(A, clk, rst, WE, WD, RD);
    input clk, WE, rst;
    input [31:0] A, WD;
    output [31:0] RD;

    // Creating the memory
    reg [31:0] Data_Mem [1023:0];
    
    // Read
    assign RD = (WE == 1'b0) ? Data_Mem[A[9:0]] : 32'h00000000;  
    // Use lower 10 bits of A for indexing

    // Write
    always @(posedge clk) begin
        if (WE) begin
            Data_Mem[A[9:0]] <= WD;  // Use lower 10 bits of A for indexing
        end
    end
    // Memory initialization using a for loop
    integer i;
    initial begin
        for (i = 0; i <= 1023; i = i + 1) begin
            Data_Mem[i] = 32'h00000000;  // Initialize memory to zero
        end
       // Data_Mem[256] = 32'h0000000A; 
    end

endmodule

module program_counter(PC_NEXT, clk, PC, rst, EN);
    input clk, rst, EN;
    input [31:0] PC_NEXT;
    output reg [31:0] PC;

    always @(posedge clk) begin
        // Active Low Reset 
        if (rst == 1'b0) begin
            PC <= 32'h00000000;
        end
        // Update PC only if EN (Enable) is high
        else if (EN) begin
            PC <= PC_NEXT;
        end
        // If EN is low, PC retains its current value (stall)
    end
    
endmodule

module instruction_memory(A,rst,RD);
    input clk,rst;
    input [31:0] A;
    output [31:0] RD;
    reg [31:0] Mem [1023:0];

//We are using Active Low Reset for our single cycle 
    assign RD = (rst == 1'b0) ? 32'h00000000 : Mem[A[31:2]]; 

    initial begin
    $readmemh("src/memfile.hex",Mem);
    end
    
endmodule
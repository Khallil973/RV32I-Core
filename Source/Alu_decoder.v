module Alu_decoder (
    input [6:0] op, 
    input [6:0] func7, 
    input [2:0] func3, 
    input [1:0] ALUOp, 
    output reg [3:0] ALUControl
);
    always @(*) begin
        case(ALUOp)
            2'b00: ALUControl = 4'b0000;  // Load/Store (ADD)
            2'b01: ALUControl = 4'b0001;  // Branch (SUB)
            2'b10: begin  // R-type instructions
                case(func3)
                    3'b000: ALUControl = ({op[5], func7[5]} == 2'b11) ? 4'b0001 : 4'b0000; // ADD/SUB
                    3'b010: ALUControl = 4'b0101;  // SLT
                    3'b110: ALUControl = 4'b0011;  // OR
                    3'b111: ALUControl = 4'b0010;  // AND
                    3'b001: ALUControl = 4'b0110;  // SLL (Shift Left Logical)
                    3'b101: begin
                        if ((func7[5] == 1'b0)) 
                            ALUControl = 4'b1001;  // SRL (Shift Right Logical)
                        else 
                            ALUControl = 4'b1010;  // SRA (Shift Right Arithmetic)
                    end
                    default: ALUControl = 4'b0000;  // Default to ADD
                endcase
            end
            default: ALUControl = 4'b0000;  // Default case
        endcase
    end
endmodule

module write_cycle(clk,rst,ResultSrcW,PCPlus4W,ALU_ResultW,ReadDataW,ResultW);
//Declaration Of Modules I/O
input clk,rst;
input [31:0] PCPlus4W,ALU_ResultW,ReadDataW;
input [1:0] ResultSrcW;
output [31:0] ResultW;

mux_3_by_1 mux (
                .a(ALU_ResultW),
                .b(ReadDataW),
                .c(PCPlus4W),
                .s(ResultSrcW),
                .d(ResultW)
                
);

endmodule
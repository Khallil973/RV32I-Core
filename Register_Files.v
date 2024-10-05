module register_file(clk,rst,A1,A2,A3,WD3,WE3,RD1,RD2);

    input clk,rst,WE3;
    input [4:0] A1,A2,A3;
    input [31:0] WD3;

    output [31:0] RD1,RD2;

    //Creation of memory 
    reg [31:0] Registers [31:0];

    //Read functionality
    assign RD1 = (rst==1'b0) ? 32'd0 : (A1 == A3) & (A1 != 0) ? WD3 : Registers[A1];
    assign RD2 = (rst==1'b0) ? 32'd0 : (A2 == A3) & (A2 != 0) ? WD3 : Registers[A2];

    //Write Enable Functionality
    always @ (posedge clk)
    begin
        if(WE3 & (A3 != 5'h00))
            Registers[A3] <= WD3;
    end

     // According to instruction my rs1 is 9 = 01001
    integer i;
    initial begin
       for (i=0; i<31; i++) begin
           Registers[i] = 32'h00000000;         
       end

    //   Registers[0] = 32'h00000000;
    //  Registers[6] = 32'h0000000A; //10 into decimal
   //     Registers[11] = 32'h0000028;
    //    Registers[12] = 32'h0000030;
    end

endmodule
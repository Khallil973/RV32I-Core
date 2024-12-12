module main_decoder(op,Zero,RegWrite,MemWrite,ResultSrc, ALUSrc, ImmSrc, ALUOp,Branch,PCSrc,Jump,func3,Load,Store);
    
    //Input & Output Declaration
    input [6:0] op;
    input [2:0] func3;
    input Zero;
    output RegWrite,ALUSrc,MemWrite,PCSrc,Jump;
    output [1:0] ImmSrc,ALUOp;
    output [1:0] ResultSrc;
    // Declare Branch as a 6-bit output signal
    output reg [5:0] Branch;
    output reg [4:0] Load;
    output reg [2:0] Store;


    // Define parameters for each branch type based on func3 values
    parameter BEQ  = 3'b000;
    parameter BNE  = 3'b001;
    parameter BLT  = 3'b100;
    parameter BGE  = 3'b101;
    parameter BLTU = 3'b110;
    parameter BGEU = 3'b111;


    // Define parameters for each I-Type load instructions type based on func3 values
    parameter LB  = 3'b000;
    parameter LH  = 3'b001;
    parameter LW  = 3'b010;
    parameter LBU  = 3'b100;
    parameter LHU = 3'b101;

    //Define parameter for each S-type store instructions 
    parameter SB  = 3'b000;
    parameter SH  = 3'b001;
    parameter SW  = 3'b010;

    //Interim Wire
    wire Jump;
  //  wire [5:0] Branch;

    assign RegWrite = (op == 7'b0000011 | op == 7'b0110011 | op == 7'b0010011 | op == 7'b1101111) ? 1'b1 : 1'b0;

    assign MemWrite = (op == 7'b0100011) ? 1'b1 : 1'b0;

    assign ResultSrc = (op == 7'b0000011) ? 2'b01 : (op == 7'b1101111) ? 2'b10 : 2'b00;

    assign ALUSrc = (op == 7'b0000011 | op == 7'b0100011 | op == 7'b0010011) ? 1'b1 : 1'b0;

   // assign Branch_1 = (op == 7'b1100011) & (func3 == 3'b000) ? 1'b1 : 1'b0;

    assign ImmSrc = (op == 7'b0100011) ? 2'b01 : (op == 7'b1100011) ? 2'b10 : (op == 7'b1101111) ? 2'b11 : 2'b00;

    assign ALUOp = (op == 7'b0110011 | op == 7'b0010011) ? 2'b10 : (op == 7'b1100011) ? 2'b01 : 2'b00;

    assign Jump = (op == 7'b1101111) || (op == 7'b1100111) ? 1'b1 : 1'b0;

//    assign Branch_2 = (op == 7'b1100011) & (func3 == 3'b001) ? 1'b1 : 1'b0;
  //  assign Branch = (op == 7'b1100011) && ((func3 == 3'b000) || (func3 == 3'b001)) ? 1'b1 : 1'b0;

 //   assign PCSrc = ((Zero & Branch) | Jump);

/*
   assign PCSrc = (Branch_1 & (Zero == 1) ? 1'b1 :  // BEQ (branch if equal)
                          (Branch_2 &(Zero == 0)) ? 1'b1 : // BNE (branch if not equal)
                            1'b0 | Jump;
*/
    

// Branch logic using case statement
  always @(*) begin
      if (op == 7'b1100011) begin  
         case (func3)
              BEQ:  Branch[0] = 1'b1;  // BEQ branch (bit 0)
              BNE:  Branch[1] = 1'b1;  // BNE branch (bit 1)
              BLT:  Branch[2] = 1'b1;  // BLT branch (bit 2)
              BGE:  Branch[3] = 1'b1;  // BGE branch (bit 3)
              BLTU: Branch[4] = 1'b1;  // BLTU branch (bit 4)
              BGEU: Branch[5] = 1'b1;  // BGEU branch (bit 5)
              default: Branch = 6'b000000;  
          endcase
      end else begin
        Branch = 6'b000000;  
    end
  end

// Load logic using case statement
  always @(*) begin
      if (op == 7'b0000011) begin  
         case (func3)
              LB:  Load[0] = 1'b1;  // LB Load (bit 0)
              LH:  Load[1] = 1'b1;  // LH Load (bit 1)
              LW:  Load[2] = 1'b1;  // LW Load (bit 2)
              LBU: Load[3] = 1'b1;  // LBU Load (bit 3)
              LHU: Load[4] = 1'b1;  // LHU Load (bit 4)
              default: Load = 6'b000000;  
          endcase
      end else begin
        Load = 6'b000000;  
    end
  end  

// Store logic using case statement
  always @(*) begin
      if (op == 7'b0100011) begin  
         case (func3)
              SB:  Store[0] = 1'b1;  // LB Load (bit 0)
              SH:  Store[1] = 1'b1;  // LH Load (bit 1)
              SW:  Store[2] = 1'b1;  // LW Load (bit 2)
              default: Store = 3'b000;  
          endcase
      end else begin
        Store = 3'b000;  
    end
  end

endmodule
 module ALU(A,B,ALUControl,Result,Zero,N,V,C);
  //Declaring Inpput
      input [31:0] A,B;
      input [3:0]ALUControl; //3bit ALU control
  //Declaring Output
      output [31:0] Result;
      output Zero,N,V,C;
  //Declaring Interim Wires
      wire [31:0] A_or_B;
      wire [31:0] A_and_B;
      wire [31:0] not_B;
      wire [31:0] mux_1;
      wire [31:0] sum;
      wire [31:0] mux_2;
      wire [31:0] slt;
      wire cout;
      wire [31:0] A_xor_B;
      wire [31:0] sll;
      wire [31:0] srl;
      wire [31:0] sra;

      // LOGIC DESIGN
      //AND Operation task perform
      assign A_or_B = A | B;
      //OR Operation task perform
      assign A_and_B = A & B;
      //NOT Operation task perform
      assign not_B = ~B;
      //Designing 2by1 Mux    
      assign mux_1 = (ALUControl[0] == 1'b0) ? B : not_B;
      assign A_xor_B = A ^ B;

      assign sll = A << B;

      assign srl = A >> B;

      assign sra = A >>> B[4:0];

      //Addition & Subtraction Operation,we use concatenation between Cout and Sum because sum generate two
      //bit answer but actually answer will become 3 bit after addition so for 1 bit we cout as a carry flag 
      //to show the output 1bit for sum
      assign {cout,sum} = A + mux_1 + ALUControl[0];

      //Zero  Extension
      assign slt = {31'b0000000000000000000000000000000,sum[31]}; //we use concatenation for set less than and use the sum LBS 31bit
      //Designing 4by1 Mux
      assign mux_2 = (ALUControl[3:0] == 4'b0000) ? sum : 
                    (ALUControl[3:0] == 4'b0001) ? sum : 
                    (ALUControl[3:0] == 4'b0010) ? A_and_B :
                    (ALUControl[3:0] == 4'b0011) ? A_or_B :
                    (ALUControl[3:0] == 4'b0101) ? slt :
                    (ALUControl[3:0] == 4'b0100) ? A_xor_B : 
                    (ALUControl[3:0] == 4'b0110) ? sll :
                    (ALUControl[3:0] == 4'b1001) ? srl :
                    (ALUControl[3:0] == 4'b1010) ? sra : 32'h00000000; //else zero statement 1 hexa value become 4 binary 

      //Finally result after mux output
      assign Result = mux_2;               

      //Flags Assignment
      assign Zero = &(~Result); //Zero Flag

      assign N = Result[31]; //Negative Flag will show the 31bit of answer will tell the behaviour of number like signed or unsigned

      assign C = cout & (~ALUControl[1]); //Carry Flag 

      assign V = (~ALUControl[1]) & (A[31] ^ sum[31]) & (~(ALUControl[0] ^ A[31] ^ B[31])); //OverFlow Flag

  endmodule


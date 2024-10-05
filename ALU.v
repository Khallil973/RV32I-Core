module ALU(A,B,ALUControl,Result,Zero,N,V,C);

//Declaring Inpput
    input [31:0] A,B;
    input [2:0]ALUControl; //2bit ALU control
    
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
    


// LOGIC DESIGN

    //AND Operation task perform
    assign A_or_B = A | B;

    //OR Operation task perform
    assign A_and_B = A & B;

    //NOT Operation task perform
    assign not_B = ~B;

    //Designing 2by1 Mux    
    assign mux_1 = (ALUControl[0] == 1'b0) ? B : not_B;


    //Addition & Subtraction Operation,we use concatenation between Cout and Sum because sum generate two
    //bit answer but actually answer will become 3 bit after addition so for 1 bit we cout as a carry flag 
    //to show the output 1bit for sum
    assign {cout,sum} = A + mux_1 + ALUControl[0];

  /*  
    assign {cout,sum} = (ALUControl[0] == 1'b0) ? A + B :
                                          (A + ((not_B)+1)) ;
    */

    //Zero  Extension
    assign slt = {31'b0000000000000000000000000000000,sum[31]}; //we use concatenation for set less than and use the sum LBS 31bit
    //Designing 4by1 Mux
    assign mux_2 = (ALUControl[2:0] == 3'b000) ? sum : 
                   (ALUControl[2:0] == 3'b001) ? sum : 
                   (ALUControl[2:0] == 3'b010) ? A_and_B :
                   (ALUControl[2:0] == 3'b011) ? A_or_B :
                   (ALUControl[2:0] == 3'b101) ? slt : 32'h00000000; //else zero statement 1 hexa value become 4 binary 

    //Finally result after mux output
    assign Result = mux_2;               

    //Flags Assignment
    assign Zero = &(~Result); //Zero Flag

    assign N = Result[31]; //Negative Flag will show the 31bit of answer will tell the behaviour of number like signed or unsigned

    assign C = cout & (~ALUControl[1]); //Carry Flag 

    assign V = (~ALUControl[1]) & (A[31] ^ sum[31]) & (~(ALUControl[0] ^ A[31] ^ B[31])); //OverFlow Flag


endmodule
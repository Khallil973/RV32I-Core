module sign_extend(In, ImmSrc, Imm_Ext);
    input [31:0] In;          // Full 32-bit instruction
    input [1:0] ImmSrc;       //  
    output reg [31:0] Imm_Ext; // Output extended immediate

    // ImmSrc
    // 00 -> I-Type
    // 01 -> S-Type
    // 10 -> B-Type
    always @(*) begin
        case (ImmSrc)
            2'b00: Imm_Ext = {{20{In[31]}}, In[31:20]};                          // I-Type (e.g., lw)
            2'b01: Imm_Ext = {{20{In[31]}}, In[31:25], In[11:7]};                // S-Type (e.g., sw)
            2'b10: Imm_Ext = {{20{In[31]}}, In[7], In[30:25], In[11:8], 1'b0}; // B-Type (branch)
            2'b11: Imm_Ext = {{12{In[31]}},In[19:12],In[20],In[30:21],1'b0};    // J (Jump)
            default: Imm_Ext = 32'b0; // Default in case of unknown ImmSrc
        endcase
    end
endmodule

// 3'b011: immExt = {instruction[31:12], 12'b0};                           // U-type 20-bit upper immediate
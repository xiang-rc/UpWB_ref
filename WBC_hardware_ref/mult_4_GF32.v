module mult_4_GF32(
    input [31:0] a,
    output wire [31:0] b
    );
    
    assign b[0] = a[30];
    assign b[1] = a[31];
    assign b[2] = a[30] ^ a[0];
    assign b[3] = a[30] ^ a[31] ^ a[1];
    assign b[4] = a[31] ^ a[2];
    assign b[6:5] = a[4:3];
    assign b[7] = a[5] ^ a[30];
    assign b[8] = a[6] ^ a[31];
    assign b[31:9] = a[29:7];
    
endmodule
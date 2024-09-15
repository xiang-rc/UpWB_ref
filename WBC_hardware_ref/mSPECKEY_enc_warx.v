`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/20 14:05:27
// Design Name: 
// Module Name: mSPECKEY_enc_warx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mSPECKEY_enc_warx(
    input [127:0] state_i,
    output wire [127:0] state_o
    );
    
    mSPECKEY_enc m0
    (
    .state_2D_in(state_i[15:0]),
    .state_2D_out(state_o[15:0])
    );
    
    mSPECKEY_enc m1
    (
    .state_2D_in(state_i[31:16]),
    .state_2D_out(state_o[31:16])
    );
    
    mSPECKEY_enc m2
    (
    .state_2D_in(state_i[47:32]),
    .state_2D_out(state_o[47:32])
    );
    
    mSPECKEY_enc m3
    (
    .state_2D_in(state_i[63:48]),
    .state_2D_out(state_o[63:48])
    );
    
    mSPECKEY_enc m4
    (
    .state_2D_in(state_i[79:64]),
    .state_2D_out(state_o[79:64])
    );
    
    mSPECKEY_enc m5
    (
    .state_2D_in(state_i[95:80]),
    .state_2D_out(state_o[95:80])
    );
    
    mSPECKEY_enc m6
    (
    .state_2D_in(state_i[111:96]),
    .state_2D_out(state_o[111:96])
    );
    
    mSPECKEY_enc m7
    (
    .state_2D_in(state_i[127:112]),
    .state_2D_out(state_o[127:112])
    );
endmodule
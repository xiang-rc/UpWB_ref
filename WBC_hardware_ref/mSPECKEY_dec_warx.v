`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/20 11:32:06
// Design Name: 
// Module Name: mSPECKEY_dec_warx
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


module mSPECKEY_dec_warx(
    input [127:0] state_i,
    output wire [127:0] state_o
    );
    
    mSPECKEY_dec m0
    (
    .state_2D_in(state_i[15:0]),
    .state_2D_out(state_o[15:0])
    );
    
    mSPECKEY_dec m1
    (
    .state_2D_in(state_i[31:16]),
    .state_2D_out(state_o[31:16])
    );
    
    mSPECKEY_dec m2
    (
    .state_2D_in(state_i[47:32]),
    .state_2D_out(state_o[47:32])
    );
    
    mSPECKEY_dec m3
    (
    .state_2D_in(state_i[63:48]),
    .state_2D_out(state_o[63:48])
    );
    
    mSPECKEY_dec m4
    (
    .state_2D_in(state_i[79:64]),
    .state_2D_out(state_o[79:64])
    );
    
    mSPECKEY_dec m5
    (
    .state_2D_in(state_i[95:80]),
    .state_2D_out(state_o[95:80])
    );
    
    mSPECKEY_dec m6
    (
    .state_2D_in(state_i[111:96]),
    .state_2D_out(state_o[111:96])
    );
    
    mSPECKEY_dec m7
    (
    .state_2D_in(state_i[127:112]),
    .state_2D_out(state_o[127:112])
    );
endmodule
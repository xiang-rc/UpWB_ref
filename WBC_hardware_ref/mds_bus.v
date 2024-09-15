`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/16 13:34:15
// Design Name: 
// Module Name: mds_bus
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


module mds_bus(
    //input [2:0] alg_mode,
    input [31:0] ram_data,
    output wire [63:0] MDS
    );
    
    assign MDS = {ram_data,ram_data};
endmodule
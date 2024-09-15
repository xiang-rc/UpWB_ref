`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/08 14:05:01
// Design Name: 
// Module Name: rdc_gen
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


module rdc_gen # (
  parameter n = 8
  )(
   input [3:0] outer_round,
   input [2:0] alg_mode,
   output [n-1:0] RDC0,RDC1,RDC2,RDC3,RDC4,RDC5,RDC6,RDC7,
   output [n-1:0] RDC8,RDC9,RDC10,RDC11,RDC12,RDC13,RDC14,RDC15
    );
    
   localparam spn8  = 3'b000;
   localparam spn16 = 3'b001;
   localparam spn32 = 3'b010;
   localparam warx  = 3'b011;
   localparam spn24 = 3'b100;
   localparam yoroi16 = 3'b101;
   localparam yoroi32 = 3'b110;
   
   reg [n-1:0] RDC_R0,RDC_R1,RDC_R2,RDC_R3,RDC_R4,RDC_R5,RDC_R6,RDC_R7;
   reg [n-1:0] RDC_R8,RDC_R9,RDC_R10,RDC_R11,RDC_R12,RDC_R13,RDC_R14,RDC_R15;
   
   assign RDC0 = RDC_R0;
   assign RDC1 = RDC_R1;
   assign RDC2 = RDC_R2;
   assign RDC3 = RDC_R3;
   assign RDC4 = RDC_R4;
   assign RDC5 = RDC_R5;
   assign RDC6 = RDC_R6;
   assign RDC7 = RDC_R7;
   assign RDC8 = RDC_R8;
   assign RDC9 = RDC_R9;
   assign RDC10 = RDC_R10;
   assign RDC11 = RDC_R11;
   assign RDC12 = RDC_R12;
   assign RDC13 = RDC_R13;
   assign RDC14 = RDC_R14;
   assign RDC15 = RDC_R15;
    
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R0 = (outer_round << 4) + 1; //spn8
     3'b001:RDC_R0 = (outer_round << 3) + 1; //spn16
     3'b010:RDC_R0 = (outer_round << 2) + 1; //spn32
     3'b011:RDC_R0 = (outer_round << 3) + 1; //warx
     3'b100:RDC_R0 = (outer_round << 2) + outer_round + 1; //spn24
     3'b101:RDC_R0 = outer_round + 1; //yoroi16
     3'b110:RDC_R0 = outer_round + 1; //yoroi32
     default:RDC_R0 = 'b0;
     endcase
   end
   
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R1 = (outer_round << 4) + 2; //spn8
     3'b001:RDC_R1 =  8'b0; //spn16
     3'b010:RDC_R1 =  8'b0; //spn32
     3'b011:RDC_R1 =  8'b0; //warx
     3'b100:RDC_R1 =  8'b0; //spn24
     3'b101:RDC_R1 =  8'b0; //yoroi16
     3'b110:RDC_R1 =  8'b0; //yoroi32
     default:RDC_R1 = 'b0;
     endcase
   end
   
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R2 = (outer_round << 4) + 3; //spn8
     3'b001:RDC_R2 = (outer_round << 3) + 2; //spn16
     3'b010:RDC_R2 =  8'b0; //spn32
     3'b011:RDC_R2 = (outer_round << 3) + 2; //warx
     3'b100:RDC_R2 =  8'b0; //spn24
     3'b101:RDC_R2 =  outer_round + 1; //yoroi16
     3'b110:RDC_R2 =  8'b0; //yoroi32
     default:RDC_R2 = 'b0;
     endcase
   end
 
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R3 = (outer_round << 4) + 4; //spn8
     3'b001:RDC_R3 =  8'b0; //spn16
     3'b010:RDC_R3 =  8'b0; //spn32
     3'b011:RDC_R3 =  8'b0; //warx
     3'b100:RDC_R3 =  (outer_round << 2) + outer_round + 2; //spn24
     3'b101:RDC_R3 =  8'b0; //yoroi16
     3'b110:RDC_R3 =  8'b0; //yoroi32
     default:RDC_R3 = 'b0;
     endcase
   end
   
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R4 = (outer_round << 4) + 5; //spn8
     3'b001:RDC_R4 = (outer_round << 3) + 3; //spn16
     3'b010:RDC_R4 = (outer_round << 2) + 2; //spn32
     3'b011:RDC_R4 = (outer_round << 3) + 3; //warx
     3'b100:RDC_R4 = 8'b0; //spn24
     3'b101:RDC_R4 = outer_round + 1; //yoroi16
     3'b110:RDC_R4 = outer_round + 1; //yoroi32
     default:RDC_R4 = 'b0;
     endcase
   end
   
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R5 = (outer_round << 4) + 6; //spn8
     3'b001:RDC_R5 =  8'b0; //spn16
     3'b010:RDC_R5 =  8'b0; //spn32
     3'b011:RDC_R5 =  8'b0; //warx
     3'b100:RDC_R5 =  8'b0; //spn24
     3'b101:RDC_R5 =  8'b0; //yoroi16
     3'b110:RDC_R5 =  8'b0; //yoroi32
     default:RDC_R5 = 'b0;
     endcase
   end
   
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R6 = (outer_round << 4) + 7; //spn8
     3'b001:RDC_R6 = (outer_round << 3) + 4; //spn16
     3'b010:RDC_R6 = 8'b0; //spn32
     3'b011:RDC_R6 = (outer_round << 3) + 4; //warx
     3'b100:RDC_R6 = (outer_round << 2) + outer_round + 3; //spn24
     3'b101:RDC_R6 = outer_round + 1; //yoroi16
     3'b110:RDC_R6 = 8'b0; //yoroi32
     default:RDC_R6 = 'b0;
     endcase
   end
   
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R7 = (outer_round << 4) + 8; //spn8
     3'b001:RDC_R7 =  8'b0; //spn16
     3'b010:RDC_R7 =  8'b0; //spn32
     3'b011:RDC_R7 =  8'b0; //warx
     3'b100:RDC_R7 =  8'b0; //spn24
     3'b101:RDC_R7 =  8'b0; //yoroi16
     3'b110:RDC_R7 =  8'b0; //yoroi32
     default:RDC_R7 = 'b0;
     endcase
   end
     
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R8 = (outer_round << 4) + 9; //spn8
     3'b001:RDC_R8 = (outer_round << 3) + 5; //spn16
     3'b010:RDC_R8 = (outer_round << 2) + 3; //spn32
     3'b011:RDC_R8 = (outer_round << 3) + 5; //warx
     3'b100:RDC_R8 = 8'b0; //spn24
     3'b101:RDC_R8 = outer_round + 1; //yoroi16
     3'b110:RDC_R8 = outer_round + 1; //yoroi32
     default:RDC_R8 = 'b0;
     endcase
   end
   
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R9 = (outer_round << 4) + 10; //spn8
     3'b001:RDC_R9 =  8'b0; //spn16
     3'b010:RDC_R9 =  8'b0; //spn32
     3'b011:RDC_R9 =  8'b0; //warx
     3'b100:RDC_R9 =  (outer_round << 2) + outer_round + 4; //spn24
     3'b101:RDC_R9 =  8'b0; //yoroi16
     3'b110:RDC_R9 =  8'b0; //yoroi32
     default:RDC_R9 = 'b0;
     endcase
   end
   
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R10 = (outer_round << 4) + 11; //spn8
     3'b001:RDC_R10 = (outer_round << 3) + 6; //spn16
     3'b010:RDC_R10 =  8'b0; //spn32
     3'b011:RDC_R10 = (outer_round << 3) + 6; //warx
     3'b100:RDC_R10 =  8'b0; //spn24
     3'b101:RDC_R10 =  outer_round + 1; //yoroi16
     3'b110:RDC_R10 =  8'b0; //yoroi32
     default:RDC_R10 = 'b0;
     endcase
   end
    
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R11 = (outer_round << 4) + 12; //spn8
     3'b001:RDC_R11 =  8'b0; //spn16
     3'b010:RDC_R11 =  8'b0; //spn32
     3'b011:RDC_R11 =  8'b0; //warx
     3'b100:RDC_R11 =  8'b0; //spn24
     3'b101:RDC_R11 =  8'b0; //yoroi16
     3'b110:RDC_R11 =  8'b0; //yoroi32
     default:RDC_R11 = 'b0;
     endcase
   end
   
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R12 = (outer_round << 4) + 13; //spn8
     3'b001:RDC_R12 = (outer_round << 3) + 7; //spn16
     3'b010:RDC_R12 = (outer_round << 2) + 4; //spn32
     3'b011:RDC_R12 = (outer_round << 3) + 7; //warx
     3'b100:RDC_R12 = (outer_round << 2) + outer_round + 5; //spn24
     3'b101:RDC_R12 = outer_round + 1; //yoroi16
     3'b110:RDC_R12 = outer_round + 1; //yoroi32
     default:RDC_R12 = 'b0;
     endcase
   end
   
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R13 = (outer_round << 4) + 14; //spn8
     3'b001:RDC_R13 =  8'b0; //spn16
     3'b010:RDC_R13 =  8'b0; //spn32
     3'b011:RDC_R13 =  8'b0; //warx
     3'b100:RDC_R13 =  8'b0; //spn24
     3'b101:RDC_R13 =  8'b0; //yoroi16
     3'b110:RDC_R13 =  8'b0; //yoroi32
     default:RDC_R13 = 'b0;
     endcase
   end
   
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R14 = (outer_round << 4) + 15; //spn8
     3'b001:RDC_R14 = (outer_round << 3) + 8; //spn16
     3'b010:RDC_R14 =  8'b0; //spn32
     3'b011:RDC_R14 = (outer_round << 3) + 8; //warx
     3'b100:RDC_R14 =  8'b0; //spn24
     3'b101:RDC_R14 =  outer_round + 1; //yoroi16
     3'b110:RDC_R14 =  8'b0; //yoroi32
     default:RDC_R14 = 'b0;
     endcase
   end
   
   always@(*)
   begin
     case(alg_mode)
     3'b000:RDC_R15 = (outer_round << 4) + 16; //spn8
     3'b001:RDC_R15 =  8'b0; //spn16
     3'b010:RDC_R15 =  8'b0; //spn32
     3'b011:RDC_R15 =  8'b0; //warx
     3'b100:RDC_R15 =  8'b0; //spn24
     3'b101:RDC_R15 =  8'b0; //yoroi16
     3'b110:RDC_R15 =  8'b0; //yoroi32
     default:RDC_R15 = 'b0;
     endcase
   end
  
endmodule
module rk_bus(
  input [15:0] rk0,
  input [31:0] rk1,
  input [2:0] alg_mode,
  output reg [127:0] rk_ext
  );
  
  always@(*)
  begin
    case(alg_mode)
    3'b000: rk_ext = {16{rk0[7:0]}};
    3'b001: rk_ext = {8{rk0}};
    3'b010: rk_ext = {4{rk1}};
    3'b011: rk_ext = {8{rk0}};
    3'b100: rk_ext = {8'd0,{5{rk1[23:0]}}};
    default: rk_ext = 128'd0;
    endcase
  end

endmodule
module lut_bus_in(
  input [15:0] old_rd_addr,
  input [12:0] addr_gen,
  input mode_wbc,
  input [2:0]  alg_mode,
  output wire [12:0] new_rd_addr
  );
  
  reg [12:0] new_rd_addr_tmp;
  always@(*)
  begin
    case(alg_mode)
    3'b000: new_rd_addr_tmp = {9'd0,old_rd_addr[7:4]}; //spn8
    3'b001: new_rd_addr_tmp = old_rd_addr[15:3]; //spn16
    default: new_rd_addr_tmp = 13'd0;
    endcase
  end
  
  assign new_rd_addr = mode_wbc == 1'b0 ? addr_gen : new_rd_addr_tmp; //0 gen lut
endmodule

module lut_bus_out(
  input clk,rst_n,
  input [3:0] new_rd_addr_bs,
  input [127:0] ram_data,
  input [2:0]  alg_mode,
  output reg [15:0] reg_data_i1,
  output reg [7:0]  reg_data_i0
  );
  
  wire [3:0] new_rd_addr_bs_q;
  DFF #(.data_width(3'd4)) d_bs(.clk(clk),.rst_n(rst_n),.d(new_rd_addr_bs),.q(new_rd_addr_bs_q));
  
  always@(*)
  begin
    case(new_rd_addr_bs_q)
    4'b0000: reg_data_i0 = ram_data[7:0];
    4'b0001: reg_data_i0 = ram_data[15:8];
    4'b0010: reg_data_i0 = ram_data[23:16];
    4'b0011: reg_data_i0 = ram_data[31:24];
    4'b0100: reg_data_i0 = ram_data[39:32];
    4'b0101: reg_data_i0 = ram_data[47:40];
    4'b0110: reg_data_i0 = ram_data[55:48];
    4'b0111: reg_data_i0 = ram_data[63:56];
    4'b1000: reg_data_i0 = ram_data[71:64];
    4'b1001: reg_data_i0 = ram_data[79:72];
    4'b1010: reg_data_i0 = ram_data[87:80];
    4'b1011: reg_data_i0 = ram_data[95:88];
    4'b1100: reg_data_i0 = ram_data[103:96];
    4'b1101: reg_data_i0 = ram_data[111:104];
    4'b1110: reg_data_i0 = ram_data[119:112];
    4'b1111: reg_data_i0 = ram_data[127:120];
    //default: reg_data_i0 = 8'd0;
    endcase
  end
  
  always@(*)
  begin
    case(new_rd_addr_bs_q[2:0])
    3'b000: reg_data_i1 = ram_data[15:0];
    3'b001: reg_data_i1 = ram_data[31:16];
    3'b010: reg_data_i1 = ram_data[47:32];
    3'b011: reg_data_i1 = ram_data[63:48];
    3'b100: reg_data_i1 = ram_data[79:64];
    3'b101: reg_data_i1 = ram_data[95:80];
    3'b110: reg_data_i1 = ram_data[111:96];
    3'b111: reg_data_i1 = ram_data[127:112];
    //default: reg_data_i1 = 16'd0;
    endcase
  end
endmodule
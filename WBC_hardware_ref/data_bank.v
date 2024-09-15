module wb_bank #(parameter addr_width = 'd13,
                 data_width = 'd128,
                 depth = 'd8192)(
    input clk,
    input [addr_width-1:0] A,
    input [data_width-1:0] D,
    input WEN,
    input REN,
    input EN,
    output reg [data_width-1:0] Q);
    (*ram_style = "block"*)reg [data_width-1:0] bank [depth-1:0];
    
    always@(posedge clk)
    begin
      if (EN == 1)
        begin
          if(WEN == 1'b1)
             bank[A] <= D;
          else
             bank[A] <= bank[A];
          end
    end
    
    always@(posedge clk)
    begin
      if(EN == 1)
        begin
          if(REN == 1'b1)
            Q <= bank[A];
          else
            Q <= Q;
        end
    end
endmodule

/*module wb_bank1 #(parameter addr_width = 'd14,
                 data_width = 'd32,
                 depth = 'd16384)(
    input clk,
    input [addr_width-1:0] A,
    input [data_width-1:0] D,
    input WEN,
    input REN,
    input EN,
    output reg [data_width-1:0] Q);
    (*ram_style = "block"*)reg [data_width-1:0] bank [depth-1:0];
    
    always@(posedge clk)
    begin
      if (EN == 1)
        begin
          if(WEN == 1'b1)
             bank[A] <= D;
          else
             bank[A] <= bank[A];
          end
    end
    
    always@(posedge clk)
    begin
      if(EN == 1)
        begin
          if(REN == 1'b1)
            Q <= bank[A];
          else
            Q <= Q;
        end
    end
endmodule*/

module mds_bank #(parameter addr_width = 'd5,
                 data_width = 'd32,
                 depth = 'd32)(
    input clk,
    input [addr_width-1:0] A,
    input [data_width-1:0] D,
    input WEN,
    input REN,
    input EN,
    output reg [data_width-1:0] Q);
    (*ram_style = "block"*)reg [data_width-1:0] bank [depth-1:0];
    
    always@(posedge clk)
    begin
      if (EN == 1)
        begin
          if(WEN == 1'b1)
             bank[A] <= D;
          else
             bank[A] <= bank[A];
          end
    end
    
    always@(posedge clk)
    begin
      if(EN == 1)
        begin
          if(REN == 1'b1)
            Q <= bank[A];
          else
            Q <= Q;
        end
    end
endmodule


/*module mds_bank3 #(parameter addr_width = 'd4,
                 data_width = 'd32,
                 depth = 'd16)(
    input clk,
    input [addr_width-1:0] A,
    input [data_width-1:0] D,
    input WEN,
    input REN,
    input EN,
    output reg [data_width-1:0] Q);
    (*ram_style = "block"*)reg [data_width-1:0] bank [depth-1:0];
    
    initial
	begin
		$readmemb("D:/vivado_project/test_hub/test_cipher/mds_bank1.txt",bank);
	end
	
    always@(posedge clk)
    begin
      if (EN == 1)
        begin
          if(WEN == 1'b1)
             bank[A] <= D;
          else
             bank[A] <= bank[A];
          end
    end
    
    always@(posedge clk)
    begin
      if(EN == 1)
        begin
          if(REN == 1'b1)
            Q <= bank[A];
          else
            Q <= Q;
        end
    end
endmodule*/

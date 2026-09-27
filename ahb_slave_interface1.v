

module ahb_slave_interface1(
    input  wire Hclk,
    input  wire Hresetn,
    input  wire Hwrite,
    input  wire Hreadyin,
    input  wire [1:0]Htrans,
    input  wire [31:0]Hwdata,
    input  wire [31:0]Haddr,Prdata,
    output [1:0]Hres,
    output wire valid,
    output reg Hwritereg,
    output reg Hwritereg1,
    output reg [31:0]Haddr1,
    output reg [31:0]Haddr2,
    output reg [31:0]Hwdata1,
    output reg [31:0]Hwdata2,
    output reg [2:0]tempselx,
    output [31:0]Hrdata
);
    assign valid = (Haddr >= 32'h80000000 && Haddr < 32'h8C000000) &&
                   Hreadyin && (Htrans == 2'b10 || Htrans == 2'b11);

    always @(posedge Hclk) begin
        if (!Hresetn) begin
            Haddr1<= 32'd0;
            Haddr2<= 32'd0;
            Hwdata1<= 32'd0;
            Hwdata2<= 32'd0;
            Hwritereg<= 1'b0;
            Hwritereg1<= 1'b0;
        end
//        else if (valid) begin
        else begin
            Haddr1<= Haddr;
            Haddr2<= Haddr1;
            Hwdata1<= Hwdata;
            Hwdata2<= Hwdata1;
            Hwritereg<= Hwrite;
            Hwritereg1<= Hwritereg;
        end
    end
        always @(*) begin
        if (Haddr >= 32'h80000000 && Haddr < 32'h84000000)
            tempselx = 3'b001;
        else if (Haddr >= 32'h84000000 && Haddr < 32'h88000000)
            tempselx = 3'b010;
        else if (Haddr >= 32'h88000000 && Haddr < 32'h8C000000)
            tempselx = 3'b100;
        else
            tempselx = 3'b000;
    end
    assign Hres = 2'd0;
    assign Hrdata=Prdata;
endmodule

module top_module(
    input hclk, hresetn, hwrite, hreadyin,
    input [31:0] hwdata, haddr, prdata,
    input [1:0] htrans,
    output pwrite, penable, hr_readyout,
    output [2:0] psel,
    output [31:0] paddr, pwdata, hrdata
);
wire valid;
wire [31:0] hwdata_1, hwdata_2, haddr_1, haddr_2;
wire [2:0] temp_selx;
wire [1:0] hresp;
wire hwrite_reg, hwrite_reg_1;
assign valid = (haddr >= 32'h80000000 && haddr < 32'h8C000000) &&
                   hreadyin && (htrans == 2'b10 || htrans == 2'b11);
ahb_slave_interface1 ahb_S(
    .Hclk(hclk),
    .Hresetn(hresetn),
    .Hwrite(hwrite),
    .Hreadyin(hreadyin),
    .Htrans(htrans),
    .Hres(hresp),
    .Hwdata(hwdata),
    .Haddr(haddr),
    .Prdata(prdata),
    .valid(valid),
    .Hwritereg(hwrite_reg),
    .Hwritereg1(hwrite_reg_1),
    .Haddr1(haddr_1),
    .Haddr2(haddr_2),
    .Hwdata1(hwdata_1),
    .Hwdata2(hwdata_2),
    .tempselx(temp_selx),
    .Hrdata(hrdata)
);
APB_controller apb_c(
    .hclk(hclk),
    .hresetn(hresetn),
    .hwrite(hwrite),
    .hwritereg(hwrite_reg),
    .valid(valid),
    .haddr(haddr),
    .haddr1(haddr_1),
    .haddr2(haddr_2),
    .hwdata(hwdata),
    .hwdata1(hwdata_1),
    .hwdata2(hwdata_2),
    .tempselx(temp_selx),
    .penable(penable),
    .pwrite(pwrite),
    .hreadyout(hr_readyout),
    .paddr(paddr),
    .pwdata(pwdata),
    .pselx(psel)
);
endmodule
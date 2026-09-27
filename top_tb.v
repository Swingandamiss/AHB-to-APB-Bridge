`timescale 1ns / 1ps

module top_tb();
reg hclk, hresetn;
wire [31:0] haddr, hwdata, hrdata, paddr, pwdata, pwdata_out, paddr_out, prdata;
wire [1:0] hresp, htrans;
wire [2:0] pselx, psel_out;
wire [2:0] psel;                    
wire hr_readyout;                   
wire hreadyout;
wire hwrite, hreadyin, penable;
wire pwrite;                        
wire pwrite_out, penable_out;
assign hresp=1'b0;
assign pselx = psel;
assign hreadyout=hr_readyout;
ahb_master ahb(
    .hclk(hclk),
    .hreset(hresetn),
    .hreadyout(hr_readyout),
    .hrdata(hrdata),
    .haddr(haddr),
    .hwdata(hwdata),
    .hwrite(hwrite),
    .hreadyin(hreadyin),
    .htrans(htrans)
);
apb_interface apb(pwrite, penable, psel, paddr, pwdata,   
    pwrite_out, penable_out, psel_out, paddr_out, pwdata_out, prdata);

top_module bridge(hclk, hresetn, hwrite, hreadyin,
    hwdata, haddr, prdata, htrans,
    pwrite, penable, hr_readyout, psel, paddr, pwdata, hrdata);
    initial begin
        hclk=1'b0;
        forever #10 hclk=~hclk;
    end
    task reset();
    begin
        @(negedge hclk);
            hresetn=1'b0;
        @(negedge hclk);
            hresetn=1'b1;
    end
    endtask
    initial begin
        reset;
//        ahb.single_write();
//        ahb.single_read();
        ahb.burst_write();
        #200
        $finish;
   end
endmodule


module apb_interface(
    input pwrite,penable,
    input [2:0]pselx,
    input [31:0]paddr,pwdata,
    output pwrite_out,penable_out,
    output[2:0]psel_out,
    output[31:0]paddr_out,pwdata_out,
    output reg [31:0]prdata
    );
    always @(*) begin
    if (!pwrite && penable)
        prdata = 8'd25;
    else
        prdata = 32'd0;  
    end
    assign pwrite_out=pwrite;
    assign psel_out=pselx;
    assign paddr_out=paddr;
    assign pwdata_out=pwdata;
    assign penable_out=penable;
endmodule

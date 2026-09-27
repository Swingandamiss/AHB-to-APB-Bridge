

module APB_controller(
    input valid, hwritereg, hclk, hresetn, hwrite,
    input [31:0]haddr1,haddr2,hwdata1,hwdata2,haddr,hwdata,
    input [2:0]tempselx,
    output reg pwrite,penable,
    output reg [2:0]pselx,
    output reg hreadyout,
    output reg [31:0]pwdata,paddr
);
parameter st_idle=3'b000,
          st_wwait=3'b001,
          st_write=3'b010,
          st_writep=3'b011,
          st_wenablep=3'b100,
          st_wenable=3'b101,
          st_read=3'b110,
          st_renable=3'b111;
reg penable_temp, pwrite_temp, hr_readyout_temp;
reg [31:0]paddr_temp,pwdata_temp;
reg [2:0]state,next_state,psel_temp;  
always @(posedge hclk)
begin
    if (!hresetn)
        state <= st_idle;
    else
        state <= next_state;
end
always @(*)
begin
    case (state)
        st_idle:
            if(valid==1 && hwrite==0)begin
                paddr_temp=haddr;
                pwrite_temp=hwrite;
                psel_temp=tempselx;
                penable_temp=0;
                hr_readyout_temp=0;
            end
            else if(valid==1 && hwrite==1)begin
                psel_temp=0;
                penable_temp=0;
                hr_readyout_temp=1;
            end
            else begin
                psel_temp=0;
                penable_temp=0;
                hr_readyout_temp=1;
            end
        st_read:
            begin
                psel_temp=tempselx;
                pwrite_temp=0;
                penable_temp=1;
                hr_readyout_temp=1;
            end
        st_renable:
            if(valid==1 && hwrite==0)begin
                paddr_temp=haddr;
                pwrite_temp=hwrite;
                psel_temp=tempselx;
                penable_temp=0;
                hr_readyout_temp=0;
            end
            else if(valid==1 && hwrite==1)begin
                psel_temp=0;
                penable_temp=0;
                hr_readyout_temp=1;
            end
            else begin
                psel_temp=0;
                penable_temp=0;
                hr_readyout_temp=1;
            end
        st_wwait: begin
                paddr_temp=haddr1;
                pwdata_temp=hwdata;
                pwrite_temp=1;
                psel_temp=tempselx;
                penable_temp=0;
                hr_readyout_temp=0;
            end
        st_write:
            begin
                pwrite_temp=1;
                psel_temp=tempselx;
                pwdata_temp=hwdata;
                penable_temp=0;
                hr_readyout_temp=1;
            end
        st_wenable:
            if(valid==1 && hwrite==0)begin
                psel_temp=1; //changed to 1
                penable_temp=0;
                hr_readyout_temp=1;
            end
            else if(valid==1 && hwrite==1)begin
                psel_temp=0;
                penable_temp=0;
                hr_readyout_temp=1;
            end
            else begin
                psel_temp=0;
                penable_temp=0;
                hr_readyout_temp=1;
            end
        st_writep: begin
            paddr_temp=haddr;      
            pwdata_temp=hwdata;     
            pwrite_temp=1;
            psel_temp=tempselx;
            penable_temp=1;      
            hr_readyout_temp=1;      
        end

        st_wenablep: begin
            if (valid==1 && hwritereg==1) begin
                paddr_temp=haddr1;
                pwdata_temp=hwdata1;
                pwrite_temp=1;
                psel_temp=tempselx;
                penable_temp=1;
                hr_readyout_temp=1;
            end
            else if (valid==1 && hwritereg==0) begin
//                paddr_temp=haddr;
                pwdata_temp=hwdata; //changed to 1
                pwrite_temp=1;
                psel_temp=tempselx;
                penable_temp=1;  //chamged to 1
                hr_readyout_temp=1;  //changed to 1
            end
            else begin
//                psel_temp=0;
                penable_temp=1;  //changed to 1
                hr_readyout_temp=1;
            end
        end
            
        default:
            next_state=st_idle;
    endcase
end    
always @(*) begin
    case (state)
        st_idle:
            if (!valid)           
                next_state = st_idle;
            else if (valid && hwrite)  
                next_state = st_wwait;
            else                       
                next_state = st_read;
        st_read:                       
            next_state = st_renable;
        st_renable:
            if (!valid)           
                next_state = st_idle;
            else if (valid && !hwrite) 
                next_state = st_read;
            else                       
                next_state = st_wwait;
        st_wwait:
            if (!valid)           
                next_state = st_write;
            else 
                next_state = st_writep;
        st_write:                      
            if (valid)
                next_state = st_wenablep;
            else if (!valid && hwritereg)
                next_state = st_wenable;
            else
                next_state = st_write;
        st_wenable:
           if (!valid)
                next_state = st_idle;
            else if (valid && !hwrite)
                next_state = st_read;
            else
                next_state = st_wwait;
        st_wenablep:
            if(valid && hwritereg)
                next_state = st_writep;
            else if (valid && !hwritereg) 
                next_state = st_write;
            else 
                next_state = st_read;
        default:
            next_state = st_idle;
    endcase
end   
always @(posedge hclk) begin
    if (!hresetn) begin
        paddr <= 0;
        pwdata <= 0;
        pwrite <= 0;
        pselx <= 0;
        penable <= 0;
        hreadyout <= 1;
    end
    else begin
        paddr <= paddr_temp; //changed from paddr_temp
        pwdata <= pwdata_temp; //changed from pwdata_temp
        pwrite <= pwrite_temp;  //changed from pwrite_temp
        pselx <= psel_temp;
        penable <= penable_temp;
        hreadyout <= hr_readyout_temp;
    end
end    
endmodule
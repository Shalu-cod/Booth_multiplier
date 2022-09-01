module Booth_mul_16(
input clk,en,
input [15:0] A,B,
output reg [31:0] Prod,
output reg done
);

reg [15:0] cnt;
reg [32:0] temp;
wire [15:0] negB;
assign negB = ~ B + 1'b1 ;
always @ (posedge clk)
begin
if(~en)
begin
cnt=16'd0;
temp=33'd0;
done <=1'b0;
end
else
begin
if(cnt==16'd0)
begin
temp <= {16'd0,A,1'b0};
cnt <= cnt + 1'b1;
end
else if(cnt> 16'd0 && cnt <16'd17)
begin
if(temp[1:0] == 2'b00 || temp[1:0] == 2'b11 )
begin
temp = {temp[32],temp[32:1]};
cnt = cnt + 1'b1;
end
else if(temp[1:0] == 2'b01)
begin
temp[32:17] = temp[32:17] + B;
temp = {temp[32],temp[32:1]};
cnt = cnt+1'b1;
end

else if(temp[1:0] == 2'b10)
begin
temp[32:17] = temp[32:17] + negB;
temp = {temp[32],temp[32:1]};
cnt = cnt+1'b1;
end
end
else
begin
Prod = temp[32:1];
done =1'b1;
end
end
end

endmodule


module booth_mul_16bit_tb;
reg clk,en;
reg signed [15:0] A,B;
wire signed [31:0] Prod;
wire done;

Booth_mul_16 M1(.clk(clk),.en(en),.A(A),.B(B),.Prod(Prod),.done(done));

initial begin
clk = 1'b0;

A = 8'd0; B = 8'd0; en = 1'b0; #10;

en = 1'b1; A = 16'd12; B = 16'd5; #100; 
en = 1'b0; #100;


en = 1'b1; A = -16'd15; B = -16'd10; #100; 
en = 1'b0; #100;

en = 1'b1;A = -16'd9; B = 16'd11; #100; 
en = 1'b0; #100;

en = 1'b1;A = -16'd10; B = -16'd34; #100; 
en = 1'b0; #100;
end


always #1 clk = !clk;

initial 
begin
$monitor("A = %d, B = %d, Prod = %d,done = %b",A,B,Prod,done);
end


endmodule
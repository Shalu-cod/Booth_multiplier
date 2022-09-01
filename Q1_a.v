module Booth_mul(
input clk,en,
input [3:0] A,B,
output reg [7:0] Prod,
output reg done
);
reg [3:0] cnt;
reg [8:0] temp;
wire [3:0] negB;
assign negB = ~ B + 1'b1;
always @ (posedge clk)
begin
    if(~en)
        begin
        cnt=4'd0;
        temp=9'd0;
        done <=1'b0;
        end
    else
    begin
        if(cnt==4'd0)
            begin
            temp <= {4'd0,A,1'b0};
            cnt <= cnt+1;
            end
        else if(cnt> 4'd0 && cnt <4'd5)
            begin
            if(temp[1:0] == 2'b00 || temp[1:0] == 2'b11 )
                begin
                temp = {temp[8],temp[8:1]};
                cnt = cnt+1'b1;
                end
            else if(temp[1:0] == 2'b01)
                begin
                temp[8:5] = temp[8:5] + B;
                temp = {temp[8],temp[8:1]};
                cnt = cnt+1'b1;
                end
            else if(temp[1:0] == 2'b10)
                begin
                temp[8:5] = temp[8:5] + negB;
                temp = {temp[8],temp[8:1]};
                cnt = cnt+1'b1;
                end
        end
        else
        begin
        Prod = temp[8:1];
        done =1'b1;
        end
    end
end
endmodule

module tb_booth_mul();

reg clk , en;
reg [3:0] A;
reg [3:0] B;
wire Prod , done;

Booth_mul b1(clk,en,A,B,Prod,done);

initial begin

$monitor("vlaue of clk=%b, en=%b, A=%b, B=%b, Prod=%b, done=%b",clk,en,A,B,Prod,done);
clk=1'b0;en=1'b0;
A=4'b0000;B=4'b0000;
#150;
en=1'b1;
A=4'b1110;B=4'b1110;
#150;
en=1'b0;
#150;
en=1'b1;
A=4'b1011;B=4'b0010;
#150;
en=1'b0;
#150;
en=1'b1;
A=4'b0111;B=4'b0010;
#150;
en=1'b0;
#150;
en=1'b1;
A=4'b1011;B=4'b1000;
#150;
en=1'b0;
#150;
en=1'b1;
A=4'b1111;B=4'b1111;
#150 $stop;

end
always #1 clk=~clk;
endmodule

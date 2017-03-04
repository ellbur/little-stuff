
module Access_Mux(
    c,
    sw,
    a,
    b
);
parameter W = 0;

output [(W-1):0] c;
input  [(W-1):0] a;
input  [(W-1):0] b;
input sw;

assign c = sw ? b : a;

endmodule


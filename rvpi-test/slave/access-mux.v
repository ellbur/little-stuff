
module Access_Mux(
    c,
    sw,
    a,
    b
);
parameter W = 0;

output [0:(W-1)] c;
input  [0:(W-1)] a;
input  [0:(W-1)] b;
input sw;

assign c = sw ? a : b;

endmodule


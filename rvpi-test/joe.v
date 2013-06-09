
module joe(
    output c,
    input  a,
    input  b
);

assign c = a & b;

initial begin
  $display();
end

endmodule


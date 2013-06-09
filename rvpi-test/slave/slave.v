
module Slave(
    output [0:4] slave_read_addr,
    output [0:4] slave_write_addr,
    output slave_write,
    input [0:11] read_node,
    input [0:11] write_node,
    input clk,
    input reset
);

assign slave_read_addr  = 4;
assign slave_write_addr = 7;
assign slave_write = 0;

endmodule


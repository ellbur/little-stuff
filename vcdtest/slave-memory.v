
`ifndef slave_memory_v
`define slave_memory_v 1

module Slave_Memory(
    output [11:0] read_node,
    input [11:0] write_node,
    input [4:0] read_addr,
    input [4:0] write_addr,
    input write,
    input clk,
    input reset
);

`include "initial-tree.v"

reg [(12*32):0] all_memory;

assign read_node = (all_memory >> (read_addr*12)) & 12'b111111111111;

Constants constants();

always @(posedge clk or negedge reset) begin
    if (~reset)
        all_memory <= initial_tree;
    else begin
        if (write) begin
            all_memory <= all_memory
                & (~(12'b111111111111 << (write_addr*12)))
                | (write_node << (write_addr*12));
        end
    end
end

endmodule

`endif


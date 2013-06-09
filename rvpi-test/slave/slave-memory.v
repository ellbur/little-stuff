
module Slave_Memory(
    output reg [0:11] read_node,
    input [0:11] write_node,
    input [0:4] read_addr,
    input [0:4] write_addr,
    input write,
    input clk,
    input reset
);

reg [0:(11*31)] all_memory;

wire [0:11] _read_node;
assign _read_node = (all_memory >> (read_addr*12)) & 12'b111111111111;

always @(posedge clk or negedge reset) begin
    if (~reset)
        all_memory <= 0;
    else begin
        if (write) begin
            all_memory <= all_memory
                & (~(12'b111111111111 << (write_addr*12)))
                | (write_node << (write_addr*12));
        end
    end
end

always @(negedge clk) begin
    read_node <= _read_node;
end

endmodule



module main();

reg clk;
reg reset;

wire master_has_control;
wire [0:4] slave_read_addr;
wire [0:4] slave_write_addr;
wire slave_write;

wire [0:4] master_read_addr;
wire [0:4] master_write_addr;
wire master_write;

assign master_has_control = 0;
assign master_read_addr = 0;
assign master_write_addr = 0;
assign master_write = 0;

wire [0:4] read_addr;
wire [0:4] write_addr;
wire write;
wire [0:11] read_node;
wire [0:11] write_node;

Access_Mux #(11) access_mux(
    .c({read_addr, write_addr, write}),
    .sw(master_has_control),
    .a({slave_read_addr, slave_write_addr, slave_write}),
    .b({master_read_addr, master_write_addr, master_write})
);

Slave_Memory slave_memory(read_node, write_node, read_addr, write_addr, write, clk, reset);
Slave slave(slave_read_addr, slave_write_addr, slave_write, read_node, write_node, clk, reset);

wire [0:(11*31)] all_memory;
assign all_memory = slave_memory.all_memory;

initial $display("");

endmodule

`include "slave.v"
`include "slave-memory.v"
`include "access-mux.v"


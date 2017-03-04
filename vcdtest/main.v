
module main();

reg clk;
reg reset;

wire master_has_control;
wire [4:0] slave_read_addr;
wire [4:0] slave_write_addr;
wire slave_write;
wire [11:0] slave_write_node;

wire [4:0] master_read_addr;
wire [4:0] master_write_addr;
wire master_write;
wire [11:0] master_write_node;

// Dummy master
assign master_has_control = 0;
assign master_read_addr = 0;
assign master_write_addr = 0;
assign master_write = 0;
assign master_write_node = 0;

wire [4:0] read_addr;
wire [4:0] write_addr;
wire write;
wire [11:0] read_node;
wire [11:0] write_node;

Access_Mux #(23) access_mux(
    .c({read_addr, write_addr, write, write_node}),
    .sw(master_has_control),
    .a({slave_read_addr, slave_write_addr, slave_write, slave_write_node}),
    .b({master_read_addr, master_write_addr, master_write, master_write_node})
);

Slave_Memory slave_memory(read_node, write_node, read_addr, write_addr, write, clk, reset);
Slave slave(slave_read_addr, slave_write_addr, slave_write, slave_write_node,
    read_node, clk, reset);

initial begin
    clk = 1;
    reset = 1;
    #0 reset = 1;
    #0 reset = 0;
    #0 reset = 1;
    
    $dumpfile("dump.vcd");
    $dumpvars;
    
    #40 $finish;
end

always #1 clk <= ~clk;

endmodule

`include "slave.v"
`include "slave-memory.v"
`include "access-mux.v"


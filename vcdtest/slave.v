
`ifndef _slave_v
`define _slave_v 1

`include "constants.v"

module Slave(
    output reg [4:0] _slave_read_addr,
    output reg [4:0] _slave_write_addr,
    output reg _slave_write,
    output reg [11:0] _slave_write_node,
    input [11:0] read_node,
    input clk,
    input reset
);

// Store outputs to be set on negative edge.
reg [4:0] slave_read_addr;
reg [4:0] slave_write_addr;
reg slave_write;
reg [11:0] slave_write_node;

always @(negedge clk) begin
    _slave_read_addr <= slave_read_addr;
    _slave_write_addr <= slave_write_addr;
    _slave_write <= slave_write;
    _slave_write_node <= slave_write_node;
end

// Data read in from memory
wire [1:0] read_type;
wire [4:0] read_car;
wire [4:0] read_cdr;
assign {read_type, read_car, read_cdr} = read_node;

// ----------------------------------------------
// States

reg [2:0] state;
parameter START     = 0;
parameter SEARCHING = 1;
parameter REDUCE_S  = 2;
parameter REDUCE_K  = 3;
parameter STUCK     = 4;

always @(posedge clk or negedge reset) begin
    if (~reset) begin
        state = START;
    end
    else begin
        // Default, if it isn't changed:
        slave_write = 0;
        
        case (state)
            START: search_init();
            SEARCHING: search();
            REDUCE_S: reduce_s();
            REDUCE_K: reduce_k();
            STUCK: stuck();
        endcase
    end
end

// --------------------------------------------------
// Searching

reg [4:0] head_ptr;

reg [2:0] depth;
reg [4:0] head3;
reg [4:0] head2;
reg [4:0] head1;
reg [4:0] cdr3;
reg [4:0] cdr2;
reg [4:0] cdr1;

task search_init;
    begin
        depth = 0;
        head_ptr = 0;
        slave_read_addr = head_ptr;
        state = SEARCHING;
    end
endtask

task search;
    begin
        if (read_type == `BRANCH) begin
            shift_stacks();
            depth = depth + 1;
            
            head_ptr = read_car;
            slave_read_addr = head_ptr;
        end
        else if (read_type == `S && depth >= 3)
            reduce_s_init();
        else if (read_type == `K && depth >= 2)
            reduce_k_init();
        else
            stuck_init();
    end
endtask

task shift_stacks;
    begin
        head3 = head2;
        head2 = head1;
        head1 = head_ptr;
        cdr3 = cdr2;
        cdr2 = cdr1;
        cdr1 = read_cdr;
    end
endtask

// --------------------------------------------------
// Reduce S

task reduce_s_init;
    begin
        // TODO: fix this
        state = STUCK;
    end
endtask

task reduce_s;
    begin
        // TODO: implement this
    end
endtask

// --------------------------------------------------
// Reduce K

//  Have we completed the K reduction yet?
reg k_done;

task reduce_k_init;
    begin
        // Read in 'a', because it will be used.
        slave_read_addr = cdr1;
        state = REDUCE_K;
        k_done = 0;
    end
endtask

task reduce_k;
    begin
        if (!k_done) begin
            // Copy cdr1 into head2
            slave_write_addr = head2;
            slave_write_node = {read_type, read_car, read_cdr};
            slave_write = 1;
            
            k_done = 1;
        end
        else begin
            // Go back to the root and hunt some more.
            search_init();
        end
    end
endtask

// --------------------------------------------------
// Stuck

task stuck_init;
    begin
        state = STUCK;
    end
endtask

task stuck;
    begin
        // Nothing to do
    end
endtask

endmodule

`endif



numCells = 16;
numCellBits = 2 + 5 + 5;

function slaveFields(snap) {
    var mem = snap['main.slave_memory.all_memory'];
    var fields = [ ];
    
    for (var j=0; j<numCells; j++) {
        var cellBits = slicex(mem, numCellBits*j, numCellBits*(j+1));
        cdrBits = slicex(cellBits, 0, 5);
        carBits = slicex(cellBits, 5, 10);
        typeBits = slicex(cellBits, 10, 12);
        
        var type;
        if      (intv(typeBits)==0) type = 'S';
        else if (intv(typeBits)==1) type = 'K';
        else if (intv(typeBits)==2) type = '.';
        else if (intv(typeBits)==3) type = 'F';
        
        fields[j] = {
            type: type,
            car: intv(carBits),
            cdr: intv(cdrBits)
        };
    }
    
    return fields;
}

function slaveHead(snap) {
    return intv(snap['main.slave.head_ptr']);
}

function slaveHeadStack(snap) {
    return [
        intv(snap['main.slave.head1']),
        intv(snap['main.slave.head2']),
        intv(snap['main.slave.head3']),
    ];
}

function slaveCdrStack(snap) {
    return [
        intv(snap['main.slave.cdr1']),
        intv(snap['main.slave.cdr2']),
        intv(snap['main.slave.cdr3']),
    ];
}

function slaveDepth(snap) {
    return intv(snap['main.slave.depth']);
}

// v is to remind you that verilog slices
// are, sadly, inclusive.
function slicev(bits, a, b) {
    if (a<0 || a>=bits.length || b<0 || b>=bits.length || b<a) {
        throw ('slice ['+a+':'+b+'] out of range ['+0+':'+(bits.length-1)+']');
    }
    return bits.substring(bits.length-1-b, bits.length-a);
}

function slicex(bits, a, b) {
    return slicev(bits, a, b-1);
}

function extend(bits, width) {
    var c = (bits.length>0&&bits[0]=='x') ? 'x' : '0';
    while (bits.length < width) {
        bits = c + bits;
    }
    return bits;
}

function intv(bits) {
    var n = parseInt(bits, 2);
    if (isNaN(n)) return 0;
    return n;
}

function reverse(bits) {
    var s = '';
    for (var i=0; i<bits.length; i++) {
        s = bits[i] + s;
    }
    return s;
}


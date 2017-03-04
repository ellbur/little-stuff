
var cellDisplays = [ ];
var headArrow;
var sigSet;
var pinDisplay;

$(document).ready(function() {
    jsPlumb.setRenderMode(jsPlumb.SVG)
    jsPlumb.Defaults.Container = "container"
    
    slave = $("#slave0Memory");
    for (var i=0; i<numCells; i++) {
        cellDisplays[i] = CellDisplay(slave, i);
    }
    headArrow = MovableArrow($('#slave0'), $('#head'), $('#head'), {
        anchors:[[0.50,0,0,-1],[0.30,1,0,1]],
        paintStyle:{strokeStyle:'#555', lineWidth:2},
        endpointStyle:{radius:1}
    });
    sigSet = VCDSignalSet(dump)
    
    $('#startTime').text(sigSet.startTime)
    $('#endTime').text(sigSet.endTime/2)

    $("#nextLink").click(function (ev) {
        try {
            sigSet.next()
            sigSet.next()
            setState()
        }
        finally {
            ev.preventDefault()
        }
    })

    $("#prevLink").click(function (ev) {
        try {
            sigSet.prev()
            sigSet.prev()
            setState()
        }
        finally {
            ev.preventDefault()
        }
    })
    
    pinDisplay = PinDisplay($('#pins'), sigSet.names);
    
    setState()
})

function CellDisplay(slaveDiv, addr) {
    var cell = $('<div/>')
    var number = $('<div>', {style: 'font-size:8pt;float:left;'})
    var content = $('<div>', {style: 'font-size:14pt'})
    
    cell.css('float', 'left')
    cell.css('width', '2em')
    cell.css('height', '2em')
    cell.css('border', '1px solid #000')
    
    number.text('' + addr)
    cell.append(number)
    cell.append(content)
    slaveDiv.append(cell)
    
    car = MovableArrow(slaveDiv, cell, cell, {
        anchors:[[0.75,0,0,-1],[0.25,0,0,-1]],
        paintStyle:{strokeStyle:'#696', lineWidth:2},
        endpointStyle:{radius:1},
        overlays:[['Arrow',{location:1}]]
    })
    cdr = MovableArrow(slaveDiv, cell, cell, {
        anchors:[[0.75,0,0,-1],[0.25,0,0,-1]],
        paintStyle:{strokeStyle:'#888', lineWidth:2},
        endpointStyles:[{radius:1},{radius:4}]
    })
    
    base = cell.offset()
    width = cell.width()
        
    var that = {
        content: content,
        div: cell,
        car: car,
        cdr: cdr
    }
    return that
}

function setState() {
    $("#time").text(sigSet.time/2)
    var snap = sigSet.snapshot()
    var fields = slaveFields(snap);
    var head = slaveHead(snap);
    
    for (var i=0; i<cellDisplays.length; i++) {
        var cell = cellDisplays[i];
        
        if (fields[i].type == '.') {
            car = fields[i].car;
            cdr = fields[i].cdr
            cell.car.source = cell.div;
            cell.car.target = cellDisplays[car].div;
            cell.cdr.source = cell.div;
            cell.cdr.target = cellDisplays[cdr].div;
        }
        else {
            cell.cdr.source = $('#nowhere')
            cell.cdr.target = $('#nowhere')
            cell.car.source = $('#nowhere')
            cell.car.target = $('#nowhere')
        }
        
        cell.content.text(fields[i].type);
        cell.car.update();
        cell.cdr.update();
    }
    
    headArrow.target = cellDisplays[head].div;
    headArrow.update();
    
    headStack = slaveHeadStack(snap);
    cdrStack = slaveCdrStack(snap);
    depth = slaveDepth(snap);
    $('#headStack').text(headStack.slice(0,depth).join(' '));
    $('#cdrStack').text(cdrStack.slice(0,depth).join(' '));
    
    // Show all pins in a sidebar so that we can debug this thing.
    pinDisplay.display(snap);
}


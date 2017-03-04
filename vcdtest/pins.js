
// Displays all pins.
function PinDisplay(div, names) {
    names = names.slice(0);
    names.sort();
    
    var pinBox = PinBox('');
    for (var i=0; i<names.length; i++)
        pinBox.add(names[i]);
    for (ch in pinBox.children)
        pinBox = pinBox.children[ch];
    
    var pinBoxDisplay = PinBoxDisplay(div, pinBox, names);
    
    var that = {
        pinBox: pinBox,
        
        display: function(snap) {
            for (name in snap) {
                pinBoxDisplay.set(name, snap[name]);
            }
        }
    };
    return that;
}

function PinBoxDisplay(div, pinBox, names) {
    var spans = { };
    for (i in names) {
        spans[names[i]] = $('<span>');
    }
    
    PinBoxPane(div, pinBox, spans);
    
    var that = {
        set: function(name, str) {
            spans[name].text(shorten(str, 12));
        }
    };
    return that;
}

function PinBoxPane(outer, pinBox, spans) {
    var div = $('<div>', {'class':'pinBox'});
    outer.append(div);
    
    var heading = $('<h3>');
    heading.text(pinBox.name);
    div.append(heading);
    
    var upper = $('<table>', {'class':'pinTable'});
    var lower = $('<div>');
    div.append(upper);
    div.append(lower);
    
    for (var leaf in pinBox.leafs) {
        var tr = $('<tr>');
        var a = $('<td>', {'class':'pinName'});
        var b = $('<td>', {'class':'pinValue'});
        tr.append(a);
        tr.append(b);
        var label = $('<span>');
        label.text(leaf+': ');
        var value = spans[pinBox.leafs[leaf]];
        a.append(label);
        b.append(value);
        upper.append(tr);
    }
    
    for (var child in pinBox.children) {
        PinBoxPane(lower, pinBox.children[child], spans);
    }
}

function PinBox(name) {
    var that = {
        name: name,
        children: { },
        leafs: { },
        
        add: function(name) {
            return that.addChild(name, name);
        },
        
        addChild: function(name, fullName) {
            var di = name.indexOf('.');
            if (di == -1) {
                if (!(name in that.leafs)) {
                    that.leafs[name] = fullName;
                }
            }
            else {
                module = name.substring(0, di);
                sub = name.substring(di+1);
                
                if (!(module in that.children)) {
                    that.children[module] = PinBox(module);
                }
                that.children[module].addChild(sub, fullName);
            }
        }
    };
    return that;
}

function shorten(str, n) {
    if (str.length <= n) return str;
    return str.substring(0, (n-2)/2) + '..' + str.substring(str.length-(n-2)/2);
}


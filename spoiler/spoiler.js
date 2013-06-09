
// Include this script in the head.

// Mark divs to be spoiled as
// <div class="spoiler"> ... </div>

function setupSpoiler(i) {
    var content = $(this).html()
    var block = $('<div class="spoiler-block"/>')
    var pane = $('<div class="spoiler-content"/>')
    var link = $('<a class="spoiler-control" href="#">show</a>')
    var shown = false
    link.click(function(ev) {
        if (shown) {
            pane.html('')
            link.html('show')
            shown = false
        }
        else {
            pane.html(content)
            link.html('hide')
            shown = true
        }
    })
    block.append(link)
    block.append(pane)
    $(this).html(block)
}

$(document).ready(function() {
    $('.spoiler').each(setupSpoiler)
})



library(rjson)
library(XML)
library(ggplot2)
library(plyr)

read.qs = function(path) {
    text = paste(readLines(path), collapse='')
    questions = fromJSON(text)$questions
    questions
}

questions = do.call(c, lapply(
    c('page-1.json', 'page-2.json', 'page-3.json'),
    read.qs)
)

tot.length.of = function(doc, query) {
    parts = xpathApply(doc, query, xmlValue)
    text = paste(parts, collapse='')
    nchar(text)
}

Table = ldply(questions, function(q) {
    body.text = sprintf('<body>%s</body>', q$body)
    body = htmlParse(body.text)
    
    description = tot.length.of(body, '//p//text()')
    code = tot.length.of(body, '//pre//text()')
    
    rep = q$owner$reputation
    
    data.frame(
        rep, description, code
    )
})

print(ggplot(data=Table)
    + geom_point(aes(rep, description, color='description'))
    + geom_point(aes(rep, code, color='code'))
    + scale_x_log10()
    + scale_y_log10()
    + xlab('Rep')
    + ylab('Verbosity')
    + scale_color_discrete('')
    + opts(legend.position = 'top')
)


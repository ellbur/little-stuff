
library(rjson)
library(XML)

text = paste(readLines('foo2.json'), collapse='')
qq = fromJSON(text)
q = qq$questions[[1]]

body = q$body



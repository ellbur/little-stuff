
`%then%` = function(x, body) {
    x = substitute(x)
    fl = as.list(substitute(body))
    car = fl[[1L]]
    cdr = {
        if (length(fl) == 1)
            list()
        else
            fl[-1L]
    }
    combined = as.call(
        c(list(car, x), cdr)
    )
    eval(combined, parent.frame())
}


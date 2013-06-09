
pf = function(x) 1 / (1 + exp(-x))

N = 20000
x.dense = seq(-6, 6, len=100)
x.try = sort(runif(N, -5, 5))
a.try = runif(N) < pf(x.try)

groups = seq_along(x.try) %then% lapply(function(I) {
    list(xs=x.try[I], as=a.try[I])
})

score = function(group) mean(group$as)
add = function(g1, g2) list(
    xs = c(g1$xs, g2$xs),
    as = c(g1$as, g2$as)
)

while (T) {
    n.now = length(groups)
    
    end = Reduce(x=groups[-1], init=list(list(), groups[[1]]),
        f = function(state, head) {
            pile    = state[[1]]
            current = state[[2]]
            
            if (score(current) < score(head)) {
                pile = append(pile, list(current))
                current = head
            }
            else {
                current = add(current, head)
            }
            
            list(pile, current)
        }
    )
    
    groups = append(end[[1]], list(end[[2]]))
    n.out = length(groups)
    
    if (n.now == n.out) break;
}

p.est = do.call(c, groups %then% lapply(function(G) {
    rep(score(G), length(G$as))
}))



noise.height = 1
n = 10

target.jump = 1
actual.jump = 1

x = actual.jump + noise.height*rnorm(n)

# Initially ambivalent
there.prior = 0.5

# p(there|x) = p(x|there)*p(there)/p(x)
# = p(x|there)*0.5/(p(x|there) + p(x|not there))

p.x.given.there = prod(exp(-(x-target.jump)**2 / (2*noise.height**2)))
p.x.given.not.there = prod(exp(-(x)**2 / (2*noise.height**2)))

part.there = p.x.given.there*there.prior
part.not.there = p.x.given.not.there*(1-there.prior)

post.there = part.there / (part.there + part.not.there)


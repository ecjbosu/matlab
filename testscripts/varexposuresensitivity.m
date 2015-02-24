

p = 1:.25:10
p = repmat(p, size(p,2), 1)

sigma = .1:.04:1.56
sigma = repmat(sigma', 1, size(sigma,2))

var = 1000000

t = 1
alpha = .05


 w = var ./ (norminv(1-alpha) .* sqrt(t) .* p .* sigma) 
 
 
 surf(w)
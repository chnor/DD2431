
import cvxopt
from cvxopt.solvers import qp
from cvxopt.base import matrix

import numpy, pylab, random, math

n = 2

X = numpy.matrix(numpy.random.rand(n, 20))
t = numpy.sign(numpy.random.rand(20) - 0.5)

print t

q = -1 * numpy.ones(n)
h = numpy.zeros(n)
G = -1 * numpy.eye(n)

P = numpy.multiply(t * t.transpose(), (X.transpose() * X + 1))
print "P = ", P

r = qp(matrix(P), matrix(q), matrix(G), matrix(h))
alpha = numpy.array(r['x'])
print alpha
print "X = ", X

print P
hits = numpy.nonzero(numpy.absolute(alpha) > 1e-6)[0]
print "hits = ", hits
print alpha[hits]
print "Selected: ", X[:, hits]

Y = X
#Y = numpy.matrix(numpy.random.rand(n, 2))

c = (alpha[hits].transpose() * t[hits]) * (X[:, hits].transpose() * Y + 1)
print "c = ", c
for i, x in enumerate(X.transpose()):
    if c[i] > 0:
        pylab.plot(x, 'bo')
    else:
        pylab.plot(x, 'ro')
pylab.show()

print "foo = ", (alpha[hits].transpose() * t[hits]) * (X[:, hits].transpose() * Y + 1)

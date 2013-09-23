
import cvxopt
from cvxopt.solvers import qp
from cvxopt.base import matrix

import numpy, pylab, random, math

n_A = 25
n_B = 40

def linear(A, B):
	return A.transpose() * B + 1
def quadratic(A, B):
	return numpy.power((A.transpose() * B + 1), 2)

K = quadratic

classA = [(random.normalvariate(-1.5, 1),
           random.normalvariate(0.5,  2),
           1.0)
           for i in range(n_A)] + \
         [(random.normalvariate(1.5, 1),
           random.normalvariate(0.5, 2),
           1.0)
           for i in range(n_A)]

classB = [(random.normalvariate(0.0, 0.5),
           random.normalvariate(-15.0, 2.5),
           -1.0)
           for i in range(n_B)]

data = classA + classB
random.shuffle(data)

#pylab.hold(True)
#pylab.plot([p[0] for p in classA], [p[1] for p in classA], 'bo')
#pylab.plot([p[0] for p in classB], [p[1] for p in classB], 'ro')
#pylab.show()

X = numpy.matrix([[p[0] for p in data], [p[1] for p in data]])
t = numpy.array([p[2] for p in data])

q = -1 * numpy.ones(len(data))
h = numpy.zeros(len(data))
G = -1 * numpy.eye(len(data))

def Kernel(A, B, K):
	# Because numpy is crap
	return K(numpy.matrix(A), numpy.matrix(B))
	#K1 = numpy.zeros((A.shape[1], B.shape[1]))
	#for i in range(A.shape[1]):
	#    for j in range(B.shape[1]):
	#        K1[i, j] = K(A[:, i], B[:, j])
	#return K1

P = numpy.outer(t, t) * numpy.array(Kernel(X, X, K))

r = qp(matrix(P), matrix(q), matrix(G), matrix(h))
alpha = numpy.array(r['x'])

hits = numpy.nonzero(numpy.absolute(alpha) > 1e-6)[0]
print "Support vectors are ", hits
print "with values: ", alpha[hits].transpose()

c = ((alpha[hits].transpose() * t[hits]) * Kernel(X[:, hits], X, K)) > 0

print "Misclassifed: ", numpy.sum(c != (t == 1)), "/", len(data)

c_1 = [p for i, p in enumerate(data) if c[0, i]]
c_2 = [p for i, p in enumerate(data) if not c[0, i]]


import cvxopt
from cvxopt.solvers import qp
from cvxopt.base import matrix

import numpy, pylab, random, math, sys
from scipy.spatial.distance import cdist, squareform

n_A = 50
n_B = 40

def linear(A, B):
	return A.transpose() * B + 1
def quadratic(A, B):
	return numpy.power((A.transpose() * B + 1), 2)
def polynomial(A, B, n):
	return numpy.power((A.transpose() * B + 1), n)
def RBF(A, B, sigma):
    A = A.transpose()
    B = B.transpose()
    A_sq = numpy.sum(numpy.power(A, 2), axis = 1)
    A_n = A.shape[0]
    B_sq = numpy.sum(numpy.power(B, 2), axis = 1)
    B_n = B.shape[0]
    
    D = (A_sq * numpy.matrix(numpy.ones(B_n))).transpose()
    D += (B_sq * numpy.matrix(numpy.ones(A_n)))
    D -= (2*B*A.transpose())
    return numpy.exp(-D/(2*sigma**2));

#K = linear
#K = quadratic
K = lambda A, B: RBF(A, B, 10)
#K = lambda A, B: polynomial(A, B, 5)

assert len(sys.argv) >= 2

C = float(sys.argv[1])

if True:
    classA = [(random.normalvariate(-1.5, 5),
               random.normalvariate(0.5,  5),
               1.0)
               for i in range(n_A)] + \
             [(random.normalvariate(5.0, 2),
               random.normalvariate(0.7, 2),
               1.0)
               for i in range(n_A)] + \
             [(random.normalvariate(-1.5, 2),
               random.normalvariate(-10, 5),
               1.0)
               for i in range(n_A)]

    classB = [(random.normalvariate(5.0, 2),
               random.normalvariate(-10.0, 2),
               -1.0)
               for i in range(n_B)] + \
             [(random.normalvariate(-1.5, 5),
               random.normalvariate(15, 2),
               -1.0)
               for i in range(n_A)] + \
             [(random.normalvariate(12, 2),
               random.normalvariate(10, 4),
               -1.0)
               for i in range(n_A)]
else:
    classA = [(random.normalvariate(-1.5, 1),
               random.normalvariate(0.5,  0.5),
               1.0)
               for i in range(n_A)]
    classB = [(random.normalvariate(2.5, 0.5),
               random.normalvariate(-0.5,  1),
               -1.0)
               for i in range(n_B)]

data = classA + classB
random.shuffle(data)

X = numpy.matrix([[p[0] for p in data], [p[1] for p in data]])
t = numpy.array([p[2] for p in data])

q = -1 * numpy.ones(len(data))
h = numpy.hstack((numpy.zeros(len(data)), C * numpy.ones(len(data))))
#h = numpy.zeros(len(data))
G = numpy.vstack((-1 * numpy.eye(len(data)), numpy.eye(len(data))))
#G = -1 * numpy.eye(len(data))

def Kernel(A, B, K):
	# Because numpy is crap
	return K(numpy.matrix(A), numpy.matrix(B))
	#K1 = numpy.matrix(numpy.zeros((A.shape[1], B.shape[1])))
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
ind = lambda Y: ((alpha[hits].transpose() * t[hits]) * Kernel(X[:, hits], Y, K).transpose())
#ind = lambda Y: ((alpha[hits].transpose() * t[hits]) * Kernel(X[:, hits], Y, K))

#c = ((alpha[hits].transpose() * t[hits]) * Kernel(X[:, hits], X, K)) > 0
c = ind(X) > 0

print "Misclassifed: ", round(10000.0 * numpy.sum(c != (t == 1)) / len(data))/100, "%"

c_1 = [p for i, p in enumerate(data) if c[0, i]]
c_2 = [p for i, p in enumerate(data) if not c[0, i]]

t_A = 100
t_B = 180

test_A = [(random.normalvariate(-1.5, 1),
           random.normalvariate(0.5,  2),
           1.0)
           for i in range(t_A)] + \
         [(random.normalvariate(1.5, 1),
           random.normalvariate(0.5, 2),
           1.0)
           for i in range(t_A)]

test_B = [(random.normalvariate(0.0, 0.5),
           random.normalvariate(-15.0, 2.5),
           -1.0)
           for i in range(t_B)]

test = test_A + test_B
random.shuffle(test)

X_test = numpy.matrix([[p[0] for p in test], [p[1] for p in test]])
t_test = numpy.array([p[2] for p in test])

#c_test = ((alpha[hits].transpose() * t[hits]) * Kernel(X[:, hits], X_test, K)) > 0
c_test = ind(X_test)

print "Misclassified in test set: ", round(10000.0*numpy.sum(c_test != (t_test == 1)) / len(test))/100, "%"

sv = X[:, hits]
sv_1 = (t[hits].transpose() > 0)
sv_2 = (t[hits].transpose() < 0)

pylab.hold(True)
pylab.plot([p[0] for p in classA], [p[1] for p in classA], 'b*')
pylab.plot([p[0] for p in classB], [p[1] for p in classB], 'r.')
pylab.plot(sv[0, sv_1], sv[1, sv_1], 'bo')
pylab.plot(sv[0, sv_2], sv[1, sv_2], 'r+')

xs = numpy.arange(numpy.min(X[0, :]) - 1, numpy.max(X[0, :]) + 1, 0.2)
ys = numpy.arange(numpy.min(X[1, :]) - 1, numpy.max(X[1, :]) + 1, 0.2)
xx, yy = numpy.meshgrid(xs, ys)
grid = numpy.matrix(numpy.vstack((xx.ravel(), yy.ravel())))
zs = numpy.reshape(ind(grid), (len(ys), len(xs)))

pylab.contour(xs, ys, zs,
              levels = (-1, 0, 1),
              colors = ('red', 'black', 'blue'),
              linewidths = (1, 1, 1))

pylab.show()


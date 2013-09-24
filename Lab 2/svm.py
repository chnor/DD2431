
import cvxopt
from cvxopt.solvers import qp
from cvxopt.base import matrix

import numpy, pylab, random, math, sys

n_A = 25
n_B = 40

def linear(A, B):
	return A.transpose() * B + 1
def quadratic(A, B):
	return numpy.power((A.transpose() * B + 1), 2)
def RBF_1(A, B, sigma):
    K = A.transpose() * B / sigma**2
    #d = numpy.diag(K)
    #n = len(d)
    #K =- numpy.matrix(numpy.outer(numpy.ones(n), d)) / 2
    #K =- numpy.matrix(numpy.outer(d, numpy.ones(n))) / 2
    return numpy.exp(K)
def RBF(sigma):
	return lambda A, B: numpy.exp(-((A - B).transpose() * (A - B)) / (2*sigma**2))

#K = quadratic
K = lambda A, B: RBF_1(A, B, 4)

assert len(sys.argv) >= 2

C = float(sys.argv[1])

classA = [(random.normalvariate(-1.5, 1),
           random.normalvariate(0.5,  2),
           1.0)
           for i in range(n_A)] + \
         [(random.normalvariate(1.5, 1),
           random.normalvariate(0.5, 2),
           1.0)
           for i in range(n_A)]

classB = [(random.normalvariate(-5.0, 0.5),
           random.normalvariate(-7.0, 2.5),
           -1.0)
           for i in range(n_B)] + \
         [(random.normalvariate(1.5, 2),
           random.normalvariate(10.0, 1),
           -1.0)
           for i in range(n_A)]

data = classA + classB
random.shuffle(data)

X = numpy.matrix([[p[0] for p in data], [p[1] for p in data]])
t = numpy.array([p[2] for p in data])

q = -1 * numpy.ones(len(data))
h = numpy.hstack((numpy.zeros(len(data)), C * numpy.ones(len(data))))
G = numpy.vstack((-1 * numpy.eye(len(data)), numpy.eye(len(data))))

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
ind = lambda Y: ((alpha[hits].transpose() * t[hits]) * Kernel(X[:, hits], Y, K))

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
pylab.plot([p[0] for p in classA], [p[1] for p in classA], 'b.')
pylab.plot([p[0] for p in classB], [p[1] for p in classB], 'r.')
pylab.plot(sv[0, sv_1], sv[1, sv_1], 'bo')
pylab.plot(sv[0, sv_2], sv[1, sv_2], 'ro')

xs = numpy.arange(-5, 10, 0.05)
ys = numpy.arange(-12, 15, 0.05)
xx, yy = numpy.meshgrid(xs, ys)
grid = numpy.matrix(numpy.vstack((xx.ravel(), yy.ravel())))
zs = numpy.reshape(ind(grid), (len(ys), len(xs)))

pylab.contour(xs, ys, zs,
              levels = (-1, 0, 1),
              colors = ('red', 'black', 'blue'),
              linewidths = (1, 1, 1))

pylab.show()


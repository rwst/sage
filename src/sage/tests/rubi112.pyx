'''
Adapted frm SymPy. Original comment:
Tests for Rubi Algebraic 1.2 rules. Parsed from Maple syntax
All tests: http://www.apmaths.uwo.ca/~arich/IntegrationProblems/MapleSyntaxFiles/MapleSyntaxFiles.html
Note: Some tests are commented since they depend rules other than Algebraic1.2.

EXAMPLES::

    sage: from sage.tests.rubi112 import test_1, test_2, test_3, test_4, test_5, test_6, test_7, test_numerical
    sage: test_1()
    sage: test_2()
    sage: test_3()
    sage: test_4()
    sage: test_5()
    sage: test_6()
    sage: test_7()
    sage: test_numerical()
'''
from cysignals.signals cimport sig_on, sig_off
from sage.functions.all import (sqrt, log, arcsin, arctan, arctanh, hypergeometric, elliptic_e, elliptic_f)
from sage.symbolic.constants import I, pi
from sage.symbolic.ring import SR
from sage.rings.all import ZZ

(a,b,c,d,e,f,m,n,x,u) = SR.var('a b c d e f m n x u')

def rubi_test(l):
    sig_on()
    try:
        res = l[0].rubi(l[1])
    except RuntimError:
        print(l[0])
        return
    finally:
        sig_off()
    v = l[1]
    if not bool(res.diff(v) - l[3].diff(v) == 0):
        print('FAIL: ' + repr(l[0]) + " == " + repr(res) + " / " + repr(l[3]))

def test_1():
    test = [
        [ SR(- ZZ(3)/ZZ(2)), x, ZZ(1), - ZZ(3)/ZZ(2)*x],
        [pi, x, ZZ(1), pi*x],
        [a, x, ZZ(1), a*x],
        [x**m, x, ZZ(1), x**(ZZ(1) + m)/(ZZ(1) + m)],
        [x**ZZ(100), x, ZZ(1), ZZ(1)/ZZ(101)*x**ZZ(101)],
        [x**(ZZ(5)/ZZ(2)), x, ZZ(1), ZZ(2)/ZZ(7)*x**(ZZ(7)/ZZ(2))],
        [x**(ZZ(5)/ZZ(3)), x, ZZ(1), ZZ(3)/ZZ(8)*x**(ZZ(8)/ZZ(3))],
        [ZZ(1)/x**(ZZ(1)/ZZ(3)), x, ZZ(1), ZZ(3)/ZZ(2)*x**(ZZ(2)/ZZ(3))],
        [x**ZZ(3)*(a + b*x), x, ZZ(2), ZZ(1)/ZZ(4)*a*x**ZZ(4) + ZZ(1)/ZZ(5)*b*x**ZZ(5)],
        [(a + b*x)**ZZ(2)/x**ZZ(2), x, ZZ(2), - a**ZZ(2)/x + b**ZZ(2)*x + ZZ(2)*a*b*log(x)],
    ]

    for i in test:
        rubi_test(i)

def test_2():
    test = [
        [(a + b*x)/x, x, ZZ(2), b*x + a*log(x)],
        [x**ZZ(5)/(a + b*x), x, ZZ(2), a**ZZ(4)*x/b**ZZ(5) - ZZ(1)/ZZ(2)*a**ZZ(3)*x**ZZ(2)/b**ZZ(4) + ZZ(1)/ZZ(3)*a**ZZ(2)*x**ZZ(3)/b**ZZ(3) - ZZ(1)/ZZ(4)*a*x**ZZ(4)/b**ZZ(2) + ZZ(1)/ZZ(5)*x**ZZ(5)/b - a**ZZ(5)*log(a + b*x)/b**ZZ(6)],
        [ZZ(1)/(a + b*x)**ZZ(2), x, ZZ(1), ( - ZZ(1))/(b*(a + b*x))],
        [ZZ(1)/(x*(a + b*x)**ZZ(3)), x, ZZ(2), ZZ(1)/ZZ(2)/(a*(a + b*x)**ZZ(2)) + ZZ(1)/(a**ZZ(2)*(a + b*x)) + log(x)/a**ZZ(3) - log(a + b*x)/a**ZZ(3)],
        [ZZ(1)/(ZZ(2) + ZZ(2)*x), x, ZZ(1), ZZ(1)/ZZ(2)*log(ZZ(1) + x)],
        [ZZ(1)/(x*(ZZ(1) + b*x)), x, ZZ(3), log(x) - log(ZZ(1) + b*x)],
        [x**ZZ(3)*sqrt(a + b*x), x, ZZ(2), - ZZ(2)/ZZ(3)*a**ZZ(3)*(a + b*x)**(ZZ(3)/ZZ(2))/b**ZZ(4) + ZZ(6)/ZZ(5)*a**ZZ(2)*(a + b*x)**(ZZ(5)/ZZ(2))/b**ZZ(4) - ZZ(6)/ZZ(7)*a*(a + b*x)**(ZZ(7)/ZZ(2))/b**ZZ(4) + ZZ(2)/ZZ(9)*(a + b*x)**(ZZ(9)/ZZ(2))/b**ZZ(4)],
        [(a + b*x)**(ZZ(3)/ZZ(2)), x, ZZ(1), ZZ(2)/ZZ(5)*(a + b*x)**(ZZ(5)/ZZ(2))/b],
        [x**ZZ(4)/sqrt(a + b*x), x, ZZ(2), - ZZ(8)/ZZ(3)*a**ZZ(3)*(a + b*x)**(ZZ(3)/ZZ(2))/b**ZZ(5) + ZZ(12)/ZZ(5)*a**ZZ(2)*(a + b*x)**(ZZ(5)/ZZ(2))/b**ZZ(5) - ZZ(8)/ZZ(7)*a*(a + b*x)**(ZZ(7)/ZZ(2))/b**ZZ(5) + ZZ(2)/ZZ(9)*(a + b*x)**(ZZ(9)/ZZ(2))/b**ZZ(5) + ZZ(2)*a**ZZ(4)*sqrt(a + b*x)/b**ZZ(5)],
        [ZZ(1)/sqrt(a + b*x), x, ZZ(1), ZZ(2)*sqrt(a + b*x)/b],
        [ZZ(1)/(x*(a + b*x)**(ZZ(3)/ZZ(2))), x, ZZ(3), - ZZ(2)*arctanh(sqrt(a + b*x)/sqrt(a))/a**(ZZ(3)/ZZ(2)) + ZZ(2)/(a*sqrt(a + b*x))],
        [ZZ(1)/(x**ZZ(2)*( - a + b*x)**(ZZ(3)/ZZ(2))), x, ZZ(4), - ZZ(3)*b*arctan(sqrt( - a + b*x)/sqrt(a))/a**(ZZ(5)/ZZ(2)) + ( - ZZ(2))/(a*x*sqrt( - a + b*x)) - ZZ(3)*sqrt( - a + b*x)/(a**ZZ(2)*x)],
        [x**ZZ(3)*(a + b*x)**(ZZ(1)/ZZ(3)), x, ZZ(2), - ZZ(3)/ZZ(4)*a**ZZ(3)*(a + b*x)**(ZZ(4)/ZZ(3))/b**ZZ(4) + ZZ(9)/ZZ(7)*a**ZZ(2)*(a + b*x)**(ZZ(7)/ZZ(3))/b**ZZ(4) - ZZ(9)/ZZ(10)*a*(a + b*x)**(ZZ(10)/ZZ(3))/b**ZZ(4) + ZZ(3)/ZZ(13)*(a + b*x)**(ZZ(13)/ZZ(3))/b**ZZ(4)],
        [x**ZZ(2)*(a + b*x)**(ZZ(2)/ZZ(3)), x, ZZ(2), ZZ(3)/ZZ(5)*a**ZZ(2)*(a + b*x)**(ZZ(5)/ZZ(3))/b**ZZ(3) - ZZ(3)/ZZ(4)*a*(a + b*x)**(ZZ(8)/ZZ(3))/b**ZZ(3) + ZZ(3)/ZZ(11)*(a + b*x)**(ZZ(11)/ZZ(3))/b**ZZ(3)],
        [x**ZZ(2)/(a + b*x)**(ZZ(1)/ZZ(3)), x, ZZ(2), ZZ(3)/ZZ(2)*a**ZZ(2)*(a + b*x)**(ZZ(2)/ZZ(3))/b**ZZ(3) - ZZ(6)/ZZ(5)*a*(a + b*x)**(ZZ(5)/ZZ(3))/b**ZZ(3) + ZZ(3)/ZZ(8)*(a + b*x)**(ZZ(8)/ZZ(3))/b**ZZ(3)],
        [x**ZZ(3)/( - a + b*x)**(ZZ(1)/ZZ(3)), x, ZZ(2), ZZ(3)/ZZ(2)*a**ZZ(3)*( - a + b*x)**(ZZ(2)/ZZ(3))/b**ZZ(4) + ZZ(9)/ZZ(5)*a**ZZ(2)*( - a + b*x)**(ZZ(5)/ZZ(3))/b**ZZ(4) + ZZ(9)/ZZ(8)*a*( - a + b*x)**(ZZ(8)/ZZ(3))/b**ZZ(4) + ZZ(3)/ZZ(11)*( - a + b*x)**(ZZ(11)/ZZ(3))/b**ZZ(4)],
    ]

    for i in test:
        rubi_test(i)

def test_3():
    test = [
        [x**m*(a + b*x), x, ZZ(2), a*x**(ZZ(1) + m)/(ZZ(1) + m) + b*x**(ZZ(2) + m)/(ZZ(2) + m)],
        [x**(ZZ(5)/ZZ(2))*(a + b*x), x, ZZ(2), ZZ(2)/ZZ(7)*a*x**(ZZ(7)/ZZ(2)) + ZZ(2)/ZZ(9)*b*x**(ZZ(9)/ZZ(2))],
        [x**(ZZ(5)/ZZ(2))/(a + b*x), x, ZZ(5), - ZZ(2)/ZZ(3)*a*x**(ZZ(3)/ZZ(2))/b**ZZ(2) + ZZ(2)/ZZ(5)*x**(ZZ(5)/ZZ(2))/b - ZZ(2)*a**(ZZ(5)/ZZ(2))*arctan(sqrt(b)*sqrt(x)/sqrt(a))/b**(ZZ(7)/ZZ(2)) + ZZ(2)*a**ZZ(2)*sqrt(x)/b**ZZ(3)],
        [x**(ZZ(3)/ZZ(2))/(a + b*x), x, ZZ(4), ZZ(2)/ZZ(3)*x**(ZZ(3)/ZZ(2))/b + ZZ(2)*a**(ZZ(3)/ZZ(2))*arctan(sqrt(b)*sqrt(x)/sqrt(a))/b**(ZZ(5)/ZZ(2)) - ZZ(2)*a*sqrt(x)/b**ZZ(2)],
        [x**(ZZ(5)/ZZ(2))/( - a + b*x), x, ZZ(5), ZZ(2)/ZZ(3)*a*x**(ZZ(3)/ZZ(2))/b**ZZ(2) + ZZ(2)/ZZ(5)*x**(ZZ(5)/ZZ(2))/b - ZZ(2)*a**(ZZ(5)/ZZ(2))*arctanh(sqrt(b)*sqrt(x)/sqrt(a))/b**(ZZ(7)/ZZ(2)) + ZZ(2)*a**ZZ(2)*sqrt(x)/b**ZZ(3)],
        [x**(ZZ(5)/ZZ(2))*sqrt(a + b*x), x, ZZ(6), - ZZ(5)/ZZ(64)*a**ZZ(4)*arctanh(sqrt(b)*sqrt(x)/sqrt(a + b*x))/b**(ZZ(7)/ZZ(2)) - ZZ(5)/ZZ(96)*a**ZZ(2)*x**(ZZ(3)/ZZ(2))*sqrt(a + b*x)/b**ZZ(2) + ZZ(1)/ZZ(24)*a*x**(ZZ(5)/ZZ(2))*sqrt(a + b*x)/b + ZZ(1)/ZZ(4)*x**(ZZ(7)/ZZ(2))*sqrt(a + b*x) + ZZ(5)/ZZ(64)*a**ZZ(3)*sqrt(x)*sqrt(a + b*x)/b**ZZ(3)],
        [x**(ZZ(3)/ZZ(2))*sqrt(a + b*x), x, ZZ(5), ZZ(1)/ZZ(8)*a**ZZ(3)*arctanh(sqrt(b)*sqrt(x)/sqrt(a + b*x))/b**(ZZ(5)/ZZ(2)) + ZZ(1)/ZZ(12)*a*x**(ZZ(3)/ZZ(2))*sqrt(a + b*x)/b + ZZ(1)/ZZ(3)*x**(ZZ(5)/ZZ(2))*sqrt(a + b*x) - ZZ(1)/ZZ(8)*a**ZZ(2)*sqrt(x)*sqrt(a + b*x)/b**ZZ(2)],
        [x**(ZZ(5)/ZZ(2))/sqrt(a + b*x), x, ZZ(5), - ZZ(5)/ZZ(8)*a**ZZ(3)*arctanh(sqrt(b)*sqrt(x)/sqrt(a + b*x))/b**(ZZ(7)/ZZ(2)) - ZZ(5)/ZZ(12)*a*x**(ZZ(3)/ZZ(2))*sqrt(a + b*x)/b**ZZ(2) + ZZ(1)/ZZ(3)*x**(ZZ(5)/ZZ(2))*sqrt(a + b*x)/b + ZZ(5)/ZZ(8)*a**ZZ(2)*sqrt(x)*sqrt(a + b*x)/b**ZZ(3)],
        [sqrt(x)/sqrt(a + b*x), x, ZZ(3), - a*arctanh(sqrt(b)*sqrt(x)/sqrt(a + b*x))/b**(ZZ(3)/ZZ(2)) + sqrt(x)*sqrt(a + b*x)/b],
        [x**(ZZ(2)/ZZ(3))*(a + b*x), x, ZZ(2), ZZ(3)/ZZ(5)*a*x**(ZZ(5)/ZZ(3)) + ZZ(3)/ZZ(8)*b*x**(ZZ(8)/ZZ(3))],
        [x**(ZZ(1)/ZZ(3))*(a + b*x), x, ZZ(2), ZZ(3)/ZZ(4)*a*x**(ZZ(4)/ZZ(3)) + ZZ(3)/ZZ(7)*b*x**(ZZ(7)/ZZ(3))],
        [x**(ZZ(5)/ZZ(3))/(a + b*x), x, ZZ(6), - ZZ(3)/ZZ(2)*a*x**(ZZ(2)/ZZ(3))/b**ZZ(2) + ZZ(3)/ZZ(5)*x**(ZZ(5)/ZZ(3))/b - ZZ(3)/ZZ(2)*a**(ZZ(5)/ZZ(3))*log(a**(ZZ(1)/ZZ(3)) + b**(ZZ(1)/ZZ(3))*x**(ZZ(1)/ZZ(3)))/b**(ZZ(8)/ZZ(3)) + ZZ(1)/ZZ(2)*a**(ZZ(5)/ZZ(3))*log(a + b*x)/b**(ZZ(8)/ZZ(3)) - a**(ZZ(5)/ZZ(3))*arctan((a**(ZZ(1)/ZZ(3)) - ZZ(2)*b**(ZZ(1)/ZZ(3))*x**(ZZ(1)/ZZ(3)))/(a**(ZZ(1)/ZZ(3))*sqrt(ZZ(3))))*sqrt(ZZ(3))/b**(ZZ(8)/ZZ(3))],
        [x**(ZZ(4)/ZZ(3))/(a + b*x), x, ZZ(6), - ZZ(3)*a*x**(ZZ(1)/ZZ(3))/b**ZZ(2) + ZZ(3)/ZZ(4)*x**(ZZ(4)/ZZ(3))/b + ZZ(3)/ZZ(2)*a**(ZZ(4)/ZZ(3))*log(a**(ZZ(1)/ZZ(3)) + b**(ZZ(1)/ZZ(3))*x**(ZZ(1)/ZZ(3)))/b**(ZZ(7)/ZZ(3)) - ZZ(1)/ZZ(2)*a**(ZZ(4)/ZZ(3))*log(a + b*x)/b**(ZZ(7)/ZZ(3)) - a**(ZZ(4)/ZZ(3))*arctan((a**(ZZ(1)/ZZ(3)) - ZZ(2)*b**(ZZ(1)/ZZ(3))*x**(ZZ(1)/ZZ(3)))/(a**(ZZ(1)/ZZ(3))*sqrt(ZZ(3))))*sqrt(ZZ(3))/b**(ZZ(7)/ZZ(3))],
        [(ZZ(1) - x)**(ZZ(1)/ZZ(4))/(ZZ(1) + x), x, ZZ(5), ZZ(4)*(ZZ(1) - x)**(ZZ(1)/ZZ(4)) - ZZ(2)*ZZ(2)**(ZZ(1)/ZZ(4))*arctan((ZZ(1) - x)**(ZZ(1)/ZZ(4))/ZZ(2)**(ZZ(1)/ZZ(4))) - ZZ(2)*ZZ(2)**(ZZ(1)/ZZ(4))*arctanh((ZZ(1) - x)**(ZZ(1)/ZZ(4))/ZZ(2)**(ZZ(1)/ZZ(4)))],
        [x**m*(a + b*x)**ZZ(2), x, ZZ(2), a**ZZ(2)*x**(ZZ(1) + m)/(ZZ(1) + m) + ZZ(2)*a*b*x**(ZZ(2) + m)/(ZZ(2) + m) + b**ZZ(2)*x**(ZZ(3) + m)/(ZZ(3) + m)],
    ]

    for i in test:
        rubi_test(i)

def test_4():
    test = [
        [x**m/(a + b*x)**ZZ(2), x, ZZ(1), x**(ZZ(1) + m)*hypergeometric([ZZ(2), ZZ(1) + m], [ZZ(2) + m], - b*x/a)/(a**ZZ(2)*(ZZ(1) + m))],
        [x**m/sqrt(ZZ(2) + ZZ(3)*x), x, ZZ(1), x**(ZZ(1) + m)*hypergeometric([ZZ(1)/ZZ(2), ZZ(1) + m], [ZZ(2) + m], - ZZ(3)/ZZ(2)*x)/((ZZ(1) + m)*sqrt(ZZ(2)))],
        [x**m*(a + b*x)**n, x, ZZ(2), x**(ZZ(1) + m)*(a + b*x)**n*hypergeometric([ZZ(1) + m, - n], [ZZ(2) + m], - b*x/a)/((ZZ(1) + m)*(ZZ(1) + b*x/a)**n)],
        [x**( - ZZ(1) + n)/(a + b*x)**n, x, ZZ(2), x**n*(ZZ(1) + b*x/a)**n*hypergeometric([n, n], [ZZ(1) + n], - b*x/a)/(n*(a + b*x)**n)],
        [(c + d*(a + b*x))**(ZZ(5)/ZZ(2)), x, ZZ(2), ZZ(2)/ZZ(7)*(c + d*(a + b*x))**(ZZ(7)/ZZ(2))/(b*d)],
        [(c + d*(a + b*x))**(ZZ(3)/ZZ(2)), x, ZZ(2), ZZ(2)/ZZ(5)*(c + d*(a + b*x))**(ZZ(5)/ZZ(2))/(b*d)],
        [(a + b*x)**ZZ(3)/(a*d/b + d*x)**ZZ(3), x, ZZ(2), b**ZZ(3)*x/d**ZZ(3)],
        [(a + b*x)*(a*c - b*c*x)**ZZ(3), x, ZZ(2), - ZZ(1)/ZZ(2)*a*c**ZZ(3)*(a - b*x)**ZZ(4)/b + ZZ(1)/ZZ(5)*c**ZZ(3)*(a - b*x)**ZZ(5)/b],
        [(a*c - b*c*x)**ZZ(3)/(a + b*x), x, ZZ(2), - ZZ(4)*a**ZZ(2)*c**ZZ(3)*x + a*c**ZZ(3)*(a - b*x)**ZZ(2)/b + ZZ(1)/ZZ(3)*c**ZZ(3)*(a - b*x)**ZZ(3)/b + ZZ(8)*a**ZZ(3)*c**ZZ(3)*log(a + b*x)/b],
        [ZZ(1)/((a + b*x)**ZZ(2)*(a*c - b*c*x)), x, ZZ(3), ( - ZZ(1)/ZZ(2))/(a*b*c*(a + b*x)) + ZZ(1)/ZZ(2)*arctanh(b*x/a)/(a**ZZ(2)*b*c)],
        [(ZZ(1) + x)**(ZZ(1)/ZZ(2))/(ZZ(1) - x)**(ZZ(9)/ZZ(2)), x, ZZ(3), ZZ(1)/ZZ(7)*(ZZ(1) + x)**(ZZ(3)/ZZ(2))/(ZZ(1) - x)**(ZZ(7)/ZZ(2)) + ZZ(2)/ZZ(35)*(ZZ(1) + x)**(ZZ(3)/ZZ(2))/(ZZ(1) - x)**(ZZ(5)/ZZ(2)) + ZZ(2)/ZZ(105)*(ZZ(1) + x)**(ZZ(3)/ZZ(2))/(ZZ(1) - x)**(ZZ(3)/ZZ(2))],
        [(ZZ(1) + x)**(ZZ(5)/ZZ(2))/(ZZ(1) - x)**(ZZ(1)/ZZ(2)), x, ZZ(5), ZZ(5)/ZZ(2)*arcsin(x) - ZZ(5)/ZZ(6)*(ZZ(1) + x)**(ZZ(3)/ZZ(2))*sqrt(ZZ(1) - x) - ZZ(1)/ZZ(3)*(ZZ(1) + x)**(ZZ(5)/ZZ(2))*sqrt(ZZ(1) - x) - ZZ(5)/ZZ(2)*sqrt(ZZ(1) - x)*sqrt(ZZ(1) + x)],
    ]
    for i in test:
        rubi_test(i)


def test_5():
    test = [
        [(ZZ(1) + a*x)**(ZZ(3)/ZZ(2))/sqrt(ZZ(1) - a*x), x, ZZ(4), ZZ(3)/ZZ(2)*arcsin(a*x)/a - ZZ(1)/ZZ(2)*(ZZ(1) + a*x)**(ZZ(3)/ZZ(2))*sqrt(ZZ(1) - a*x)/a - ZZ(3)/ZZ(2)*sqrt(ZZ(1) - a*x)*sqrt(ZZ(1) + a*x)/a],
        [(ZZ(1) - x)**(ZZ(1)/ZZ(2))/(ZZ(1) + x)**(ZZ(1)/ZZ(2)), x, ZZ(3), arcsin(x) + sqrt(ZZ(1) - x)*sqrt(ZZ(1) + x)],
        [ZZ(1)/((ZZ(1) - x)**(ZZ(1)/ZZ(2))*(ZZ(1) + x)**(ZZ(3)/ZZ(2))), x, ZZ(1), - sqrt(ZZ(1) - x)/sqrt(ZZ(1) + x)],
        [(a + a*x)**(ZZ(5)/ZZ(2))*(c - c*x)**(ZZ(5)/ZZ(2)), x, ZZ(5), ZZ(5)/ZZ(24)*a*c*x*(a + a*x)**(ZZ(3)/ZZ(2))*(c - c*x)**(ZZ(3)/ZZ(2)) + ZZ(1)/ZZ(6)*x*(a + a*x)**(ZZ(5)/ZZ(2))*(c - c*x)**(ZZ(5)/ZZ(2)) + ZZ(5)/ZZ(8)*a**(ZZ(5)/ZZ(2))*c**(ZZ(5)/ZZ(2))*arctan(sqrt(c)*sqrt(a + a*x)/(sqrt(a)*sqrt(c - c*x))) + ZZ(5)/ZZ(16)*a**ZZ(2)*c**ZZ(2)*x*sqrt(a + a*x)*sqrt(c - c*x)],
        [ZZ(1)/((a + a*x)**(ZZ(5)/ZZ(2))*(c - c*x)**(ZZ(5)/ZZ(2))), x, ZZ(2), ZZ(1)/ZZ(3)*x/(a*c*(a + a*x)**(ZZ(3)/ZZ(2))*(c - c*x)**(ZZ(3)/ZZ(2))) + ZZ(2)/ZZ(3)*x/(a**ZZ(2)*c**ZZ(2)*sqrt(a + a*x)*sqrt(c - c*x))],
        [(ZZ(3) - x)**(ZZ(1)/ZZ(2))*( - ZZ(2) + x)**(ZZ(1)/ZZ(2)), x, ZZ(5), - ZZ(1)/ZZ(8)*arcsin(ZZ(5) - ZZ(2)*x) - ZZ(1)/ZZ(2)*(ZZ(3) - x)**(ZZ(3)/ZZ(2))*sqrt( - ZZ(2) + x) + ZZ(1)/ZZ(4)*sqrt(ZZ(3) - x)*sqrt( - ZZ(2) + x)],
        [ZZ(1)/(sqrt(a + b*x)*sqrt( - a*d + b*d*x)), x, ZZ(2), ZZ(2)*arctanh(sqrt(d)*sqrt(a + b*x)/sqrt( - a*d + b*d*x))/(b*sqrt(d))],
        [ZZ(1)/((a - I*a*x)**(ZZ(7)/ZZ(4))*(a + I*a*x)**(ZZ(1)/ZZ(4))), x, ZZ(1), - ZZ(2)/ZZ(3)*I*(a + I*a*x)**(ZZ(3)/ZZ(4))/(a**ZZ(2)*(a - I*a*x)**(ZZ(3)/ZZ(4)))],
        [(a + b*x)**ZZ(2)*(a*c - b*c*x)**n, x, ZZ(2), - ZZ(4)*a**ZZ(2)*(a*c - b*c*x)**(ZZ(1) + n)/(b*c*(ZZ(1) + n)) + ZZ(4)*a*(a*c - b*c*x)**(ZZ(2) + n)/(b*c**ZZ(2)*(ZZ(2) + n)) - (a*c - b*c*x)**(ZZ(3) + n)/(b*c**ZZ(3)*(ZZ(3) + n))],
        [(a + b*x)**ZZ(4)*(c + d*x), x, ZZ(2), ZZ(1)/ZZ(5)*(b*c - a*d)*(a + b*x)**ZZ(5)/b**ZZ(2) + ZZ(1)/ZZ(6)*d*(a + b*x)**ZZ(6)/b**ZZ(2)],
        [(a + b*x)*(c + d*x), x, ZZ(2), a*c*x + ZZ(1)/ZZ(2)*(b*c + a*d)*x**ZZ(2) + ZZ(1)/ZZ(3)*b*d*x**ZZ(3)],
        [(a + b*x)**ZZ(5)/(c + d*x), x, ZZ(2), b*(b*c - a*d)**ZZ(4)*x/d**ZZ(5) - ZZ(1)/ZZ(2)*(b*c - a*d)**ZZ(3)*(a + b*x)**ZZ(2)/d**ZZ(4) + ZZ(1)/ZZ(3)*(b*c - a*d)**ZZ(2)*(a + b*x)**ZZ(3)/d**ZZ(3) - ZZ(1)/ZZ(4)*(b*c - a*d)*(a + b*x)**ZZ(4)/d**ZZ(2) + ZZ(1)/ZZ(5)*(a + b*x)**ZZ(5)/d - (b*c - a*d)**ZZ(5)*log(c + d*x)/d**ZZ(6)],
        [(a + b*x)/(c + d*x)**ZZ(3), x, ZZ(1), ZZ(1)/ZZ(2)*(a + b*x)**ZZ(2)/((b*c - a*d)*(c + d*x)**ZZ(2))],
        [(a + b*x)**ZZ(5)*(c + d*x)**(ZZ(1)/ZZ(2)), x, ZZ(2), - ZZ(2)/ZZ(3)*(b*c - a*d)**ZZ(5)*(c + d*x)**(ZZ(3)/ZZ(2))/d**ZZ(6) + ZZ(2)*b*(b*c - a*d)**ZZ(4)*(c + d*x)**(ZZ(5)/ZZ(2))/d**ZZ(6) - ZZ(20)/ZZ(7)*b**ZZ(2)*(b*c - a*d)**ZZ(3)*(c + d*x)**(ZZ(7)/ZZ(2))/d**ZZ(6) + ZZ(20)/ZZ(9)*b**ZZ(3)*(b*c - a*d)**ZZ(2)*(c + d*x)**(ZZ(9)/ZZ(2))/d**ZZ(6) - ZZ(10)/ZZ(11)*b**ZZ(4)*(b*c - a*d)*(c + d*x)**(ZZ(11)/ZZ(2))/d**ZZ(6) + ZZ(2)/ZZ(13)*b**ZZ(5)*(c + d*x)**(ZZ(13)/ZZ(2))/d**ZZ(6)],
        [(c + d*x)**(ZZ(1)/ZZ(2))/(a + b*x)**ZZ(2), x, ZZ(3), - d*arctanh(sqrt(b)*sqrt(c + d*x)/sqrt(b*c - a*d))/(b**(ZZ(3)/ZZ(2))*sqrt(b*c - a*d)) - sqrt(c + d*x)/(b*(a + b*x))],
    ]

    for i in test:
        rubi_test(i)


def test_6():
    test = [
        [(ZZ(1) + a*x)**(ZZ(3)/ZZ(2))/sqrt(ZZ(1) - a*x), x, ZZ(4), ZZ(3)/ZZ(2)*arcsin(a*x)/a - ZZ(1)/ZZ(2)*(ZZ(1) + a*x)**(ZZ(3)/ZZ(2))*sqrt(ZZ(1) - a*x)/a - ZZ(3)/ZZ(2)*sqrt(ZZ(1) - a*x)*sqrt(ZZ(1) + a*x)/a],
        [(ZZ(1) - x)**(ZZ(1)/ZZ(2))/(ZZ(1) + x)**(ZZ(1)/ZZ(2)), x, ZZ(3), arcsin(x) + sqrt(ZZ(1) - x)*sqrt(ZZ(1) + x)],
        [ZZ(1)/((ZZ(1) - x)**(ZZ(1)/ZZ(2))*(ZZ(1) + x)**(ZZ(3)/ZZ(2))), x, ZZ(1), - sqrt(ZZ(1) - x)/sqrt(ZZ(1) + x)],
        [(a + a*x)**(ZZ(5)/ZZ(2))*(c - c*x)**(ZZ(5)/ZZ(2)), x, ZZ(5), ZZ(5)/ZZ(24)*a*c*x*(a + a*x)**(ZZ(3)/ZZ(2))*(c - c*x)**(ZZ(3)/ZZ(2)) + ZZ(1)/ZZ(6)*x*(a + a*x)**(ZZ(5)/ZZ(2))*(c - c*x)**(ZZ(5)/ZZ(2)) + ZZ(5)/ZZ(8)*a**(ZZ(5)/ZZ(2))*c**(ZZ(5)/ZZ(2))*arctan(sqrt(c)*sqrt(a + a*x)/(sqrt(a)*sqrt(c - c*x))) + ZZ(5)/ZZ(16)*a**ZZ(2)*c**ZZ(2)*x*sqrt(a + a*x)*sqrt(c - c*x)],
        [ZZ(1)/((a + a*x)**(ZZ(5)/ZZ(2))*(c - c*x)**(ZZ(5)/ZZ(2))), x, ZZ(2), ZZ(1)/ZZ(3)*x/(a*c*(a + a*x)**(ZZ(3)/ZZ(2))*(c - c*x)**(ZZ(3)/ZZ(2))) + ZZ(2)/ZZ(3)*x/(a**ZZ(2)*c**ZZ(2)*sqrt(a + a*x)*sqrt(c - c*x))],
        [(ZZ(3) - x)**(ZZ(1)/ZZ(2))*( - ZZ(2) + x)**(ZZ(1)/ZZ(2)), x, ZZ(5), - ZZ(1)/ZZ(8)*arcsin(ZZ(5) - ZZ(2)*x) - ZZ(1)/ZZ(2)*(ZZ(3) - x)**(ZZ(3)/ZZ(2))*sqrt( - ZZ(2) + x) + ZZ(1)/ZZ(4)*sqrt(ZZ(3) - x)*sqrt( - ZZ(2) + x)],
        [ZZ(1)/(sqrt(a + b*x)*sqrt( - a*d + b*d*x)), x, ZZ(2), ZZ(2)*arctanh(sqrt(d)*sqrt(a + b*x)/sqrt( - a*d + b*d*x))/(b*sqrt(d))],
        [ZZ(1)/((a - I*a*x)**(ZZ(7)/ZZ(4))*(a + I*a*x)**(ZZ(1)/ZZ(4))), x, ZZ(1), - ZZ(2)/ZZ(3)*I*(a + I*a*x)**(ZZ(3)/ZZ(4))/(a**ZZ(2)*(a - I*a*x)**(ZZ(3)/ZZ(4)))],
        [(a + b*x)**ZZ(2)*(a*c - b*c*x)**n, x, ZZ(2), - ZZ(4)*a**ZZ(2)*(a*c - b*c*x)**(ZZ(1) + n)/(b*c*(ZZ(1) + n)) + ZZ(4)*a*(a*c - b*c*x)**(ZZ(2) + n)/(b*c**ZZ(2)*(ZZ(2) + n)) - (a*c - b*c*x)**(ZZ(3) + n)/(b*c**ZZ(3)*(ZZ(3) + n))],
        [(a + b*x)**ZZ(4)*(c + d*x), x, ZZ(2), ZZ(1)/ZZ(5)*(b*c - a*d)*(a + b*x)**ZZ(5)/b**ZZ(2) + ZZ(1)/ZZ(6)*d*(a + b*x)**ZZ(6)/b**ZZ(2)],
        [(a + b*x)*(c + d*x), x, ZZ(2), a*c*x + ZZ(1)/ZZ(2)*(b*c + a*d)*x**ZZ(2) + ZZ(1)/ZZ(3)*b*d*x**ZZ(3)],
        [(a + b*x)**ZZ(5)/(c + d*x), x, ZZ(2), b*(b*c - a*d)**ZZ(4)*x/d**ZZ(5) - ZZ(1)/ZZ(2)*(b*c - a*d)**ZZ(3)*(a + b*x)**ZZ(2)/d**ZZ(4) + ZZ(1)/ZZ(3)*(b*c - a*d)**ZZ(2)*(a + b*x)**ZZ(3)/d**ZZ(3) - ZZ(1)/ZZ(4)*(b*c - a*d)*(a + b*x)**ZZ(4)/d**ZZ(2) + ZZ(1)/ZZ(5)*(a + b*x)**ZZ(5)/d - (b*c - a*d)**ZZ(5)*log(c + d*x)/d**ZZ(6)],
        [(a + b*x)/(c + d*x)**ZZ(3), x, ZZ(1), ZZ(1)/ZZ(2)*(a + b*x)**ZZ(2)/((b*c - a*d)*(c + d*x)**ZZ(2))],
        [(a + b*x)**ZZ(5)*(c + d*x)**(ZZ(1)/ZZ(2)), x, ZZ(2), - ZZ(2)/ZZ(3)*(b*c - a*d)**ZZ(5)*(c + d*x)**(ZZ(3)/ZZ(2))/d**ZZ(6) + ZZ(2)*b*(b*c - a*d)**ZZ(4)*(c + d*x)**(ZZ(5)/ZZ(2))/d**ZZ(6) - ZZ(20)/ZZ(7)*b**ZZ(2)*(b*c - a*d)**ZZ(3)*(c + d*x)**(ZZ(7)/ZZ(2))/d**ZZ(6) + ZZ(20)/ZZ(9)*b**ZZ(3)*(b*c - a*d)**ZZ(2)*(c + d*x)**(ZZ(9)/ZZ(2))/d**ZZ(6) - ZZ(10)/ZZ(11)*b**ZZ(4)*(b*c - a*d)*(c + d*x)**(ZZ(11)/ZZ(2))/d**ZZ(6) + ZZ(2)/ZZ(13)*b**ZZ(5)*(c + d*x)**(ZZ(13)/ZZ(2))/d**ZZ(6)],
        [(c + d*x)**(ZZ(1)/ZZ(2))/(a + b*x)**ZZ(2), x, ZZ(3), - d*arctanh(sqrt(b)*sqrt(c + d*x)/sqrt(b*c - a*d))/(b**(ZZ(3)/ZZ(2))*sqrt(b*c - a*d)) - sqrt(c + d*x)/(b*(a + b*x))],
        [(a + b*x)**ZZ(4)/(c + d*x)**(ZZ(1)/ZZ(2)), x, ZZ(2), - ZZ(8)/ZZ(3)*b*(b*c - a*d)**ZZ(3)*(c + d*x)**(ZZ(3)/ZZ(2))/d**ZZ(5) + ZZ(12)/ZZ(5)*b**ZZ(2)*(b*c - a*d)**ZZ(2)*(c + d*x)**(ZZ(5)/ZZ(2))/d**ZZ(5) - ZZ(8)/ZZ(7)*b**ZZ(3)*(b*c - a*d)*(c + d*x)**(ZZ(7)/ZZ(2))/d**ZZ(5) + ZZ(2)/ZZ(9)*b**ZZ(4)*(c + d*x)**(ZZ(9)/ZZ(2))/d**ZZ(5) + ZZ(2)*(b*c - a*d)**ZZ(4)*sqrt(c + d*x)/d**ZZ(5)],
        [(a + b*x)**ZZ(2)/(c + d*x)**(ZZ(1)/ZZ(2)), x, ZZ(2), - ZZ(4)/ZZ(3)*b*(b*c - a*d)*(c + d*x)**(ZZ(3)/ZZ(2))/d**ZZ(3) + ZZ(2)/ZZ(5)*b**ZZ(2)*(c + d*x)**(ZZ(5)/ZZ(2))/d**ZZ(3) + ZZ(2)*(b*c - a*d)**ZZ(2)*sqrt(c + d*x)/d**ZZ(3)],
        [(ZZ(1) - x)**(ZZ(1)/ZZ(3))/(ZZ(1) + x), x, ZZ(5), ZZ(3)*(ZZ(1) - x)**(ZZ(1)/ZZ(3)) + ZZ(3)*log(ZZ(2)**(ZZ(1)/ZZ(3)) - (ZZ(1) - x)**(ZZ(1)/ZZ(3)))/ZZ(2)**(ZZ(2)/ZZ(3)) - log(ZZ(1) + x)/ZZ(2)**(ZZ(2)/ZZ(3)) - ZZ(2)**(ZZ(1)/ZZ(3))*arctan((ZZ(1) + ZZ(2)**(ZZ(2)/ZZ(3))*(ZZ(1) - x)**(ZZ(1)/ZZ(3)))/sqrt(ZZ(3)))*sqrt(ZZ(3))],
        [(c + d*x)**(ZZ(1)/ZZ(2))/(a + b*x)**(ZZ(1)/ZZ(2)), x, ZZ(3), (b*c - a*d)*arctanh(sqrt(d)*sqrt(a + b*x)/(sqrt(b)*sqrt(c + d*x)))/(b**(ZZ(3)/ZZ(2))*sqrt(d)) + sqrt(a + b*x)*sqrt(c + d*x)/b],
        [(a + b*x)**(ZZ(1)/ZZ(2))*(c + d*x)**(ZZ(3)/ZZ(2)), x, ZZ(5), ZZ(1)/ZZ(3)*(a + b*x)**(ZZ(3)/ZZ(2))*(c + d*x)**(ZZ(3)/ZZ(2))/b - ZZ(1)/ZZ(8)*(b*c - a*d)**ZZ(3)*arctanh(sqrt(d)*sqrt(a + b*x)/(sqrt(b)*sqrt(c + d*x)))/(b**(ZZ(5)/ZZ(2))*d**(ZZ(3)/ZZ(2))) + ZZ(1)/ZZ(4)*(b*c - a*d)*(a + b*x)**(ZZ(3)/ZZ(2))*sqrt(c + d*x)/b**ZZ(2) + ZZ(1)/ZZ(8)*(b*c - a*d)**ZZ(2)*sqrt(a + b*x)*sqrt(c + d*x)/(b**ZZ(2)*d)],
        [(a + b*x)**(ZZ(1)/ZZ(2))/(c + d*x)**(ZZ(1)/ZZ(2)), x, ZZ(3), - (b*c - a*d)*arctanh(sqrt(d)*sqrt(a + b*x)/(sqrt(b)*sqrt(c + d*x)))/(d**(ZZ(3)/ZZ(2))*sqrt(b)) + sqrt(a + b*x)*sqrt(c + d*x)/d],
        [ZZ(1)/((a + b*x)**(ZZ(1)/ZZ(2))*(c + d*x)**(ZZ(5)/ZZ(2))), x, ZZ(2), ZZ(2)/ZZ(3)*sqrt(a + b*x)/((b*c - a*d)*(c + d*x)**(ZZ(3)/ZZ(2))) + ZZ(4)/ZZ(3)*b*sqrt(a + b*x)/((b*c - a*d)**ZZ(2)*sqrt(c + d*x))],
        [(a + b*x)**m*(c + d*x)**(ZZ(1) + ZZ(2)*n - ZZ(2)*(ZZ(1) + n)), x, ZZ(2), (a + b*x)**(ZZ(1) + m)*hypergeometric([ZZ(1), ZZ(1) + m], [ZZ(2) + m], - d*(a + b*x)/(b*c - a*d))/((b*c - a*d)*(ZZ(1) + m))],
        [a + b*x + c*x**ZZ(2) + d*x**ZZ(3), x, ZZ(1), a*x + ZZ(1)/ZZ(2)*b*x**ZZ(2) + ZZ(1)/ZZ(3)*c*x**ZZ(3) + ZZ(1)/ZZ(4)*d*x**ZZ(4)],
        [a + d/x**ZZ(3) + c/x**ZZ(2) + b/x, x, ZZ(1), - ZZ(1)/ZZ(2)*d/x**ZZ(2) - c/x + a*x + b*log(x)],
    ]

    for i in test:
        rubi_test(i)

def test_7():
    test = [
        #[(a + b*x)**(ZZ(3)/ZZ(2))*(c + d*x)**(ZZ(1)/ZZ(3)), x, ZZ(5), ZZ(12)/ZZ(187)*(b*c - a*d)*(a + b*x)**(ZZ(3)/ZZ(2))*(c + d*x)**(ZZ(1)/ZZ(3))/(b*d) + ZZ(6)/ZZ(17)*(a + b*x)**(ZZ(5)/ZZ(2))*(c + d*x)**(ZZ(1)/ZZ(3))/b - ZZ(108)/ZZ(935)*(b*c - a*d)**ZZ(2)*(c + d*x)**(ZZ(1)/ZZ(3))*sqrt(a + b*x)/(b*d**ZZ(2)) - ZZ(108)/ZZ(935)*ZZ(3)**(ZZ(3)/ZZ(4))*(b*c - a*d)**ZZ(3)*((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)))*elliptic_f(( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + (b*c - a*d)**(ZZ(1)/ZZ(3))*(ZZ(1) + sqrt(ZZ(3))))/( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + (b*c - a*d)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3)))), sqrt( - ZZ(7) + ZZ(4)*sqrt(ZZ(3))))*sqrt(((b*c - a*d)**(ZZ(2)/ZZ(3)) + b**(ZZ(1)/ZZ(3))*(b*c - a*d)**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + b**(ZZ(2)/ZZ(3))*(c + d*x)**(ZZ(2)/ZZ(3)))/( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + (b*c - a*d)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3))))**ZZ(2))*sqrt(ZZ(2) - sqrt(ZZ(3)))/(b**(ZZ(4)/ZZ(3))*d**ZZ(3)*sqrt(a - b*c/d + b*(c + d*x)/d)*sqrt( - (b*c - a*d)**(ZZ(1)/ZZ(3))*((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)))/( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + (b*c - a*d)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3))))**ZZ(2)))],
        #[(a + b*x)**(ZZ(3)/ZZ(2))/(c + d*x)**(ZZ(1)/ZZ(3)), x, ZZ(6), ZZ(6)/ZZ(13)*(a + b*x)**(ZZ(3)/ZZ(2))*(c + d*x)**(ZZ(2)/ZZ(3))/d - ZZ(54)/ZZ(91)*(b*c - a*d)*(c + d*x)**(ZZ(2)/ZZ(3))*sqrt(a + b*x)/d**ZZ(2) - ZZ(162)/ZZ(91)*(b*c - a*d)**ZZ(2)*sqrt(a - b*c/d + b*(c + d*x)/d)/(b**(ZZ(2)/ZZ(3))*d**ZZ(2)*( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + (b*c - a*d)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3))))) - ZZ(54)/ZZ(91)*ZZ(3)**(ZZ(3)/ZZ(4))*(b*c - a*d)**(ZZ(7)/ZZ(3))*((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)))*elliptic_f(( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + (b*c - a*d)**(ZZ(1)/ZZ(3))*(ZZ(1) + sqrt(ZZ(3))))/( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + (b*c - a*d)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3)))), sqrt( - ZZ(7) + ZZ(4)*sqrt(ZZ(3))))*sqrt(ZZ(2))*sqrt(((b*c - a*d)**(ZZ(2)/ZZ(3)) + b**(ZZ(1)/ZZ(3))*(b*c - a*d)**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + b**(ZZ(2)/ZZ(3))*(c + d*x)**(ZZ(2)/ZZ(3)))/( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + (b*c - a*d)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3))))**ZZ(2))/(b**(ZZ(2)/ZZ(3))*d**ZZ(3)*sqrt(a - b*c/d + b*(c + d*x)/d)*sqrt( - (b*c - a*d)**(ZZ(1)/ZZ(3))*((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)))/( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + (b*c - a*d)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3))))**ZZ(2))) + ZZ(81)/ZZ(91)*ZZ(3)**(ZZ(1)/ZZ(4))*(b*c - a*d)**(ZZ(7)/ZZ(3))*((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)))*elliptic_e(( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + (b*c - a*d)**(ZZ(1)/ZZ(3))*(ZZ(1) + sqrt(ZZ(3))))/( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + (b*c - a*d)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3)))), sqrt( - ZZ(7) + ZZ(4)*sqrt(ZZ(3))))*sqrt(((b*c - a*d)**(ZZ(2)/ZZ(3)) + b**(ZZ(1)/ZZ(3))*(b*c - a*d)**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + b**(ZZ(2)/ZZ(3))*(c + d*x)**(ZZ(2)/ZZ(3)))/( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + (b*c - a*d)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3))))**ZZ(2))*sqrt(ZZ(2) + sqrt(ZZ(3)))/(b**(ZZ(2)/ZZ(3))*d**ZZ(3)*sqrt(a - b*c/d + b*(c + d*x)/d)*sqrt( - (b*c - a*d)**(ZZ(1)/ZZ(3))*((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)))/( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + (b*c - a*d)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3))))**ZZ(2)))],
        [(a + b*x)**(ZZ(2)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)), x, ZZ(3), ZZ(1)/ZZ(6)*(b*c - a*d)*(a + b*x)**(ZZ(2)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))/(b*d) + ZZ(1)/ZZ(2)*(a + b*x)**(ZZ(5)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))/b + ZZ(1)/ZZ(18)*(b*c - a*d)**ZZ(2)*log(c + d*x)/(b**(ZZ(4)/ZZ(3))*d**(ZZ(5)/ZZ(3))) + ZZ(1)/ZZ(6)*(b*c - a*d)**ZZ(2)*log( - ZZ(1) + d**(ZZ(1)/ZZ(3))*(a + b*x)**(ZZ(1)/ZZ(3))/(b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))))/(b**(ZZ(4)/ZZ(3))*d**(ZZ(5)/ZZ(3))) + ZZ(1)/ZZ(3)*(b*c - a*d)**ZZ(2)*arctan(ZZ(1)/sqrt(ZZ(3)) + ZZ(2)*d**(ZZ(1)/ZZ(3))*(a + b*x)**(ZZ(1)/ZZ(3))/(b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*sqrt(ZZ(3))))/(b**(ZZ(4)/ZZ(3))*d**(ZZ(5)/ZZ(3))*sqrt(ZZ(3)))],
        [(a + b*x)**(ZZ(4)/ZZ(3))/(c + d*x)**(ZZ(1)/ZZ(3)), x, ZZ(3), - ZZ(2)/ZZ(3)*(b*c - a*d)*(a + b*x)**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(2)/ZZ(3))/d**ZZ(2) + ZZ(1)/ZZ(2)*(a + b*x)**(ZZ(4)/ZZ(3))*(c + d*x)**(ZZ(2)/ZZ(3))/d - ZZ(1)/ZZ(9)*(b*c - a*d)**ZZ(2)*log(a + b*x)/(b**(ZZ(2)/ZZ(3))*d**(ZZ(7)/ZZ(3))) - ZZ(1)/ZZ(3)*(b*c - a*d)**ZZ(2)*log( - ZZ(1) + b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))/(d**(ZZ(1)/ZZ(3))*(a + b*x)**(ZZ(1)/ZZ(3))))/(b**(ZZ(2)/ZZ(3))*d**(ZZ(7)/ZZ(3))) - ZZ(2)/ZZ(3)*(b*c - a*d)**ZZ(2)*arctan(ZZ(1)/sqrt(ZZ(3)) + ZZ(2)*b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))/(d**(ZZ(1)/ZZ(3))*(a + b*x)**(ZZ(1)/ZZ(3))*sqrt(ZZ(3))))/(b**(ZZ(2)/ZZ(3))*d**(ZZ(7)/ZZ(3))*sqrt(ZZ(3)))],
        #[(a + b*x)**(ZZ(5)/ZZ(2))/(c + d*x)**(ZZ(1)/ZZ(4)), x, ZZ(10), - ZZ(40)/ZZ(117)*(b*c - a*d)*(a + b*x)**(ZZ(3)/ZZ(2))*(c + d*x)**(ZZ(3)/ZZ(4))/d**ZZ(2) + ZZ(4)/ZZ(13)*(a + b*x)**(ZZ(5)/ZZ(2))*(c + d*x)**(ZZ(3)/ZZ(4))/d + ZZ(16)/ZZ(39)*(b*c - a*d)**ZZ(2)*(c + d*x)**(ZZ(3)/ZZ(4))*sqrt(a + b*x)/d**ZZ(3) - ZZ(32)/ZZ(39)*(b*c - a*d)**(ZZ(15)/ZZ(4))*elliptic_e(b**(ZZ(1)/ZZ(4))*(c + d*x)**(ZZ(1)/ZZ(4))/(b*c - a*d)**(ZZ(1)/ZZ(4)), I)*sqrt(ZZ(1) - b*(c + d*x)/(b*c - a*d))/(b**(ZZ(3)/ZZ(4))*d**ZZ(4)*sqrt(a - b*c/d + b*(c + d*x)/d)) + ZZ(32)/ZZ(39)*(b*c - a*d)**(ZZ(15)/ZZ(4))*elliptic_e(b**(ZZ(1)/ZZ(4))*(c + d*x)**(ZZ(1)/ZZ(4))/(b*c - a*d)**(ZZ(1)/ZZ(4)), I)*sqrt(ZZ(1) - b*(c + d*x)/(b*c - a*d))/(b**(ZZ(3)/ZZ(4))*d**ZZ(4)*sqrt(a - b*c/d + b*(c + d*x)/d))],
        [(c + d*x)**(ZZ(5)/ZZ(4))/(a + b*x)**(ZZ(25)/ZZ(4)), x, ZZ(4), - ZZ(4)/ZZ(21)*(c + d*x)**(ZZ(9)/ZZ(4))/((b*c - a*d)*(a + b*x)**(ZZ(21)/ZZ(4))) + ZZ(16)/ZZ(119)*d*(c + d*x)**(ZZ(9)/ZZ(4))/((b*c - a*d)**ZZ(2)*(a + b*x)**(ZZ(17)/ZZ(4))) - ZZ(128)/ZZ(1547)*d**ZZ(2)*(c + d*x)**(ZZ(9)/ZZ(4))/((b*c - a*d)**ZZ(3)*(a + b*x)**(ZZ(13)/ZZ(4))) + ZZ(512)/ZZ(13923)*d**ZZ(3)*(c + d*x)**(ZZ(9)/ZZ(4))/((b*c - a*d)**ZZ(4)*(a + b*x)**(ZZ(9)/ZZ(4)))],
        [(a + b*x)**(ZZ(5)/ZZ(4))/(c + d*x)**(ZZ(1)/ZZ(4)), x, ZZ(6), - ZZ(5)/ZZ(8)*(b*c - a*d)*(a + b*x)**(ZZ(1)/ZZ(4))*(c + d*x)**(ZZ(3)/ZZ(4))/d**ZZ(2) + ZZ(1)/ZZ(2)*(a + b*x)**(ZZ(5)/ZZ(4))*(c + d*x)**(ZZ(3)/ZZ(4))/d + ZZ(5)/ZZ(16)*(b*c - a*d)**ZZ(2)*arctan(d**(ZZ(1)/ZZ(4))*(a + b*x)**(ZZ(1)/ZZ(4))/(b**(ZZ(1)/ZZ(4))*(c + d*x)**(ZZ(1)/ZZ(4))))/(b**(ZZ(3)/ZZ(4))*d**(ZZ(9)/ZZ(4))) + ZZ(5)/ZZ(16)*(b*c - a*d)**ZZ(2)*arctanh(d**(ZZ(1)/ZZ(4))*(a + b*x)**(ZZ(1)/ZZ(4))/(b**(ZZ(1)/ZZ(4))*(c + d*x)**(ZZ(1)/ZZ(4))))/(b**(ZZ(3)/ZZ(4))*d**(ZZ(9)/ZZ(4)))],
        [ZZ(1)/((a + b*x)**(ZZ(3)/ZZ(4))*(c + d*x)**(ZZ(1)/ZZ(4))), x, ZZ(4), ZZ(2)*arctan(d**(ZZ(1)/ZZ(4))*(a + b*x)**(ZZ(1)/ZZ(4))/(b**(ZZ(1)/ZZ(4))*(c + d*x)**(ZZ(1)/ZZ(4))))/(b**(ZZ(3)/ZZ(4))*d**(ZZ(1)/ZZ(4))) + ZZ(2)*arctanh(d**(ZZ(1)/ZZ(4))*(a + b*x)**(ZZ(1)/ZZ(4))/(b**(ZZ(1)/ZZ(4))*(c + d*x)**(ZZ(1)/ZZ(4))))/(b**(ZZ(3)/ZZ(4))*d**(ZZ(1)/ZZ(4)))],
        #[(a + b*x)**(ZZ(3)/ZZ(2))/(c + d*x)**(ZZ(1)/ZZ(5)), x, ZZ(2), ZZ(2)/ZZ(5)*(a + b*x)**(ZZ(5)/ZZ(2))*(b*(c + d*x)/(b*c - a*d))**(ZZ(1)/ZZ(5))*hypergeometric([ZZ(1)/ZZ(5), ZZ(5)/ZZ(2)], [ZZ(7)/ZZ(2)], - d*(a + b*x)/(b*c - a*d))/(b*(c + d*x)**(ZZ(1)/ZZ(5)))],
        #[(a + b*x)**(ZZ(5)/ZZ(2))/(c + d*x)**(ZZ(1)/ZZ(6)), x, ZZ(7), - ZZ(9)/ZZ(28)*(b*c - a*d)*(a + b*x)**(ZZ(3)/ZZ(2))*(c + d*x)**(ZZ(5)/ZZ(6))/d**ZZ(2) + ZZ(3)/ZZ(10)*(a + b*x)**(ZZ(5)/ZZ(2))*(c + d*x)**(ZZ(5)/ZZ(6))/d + ZZ(81)/ZZ(224)*(b*c - a*d)**ZZ(2)*(c + d*x)**(ZZ(5)/ZZ(6))*sqrt(a + b*x)/d**ZZ(3) + ZZ(243)/ZZ(448)*(b*c - a*d)**ZZ(3)*(c + d*x)**(ZZ(1)/ZZ(6))*(ZZ(1) + sqrt(ZZ(3)))*sqrt(a - b*c/d + b*(c + d*x)/d)/(b**(ZZ(2)/ZZ(3))*d**ZZ(3)*((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) + sqrt(ZZ(3))))) + ZZ(243)/ZZ(448)*ZZ(3)**(ZZ(1)/ZZ(4))*(b*c - a*d)**(ZZ(10)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(6))*((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)))*sqrt(cos(arccos(((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3))))/((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) + sqrt(ZZ(3))))))**ZZ(2))/cos(arccos(((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3))))/((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) + sqrt(ZZ(3))))))*elliptic_e(sin(arccos(((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3))))/((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) + sqrt(ZZ(3)))))), sqrt(ZZ(1)/ZZ(4)*(ZZ(2) + sqrt(ZZ(3)))))*sqrt(((b*c - a*d)**(ZZ(2)/ZZ(3)) + b**(ZZ(1)/ZZ(3))*(b*c - a*d)**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + b**(ZZ(2)/ZZ(3))*(c + d*x)**(ZZ(2)/ZZ(3)))/((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) + sqrt(ZZ(3))))**ZZ(2))/(b**(ZZ(2)/ZZ(3))*d**ZZ(4)*sqrt(a - b*c/d + b*(c + d*x)/d)*sqrt( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)))/((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) + sqrt(ZZ(3))))**ZZ(2))) + ZZ(81)/ZZ(896)*ZZ(3)**(ZZ(3)/ZZ(4))*(b*c - a*d)**(ZZ(10)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(6))*((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)))*sqrt(cos(arccos(((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3))))/((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) + sqrt(ZZ(3))))))**ZZ(2))/cos(arccos(((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3))))/((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) + sqrt(ZZ(3))))))*elliptic_f(sin(arccos(((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) - sqrt(ZZ(3))))/((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) + sqrt(ZZ(3)))))), sqrt(ZZ(1)/ZZ(4)*(ZZ(2) + sqrt(ZZ(3)))))*(ZZ(1) - sqrt(ZZ(3)))*sqrt(((b*c - a*d)**(ZZ(2)/ZZ(3)) + b**(ZZ(1)/ZZ(3))*(b*c - a*d)**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)) + b**(ZZ(2)/ZZ(3))*(c + d*x)**(ZZ(2)/ZZ(3)))/((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) + sqrt(ZZ(3))))**ZZ(2))/(b**(ZZ(2)/ZZ(3))*d**ZZ(4)*sqrt(a - b*c/d + b*(c + d*x)/d)*sqrt( - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3)))/((b*c - a*d)**(ZZ(1)/ZZ(3)) - b**(ZZ(1)/ZZ(3))*(c + d*x)**(ZZ(1)/ZZ(3))*(ZZ(1) + sqrt(ZZ(3))))**ZZ(2)))],
        #[(a + b*x)**m*(c + d*x)**n, x, ZZ(2), - (a + b*x)**(ZZ(1) + m)*(c + d*x)**(ZZ(1) + n)*hypergeometric([ZZ(1), ZZ(2) + m + n], [ZZ(2) + n], b*(c + d*x)/(b*c - a*d))/((b*c - a*d)*(ZZ(1) + n)), (a + b*x)**(ZZ(1) + m)*(c + d*x)**n*hypergeometric([ZZ(1) + m, - n], [ZZ(2) + m], - d*(a + b*x)/(b*c - a*d))/(b*(ZZ(1) + m)*(b*(c + d*x)/(b*c - a*d))**n)],
    ]

    for i in test:
        rubi_test(i)

def test_numerical():
    test = [
        [(a + b*x)**(ZZ(1)/ZZ(2))*(c + d*x)**(ZZ(1)/ZZ(4)), x, ZZ(5), ZZ(4)/ZZ(7)*(a + b*x)**(ZZ(3)/ZZ(2))*(c + d*x)**(ZZ(1)/ZZ(4))/b + ZZ(4)/ZZ(21)*(b*c - a*d)*(c + d*x)**(ZZ(1)/ZZ(4))*sqrt(a + b*x)/(b*d) - ZZ(8)/ZZ(21)*(b*c - a*d)**(ZZ(9)/ZZ(4))*elliptic_f(b**(ZZ(1)/ZZ(4))*(c + d*x)**(ZZ(1)/ZZ(4))/(b*c - a*d)**(ZZ(1)/ZZ(4)), I)*sqrt(ZZ(1) - b*(c + d*x)/(b*c - a*d))/(b**(ZZ(5)/ZZ(4))*d**ZZ(2)*sqrt(a - b*c/d + b*(c + d*x)/d))],
        [ZZ(1)/((a + b*x)*(a*d/b + d*x)**ZZ(3)), x, ZZ(2), - ZZ(1)/ZZ(3)*b**ZZ(2)/(d**ZZ(3)*(a + b*x)**ZZ(3))],
    ]

    for i in test:
        rubi_test(i)

# from sage.symbolic.function import BuiltinFunction
# from sage.calculus.calculus import maxima
# from sage.structure.coerce import parent
#
# _done = False
# def _init():
#     """
#     Internal function which checks if Maxima has loaded the
#     "orthopoly" package.  All functions using this in this
#     file should call this function first.
#
#     TEST:
#
#     The global starts ``False``::
#
#         sage: sage.functions.maxima_function._done
#         False
#
#     Then after using one of the MaximaFunctions, it changes::
#
#         sage: from sage.functions.special import elliptic_ec
#         sage: elliptic_ec(0.1)
#         1.53075763689776
#
#         sage: sage.functions.maxima_function._done
#         True
#     """
#     global _done
#     if _done:
#         return
#     maxima.eval('load("orthopoly");')
#     maxima.eval('orthopoly_returns_intervals:false;')
#     _done = True
#
#
# class MaximaFunction(BuiltinFunction):
#     """
#     EXAMPLES::
#
#         sage: from sage.functions.maxima_function import MaximaFunction
#         sage: f = MaximaFunction("jacobi_sn")
#         sage: f(1,1)
#         tanh(1)
#         sage: f(1/2,1/2).n()
#         0.470750473655657
#     """
#     def __init__(self, name, nargs=2, conversions={}):
#         """
#         EXAMPLES::
#
#             sage: from sage.functions.maxima_function import MaximaFunction
#             sage: f = MaximaFunction("jacobi_sn")
#             sage: f(1,1)
#             tanh(1)
#             sage: f(1/2,1/2).n()
#             0.470750473655657
#         """
#         c = dict(maxima=name)
#         c.update(conversions)
#         BuiltinFunction.__init__(self, name=name, nargs=nargs,
#                                    conversions=c)
#
#     def _maxima_init_evaled_(self, *args):
#         """
#         Returns a string which represents this function evaluated at
#         *args* in Maxima.
#
#         EXAMPLES::
#
#             sage: from sage.functions.maxima_function import MaximaFunction
#             sage: f = MaximaFunction("jacobi_sn")
#             sage: f._maxima_init_evaled_(1/2, 1/2)
#             'jacobi_sn(1/2, 1/2)'
#
#         TESTS:
#
#         Check if complex numbers in the arguments are converted to maxima
#         correctly (see :trac:`7557`)::
#
#             sage: t = f(1.2+2*I*elliptic_kc(1-.5),.5)
#             sage: t._maxima_init_(maxima)  # abs tol 1e-13
#             '0.88771548861928029 - 1.7301614091485560e-15*%i'
#             sage: t.n() # abs tol 1e-13
#             0.887715488619280 - 1.79195288804672e-15*I
#
#         """
#         args_maxima = []
#         for a in args:
#             if isinstance(a, str):
#                 args_maxima.append(a)
#             elif hasattr(a, '_maxima_init_'):
#                 args_maxima.append(a._maxima_init_())
#             else:
#                 args_maxima.append(str(a))
#         return "%s(%s)"%(self.name(), ', '.join(args_maxima))
#
#     def _evalf_(self, *args, **kwds):
#         """
#         Returns a numerical approximation of this function using
#         Maxima.  Currently, this is limited to 53 bits of precision.
#
#         EXAMPLES::
#
#             sage: from sage.functions.maxima_function import MaximaFunction
#             sage: f = MaximaFunction("jacobi_sn")
#             sage: f(1/2, 1/2)
#             jacobi_sn(1/2, 1/2)
#             sage: f(1/2, 1/2).n()
#             0.470750473655657
#             sage: f(1/2, 1/2).n(20)
#             0.47075
#             sage: f(1, I).n()
#             0.848379519751901 - 0.0742924572771414*I
#
#         TESTS::
#
#             sage: f(1/2, 1/2).n(150)
#             Traceback (most recent call last):
#             ...
#             NotImplementedError: Maxima function jacobi_sn not implemented for Real Field with 150 bits of precision
#             sage: f._evalf_(1/2, 1/2, parent=int)
#             Traceback (most recent call last):
#             ...
#             NotImplementedError: Maxima function jacobi_sn not implemented for <type 'int'>
#             sage: f._evalf_(1/2, 1/2, parent=complex)
#             (0.4707504736556572+0j)
#             sage: f._evalf_(1/2, 1/2, parent=RDF)
#             0.4707504736556572
#             sage: f._evalf_(1, I, parent=CDF)  # abs tol 1e-16
#             0.8483795707591759 - 0.07429247342160791*I
#             sage: f._evalf_(1, I, parent=RR)
#             Traceback (most recent call last):
#             ...
#             TypeError: Unable to convert x (='0.848379570759176-0.0742924734216079*I') to real number.
#         """
#         parent = kwds['parent']
#         # The result from maxima is a machine double, which corresponds
#         # to RDF (or CDF). Therefore, before converting, we check that
#         # we can actually coerce RDF into our parent.
#         if parent is not float and parent is not complex:
#             if not isinstance(parent, Parent) or not parent.has_coerce_map_from(RDF):
#                 raise NotImplementedError("Maxima function %s not implemented for %r"%(self.name(), parent))
#         _init()
#         return parent(maxima("%s, numer"%self._maxima_init_evaled_(*args)))
#
#     def _eval_(self, *args):
#         """
#         Try to evaluate this function at ``*args``, return ``None`` if
#         Maxima did not compute a numerical evaluation.
#
#         EXAMPLES::
#
#             sage: from sage.functions.maxima_function import MaximaFunction
#             sage: f = MaximaFunction("jacobi_sn")
#             sage: f(1,1)
#             tanh(1)
#
#             sage: f._eval_(1,1)
#             tanh(1)
#
#         Since Maxima works only with double precision, numerical
#         results are in ``RDF``, no matter what the input precision is::
#
#             sage: R = RealField(300)
#             sage: r = jacobi_sn(R(1/2), R(1/8)); r # not tested
#             0.4950737320232015
#             sage: parent(r)  # not tested
#             Real Double Field
#         """
#         _init()
#         try:
#             s = maxima(self._maxima_init_evaled_(*args))
#         except TypeError:
#             return None
#
#         if self.name() in s.__repr__():  # Avoid infinite recursion
#             return None
#         else:
#             return s.sage()
#
# from sage.misc.cachefunc import cached_function
#
# @cached_function
# def maxima_function(name):
#     """
#     Returns a function which is evaluated both symbolically and
#     numerically via Maxima.  In particular, it returns an instance
#     of :class:`MaximaFunction`.
#
#     .. note::
#
#        This function is cached so that duplicate copies of the same
#        function are not created.
#
#     EXAMPLES::
#
#         sage: spherical_hankel2(2,i).simplify()
#         -e
#     """
#     # The superclass of MaximaFunction, BuiltinFunction, assumes that there
#     # will be only one symbolic function with the same name and class.
#     # We create a new class for each Maxima function wrapped.
#     class NewMaximaFunction(MaximaFunction):
#         def __init__(self):
#             """
#             Constructs an object that wraps a Maxima function.
#
#             TESTS::
#
#                 sage: spherical_hankel2(2,x).simplify()
#                 (-I*x^2 - 3*x + 3*I)*e^(-I*x)/x^3
#             """
#             MaximaFunction.__init__(self, name)
#
#     return NewMaximaFunction()

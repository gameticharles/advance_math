import '../expression/expression.dart';
import 'differentiation.dart';
import 'integration.dart';
import 'symbolic_calculus.dart';

/// A hybrid calculus class that bridges symbolic and numerical methods.
///
/// This class provides methods to evaluate symbolic expressions using numerical
/// techniques and to compare the results of symbolic and numerical calculations
/// for validation purposes.
class HybridCalculus {
  /// Evaluates the derivative of a symbolic expression numerically.
  ///
  /// This method uses the `NumericalDifferentiation` class to compute the
  /// derivative of the expression at a specific point.
  ///
  /// Parameters:
  /// - [expr]: The symbolic expression to differentiate.
  /// - [variable]: The variable with respect to which the derivative is taken.
  /// - [at]: The point at which to evaluate the derivative.
  ///
  /// Returns: The numerical value of the derivative.
  static num evaluateDerivative(Expression expr, String variable, num at) {
    // Define the function to differentiate
    num f(num x) {
      return expr.evaluate({variable: x});
    }

    // Use numerical differentiation
    return NumericalDifferentiation.derivative(f, at);
  }

  /// Evaluates the integral of a symbolic expression numerically.
  ///
  /// This method uses the `NumericalIntegration` class to compute the
  /// definite integral of the expression over a range.
  ///
  /// Parameters:
  /// - [expr]: The symbolic expression to integrate.
  /// - [variable]: The variable of integration.
  /// - [a]: The lower bound of the integral.
  /// - [b]: The upper bound of the integral.
  ///
  /// Returns: The numerical value of the integral.
  static num evaluateIntegral(Expression expr, String variable, num a, num b) {
    // Define the function to integrate
    num f(num x) {
      return expr.evaluate({variable: x});
    }

    // Use numerical integration (Simpson's rule is generally robust)
    return NumericalIntegration.simpsons(f, a, b);
  }

  /// Compares symbolic and numerical results for validation.
  ///
  /// This method computes the derivative and integral of the expression using
  /// both symbolic and numerical methods and returns a map containing the
  /// results and the difference (error) between them.
  ///
  /// Parameters:
  /// - [expr]: The symbolic expression to analyze.
  /// - [variable]: The variable involved.
  /// - [at]: The point at which to evaluate the derivative.
  /// - [a]: The lower bound for integration (default: 0).
  /// - [b]: The upper bound for integration (default: 1).
  ///
  /// Returns: A map with keys 'derivative' and 'integral', each containing
  /// 'symbolic', 'numerical', and 'error'.
  static Map<String, dynamic> compareResults(
    Expression expr,
    String variable,
    num at, {
    num a = 0,
    num b = 1,
  }) {
    // 1. Derivative Comparison
    // Symbolic
    Expression symbolicDerivExpr =
        SymbolicCalculus.partialDerivative(expr, variable);
    num symbolicDerivVal = symbolicDerivExpr.evaluate({variable: at});

    // Numerical
    num numericalDerivVal = evaluateDerivative(expr, variable, at);

    // 2. Integral Comparison
    // Symbolic (Definite)
    num symbolicIntegralVal =
        SymbolicCalculus.definiteIntegral(expr, variable, a, b);

    // Numerical
    num numericalIntegralVal = evaluateIntegral(expr, variable, a, b);

    return {
      'derivative': {
        'symbolic': symbolicDerivVal,
        'numerical': numericalDerivVal,
        'error': (symbolicDerivVal - numericalDerivVal).abs(),
      },
      'integral': {
        'symbolic': symbolicIntegralVal,
        'numerical': numericalIntegralVal,
        'error': (symbolicIntegralVal - numericalIntegralVal).abs(),
      },
    };
  }
}

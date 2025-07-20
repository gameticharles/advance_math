import 'dart:math';

/// Computes the error function of [x].
///
/// The error function is a mathematical function used in probability, statistics,
/// and partial differential equations. This implementation is based on a numerical approximation.
///
/// For a given input [x], the function computes:
///
/// \[
/// \text{erf}(x) = \frac{2}{\sqrt{\pi}} \int_0^x e^{-t^2} dt
/// \]
///
/// Parameters:
///  - [x]: A double value for which the error function is computed.
///
/// Returns:
///  - A double value representing the error function of [x].
///
/// Example:
/// ```dart
/// var result = erf(0.5);
/// print(result);  // Expected output: ~0.5205
/// ```
double erf(double x) {
  var t = 1 / (1 + 0.5 * x.abs());
  var result = 1 -
      t *
          (exp(-x * x -
              1.26551223 +
              t *
                  (1.00002368 +
                      t *
                          (0.37409196 +
                              t *
                                  (0.09678418 +
                                      t *
                                          (-0.18628806 +
                                              t *
                                                  (0.27886807 +
                                                      t *
                                                          (-1.13520398 +
                                                              t *
                                                                  (1.48851587 +
                                                                      t *
                                                                          (-0.82215223 +
                                                                              t * 0.17087277))))))))));
  return x >= 0 ? result : -result;
}

import 'dart:math';

/// Approximate solution for the error function of [x].
///
/// * Fractional error is less than 1.2e7.
/// * There is no standard erf() available in dart:math.
/// * The approximation is based on Chebyshev fitting.
///
double erf(double x) {
  final z = x.abs();
  final t = 1.0 / (1.0 + 0.5 * z);

  // Approximate the complementary error function
  var erfc = t *
      exp(
        -z * z -
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
                                                                            t * 0.17087277)))))))),
      );

  if (x < 0.0) erfc = 2.0 - erfc;
  return 1.0 - erfc;
}

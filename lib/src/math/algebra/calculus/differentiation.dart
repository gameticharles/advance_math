import '../../basic/math.dart';

/// A class providing various numerical differentiation methods for approximating
/// derivatives of functions.
///
/// This class implements finite difference methods for computing derivatives,
/// including forward, backward, and central differences, as well as higher-order
/// derivatives and multivariate calculus operations.
///
/// Example:
/// ```dart
/// // Differentiate f(x) = x^2 at x = 3
/// double f(double x) => x * x;
///
/// var result = NumericalDifferentiation.derivative(f, 3);
/// print('f\'(3) = $result'); // ~6.0
/// ```
class NumericalDifferentiation {
  /// Computes the first derivative using central difference method.
  ///
  /// The central difference formula provides better accuracy than forward or
  /// backward differences by using function values on both sides of the point.
  ///
  /// Formula: f'(x) ≈ [f(x+h) - f(x-h)] / (2h)
  ///
  /// Parameters:
  /// - [f]: The function to differentiate
  /// - [x]: The point at which to compute the derivative
  /// - [h]: Step size (default: 1e-5)
  ///
  /// Returns: Approximation of the first derivative at x
  ///
  /// Example:
  /// ```dart
  /// double f(double x) => x * x * x;
  /// var result = NumericalDifferentiation.derivative(f, 2.0);
  /// print(result); // ~12.0 (exact: 3*x^2 = 12)
  /// ```
  static num derivative(num Function(num) f, num x, {double h = 1e-5}) {
    return (f(x + h) - f(x - h)) / (2 * h);
  }

  /// Computes the first derivative using forward difference method.
  ///
  /// Forward difference uses the function value ahead of the point.
  /// Less accurate than central difference but useful at boundaries.
  ///
  /// Formula: f'(x) ≈ [f(x+h) - f(x)] / h
  ///
  /// Parameters:
  /// - [f]: The function to differentiate
  /// - [x]: The point at which to compute the derivative
  /// - [h]: Step size (default: 1e-5)
  ///
  /// Returns: Approximation of the first derivative at x
  ///
  /// Example:
  /// ```dart
  /// double f(double x) => math.sin(x);
  /// var result = NumericalDifferentiation.forwardDifference(f, 0);
  /// print(result); // ~1.0 (exact: cos(0) = 1)
  /// ```
  static num forwardDifference(num Function(num) f, num x, {double h = 1e-5}) {
    return (f(x + h) - f(x)) / h;
  }

  /// Computes the first derivative using backward difference method.
  ///
  /// Backward difference uses the function value behind the point.
  /// Less accurate than central difference but useful at boundaries.
  ///
  /// Formula: f'(x) ≈ [f(x) - f(x-h)] / h
  ///
  /// Parameters:
  /// - [f]: The function to differentiate
  /// - [x]: The point at which to compute the derivative
  /// - [h]: Step size (default: 1e-5)
  ///
  /// Returns: Approximation of the first derivative at x
  ///
  /// Example:
  /// ```dart
  /// double f(double x) => math.exp(x);
  /// var result = NumericalDifferentiation.backwardDifference(f, 1);
  /// print(result); // ~2.718 (exact: e^1 = e)
  /// ```
  static num backwardDifference(num Function(num) f, num x, {double h = 1e-5}) {
    return (f(x) - f(x - h)) / h;
  }

  /// Computes the second derivative using central difference method.
  ///
  /// The second derivative measures the rate of change of the first derivative,
  /// indicating concavity.
  ///
  /// Formula: f''(x) ≈ [f(x+h) - 2f(x) + f(x-h)] / h²
  ///
  /// Parameters:
  /// - [f]: The function to differentiate
  /// - [x]: The point at which to compute the second derivative
  /// - [h]: Step size (default: 1e-5)
  ///
  /// Returns: Approximation of the second derivative at x
  ///
  /// Example:
  /// ```dart
  /// double f(double x) => x * x * x;
  /// var result = NumericalDifferentiation.secondDerivative(f, 2);
  /// print(result); // ~12.0 (exact: 6x = 12)
  /// ```
  static num secondDerivative(num Function(num) f, num x, {double h = 1e-5}) {
    return (f(x + h) - 2 * f(x) + f(x - h)) / (h * h);
  }

  /// Computes the nth derivative using recursive application of central differences.
  ///
  /// Higher-order derivatives are computed by recursively applying the
  /// differentiation operator.
  ///
  /// Parameters:
  /// - [f]: The function to differentiate
  /// - [x]: The point at which to compute the derivative
  /// - [n]: Order of the derivative (must be positive)
  /// - [h]: Step size (default: 1e-5)
  ///
  /// Returns: Approximation of the nth derivative at x
  ///
  /// Throws [ArgumentError] if n is not positive
  ///
  /// Example:
  /// ```dart
  /// double f(double x) => x * x * x * x;
  /// var result = NumericalDifferentiation.nthDerivative(f, 1, 4);
  /// print(result); // ~24.0 (exact: 4! = 24)
  /// ```
  static num nthDerivative(num Function(num) f, num x, int n,
      {double h = 1e-5}) {
    if (n <= 0) {
      throw ArgumentError('Order of derivative must be positive');
    }

    if (n == 1) {
      return derivative(f, x, h: h);
    } else if (n == 2) {
      return secondDerivative(f, x, h: h);
    }

    // For n > 2, use recursive finite differences
    // f^(n)(x) ≈ [f^(n-1)(x+h) - f^(n-1)(x-h)] / (2h)
    num derivativeAtPoint(num point) {
      return nthDerivative(f, point, n - 1, h: h);
    }

    return (derivativeAtPoint(x + h) - derivativeAtPoint(x - h)) / (2 * h);
  }

  /// Computes the gradient of a multivariate function.
  ///
  /// The gradient is a vector of partial derivatives, pointing in the direction
  /// of steepest ascent.
  ///
  /// Parameters:
  /// - [f]: Function taking a list of coordinates and returning a scalar
  /// - [x]: Point at which to compute the gradient
  /// - [h]: Step size for finite differences (default: 1e-5)
  ///
  /// Returns: List of partial derivatives [∂f/∂x₁, ∂f/∂x₂, ...]
  ///
  /// Example:
  /// ```dart
  /// // f(x, y) = x² + y²
  /// double f(List<num> coords) {
  ///   double x = coords[0].toDouble();
  ///   double y = coords[1].toDouble();
  ///   return x * x + y * y;
  /// }
  /// var grad = NumericalDifferentiation.gradient(f, [1, 2]);
  /// print(grad); // [2, 4]
  /// ```
  static List<num> gradient(num Function(List<num>) f, List<num> x,
      {double h = 1e-5}) {
    final n = x.length;
    final grad = List<num>.filled(n, 0);

    for (int i = 0; i < n; i++) {
      // Create points x + h*ei and x - h*ei
      final xPlusH = List<num>.from(x);
      final xMinusH = List<num>.from(x);

      xPlusH[i] += h;
      xMinusH[i] -= h;

      // Central difference for partial derivative
      grad[i] = (f(xPlusH) - f(xMinusH)) / (2 * h);
    }

    return grad;
  }

  /// Computes the Jacobian matrix of a vector-valued function.
  ///
  /// The Jacobian is a matrix of all first-order partial derivatives of a
  /// vector-valued function.
  ///
  /// Parameters:
  /// - [functions]: List of functions, each taking a list of coordinates
  /// - [x]: Point at which to compute the Jacobian
  /// - [h]: Step size for finite differences (default: 1e-5)
  ///
  /// Returns: 2D list representing the Jacobian matrix J[i][j] = ∂fᵢ/∂xⱼ
  ///
  /// Example:
  /// ```dart
  /// // Functions: f1(x,y) = x²+y, f2(x,y) = x*y
  /// List<num Function(List<num>)> functions = [
  ///   (coords) => coords[0]*coords[0] + coords[1],
  ///   (coords) => coords[0]*coords[1],
  /// ];
  /// var J = NumericalDifferentiation.jacobian(functions, [2, 3]);
  /// // J = [[4, 1], [3, 2]]
  /// ```
  static List<List<num>> jacobian(
      List<num Function(List<num>)> functions, List<num> x,
      {double h = 1e-5}) {
    final m = functions.length; // Number of functions
    final n = x.length; // Number of variables

    final J = List.generate(m, (_) => List<num>.filled(n, 0));

    for (int i = 0; i < m; i++) {
      // Compute gradient of the i-th function
      final gradI = gradient(functions[i], x, h: h);
      for (int j = 0; j < n; j++) {
        J[i][j] = gradI[j];
      }
    }

    return J;
  }

  /// Computes the Hessian matrix of a scalar function.
  ///
  /// The Hessian is a square matrix of second-order partial derivatives,
  /// describing the local curvature of the function.
  ///
  /// Parameters:
  /// - [f]: Scalar function taking a list of coordinates
  /// - [x]: Point at which to compute the Hessian
  /// - [h]: Step size for finite differences (default: 1e-4)
  ///
  /// Returns: 2D list representing the Hessian matrix H[i][j] = ∂²f/∂xᵢ∂xⱼ
  ///
  /// Example:
  /// ```dart
  /// // f(x, y) = x² + xy + y²
  /// double f(List<num> coords) {
  ///   double x = coords[0].toDouble();
  ///   double y = coords[1].toDouble();
  ///   return x*x + x*y + y*y;
  /// }
  /// var H = NumericalDifferentiation.hessian(f, [1, 1]);
  /// // H = [[2, 1], [1, 2]]
  /// ```
  static List<List<num>> hessian(num Function(List<num>) f, List<num> x,
      {double h = 1e-4}) {
    final n = x.length;
    final H = List.generate(n, (_) => List<num>.filled(n, 0));

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (i == j) {
          // Diagonal elements: ∂²f/∂xᵢ²
          final xPlusH = List<num>.from(x);
          final xMinusH = List<num>.from(x);
          xPlusH[i] += h;
          xMinusH[i] -= h;

          H[i][j] = (f(xPlusH) - 2 * f(x) + f(xMinusH)) / (h * h);
        } else {
          // Off-diagonal elements: ∂²f/∂xᵢ∂xⱼ
          // Using central differences in both directions
          final xPlusBoth = List<num>.from(x);
          final xPlusI = List<num>.from(x);
          final xPlusJ = List<num>.from(x);
          final xMinusBoth = List<num>.from(x);

          xPlusBoth[i] += h;
          xPlusBoth[j] += h;
          xPlusI[i] += h;
          xPlusJ[j] += h;
          xMinusBoth[i] -= h;
          xMinusBoth[j] -= h;

          H[i][j] = (f(xPlusBoth) - f(xPlusI) - f(xPlusJ) + f(x)) / (h * h);
        }
      }
    }

    // Symmetrize the Hessian (it should be symmetric for continuous functions)
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        final avg = (H[i][j] + H[j][i]) / 2;
        H[i][j] = avg;
        H[j][i] = avg;
      }
    }

    return H;
  }

  /// Computes the directional derivative of a function in a given direction.
  ///
  /// The directional derivative measures the rate of change of the function
  /// in a specific direction.
  ///
  /// Formula: D_v f(x) = ∇f(x) · v
  ///
  /// Parameters:
  /// - [f]: Scalar function taking a list of coordinates
  /// - [point]: Point at which to compute the directional derivative
  /// - [direction]: Direction vector (will be normalized)
  /// - [h]: Step size for gradient computation (default: 1e-5)
  ///
  /// Returns: The directional derivative in the given direction
  ///
  /// Example:
  /// ```dart
  /// double f(List<num> coords) {
  ///   double x = coords[0].toDouble();
  ///   double y = coords[1].toDouble();
  ///   return x * x + y * y;
  /// }
  /// var dd = NumericalDifferentiation.directionalDerivative(
  ///   f, [1, 1], [1, 0]  // derivative in x-direction
  /// );
  /// print(dd); // ~2.0
  /// ```
  static num directionalDerivative(
      num Function(List<num>) f, List<num> point, List<num> direction,
      {double h = 1e-5}) {
    if (point.length != direction.length) {
      throw ArgumentError('Point and direction must have the same dimension');
    }

    // Normalize the direction vector
    final magnitude = sqrt(direction.fold<num>(0, (sum, d) => sum + d * d));

    if (magnitude == 0) {
      throw ArgumentError('Direction vector cannot be zero');
    }

    final normalizedDirection = direction.map((d) => d / magnitude).toList();

    // Compute gradient
    final grad = gradient(f, point, h: h);

    // Dot product: ∇f · v
    num dotProduct = 0;
    for (int i = 0; i < grad.length; i++) {
      dotProduct += grad[i] * normalizedDirection[i];
    }

    return dotProduct;
  }

  /// Computes derivatives with multiple step sizes and estimates error.
  ///
  /// Uses Richardson extrapolation to improve accuracy and estimate
  /// the error in the derivative approximation.
  ///
  /// Parameters:
  /// - [f]: The function to differentiate
  /// - [x]: The point at which to compute the derivative
  /// - [h]: Initial step size (default: 1e-3)
  ///
  /// Returns: Map with keys 'value' (best estimate) and 'error' (estimated error)
  ///
  /// Example:
  /// ```dart
  /// double f(double x) => math.sin(x);
  /// var result = NumericalDifferentiation.derivativeWithError(f, math.pi/4);
  /// print('Value: ${result['value']}, Error: ${result['error']}');
  /// ```
  static Map<String, num> derivativeWithError(num Function(num) f, num x,
      {double h = 1e-3}) {
    // Compute derivatives with different step sizes
    final d1 = derivative(f, x, h: h);
    final d2 = derivative(f, x, h: h / 2);

    // Richardson extrapolation
    // error ~ O(h²), so error(h/2) ≈ error(h)/4
    final value = (4 * d2 - d1) / 3;
    final error = ((d2 - d1) / 3).abs();

    return {'value': value, 'error': error};
  }

  /// Computes the Laplacian (divergence of gradient) of a scalar function.
  ///
  /// The Laplacian is the sum of all unmixed second partial derivatives.
  /// It appears frequently in physics (heat equation, wave equation, etc.).
  ///
  /// Formula: ∇²f = ∂²f/∂x₁² + ∂²f/∂x₂² + ... + ∂²f/∂xₙ²
  ///
  /// Parameters:
  /// - [f]: Scalar function taking a list of coordinates
  /// - [x]: Point at which to compute the Laplacian
  /// - [h]: Step size for finite differences (default: 1e-4)
  ///
  /// Returns: The Laplacian at point x
  ///
  /// Example:
  /// ```dart
  /// // f(x, y) = x² + y²
  /// double f(List<num> coords) {
  ///   double x = coords[0].toDouble();
  ///   double y = coords[1].toDouble();
  ///   return x * x + y * y;
  /// }
  /// var laplacian = NumericalDifferentiation.laplacian(f, [1, 1]);
  /// print(laplacian); // ~4.0 (exact: 2 + 2 = 4)
  /// ```
  static num laplacian(num Function(List<num>) f, List<num> x,
      {double h = 1e-4}) {
    final n = x.length;
    num lapl = 0;

    for (int i = 0; i < n; i++) {
      final xPlusH = List<num>.from(x);
      final xMinusH = List<num>.from(x);
      xPlusH[i] += h;
      xMinusH[i] -= h;

      // Second partial derivative with respect to xi
      lapl += (f(xPlusH) - 2 * f(x) + f(xMinusH)) / (h * h);
    }

    return lapl;
  }

  /// Computes the divergence of a vector field.
  ///
  /// The divergence measures the "outgoingness" of a vector field at a point.
  ///
  /// Formula: div F = ∂F₁/∂x₁ + ∂F₂/∂x₂ + ... + ∂Fₙ/∂xₙ
  ///
  /// Parameters:
  /// - [vectorField]: List of component functions
  /// - [x]: Point at which to compute the divergence
  /// - [h]: Step size for finite differences (default: 1e-5)
  ///
  /// Returns: The divergence at point x
  ///
  /// Example:
  /// ```dart
  /// // F(x, y) = (x, y)
  /// List<num Function(List<num>)> F = [
  ///   (coords) => coords[0],
  ///   (coords) => coords[1],
  /// ];
  /// var div = NumericalDifferentiation.divergence(F, [1, 1]);
  /// print(div); // ~2.0 (exact: 1 + 1 = 2)
  /// ```
  static num divergence(List<num Function(List<num>)> vectorField, List<num> x,
      {double h = 1e-5}) {
    final n = vectorField.length;
    if (x.length != n) {
      throw ArgumentError(
          'Vector field dimension must match coordinate dimension');
    }

    num div = 0;

    for (int i = 0; i < n; i++) {
      final xPlusH = List<num>.from(x);
      final xMinusH = List<num>.from(x);
      xPlusH[i] += h;
      xMinusH[i] -= h;

      // ∂Fᵢ/∂xᵢ
      div += (vectorField[i](xPlusH) - vectorField[i](xMinusH)) / (2 * h);
    }

    return div;
  }

  /// Computes the curl of a 3D vector field.
  ///
  /// The curl measures the rotation or circulation of a vector field.
  /// Only defined for 3D vector fields.
  ///
  /// Formula: curl F = (∂F₃/∂y - ∂F₂/∂z, ∂F₁/∂z - ∂F₃/∂x, ∂F₂/∂x - ∂F₁/∂y)
  ///
  /// Parameters:
  /// - [vectorField]: List of 3 component functions [Fx, Fy, Fz]
  /// - [x]: Point [x, y, z] at which to compute the curl
  /// - [h]: Step size for finite differences (default: 1e-5)
  ///
  /// Returns: List [curl_x, curl_y, curl_z]
  ///
  /// Throws [ArgumentError] if vector field is not 3D
  ///
  /// Example:
  /// ```dart
  /// // F(x, y, z) = (y, -x, 0) - rotation around z-axis
  /// List<num Function(List<num>)> F = [
  ///   (coords) => coords[1],
  ///   (coords) => -coords[0],
  ///   (coords) => 0,
  /// ];
  /// var curl = NumericalDifferentiation.curl(F, [1, 0, 0]);
  /// print(curl); // [0, 0, -2]
  /// ```
  static List<num> curl(List<num Function(List<num>)> vectorField, List<num> x,
      {double h = 1e-5}) {
    if (vectorField.length != 3 || x.length != 3) {
      throw ArgumentError('Curl is only defined for 3D vector fields');
    }

    final f1 = vectorField[0];
    final f2 = vectorField[1];
    final f3 = vectorField[2];

    // Compute partial derivatives
    num partialDerivative(num Function(List<num>) f, int varIndex) {
      final xPlus = List<num>.from(x);
      final xMinus = List<num>.from(x);
      xPlus[varIndex] += h;
      xMinus[varIndex] -= h;
      return (f(xPlus) - f(xMinus)) / (2 * h);
    }

    // curl_x = ∂F₃/∂y - ∂F₂/∂z
    final curlX = partialDerivative(f3, 1) - partialDerivative(f2, 2);

    // curl_y = ∂F₁/∂z - ∂F₃/∂x
    final curlY = partialDerivative(f1, 2) - partialDerivative(f3, 0);

    // curl_z = ∂F₂/∂x - ∂F₁/∂y
    final curlZ = partialDerivative(f2, 0) - partialDerivative(f1, 1);

    return [curlX, curlY, curlZ];
  }
}

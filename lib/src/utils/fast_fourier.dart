
/// This class multiplies two polynomials with possibly negative coefficients very efficiently using
/// the Fast Fourier Transform (FFT). NOTE: This code only works for polynomials with coefficients in the
/// range of a signed integer.
///
/// Time Complexity: O(n log n)
///
/// Author: David Brink
class FastFourierTransform {
  // p is a prime number set to be larger than 2^31-1
  static const int p = 4300210177;

  // q is 2^64 mod p used to compute x*y mod p
  // Note: If x*y mod p is negative it is because 2^64
  // has been subtracted and so it must be added again.
  static const int q = 857728777;

  // A number that has order 2^20 modulo p
  static const int zeta = 3273;

  static const int exp = 20;
  static List<int> powers = List<int>.filled((1 << exp) + 1, 0);

  // Static initializer to populate powers array
  static void _initialize() {
    powers[0] = 1;
    for (int i = 1; i < powers.length; i++) {
      powers[i] = _mult(zeta, powers[i - 1]);
    }
  }

  /// Computes the polynomial product modulo p
  ///
  /// [x] and [y] are the arrays representing the coefficients of the polynomials.
  /// Returns an array representing the coefficients of the product polynomial.
  static List<int> multiply(List<int> x, List<int> y) {
    // If the coefficients are negative place them in the range of [0, p)
    for (int i = 0; i < x.length; i++) if (x[i] < 0) x[i] += p;
    for (int i = 0; i < y.length; i++) if (y[i] < 0) y[i] += p;

    int zLength = x.length + y.length - 1;
    int logN = 32 - (zLength - 1).bitLength;
    List<int> xx = _transform(x, logN, false);
    List<int> yy = _transform(y, logN, false);
    List<int> zz = List<int>.filled(1 << logN, 0);
    for (int i = 0; i < zz.length; i++) zz[i] = _mult(xx[i], yy[i]);
    List<int> nZ = _transform(zz, logN, true);
    List<int> z = List<int>.filled(zLength, 0);
    int nInverse = p - ((p - 1) >> logN);
    for (int i = 0; i < z.length; i++) {
      z[i] = _mult(nInverse, nZ[i]);

      // Allow for negative coefficients. If you know the answer cannot be
      // greater than 2^31-1 subtract p to obtain the negative coefficient.
      if (z[i] >= 2147483647) z[i] -= p;
    }
    return z;
  }

  // Multiplies two numbers modulo p
  static int _mult(int x, int y) {
    int z = x * y;
    if (z < 0) {
      z = z % p + q;
      return z < 0 ? z + p : z;
    }
    if (z < (1 << 56) && x > (1 << 28) && y > (1 << 28)) {
      z = z % p + q;
      return z < p ? z : z - p;
    }
    return z % p;
  }

  // Transforms the polynomial using FFT
  static List<int> _transform(List<int> v, int logN, bool inverse) {
    int n = 1 << logN;
    List<int> w = List<int>.filled(n, 0);
    for (int i = 0; i < v.length; i++) {
      w[(_reverseBits(i) >> (32 - logN)) & (n - 1)] = v[i];
    }
    for (int i = 0; i < logN; i++) {
      int jMax = 1 << i;
      int kStep = 2 << i;
      int index = 0;
      int step = 1 << (exp - i - 1);
      if (inverse) {
        index = 1 << exp;
        step = -step;
      }
      for (int j = 0; j < jMax; j++) {
        int zeta = powers[index];
        index += step;
        for (int k = j; k < n; k += kStep) {
          int kk = jMax | k;
          int x = w[k];
          int y = _mult(zeta, w[kk]);
          int z = x + y;
          w[k] = z < p ? z : z - p;
          z = x - y;
          w[kk] = z < 0 ? z + p : z;
        }
      }
    }
    return w;
  }

  // Reverses the bits of an integer
  static int _reverseBits(int n) {
    int result = 0;
    for (int i = 0; i < 32; i++) {
      result = (result << 1) | (n & 1);
      n >>= 1;
    }
    return result;
  }

  /// Example usage
  static void main() {
    _initialize();

    // 1*x^0 + 5*x^1 + 3*x^2 + 2*x^3
    List<int> polynomial1 = [1, 5, 3, 2];

    // 0*x^0 + 0*x^1 + 6*x^2 + 2*x^3 + 5*x^4
    List<int> polynomial2 = [0, 0, 6, 2, 5];

    // Multiply the polynomials using the FFT algorithm
    List<int> result = multiply(polynomial1, polynomial2);

    // Prints [0, 0, 6, 32, 33, 43, 19, 10] or equivalently
    // 6*x^2 + 32*x^3 + 33*x^4 + 43*x^5 + 19*x^6 + 10*x^7
    print(result);
  }
}

void main() {
  FastFourierTransform.main();
}

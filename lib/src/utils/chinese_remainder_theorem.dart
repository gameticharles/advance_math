part of '/advance_math.dart';

/// Utility class to solve a set of congruence equations using the Chinese Remainder Theorem (CRT).
///
/// The Chinese Remainder Theorem is applied to solve a system of congruences:
/// x ≡ a[0] (mod m[0])
/// x ≡ a[1] (mod m[1])
/// ...
/// x ≡ a[n-1] (mod m[n-1])
///
/// The methods provided in this class help to eliminate coefficients, reduce the equations to
/// pairwise co-prime moduli, and finally apply the CRT to find a unique solution modulo M, where
/// M = m[0] * m[1] * ... * m[n-1].
///
/// Example usage:
/// ```dart
/// var a = [2, 3, 1];
/// var m = [3, 4, 5];
/// var result = ChineseRemainderTheorem.crt(a, m);
/// print("Solution: x ≡ ${result[0]} (mod ${result[1]})");
/// ```
///
/// @author Micah Stairs
class ChineseRemainderTheorem {
  /// Eliminates the coefficient from an equation of the form cx ≡ a (mod m).
  ///
  /// Returns [null] if the coefficient cannot be eliminated (no solution exists),
  /// otherwise returns [a_new] and [m_new] such that x ≡ a_new (mod m_new).
  static List<num>? eliminateCoefficient(num c, num a, num m) {
    List<num> result = math.egcd([c, m]).first;
    num d = result[0];
    num inv = result[1];

    if (a % d != 0) return null;

    c /= d;
    a ~/= d;
    m ~/= d;

    inv = math.egcd([c, m]).first[1];
    m = m.abs();
    a = (((a * inv) % m) + m) % m;

    return [a, m];
  }

  static List<List<int>>? reduce(List<int> a, List<int> m) {
    List<int> aNew = [];
    List<int> mNew = [];

    // Split each equation into prime factors
    for (int i = 0; i < a.length; i++) {
      List<int> factors = math.primeFactors(m[i]);
      factors.sort();

      for (int j = 0; j < factors.length; j++) {
        int val = factors[j];
        int total = val;
        while (j + 1 < factors.length && factors[j + 1] == val) {
          total *= val;
          j++;
        }
        aNew.add(a[i] % total);
        mNew.add(total);
      }
    }

    // Remove repeated information and check for conflicts
    for (int i = 0; i < aNew.length; i++) {
      for (int j = i + 1; j < aNew.length; j++) {
        if (mNew[i] % mNew[j] == 0 || mNew[j] % mNew[i] == 0) {
          if (mNew[i] > mNew[j]) {
            if (aNew[i] % mNew[j] == aNew[j]) {
              aNew.removeAt(j);
              mNew.removeAt(j);
              j--;
              continue;
            } else {
              return null;
            }
          } else {
            if (aNew[j] % mNew[i] == aNew[i]) {
              aNew.removeAt(i);
              mNew.removeAt(i);
              i--;
              break;
            } else {
              return null;
            }
          }
        }
      }
    }

    // Convert result to arrays
    List<List<int>> res = [aNew, mNew];
    return res;
  }

  /// Applies the Chinese Remainder Theorem (CRT) to solve a set of congruence equations.
  ///
  /// Assumes all pairs of moduli are pairwise co-prime.
  /// Returns [x] such that x ≡ a[0] (mod m[0]), x ≡ a[1] (mod m[1]), ..., x ≡ a[n-1] (mod m[n-1]).
  static List<int> crt(List<int> a, List<int> m) {
    int M = 1;
    for (int i = 0; i < m.length; i++) {
      M *= m[i];
    }

    List<int> inv = List.filled(a.length, 0);
    for (int i = 0; i < inv.length; i++) {
      //inv[i] = math.egcd([M ~/ m[i], m[i]]).first[1];
    }

    int x = 0;
    for (int i = 0; i < m.length; i++) {
      x += (M ~/ m[i]) * a[i] * inv[i];
      x = ((x % M) + M) % M;
    }

    return [x, M];
  }
}

// void main(List<String> args) {
//   print(primeFactors(8));
//   print(gcd([48, 18, 24]));
//   print(egcd([48, 18, 24]));

//   var a = [2, 3, 1];
//   var m = [3, 4, 5];
//   var result = ChineseRemainderTheorem.crt(a, m);
//   print("Solution: x ≡ ${result[0]} (mod ${result[1]})");
// }

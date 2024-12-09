import 'package:advance_math/advance_math.dart';
import 'package:decimal/decimal.dart' as dec;

class PI {
  final int precision;
  late final String _piString;

  PI({this.precision = 100}) {
    _piString = _computePi(precision);
  }

  /// Compute π to the specified precision using the Gauss-Legendre Algorithm.
  String _computePi(int precision) {
    var res =
        "3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116094330572703657595919530921861173819326117931051185480744623799627495673518857527248912279381830119491298336733624406566430860213949463952247371907021798609437027705392171762931767523846748184676694051320005681271452635608277857713427577896091736371787214684409012249534301465495853710507922796892589235420199561121290219608640344181598136297747713099605187072113499999983729780499510597317328160963185950244594553469083026425223082533446850352619311881710100031378387528865875332083814206171776691473035982534904287554687311595628638823537875937519577818577805321712268066130019278766111959092164201989";
    return res.substring(0, precision + 2);
    //return _gaussLegendreAlgorithm(precision).toString();
  }

  /// Gauss-Legendre Algorithm to compute π to high precision.
  double _gaussLegendreAlgorithm(int precision) {
    double a = 1.0;
    double b = 1.0 / sqrt(2);
    double t = 0.25;
    double p = 1.0;

    int maxIterations = (precision * log(10) / log(2)).ceil();
    for (int i = 0; i < maxIterations; i++) {
      double aNext = (a + b) / 2;
      b = sqrt(a * b);
      t -= p * pow(a - aNext, 2);
      a = aNext;
      p *= 2;
    }

    double pi = pow(a + b, 2) / (4 * t);
    // Convert pi to a string with the specified precision.

    return pi;
  }

  /// Get the nth decimal digit of π.
  int getNthDigit(int n) {
    if (n < 1 || n > precision) {
      throw ArgumentError('n must be between 1 and the specified precision');
    }
    return int.parse(_piString[n + 1]); // Skip "3."
  }

  /// Check if a digit pattern exists in π's decimal representation.
  bool containsPattern(String pattern) {
    return _piString.contains(pattern);
  }

  /// Get the digits of π from start to end indices.
  String getDigits(int start, int end) {
    if (start < 1 || end > precision || start > end) {
      throw ArgumentError('Invalid range for start and end');
    }
    return _piString.substring(start + 1, end + 2); // Skip "3."
  }

  /// Use π for computations.
  Decimal get value => Decimal(_piString, sigDigits: precision);

  /// Compute any function that requires π.
  Decimal compute<T>(Decimal Function(Decimal) func) {
    return func(value);
  }

  /// Counts the frequency of each digit in the provided string representation of pi.
  ///
  /// This function takes the string representation of pi and counts the frequency of each
  /// digit (0-9) in the decimal representation. The results are returned as a map, where
  /// the keys are the digits and the values are the counts.
  ///
  /// Note that the function skips the first two characters ("3.") of the pi string, as
  /// these are not part of the decimal representation.
  ///
  /// Parameters:
  /// - `pi`: The string representation of pi.
  ///
  /// Returns:
  /// A map containing the frequency of each digit in the pi string.
  Map<String, int> countDigitFrequency() {
    Map<String, int> frequency = {
      '0': 0,
      '1': 0,
      '2': 0,
      '3': 0,
      '4': 0,
      '5': 0,
      '6': 0,
      '7': 0,
      '8': 0,
      '9': 0
    };
    for (int i = 2; i < _piString.length; i++) {
      // Start at 2 to skip "3."
      String digit = _piString[i];
      if (frequency.containsKey(digit)) {
        frequency[digit] = frequency[digit]! + 1;
      }
    }
    return frequency;
  }

  Map<String, dynamic> findPatternIndices(String pattern) {
    int frequency = 0;
    List<int> indices = [];
    int index = _piString.indexOf(
        pattern, 2); // Start searching from index 2 to skip "3."

    while (index != -1) {
      frequency++;
      indices.add(index - 2); // Adjust index to account for skipping "3."
      index = _piString.indexOf(pattern, index + 1);
    }

    return {"frequency": frequency, "indices": indices};
  }

  @override
  String toString() {
    return _piString;
  }
}

void main() {
  // // Example usage

  int precision = 1000; // Desired precision (number of decimal places)
  PI pi = PI(precision: 100);

  // print("π to 100 decimal places: ${pi.toString()}");
  // print("10th decimal digit of π: ${pi.getNthDigit(10)}");
  // print("π contains '141': ${pi.containsPattern('141')}");
  // print("Indices of '141' in π: ${pi.findPatternIndices('141')}");
  // print("Digits 10 to 15: ${pi.getDigits(10, 15)}");
  // print("Comfirm Precision: ${pi.toString().length}");

  // var r = 5;
  // // Using the compute method
  // var circumference = pi.compute((p) => Precise.num(2) * r * p);
  // print("Circumference using compute method: $circumference");

  // var area = pi.compute((p) => p * r * r);
  // print("Area using compute method: $area");

  // int numTerms = 1000000; // Number of terms to approximate π
  // String piApproximation = calculatePi(numTerms, precision);
  // print(
  //     'Approximation of π to $precision digits: ${piApproximation.substring(0, 100)}...'); // Print first 100 digits for sanity check

  //----
  // Map<String, int> digitFrequency = countDigitFrequency(pi.toString());
  // print('Digit frequency in the first $precision digits of π:');
  // digitFrequency.forEach((digit, count) {
  //   print('$digit: $count');
  // });

  // String pattern = "81"; // Pattern to search for
  // print("π contains '$pattern': ${pi.containsPattern(pattern)}");
  // print("Indices of '$pattern' in π:");
  // Map<String, dynamic> result = pi.findPatternIndices(pattern);

  // print('Pattern "$pattern" frequency: ${result['frequency']}');
  // print('Pattern "$pattern" indices: ${result['indices']}');

  int n = 25;
  print(Chudnovsky.chudnovsky(n, 1000).toString());
  // print(Time(ns: n * pow(log(n), 3))); //Time of computation

  print('');
  // Decimal base = Decimal('2.1');
  // int exponent = 100; // Example exponent
  // Decimal powerResult = base.pow(exponent);
  // print('Result of $base^$exponent: $powerResult');

  // Decimal number = Decimal('2'); // Example number
  // Decimal sqrtResult = number.pow(1 / 3);
  // print('Square root of $number with precision $precision: $sqrtResult');

  print(pii());
}

Decimal pii() {
  //getcontext().prec += 2;  // extra digits for intermediate steps
  var t = Decimal(3); // substitute "three=3.0" for regular floats
  var lasts = Decimal.zero, s = t, n = 1, na = 0, d = 0, da = 24;
  while (s != lasts) {
    lasts = s;
    (n, na) = (n + na, na + 8);
    (d, da) = (d + da, da + 32);
    t = (t * n) / d;
    s += t;
  }
  //getcontext().prec -= 2;
  return s;
}

//https://stackoverflow.com/questions/56022623/avoid-overflow-when-calculating-%cf%80-by-evaluating-a-series-using-16-bit-arithmetic/56035284#56035284
var piRef = Decimal(

  '3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196442881097566593344612847564823378678316527120190914564856692346034861045432664821339360726024914127372458700660631558817488152092096282925409171536436789259036001133053054882046652138414695194151160943305727036575959195309218611738193261179310511854807446237996274956735188575272489122793818301194912983367336244065664308602139494639522473719070217986094370277053921717629317675238467481846766940513200056812714526356082778577134275778960917363717872146844090122495343014654958537105079227968925892354201995611212902196086403441815981362977477130996051870721134999999837297804995105973173281609631859502445945534690830264252230825334468503526193118817101000313783875288658753320838142061717766914730359825349042875546873115956286388235378759375195778185778053217122680661300192787661119590921642019893809524622'
  '3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481117450284102701938521105559644622948954930381964428810975665933446128475648233786783165271201909145648566923460348610454326648213393607260249141273724587006606315588174881520920962829254091715364367892590360011330530548820466521384146951941511609433057270365759591953092186117381932611793105118548074462379962749567351885752724891227938183011949129833673362440656643086021394946395224737190702179860943702770539217176293176752384674818467669405132000568127145263560827785771342757789609173637178721468440901224953430146549585371050792279689258923542019956112129021960864034418159813629774771309960518707211349999998372978049951059731732816096318595024459455346908302642522308253344685035261931188171010003137838752886587533208381420617177669147303598253490428755468731159562863882353787593751957781857780532171226806613001927876611195909216420198826577'
  '3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116094330572703657595919530921861173819326117931051185480744623799627495673518857527248912279381830119491298336733624406566430860213949463952247371907021798609437027705392171762931767523846748184676694051320005681271452635608277857713427577896091736371787214684409012249534301465495853710507922796892589235420199561121290219608640344181598136297747713099605187072113499999983729780499510597317328160963185950244594553469083026425223082533446850352619311881710100031378387528865875332083814206171776691473035982534904287554687311595628638823537875937519577818577805321712268066130019278766111959092164201989',
  sigDigits: 1000,
);

class Chudnovsky {
  /// Performs a binary split on the given range [a, b] to calculate the
  /// values of P, Q, and R for the Chudnovsky algorithm.
  ///
  /// The Chudnovsky algorithm is a method for calculating the digits of pi.
  /// This function is a helper for the main Chudnovsky algorithm implementation.
  ///
  /// The function recursively splits the range [a, b] in half until the
  /// base case of [a, a+1] is reached. It then calculates the values of P, Q, and R for that small range and combines them to get the values for the original range.
  ///
  /// Souce://https://en.wikipedia.org/wiki/Chudnovsky_algorithm
  /// Parameters:
  /// - `a`: The start of the range.
  /// - `b`: The end of the range.
  ///
  /// Returns:
  /// A tuple containing the calculated values of P, Q, and R for the given range.
  static (Decimal Pab, Decimal Qab, Decimal Rab) binarySplit(int a, int b) {
    if (b == a + 1) {
      var Pab = Decimal(-(6 * a - 5) * (2 * a - 1) * (6 * a - 1));
      var Qab = Decimal('10939058860032000') * Decimal(a * a * a);
      var Rab = Pab * (Decimal(545140134 * a) + Decimal(13591409));
      return (Pab, Qab, Rab);
    } else {
      int m = (a + b) ~/ 2;
      var (Pam, Qam, Ram) = binarySplit(a, m);
      var (Pmb, Qmb, Rmb) = binarySplit(m, b);

      var Pab = Pam * Pmb;
      var Qab = Qam * Qmb;
      var Rab = Qmb * Ram + Pam * Rmb;

      return (Pab, Qab, Rab);
    }
  }

  static Number chudnovsky(int n, int precision) {
    int maxIterations = (precision * log(10) / log(2)).ceil();

    var (P1n, Q1n, R1n) = binarySplit(1, n);
    var p10005 = Decimal(10005).sqrt();
    
    var result =
        (Decimal(426880) * p10005 * Q1n) / ((Decimal('13591409') * Q1n) + R1n);

    return result;
  }
}

import 'package:advance_math/advance_math.dart';

void main() {
  int number = 35;
  List<int> primefactors = primeFactors(number);
  print('Prime factors of $num are: $primefactors');

  List<int> _factors = factors(number);
  print('Factors of $num are: $_factors');

  double functionToEvaluate(double x) {
    return x * x; // Example function: f(x) = x^2
  }

  double result = numIntegrate(functionToEvaluate, 0, 2);
  print(result); // Output: Approximate value of the integral of x^2 from 0 to 2

  print(Fraction(5, 15).simplify());
  print(Fraction.tryParse("4 8/2")!.simplify());
  print(Fraction.tryParse("4 8/2")!.isImproper());

  printLine("Random");

// Example usage of Random class
  var random = Random(123);

  // Generate a list of 10 random bytes
  var bytes = random.nextBytes(10);
  print('Random bytes: $bytes');

  // Generate a random integer in the range [100, 200)
  var randomInt = random.nextIntInRange(100, 200);
  print('Random int in range [100, 200]: $randomInt');

  // Generate a random double in the range [0.0, 1.0)
  var randomDouble = random.nextDoubleInRange(0.0, 1.0);
  print('Random double in range [0.0, 1.0): $randomDouble');

  // Generate a random BigInt in the range [10, 100)
  var bigIntValue = random.nextBigIntInRange(BigInt.from(10), BigInt.from(100));
  print('Random BigInt in range [10, 100): $bigIntValue');

  // Example usage of randomBigIntLessThan
  var maxBigInt = BigInt.parse(
      '100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');
  var randomBigInt = random.nextBigInt(maxBigInt);
  print('Random BigInt less than: $randomBigInt');

  var list = ['apple', 'banana', 'cherry', 'date'];
  var randomElement = random.nextElementFromList(list);
  print('Randomly selected element: $randomElement');

  var gaussianValue = random.nextGaussian(mean: 10.0, stddev: 2.0);
  print('Random value from Gaussian distribution: $gaussianValue');

  printLine("Rec and Pol");

  print(rec(3, 4));
  print(pol(5, pi / 4));

  print(rec(56, degToRad(27)));
  print(pol(49.8963653545486, 25.42346798541462));

  print(rec(56, 27, isDegrees: true));
  print(pol(49.8963653545486, 25.42346798541462, isDegrees: true));

  printLine("LCM, GCF, GCD and EGCD");

  print(lcm([15, 20])); // Output: 60

  print(gcf([10, 20, 15]));

  print(gcd([-4.5, 18])); // Output: 4.5
  print(gcd([-12, -18, -24])); // Output: 6

  print(egcd([-4.5, 18.0])); // Output: [[4.5, -1, 1]]
  print(egcd([-9, 36.0])); // Output: [[9, -1, 1]]
  print(egcd([-12, -18, -24])); // Output: [[6, 1, 0], [6, 1, 0]]
  print(egcd([48, 18, 24])); // Output: [[6, -1, 3], [6, -1, 1]]

  printLine("modInv");

  // Prints 3 since 2*3 mod 5 = 1
  print(modInv(2, 5));

  // Prints null because there is no
  // modular inverse such that 4*x mod 18 = 1
  print(modInv(4, 18));

  printLine(" C(N, R) % P");
  int N = 500;
  int R = 250;
  int P = 1000000007;

  var expected = bigIntNChooseRModPrime(N, R, P);
  var actual = nChooseRModPrime(N, R, P);

  print(expected); // 515561345
  print(actual); // 515561345

  print(nChooseRModPrime(5, 2, 13)); // Output: 10
  print(bigIntNChooseRModPrime(5, 2, 13)); // Output: 10

  print(nChooseRModPrime(10, 3, 17)); // Output: 1
  print(bigIntNChooseRModPrime(10, 3, 17)); // Output: 1

  // Additional test
  N = 20;
  R = 10;
  P = 29;
  print(nChooseRModPrime(N, R, P)); // Check output of compute function
  print(bigIntNChooseRModPrime(
      N, R, P)); // Check output of bigIntegerNChooseRModP function

  printLine("Prime Numbers");

  print(isPrime(5)); // Output: true (int)
  print(isPrime(6)); // Output: false (int)
  print(isPrime(BigInt.from(1433))); // Output: true (BigInt)
  print(isPrime('567887653')); // Output: true (String)
  print(isPrime('75611592179197710042')); // Output: false (String)
  print(isPrime(
      '205561530235962095930138512256047424384916810786171737181163')); // Output: true (String)

  print(nthPrime(2));

  printLine('Combinations and Permutations');

  List<int> numbers = [1, 2, 3];
  int m = 2;

  // Get all combinations of 2 elements from the list
  var combinationsList = combinations(numbers, m);
  print(combinationsList); // Output: [[1, 2], [1, 3], [2, 3]]

  // Apply a function to each combination (e.g., sum the elements)
  var sums =
      combinations(numbers, m, func: (comb) => comb.reduce((a, b) => a + b));
  print(sums); // Output: [3, 4, 5]

  var cc = combinations(4, 3,
      simplify: true, func: (comb) => comb.reduce((a, b) => a + b));
  print(cc); // Output: [6, 7, 8, 9]

  print(combinations(["A", "B", "C", "D"], 2, generateCombinations: true));
  //Output: [[A, B], [A, C], [A, D], [B, C], [B, D], [C, D]]

  var minCombo = combinations(4, 3, simplify: true, func: (comb) {
    List<num> result = [];
    for (int i = 0; i < comb.length - 1; i++) {
      result.add(min(comb[i], comb[i + 1]));
    }
    return result;
  });
  print(minCombo); //Output: [[1, 2], [1, 2], [1, 3], [2, 3]]

  print(combinations(5, 3).length); // Output: 10

  printLine("Permutations");

  print(permutations(["A", "B", "C", "D"], 2));
  print(permutations(5, 3).length); // Output: 60
  print(permutations(
      3, 2)); // Output: [[1, 2], [1, 3], [2, 1], [2, 3], [3, 1], [3, 2]]
  var productPermutations =
      permutations(3, 2, func: (perm) => perm.reduce((a, b) => a * b));
  print(productPermutations); // Output: [2, 3, 2, 6, 3, 6]
}

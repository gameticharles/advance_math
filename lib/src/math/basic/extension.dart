part of maths;

extension MathExtension on num {
  // Example of sum extension method
  int sumUpTo() => this * (this + 1) ~/ 2;

  num absolute() => this.abs();

  dynamic squareRoot() =>
      this >= 0 ? math.sqrt(this) : Complex(0, math.sqrt(-this));

  dynamic cubeRoot() => nthRoot(3);

  dynamic nthRoot(double nth) => this >= 0
      ? math.pow(this, 1 / nth)
      : Complex(0, math.pow(-this, 1 / nth));

  dynamic exponentiation(num exponent) => math.exp(this);

  dynamic power(num exponent) => math.pow(this, exponent);

  // ... more methods here

  // Checks if the number is even
  bool isEven() => this % 2 == 0;

  // Checks if the number is odd
  bool isOdd() => this % 2 != 0;

  // Checks if the number is a perfect square
  bool isPerfectSquare() {
    var x = math.sqrt(this).toInt();
    return x * x == this;
  }

  // Checks if the number is prime
  bool isPrime() {
    if (this <= 1) return false;
    for (int i = 2; i * i <= this; i++) {
      if (this % i == 0) return false;
    }
    return true;
  }

  // ... more methods here

  // Round down to the nearest integer
  int floor() => this.floor();

  // Round up to the nearest integer
  int ceil() => this.ceil();

  // Round to the nearest integer
  int round() => this.round();

  // ... more methods here
}

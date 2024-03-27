part of maths;

extension MathExtension on num {
  // Example of sum extension method
  int sumUpTo() => this * (this + 1) ~/ 2;

  ///The absolute value of this number.
  num absolute() => this.abs();

  /// Square root of the number
  dynamic squareRoot() =>
      this >= 0 ? math.sqrt(this) : Complex(0, math.sqrt(-this));

  /// Cube root of a number
  dynamic cubeRoot() => nthRoot(3);

  /// Compute the nth root of a number
  dynamic nthRoot(double nth) => this >= 0
      ? math.pow(this, 1 / nth)
      : Complex(0, math.pow(-this, 1 / nth));

  /// Exponent of a number
  dynamic exponentiation(num exponent) => math.exp(this);

  /// Get the power of a number
  dynamic power(num exponent) => math.pow(this, exponent);

  // ... more methods here

  /// Checks if the number is even
  bool isEven() => this % 2 == 0;

  /// Checks if the number is odd
  bool isOdd() => this % 2 != 0;

  /// Checks if the number is a perfect square
  bool isPerfectSquare() {
    var x = math.sqrt(this).toInt();
    return x * x == this;
  }

  /// Checks if the number is prime
  bool isPrime() {
    if (this <= 1) return false;
    for (int i = 2; i * i <= this; i++) {
      if (this % i == 0) return false;
    }
    return true;
  }

  // ... more methods here

  /// Round down to the nearest integer
  int floor() => this.floor();

  /// Round up to the nearest integer
  int ceil() => this.ceil();

  /// Round to the nearest integer
  int round() => this.round();

  // ... more methods here
}

extension IterableExt<E> on Iterable<E> {
  /// Extends [Iterable] with the ability to intersperse an element of type [T] between each element.
  ///
  /// This extension adds the `insertBetween` method to any `Iterable` object,
  /// allowing for the insertion of a separator of type [T] between each of the iterable's elements.
  ///
  /// The separator is inserted after each element except the last,
  /// ensuring that the iterable's original order is preserved with the
  /// separator neatly placed in between.
  ///
  /// The method is generic, allowing the separator to be of a different type from the elements
  /// in the iterable. This is particularly useful when the elements are of a basic type (like `int`),
  /// and the separator is of a different type (like `String`).
  ///
  /// Example Usage:
  /// ```dart
  /// final numbers = [1, 2, 3];
  /// final withComma = numbers.insertBetween<String>(',').toList();
  /// print(withComma); // Output: ['1', ',', '2', ',', '3']
  /// ```
  ///
  /// In a Flutter context, it can be used to intersperse widgets, such as:
  /// ```dart
  /// Column(
  ///   children: <Widget>[
  ///     FloatingActionButton(onPressed: () {}, tooltip: 'Increment', child: const Icon(Icons.add)),
  ///     FloatingActionButton(onPressed: () {}, tooltip: 'Increment', child: const Icon(Icons.add)),
  ///   ].insertBetween<Widget>(const SizedBox(height: 5.0)).toList(),
  /// )
  /// ```
  ///
  /// [E] - The type of elements in the iterable.
  ///
  /// [T] - The type of the separator to be inserted.
  Iterable<T> insertBetween<T>(T separator) sync* {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return; // Exit if the iterable is empty

    while (true) {
      yield iterator.current as T; // Cast each element to type T
      if (!iterator.moveNext()) break; // Stop if no more elements
      yield separator;
    }
  }
}

class InvalidRomanNumeralException implements Exception {
  final String message;
  InvalidRomanNumeralException(this.message);
  @override
  String toString() => "InvalidRomanNumeralException: $message";
}

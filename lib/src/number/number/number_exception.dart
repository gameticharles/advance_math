/// The base class for all exceptions thrown in relation to numbers.
class NumberException implements Exception {
  /// Constructs a NumberException with an optional message
  const NumberException([this.message = '']);

  /// The optional message to display.
  final String message;

  @override
  String toString() => 'NumberException: $message';
}

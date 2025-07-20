/// The base class for all exceptions thrown in relation to quantities.
class QuantityException implements Exception {
  /// Constructs a QuantityException with an optional message
  const QuantityException([this.message = '']);

  /// The optional message to display.
  final String message;

  @override
  String toString() => 'QuantityException: $message';
}

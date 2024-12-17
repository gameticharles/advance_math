import 'quantity_exception.dart';

/// This Exception is thrown when an attempt is made to perform an
/// operation on a Quantity having unexpected or illegal dimensions.
class DimensionsException extends QuantityException {
  /// Constructs a DimensionsException with an optional message.
  DimensionsException([super.str]);
}

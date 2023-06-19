import 'quantity.dart';
import 'quantity_exception.dart';

/// This Exception is thrown when an attempt is made to modify an
/// immutable Quantity object (for example through its setMKS method).
class ImmutableQuantityException extends QuantityException {
  ///  Constructs a ImmutableQuantityException with an optional message (str).
  ImmutableQuantityException(
      {String str = 'An attempt was made to modify an immutable quantity:  ', required Quantity q})
      : super('$str $q');
}

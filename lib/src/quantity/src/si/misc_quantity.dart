import '../../../number/number/number.dart';
import 'dimensions.dart';
import 'dimensions_exception.dart';
import 'quantity.dart';
import 'types/scalar.dart';
import 'units.dart';

/// A MiscQuantity is a general (miscellaneous) Quantity having arbitrary dimensions (including
/// possibly the same dimensions as a named Quantity subclass).  MiscQuantity
/// objects may be used, for example, in less common domains or as intermediate
/// results in equations.
///
/// ## Construction
/// MiscQuantity objects are harder to construct than other subclasses of
/// Quantity.  Both the SI-MKS value and the Dimensions must be provided at
/// object creation.  Other subclasses allow construction with any appropriate
/// Units (and its implicit conversion factor to SI-MKS) and automatically
/// initialize the Dimensions.
class MiscQuantity extends Quantity {
  /// This constructor sets the [value], [dim]ensions and relative
  /// uncertainty.
  /// [value] may be a num or Number object.
  MiscQuantity(
      [super.value,
      Dimensions super.dim = Scalar.scalarDimensions,
      super.uncert])
      : super.misc();

  /// Constructs a constant MiscQuantity.
  const MiscQuantity.constant(Number valueSI, Dimensions dim,
      {Units? units, double uncert = 0.0})
      : super.constant(valueSI, dim, units, uncert);

  ///  Gets this quantity's value in [units].
  ///
  /// * The Dimensions of the specified units are checked for validity.
  ///   This method throws a DimensionsException (a RuntimeException) if the
  ///   units' Dimensions are not equal to this MiscQuantity object's Dimensions.
  /// * The value is returned in double precision even if the quantity's
  ///   value is stored internally in arbitrary precision.
  Number getValue(Units units) {
    if (dimensions != (units as Quantity).dimensions) {
      throw DimensionsException(
          'The units provided do not have proper dimensions for this Quantity.');
    }
    return super.valueInUnits(units);
  }

  /// Attempts to construct a typed quantity from this miscellaneous quantity.
  Quantity toTypedQuantity() =>
      dimensions.toQuantity(valueSI, null, relativeUncertainty);
}

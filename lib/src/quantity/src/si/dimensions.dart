import '../../quantity_si.dart' show createTypedQuantityInstance, logger;
import '../../src/si/dimensions_exception.dart';
import '../../src/si/misc_quantity.dart';
import '../../src/si/quantity.dart';
import '../../src/si/types/absorbed_dose_rate.dart';
import '../../src/si/types/acceleration.dart';
import '../../src/si/types/amount_of_substance.dart';
import '../../src/si/types/angle.dart';
import '../../src/si/types/angular_acceleration.dart';
import '../../src/si/types/angular_momentum.dart';
import '../../src/si/types/angular_speed.dart';
import '../../src/si/types/area.dart';
import '../../src/si/types/capacitance.dart';
import '../../src/si/types/catalytic_activity.dart';
import '../../src/si/types/charge.dart';
import '../../src/si/types/charge_density.dart';
import '../../src/si/types/concentration.dart';
import '../../src/si/types/conductance.dart';
import '../../src/si/types/current.dart';
import '../../src/si/types/current_density.dart';
import '../../src/si/types/dynamic_viscosity.dart';
import '../../src/si/types/electric_field_strength.dart';
import '../../src/si/types/electric_flux_density.dart';
import '../../src/si/types/electric_potential_difference.dart';
import '../../src/si/types/energy.dart';
import '../../src/si/types/entropy.dart';
import '../../src/si/types/exposure.dart';
import '../../src/si/types/force.dart';
import '../../src/si/types/frequency.dart';
import '../../src/si/types/heat_flux_density.dart';
import '../../src/si/types/illuminance.dart';
import '../../src/si/types/inductance.dart';
import '../../src/si/types/kinematic_viscosity.dart';
import '../../src/si/types/length.dart';
import '../../src/si/types/luminance.dart';
import '../../src/si/types/luminous_flux.dart';
import '../../src/si/types/luminous_intensity.dart';
import '../../src/si/types/magnetic_field_strength.dart';
import '../../src/si/types/magnetic_flux.dart';
import '../../src/si/types/magnetic_flux_density.dart';
import '../../src/si/types/mass.dart';
import '../../src/si/types/mass_density.dart';
import '../../src/si/types/mass_flow_rate.dart';
import '../../src/si/types/mass_flux_density.dart';
import '../../src/si/types/molar_energy.dart';
import '../../src/si/types/molar_entropy.dart';
import '../../src/si/types/permeability.dart';
import '../../src/si/types/permittivity.dart';
import '../../src/si/types/power.dart';
import '../../src/si/types/pressure.dart';
import '../../src/si/types/radiance.dart';
import '../../src/si/types/radiant_intensity.dart';
import '../../src/si/types/resistance.dart';
import '../../src/si/types/scalar.dart';
import '../../src/si/types/solid_angle.dart';
import '../../src/si/types/specific_energy.dart';
import '../../src/si/types/specific_heat_capacity.dart';
import '../../src/si/types/specific_volume.dart';
import '../../src/si/types/spectral_irradiance.dart';
import '../../src/si/types/speed.dart';
import '../../src/si/types/surface_tension.dart';
import '../../src/si/types/temperature_interval.dart';
import '../../src/si/types/thermal_conductivity.dart';
import '../../src/si/types/time.dart';
import '../../src/si/types/torque.dart';
import '../../src/si/types/volume.dart';
import '../../src/si/types/volume_flow_rate.dart';
import '../../src/si/types/wave_number.dart';
import '../../src/si/units.dart';

/// The Dimensions class represents the dimensions of a physical quantity.
///
/// ## The Seven Base Quantities
/// In the International System of Units (SI) all quantities are considered
/// to be either one of the seven base quantities (Length, Mass, Time Interval,
/// Temperature, Current, Intensity and Amount of Substance) or derived from
/// those base quantities through combinations and/or arbitrary exponents.
/// The Dimensions of a quantity capture which combination applies for that
/// particular quantity.  Any combination of these base quantities is possible;
/// in practice less than 100 derived quantities are in common use.
/// The Dimensions of a quantity determine its type and directly relate to that
/// quantity's significance and meaning in the real world.
///
/// ## The Dimensions Class Also Tracks Angle and Solid Angle
/// The dimensions that are tracked include the seven base SI quantities and
/// also the angle and solid angle dimensionless quantities.  Angular
/// quantities are often distinguished from their non-angular counterparts
/// even if the SI base dimensions are equal.  Consequently, in order
/// to support such differentiation, Angle and SolidAngle dimensions are stored
/// alongside the base seven dimensions and used to distinguish between
/// dimensions and determine quantity types.  To test whether two Dimensions
/// objects are equal strictly in terms of the base SI dimensions, the
/// equalsSI method may be used.
class Dimensions {
  /// No-arg constructor sets all dimensions to zero (that is, a scalar quantity).
  Dimensions()
      : _dimensionMap = <String, num>{},
        qType = Scalar;

  /// Constructs a constant Dimensions object with a map of base dimension keys to exponents
  const Dimensions.constant(Map<String, num> dims, {this.qType})
      : _dimensionMap = dims;

  /// Constructs a Dimensions object with a map of base dimension keys to base dimension exponents.
  Dimensions.fromMap(Map<String, num> typeValuePairs)
      : _dimensionMap = Map<String, num>.from(typeValuePairs),
        qType = null;

  /// Creates a Dimensions object by copying an existing Dimensions object.
  ///
  /// This is a deep copy that clones the internal _dimensionMap HashMap
  /// object (which in turn contains only immutable objects of classes String and num).
  ///
  /// Any type hint is preserved by default but can be cleared by setting `includeTypeHint` to false.
  Dimensions.copy(Dimensions d2, {bool includeTypeHint = true})
      : _dimensionMap = Map<String, num>.from(d2._dimensionMap),
        qType = includeTypeHint ? d2.qType : null;

  /// The dimensions (base dimension key -> base dimension exponent)
  final Map<String, num> _dimensionMap;

  // DIMENSION COMPONENTS

  // ==basic SI dimensions==

  /// Identifier for Base SI Quantity: Length
  static const String baseLengthKey = 'Length';

  /// Identifier for Base SI Quantity: Mass
  static const String baseMassKey = 'Mass';

  /// Identifier for Base SI Quantity: Time Interval
  static const String baseTimeKey = 'Time';

  /// Identifier for Base SI Quantity: Temperature
  static const String baseTemperatureKey = 'Temperature';

  /// Identifier for Base SI Quantity: Current
  static const String baseCurrentKey = 'Current';

  /// Identifier for Base SI Quantity: (Luminous) Intensity
  static const String baseIntensityKey = 'Intensity';

  /// Identifier for Base SI Quantity: Amount of Substance
  static const String baseAmountKey = 'Amount';

  // ==special derived==

  /// Identifier for Special Derived Dimensionless SI Quantity: Angle
  static const String baseAngleKey = 'Angle';

  /// Identifier for Special Derived Dimensionless SI Quantity: Solid Angle
  static const String baseSolidAngleKey = 'Solid Angle';

  /// Optional associated Quantity type
  final Type? qType;

  /// Tests the equality of this Dimensions object and another Dimensions object.
  /// Two Dimensions objects are only equal if they have exactly equal
  /// values for each component dimension.
  @override
  bool operator ==(dynamic d2) {
    if (d2 is Dimensions) {
      if (identical(this, d2)) return true;

      // Check size
      if (_dimensionMap.keys.length != d2._dimensionMap.keys.length) {
        return false;
      }

      // Check Values
      for (final key in _dimensionMap.keys) {
        if (!d2._dimensionMap.containsKey(key) ||
            (_dimensionMap[key] != d2._dimensionMap[key])) return false;
      }

      return true;
    }
    return false;
  }

  /// Returns a hash code consistent with [operator ==] by constructing a
  /// string key based on the dimension component values.
  @override
  int get hashCode {
    if (_dimensionMap.isEmpty) return 0;

    // Construct a unique string key and take its hashcode
    final buffer = (StringBuffer())
      ..write('L${getComponentExponent(Dimensions.baseLengthKey)}')
      ..write('M${getComponentExponent(Dimensions.baseMassKey)}')
      ..write('T${getComponentExponent(Dimensions.baseTimeKey)}')
      ..write('C${getComponentExponent(Dimensions.baseCurrentKey)}')
      ..write('I${getComponentExponent(Dimensions.baseIntensityKey)}')
      ..write('TP${getComponentExponent(Dimensions.baseTemperatureKey)}')
      ..write('AM${getComponentExponent(Dimensions.baseAmountKey)}')
      ..write('A${getComponentExponent(Dimensions.baseAngleKey)}')
      ..write('S${getComponentExponent(Dimensions.baseSolidAngleKey)}');

    return buffer.toString().hashCode;
  }

  /// Tests the equality of this Dimensions object and [d2],
  /// only considering the seven base SI quantities (that is, angle and solid
  /// angle components are ignored).
  ///
  /// Two Dimensions objects are only equal if they have exactly equal
  /// exponents for each base component dimension.
  bool equalsSI(Dimensions? d2) {
    if (d2 == null) return false;
    if (d2 == this) return true;

    if (_dimensionMap[baseLengthKey] != d2._dimensionMap[baseLengthKey]) {
      return false;
    }
    if (_dimensionMap[baseMassKey] != d2._dimensionMap[baseMassKey]) {
      return false;
    }
    if (_dimensionMap[baseTemperatureKey] !=
        d2._dimensionMap[baseTemperatureKey]) return false;
    if (_dimensionMap[baseTimeKey] != d2._dimensionMap[baseTimeKey]) {
      return false;
    }
    if (_dimensionMap[baseAmountKey] != d2._dimensionMap[baseAmountKey]) {
      return false;
    }
    if (_dimensionMap[baseCurrentKey] != d2._dimensionMap[baseCurrentKey]) {
      return false;
    }
    if (_dimensionMap[baseIntensityKey] != d2._dimensionMap[baseIntensityKey]) {
      return false;
    }

    return true;
  }

  /// Whether or not these are scalar dimensions, including having no angle or
  /// solid angle dimensions.
  ///
  /// Use `isScalarSI` to see if these Dimensions are scalar in the strict
  /// International System of Units (SI) sense, which allows non-zero angular and
  /// solid angular dimensions.
  bool get isScalar => _dimensionMap.isEmpty;

  /// Whether or not these are scalar dimensions, in the strict
  /// International System of Units (SI) sense, which allows non-zero angle and
  /// solid angle dimensions.
  ///
  /// Use `isScalarSI` to see if these Dimensions are scalar in the strict
  /// International System of Units sense, which allows non-zero angular and
  /// solid angular dimensions.
  bool get isScalarSI {
    if (getComponentExponent(Dimensions.baseLengthKey) != 0) return false;
    if (getComponentExponent(Dimensions.baseMassKey) != 0) return false;
    if (getComponentExponent(Dimensions.baseTimeKey) != 0) return false;
    if (getComponentExponent(Dimensions.baseTemperatureKey) != 0) return false;
    if (getComponentExponent(Dimensions.baseAmountKey) != 0) return false;
    if (getComponentExponent(Dimensions.baseCurrentKey) != 0) return false;
    if (getComponentExponent(Dimensions.baseIntensityKey) != 0) return false;
    return true;
  }

  /// Gets the exponent value for the specified base dimension [component] key.
  num getComponentExponent(String component) => _dimensionMap[component] ?? 0;

  /// Returns the product of this Dimensions object and [other] Dimensions.
  ///
  /// Dimension multiplication (as occurs when two physical quantities are
  /// multiplied) is accomplished by adding component exponents.  For example,
  /// a time (time +1) multiplied by a frequency (time -1) yields a scalar
  /// (1 + (-1) = 0).
  Dimensions operator *(Dimensions other) {
    // Return self if other is Scalar.
    if (other._dimensionMap.isNotEmpty != true) return this;

    // Copy.  Clear the type hint.
    final result = Dimensions.copy(this, includeTypeHint: false);

    // Add other's dimensions to my dimensions.
    num otherValue = 0;
    num myValue = 0;
    num newValue = 0;
    for (final key in other._dimensionMap.keys) {
      otherValue = other._dimensionMap[key] as num;
      myValue =
          _dimensionMap.containsKey(key) ? result._dimensionMap[key] as num : 0;
      newValue = otherValue + myValue;

      if (newValue != 0.0) {
        result._dimensionMap[key] = newValue;
      } else {
        result._dimensionMap.remove(key); // remove 0's
      }
    }

    return result;
  }

  /// Divides this Dimension by [other] Dimensions, creating a Dimensions
  /// object.
  ///
  /// Dimension division (as occurs when two quantities are
  /// divided) is accomplished by subtracting the component dimensions of the
  /// divisor (bottom).  For example, a volume (length: +3) divided by a length
  /// (length: +1) yields an area (length: +2) or (3 - (+1) = 2).
  Dimensions operator /(Dimensions other) {
    // Return self if other is Scalar.
    if (other._dimensionMap.isEmpty) return this;

    // Copy.  Clear the type hint.
    final result = Dimensions.copy(this, includeTypeHint: false);

    // Add other's dimensions to my dimensions
    num otherValue = 0;
    num? myValue = 0;
    num newValue = 0;
    for (final key in other._dimensionMap.keys) {
      otherValue = other._dimensionMap[key] as num;
      myValue = _dimensionMap.containsKey(key) ? result._dimensionMap[key] : 0;
      if (myValue == null) {
        result._dimensionMap[key] = otherValue * -1;
      } else {
        newValue = myValue - otherValue;
        if (newValue != 0.0) {
          result._dimensionMap[key] = newValue;
        } else {
          result._dimensionMap.remove(key); // remove 0's
        }
      }
    }

    return result;
  }

  /// Determines the inverse of the dimensions represented by this object,
  /// creating a Dimension object.  This object is not modified.
  ///
  /// Dimension inversion occurs when a Quantity is divided into 1 and is
  /// accomplished by simply negating the sign of each dimension component.
  /// For example the inverse of frequency dimensions (time: -1) is duration
  /// (time: +1).
  Dimensions inverse() {
    final invertedMap = <String, num>{};
    for (final t in _dimensionMap.keys) {
      final value = _dimensionMap[t];
      if (value != null) invertedMap[t] = value * -1;
    }

    return Dimensions.fromMap(invertedMap);
  }

  /// Calculates these Dimensions raised to the power specified by [exp]onent
  ///
  /// Each base dimension component exponent is multiplied by [exp] to achieve
  /// the desired result.
  Dimensions operator ^(num exp) {
    if (exp == 0) return Dimensions();
    if (exp == 1) return this;

    // Make a copy of this Object.  Clear the type hint.
    final result = Dimensions.copy(this, includeTypeHint: false);

    final keysToRemove = <String>[];
    num value;
    for (final k in result._dimensionMap.keys) {
      value = result._dimensionMap[k] as num;
      if (value != 0) {
        result._dimensionMap[k] = value * exp;
      } else {
        keysToRemove.add(k);
      }
    }

    // Remove 0's
    keysToRemove.forEach(result._dimensionMap.remove);

    return result;
  }

  /// Determines the Quantity type associated with the specified dimensions.
  ///
  /// * If no specific Quantity type is found that matches the dimensions
  ///   the MiscQuantity class will be returned.
  /// * The appropriate Quantity subclass is determined by a priori knowledge
  ///   of all the Quantity types included in this library.  Therefore, if new
  ///   Quantity subclasses are added outside of this library the Dimensions
  ///   class will not automatically be aware of them, which will affect this
  ///   method.  Therefore, if Quantity subclasses are added, this method should
  ///   be modified to include the subclasses.
  /// * Some distinct Quantity types have identical dimensions.  In this case
  ///   the first Quantity type discovered is returned.
  static Type determineQuantityType(Dimensions? dim) {
    if (dim == null) return MiscQuantity;

    // Get the number of dimension components
    final numDims = dim._dimensionMap.length;

    // Check Scalar first for all 0's case
    if (numDims == 0) return Scalar;

    // Check for more components exist in any named Quantity
    if (numDims > 5) return MiscQuantity;

    // Bin Possibilities By Length Dimension and number of components
    final lengthExp = dim.getComponentExponent(Dimensions.baseLengthKey);
    if (lengthExp is! int) {
      return MiscQuantity; // non-integer exponents means MiscQuantity
    }

    if (lengthExp == -3) {
      if (numDims == 1) {
        return Volume;
      } else if (numDims == 2) {
        if (dim == MassDensity.massDensityDimensions) return MassDensity;
        if (dim == Concentration.concentrationDimensions) return Concentration;
      } else if (numDims == 3) {
        if (dim == ChargeDensity.electricChargeDensityDimensions) {
          return ChargeDensity;
        }
      } else if (numDims == 4) {
        if (dim == Permittivity.permittivityDimensions) return Permittivity;
      }
    } else if (lengthExp == -2) {
      if (numDims == 2) {
        if (dim == CurrentDensity.electricCurrentDensityDimensions) {
          return CurrentDensity;
        }
        if (dim == Luminance.luminanceDimensions) return Luminance;
      } else if (numDims == 3) {
        if (dim == ElectricFluxDensity.electricFluxDensityDimensions) {
          return ElectricFluxDensity;
        }
        if (dim == Illuminance.illuminanceDimensions) return Illuminance;
        if (dim == MassFluxDensity.massFluxDensityDimensions) {
          return MassFluxDensity;
        }
      } else if (numDims == 4) {
        if (dim == Capacitance.electricCapacitanceDimensions) {
          return Capacitance;
        }
        if (dim == Conductance.electricConductanceDimensions) {
          return Conductance;
        }
      }
    } else if (lengthExp == -1) {
      if (numDims == 1) {
        return WaveNumber;
      } else if (numDims == 2) {
        if (dim == MagneticFieldStrength.magneticFieldStrengthDimensions) {
          return MagneticFieldStrength;
        }
      } else if (numDims == 3) {
        if (dim == Pressure.pressureDimensions) return Pressure;
        if (dim == DynamicViscosity.dynamicViscosityDimensions) {
          return DynamicViscosity;
        }
      }
    } else if (lengthExp == 0) {
      if (numDims == 1) {
        if (dim == Mass.massDimensions) return Mass;
        if (dim == Time.timeDimensions) return Time;
        if (dim == Current.electricCurrentDimensions) return Current;
        if (dim == TemperatureInterval.temperatureIntervalDimensions) {
          return TemperatureInterval;
        }
        if (dim == AmountOfSubstance.amountOfSubstanceDimensions) {
          return AmountOfSubstance;
        }
        if (dim == LuminousIntensity.luminousIntensityDimensions) {
          return LuminousIntensity;
        }
        if (dim == Angle.angleDimensions) return Angle;
        if (dim == SolidAngle.solidAngleDimensions) return SolidAngle;

        if (dim == Frequency.frequencyDimensions) return Frequency;
      } else if (numDims == 2) {
        if (dim == Charge.electricChargeDimensions) return Charge;
        if (dim == LuminousFlux.luminousFluxDimensions) return LuminousFlux;
        if (dim == SurfaceTension.surfaceTensionDimensions) {
          return SurfaceTension;
        }
        if (dim == AngularSpeed.angularSpeedDimensions) return AngularSpeed;
        if (dim == AngularAcceleration.angularAccelerationDimensions) {
          return AngularAcceleration;
        }
        if (dim == HeatFluxDensity.heatFluxDensityDimensions) {
          return HeatFluxDensity;
        }
        if (dim == CatalyticActivity.catalyticActivityDimensions) {
          return CatalyticActivity;
        }
        if (dim == MassFlowRate.massFlowRateDimensions) return MassFlowRate;
        if (dim == SpectralIrradiance.spectralIrradianceDimensions) {
          return SpectralIrradiance;
        }
      } else if (numDims == 3) {
        if (dim == MagneticFluxDensity.magneticFluxDensityDimensions) {
          return MagneticFluxDensity;
        }
        if (dim == Exposure.exposureDimensions) return Exposure;
        if (dim == Radiance.radianceDimensions) return Radiance;
      }
    } else if (lengthExp == 1) {
      if (numDims == 1) {
        return Length;
      } else if (numDims == 2) {
        if (dim == Speed.speedDimensions) return Speed;
        if (dim == Acceleration.accelerationDimensions) return Acceleration;
      } else if (numDims == 3) {
        if (dim == Force.forceDimensions) return Force;
        if (dim == AngularMomentum.angularMometumDimensions) {
          return AngularMomentum;
        }
      } else if (numDims == 4) {
        if (dim == ThermalConductivity.thermalConductivityDimensions) {
          return ThermalConductivity;
        }
        if (dim == ElectricFieldStrength.electricFieldStrengthDimensions) {
          return ElectricFieldStrength;
        }
        if (dim == Permeability.permeabilityDimensions) return Permeability;
      }
    } else if (lengthExp == 2) {
      if (numDims == 1) {
        return Area;
      } else if (numDims == 2) {
        if (dim == SpecificEnergy.specificEnergyDimensions) {
          return SpecificEnergy;
        }
        if (dim == AbsorbedDoseRate.absorbedDoseRateDimensions) {
          return AbsorbedDoseRate;
        }
        if (dim == KinematicViscosity.kinematicViscosityDimensions) {
          return KinematicViscosity;
        }
      } else if (numDims == 3) {
        if (dim == Energy.energyDimensions) return Energy;
        if (dim == Power.powerDimensions) return Power;
        if (dim == SpecificHeatCapacity.specificHeatCapacityDimensions) {
          return SpecificHeatCapacity; // or specific entropy
        }
      } else if (numDims == 4) {
        if (dim ==
            ElectricPotentialDifference.electricPotentialDifferenceDimensions) {
          return ElectricPotentialDifference;
        }
        if (dim == Resistance.electricResistanceDimensions) return Resistance;
        if (dim == MagneticFlux.magneticFluxDimensions) return MagneticFlux;
        if (dim == Inductance.inductanceDimensions) return Inductance;
        if (dim == Entropy.entropyDimensions) {
          return Entropy; // also heat capacity
        }
        if (dim == MolarEnergy.molarEnergyDimensions) return MolarEnergy;
        if (dim == RadiantIntensity.radiantIntensityDimensions) {
          return RadiantIntensity;
        }
        if (dim == Torque.torqueDimensions) return Torque;
      } else if (numDims == 5) {
        if (dim == MolarEntropy.molarEntropyDimensions) {
          return MolarEntropy; // also molar heat capacity
        }
      }
    } else if (lengthExp == 3) {
      if (numDims == 1) {
        return Volume;
      } else if (numDims == 2) {
        if (dim == SpecificVolume.specificVolumeDimensions) {
          return SpecificVolume;
        }
        if (dim == VolumeFlowRate.volumeFlowRateDimensions) {
          return VolumeFlowRate;
        }
      }
    } else {
      return MiscQuantity;
    }

    // Couldn't find any... return MiscQuantity
    return MiscQuantity;
  }

  /// Returns a instance of the Quantity type associated with these dimensions.
  /// If no specific Quantity type is found with dimensions that match these dimensions
  /// a instance of the [MiscQuantity] class will be returned.
  /// If no [value] is provided, it defaults to zero.
  /// If no [units] are provided, then MKS units are assumed.
  /// If no uncertainty is provided, the value is presumed to be exact.
  Quantity toQuantity(
      [dynamic value = 0.0, Units? units, double uncert = 0.0]) {
    // Check that the units match the dimensions, if provided.
    if (units is Quantity && (units as Quantity).dimensions != this) {
      throw DimensionsException(
          'The dimensions of the provided units must equal the dimensions');
    }
    try {
      final type = qType ?? determineQuantityType(this);
      print(type);
      if (type is! MiscQuantity) {
        final Quantity q =
            createTypedQuantityInstance(type, value, units, uncert: uncert);
        return q;
      }
    } catch (e, s) {
      logger.warning(
          'Problem creating type instance; falling back to MiscQuantity for $this',
          e,
          s);
    }

    // Unable to create a typed instance; return a MiscQuantity with these dimensions.
    return MiscQuantity(units?.toMks(value) ?? value, this, uncert);
  }

  /// Returns a String representation of this Dimensions object in the form:
  ///
  ///     'Dimensions [<type>=<value>; <type2>=<value2> ... ]'
  @override
  String toString() {
    final buffer = (StringBuffer())..write(' Dimensions [');
    var first = true;
    for (final t in _dimensionMap.keys) {
      if (!first) {
        buffer.write('; ');
      } else {
        first = false;
      }
      buffer.write('$t=${_dimensionMap[t]}');
    }

    buffer.write(']');
    return buffer.toString();
  }
}

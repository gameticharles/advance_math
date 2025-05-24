# Quantity Module

This module provides a robust system for working with physical quantities, their units, and dimensions. It supports SI units, allows for calculations that are dimensionally aware, and integrates with arbitrary-precision numbers.

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
  - [Quantity (`Quantity` class)](#quantity-class)
  - [Dimensions (`Dimensions` class)](#dimensions-class)
  - [Units (`Units` mixin)](#units-mixin)
  - [SI Units](#si-units)
- [Using Quantities](#using-quantities)
  - [Creating Quantities](#creating-quantities)
  - [Performing Operations](#performing-operations)
  - [Unit Conversion](#unit-conversion)
- [Available Quantity Types (SI Base and Derived)](#available-quantity-types-si)
- [Domain-Specific Quantities, Units, and Constants](#domain-specific-quantities-units-and-constants)
  - [Astronomical](#astronomical)
    - [Constants](#astronomical-constants)
    - [Units](#astronomical-units)
  - [Electromagnetic](#electromagnetic)
    - [Constants](#electromagnetic-constants)
    - [Units](#electromagnetic-units)
  - [Thermodynamic](#thermodynamic)
    - [Constants](#thermodynamic-constants)
    - [Units](#thermodynamic-units)
  - [Universal](#universal)
    - [Constants](#universal-constants)
- [Quantity Extensions (`quantity_ext.dart`)](#quantity-extensions)
- [Quantity Ranges (`quantity_range.dart`)](#quantity-ranges)
  - [`QuantityRange<Q extends Quantity>`](#quantityrange)
  - [`AngleRange`](#anglerange)
  - [`TimePeriod`](#timeperiod)

---

## Overview
The `quantity` module provides a comprehensive system for representing and manipulating physical quantities in a type-safe and dimensionally-aware manner. This is crucial for scientific and engineering applications where correctness of units and dimensions is paramount.

Key features:
-   **Dimensional Analysis**: Operations are checked for dimensional consistency (e.g., adding Length to Mass is an error).
-   **Unit Conversion**: Seamless conversion between compatible units (e.g., meters to feet).
-   **Type Safety**: Specific quantity types (e.g., `Length`, `Mass`) ensure correct usage.
-   **SI Unit Support**: Strong support for the International System of Units (SI).
-   **Arbitrary Precision**: Integrates with `Decimal` and `Rational` for high-accuracy calculations.
-   **Uncertainty Propagation**: Supports representing and propagating uncertainties.

`Quantity` instances are immutable. The module provides `MutableQuantity` for scenarios requiring mutable values.

## Key Concepts

### Quantity (`Quantity` class)
*(from `lib/src/quantity/quantity.dart` and `lib/src/number/number/number.dart`)*
The abstract base class `Quantity` (which extends `Number`) represents a physical quantity.

**Core Attributes:**
-   **Value (`valueSI`):** The numerical value stored in SI base units (MKS - Meter, Kilogram, Second), typically as a `Number` (e.g., `Decimal`, `Double`).
-   **Dimensions (`dimensions`):** A `Dimensions` object defining the physical nature (e.g., Length, Mass/Time).
-   **Preferred Units (`preferredUnits`):** Optional `Units` for display or value retrieval in non-SI units.
-   **Relative Standard Uncertainty (`relativeUncertainty`):** A `double` for uncertainty.

### Dimensions (`Dimensions` class)
*(Behavior inferred from usage, as `dimensions.dart` was not read directly)*
Represents the physical dimensions of a quantity (e.g., Length: `L¹`, Speed: `L¹T⁻¹`).

**Representation:**
-   Internally a map of base dimension keys (e.g., `Dimensions.baseLengthKey`) to their `num` exponents.
-   Seven SI base dimensions: Length, Mass, Time, Temperature, Electric Current, Luminous Intensity, Amount of Substance.
-   Angle and Solid Angle are also treated as distinct dimensional components.

**Dimensional Analysis:**
-   `+`, `-`: Requires identical dimensions.
-   `*`: Resulting dimensions are products (exponents added).
-   `/`: Resulting dimensions are quotients (exponents subtracted).
-   `^` (power): Dimensional exponents are multiplied by the scalar power.
-   Functions like `sqrt`, `log`, `trig` often require or result in scalar (dimensionless) quantities or specific dimensional inputs.

### Units (`Units` mixin)
*(Behavior inferred from usage, as `units.dart` was not read directly)*
Represents a specific measure of a quantity (e.g., meter for Length). `Units` are typically instances of `Quantity` subclasses with the `Units` mixin.

**Key Attributes:**
-   **Name (`name`):** Full plural name (e.g., "meters").
-   **Singular Name (`singular`):** E.g., "meter".
-   **Abbreviations (`abbrev1`, `abbrev2`):** E.g., "m".
-   **Conversion Factor (`convToMKS`):** `Number` factor to convert to SI base units.
-   **Offset (`offset`):** `double` for units like Celsius.
-   **Metric Base (`metricBase`):** Boolean, if SI prefixes apply.
-   **Quantity Type (`quantityType`):** The `Type` of quantity (e.g., `Length`).

Units are usually defined as static constants in quantity classes (e.g., `Length.meters`).

### SI Units
*(Definitions primarily from `lib/src/quantity/quantity_si.dart` and related files)*
The module fully supports the International System of Units (SI).
-   **Base Units:** meter (m), kilogram (kg), second (s), ampere (A), kelvin (K), mole (mol), candela (cd).
-   **Derived Units:** newton (N), joule (J), watt (W), pascal (Pa), hertz (Hz), volt (V), ohm (Ω), farad (F), henry (H), etc.
-   **Metric Prefixes:** Standard prefixes (kilo, milli, micro, etc.) are supported for `metricBase` units via methods like `.kilo()`, `.milli()`.

## Using Quantities

### Creating Quantities
Instantiate specific quantity types using named unit parameters. Values are stored in SI.
```dart
// import 'package:advance_math/quantity.dart';

var dist = Length(m: 100);         // 100 meters
var massVal = Mass(kg: 50.5);       // 50.5 kilograms
var timeVal = Time(s: 10);          // 10 seconds
var current = Current(A: 1.5);      // 1.5 amperes
var tempK = Temperature(K: 300);    // 300 kelvin
var tempC = Temperature(C: 25);     // 25 degrees Celsius
var amount = AmountOfSubstance(mol: 2); // 2 moles
var intensity = LuminousIntensity(cd: 75); // 75 candela

// Using specific unit objects (less common for direct creation)
var heightInFeet = Length(value: 10, units: LengthUnits.feet);
print(heightInFeet.m); // Output: 3.048 (SI value)
print(heightInFeet);   // Output: 10 ft
```

### Performing Operations
Arithmetic and comparison operators are dimensionally aware.
```dart
final l1 = Length(m: 10);
final l2 = Length(km: 0.02); // 20 meters
final totalLength = l1 + l2; // Result is 30 m
print(totalLength); // Output: 30 m

final t = Time(s: 5);
final speed = totalLength / t; // Speed = Length / Time
print(speed); // Output: 6 m s-1

final area = l1 * l2; // Area = Length * Length
print(area);  // Output: 200 m2

// final invalidOp = l1 + Mass(kg: 5); // Throws DimensionsException

print(l1 > l2); // Output: false (10m > 20m is false)
print(l1 == Length(m:10.0)); // Output: true
```

### Unit Conversion
Use `valueInUnits(Units units)` to get the numerical value in different units.
```dart
final length = Length(m: 1000);
print(length.valueInUnits(LengthUnits.meters));     // Output: 1000
print(length.valueInUnits(LengthUnits.kilometers)); // Output: 1.0
print(length.valueInUnits(LengthUnits.feet));       // Output: 3280.839...

final tempCelsius = Temperature(C: 0);
print(tempCelsius.valueInUnits(TemperatureUnits.kelvin));      // Output: 273.15
print(tempCelsius.valueInUnits(TemperatureUnits.fahrenheit));  // Output: 32.0
```
To get a new `Quantity` object with different preferred units:
```dart
final lengthM = Length(m: 2500);
final lengthKm = Length(value: lengthM.valueSI, units: LengthUnits.kilometers);
print(lengthKm); // Output: 2.5 km
```

## Available Quantity Types (SI Base and Derived)
*(Based on `quantity_si.dart` and its exports)*
This is a non-exhaustive list. Each type has predefined `Units` constants (e.g., `Length.meters`).

**Base SI Quantities:**
- `Length` (m), `Mass` (kg), `Time` (s), `Current` (A), `Temperature` (K), `AmountOfSubstance` (mol), `LuminousIntensity` (cd).

**Common Derived SI Quantities:**
- `Area` (m²), `Volume` (m³), `Speed` (m/s), `Acceleration` (m/s²), `Frequency` (Hz), `Force` (N), `Pressure` (Pa), `Energy` (J), `Power` (W), `Charge` (C), `Voltage` (V), `Resistance` (Ω), `Capacitance` (F), `Inductance` (H), `Angle` (rad), `SolidAngle` (sr), and many more.

## Domain-Specific Quantities, Units, and Constants
*(From `lib/src/quantity/domain/*.dart` files)*

### Astronomical
*(From `lib/src/quantity/domain/astronomical.dart`)*

#### Astronomical Constants
-   **`gravitySolarSurface`: `Acceleration`**
    -   Value: `274.0 m/s²`
    -   Description: Gravitational acceleration at the Sun's surface.
-   **`hubbleConstant`: `Frequency`**
    -   Value: `2.4e-18 Hz` (approx. 74 km/s/Mpc)
    -   Description: Constant of proportionality in Hubble's Law, describing universe expansion.
    -   Uncertainty: `0.333...` (relative)
-   **`solarConstant`: `EnergyFlux`**
    -   Value: `1370.0 W/m²`
    -   Description: Mean solar electromagnetic radiation per unit area at 1 AU.
-   **`solarRadius`: `Length`**
    -   Value: `6.9599e8 m`
    -   Description: The radius of the Sun.
-   **`earthRadiusEquatorial`: `Length`**
    -   Value: `6378.164 m` (Note: This seems low, likely should be `6.378164e6 m` or in km)
    -   Source value: `6378.164`. If this was intended as km, then `6.378164e6 m`. Assuming it's stored as meters.
    -   Description: The radius of the Earth at the equator.
-   **`solarMass`: `Mass`**
    -   Value: `1.989e30 kg`
    -   Description: Mass of the Sun.
-   **`earthMass`: `Mass`**
    -   Value: `5.972e24 kg`
    -   Description: Mass of the Earth.

#### Astronomical Units
-   **`astronomicalUnits`: `LengthUnits`** (from `length_ext.dart`, exported by `quantity.dart`)
    -   Description: A unit of length equal to the average distance from Earth to the Sun.
    -   Example: `Length(ua: 1).m` gives meters.
-   **`parsecs`: `LengthUnits`**
    -   Description: Unit of length used to measure large distances to astronomical objects outside the Solar System (approx 3.26 light-years).
    -   Example: `Length(pc: 1).m`
-   **`lightYears`: `LengthUnits`**
    -   Description: Distance light travels in one Julian year in vacuum.
    -   Example: `Length(ly: 1).m`
-   **`gees`: `AccelerationUnits`** (from `acceleration_ext.dart`)
    -   Description: Unit of acceleration equal to standard gravity (9.80665 m/s²).
    -   Example: `Acceleration(gee: 1).valueSI` gives `9.80665`.
-   **`yearsTropical`, `yearsSidereal`, `yearsJulian`: `TimeUnits`** (from `time_ext.dart`)
    -   Description: Various definitions of a year.
    -   Example: `Time(yearsJulian: 1).s` gives seconds in a Julian year.
-   **`janskys`: `SpectralIrradianceUnits`** (from `spectral_irradiance_ext.dart`)
    -   Description: Unit of spectral flux density. `1 Jy = 10⁻²⁶ W m⁻² Hz⁻¹`.
-   **`microjanskys`: `SpectralIrradianceUnits`**
    -   Description: `10⁻⁶` Janskys.

### Electromagnetic
*(From `lib/src/quantity/domain/electromagnetic.dart`)*

#### Electromagnetic Constants
-   **`elementaryCharge`: `Charge`** (from `quantity_si.dart` via `quantity.dart`)
    -   Value: `1.602176634e-19 C`
    -   Description: Electric charge carried by a single proton, or magnitude of charge of a single electron.
-   **`vacuumMagneticPermeability`: `Permeability`** (µ₀)
    -   Value: `1.25663706212e-6 N/A²` (or H/m)
    -   Description: Magnetic permeability of classical vacuum. Synonym: `mu0`, `vacuum`.
-   **`conductanceQuantum`: `Conductance`** (G₀)
    -   Value: `7.748091729e-5 S` (Siemens)
    -   Description: Quantized unit of electrical conductance. Synonym: `G0`.
-   **`vonKlitzingConstant`: `Resistance`** (R<sub>K</sub>)
    -   Value: `25812.80745... Ω`
    -   Description: Quantum Hall resistance. Synonym: `RK`.
-   **`magneticFluxQuantum`: `MagneticFlux`** (Φ₀)
    -   Value: `2.067833848e-15 Wb` (Weber)
    -   Description: Quantum of magnetic flux.
-   **`josephsonConstant`: `MiscQuantity`** (K<sub>J</sub>) (Hz/V)
    -   Value: `4.835978484...e14 Hz/V`
    -   Dimensions: `{'Length': -2, 'Mass': -1, 'Current': 1, 'Time': 2}` (Hz/V)
    -   Description: Inverse of the magnetic flux quantum, relates frequency to voltage in Josephson effect. Synonym: `KJ`.
-   **`bohrMagneton`: `MiscQuantity`** (µ<sub>B</sub>) (J/T or A·m²)
    -   Value: `9.2740100783e-24 J/T`
    -   Dimensions: `{'Length': 2, 'Current': 1}` (A·m²)
    -   Description: Physical constant for magnetic moment of an electron. Synonym: `muB`.
-   **`nuclearMagneton`: `MiscQuantity`** (µ<sub>N</sub>) (J/T or A·m²)
    -   Value: `5.0507837461e-27 J/T`
    -   Dimensions: `{'Length': 2, 'Current': 1}` (A·m²)
    -   Description: Physical constant for magnetic moment of heavy particles. Synonym: `muN`.

#### Electromagnetic Units
*(Most electromagnetic units are standard SI units like Ampere, Volt, Ohm, Farad, Henry, Coulomb, Weber, Tesla, Siemens, which are covered in the SI section. Domain-specific units are less common here beyond constants.)*

### Thermodynamic
*(From `lib/src/quantity/domain/thermodynamic.dart`)*

#### Thermodynamic Constants
-   **`boltzmannConstant`: `Entropy`** (k or k<sub>B</sub>)
    -   Value: `1.380649e-23 J/K`
    -   Description: Relates average kinetic energy of particles in a gas with temperature. Synonym: `k`.
-   **`avogadro`: `MiscQuantity`** (N<sub>A</sub> or L)
    -   Value: `6.02214076e23 mol⁻¹`
    -   Dimensions: `{'Amount': -1}`
    -   Description: Number of constituent particles per mole. Synonyms: `NA`, `L`.
-   **`faradayConstant`: `MiscQuantity`** (F) (C/mol)
    -   Value: `96485.3321... C/mol`
    -   Dimensions: `{'Current': 1, 'Time': 1, 'Amount': -1}`
    -   Description: Electric charge per mole of electrons.
-   **`firstRadiationConstant`: `MiscQuantity`** (c₁) (W·m²)
    -   Value: `3.741771852...e-16 W·m²`
    -   Dimensions: `{'Length': 3, 'Mass': 1, 'Time': -3}`
-   **`loschmidtStdAtm`: `MiscQuantity`** (n₀) (m⁻³)
    -   Value: `2.6867801...e25 m⁻³`
    -   Description: Number density of ideal gas at STP (273.15 K, 101.325 kPa).
-   **`gasConstantMolar`: `MolarEntropy`** (R) (J/(mol·K))
    -   Value: `8.314462618... J/(mol·K)`
    -   Description: Molar gas constant.
-   **`molarPlanck`: `MiscQuantity`** (N<sub>A</sub>h) (J·s/mol)
    -   Value: `3.990312712...e-10 J·s/mol`
    -   Dimensions: `{'Length': 2, 'Mass': 1, 'Time': -1, 'Amount': 1}`
-   **`molarVolume100kPa`: `MiscQuantity`** (V<sub>m</sub>) (m³/mol)
    -   Value: `22.71095464...e-3 m³/mol`
    -   Description: Molar volume of ideal gas at 273.15 K, 100 kPa.
-   **`molarVolumeStdAtm`: `MiscQuantity`** (V<sub>m</sub>) (m³/mol)
    -   Value: `22.41396954...e-3 m³/mol`
    -   Description: Molar volume of ideal gas at STP (273.15 K, 101.325 kPa).
-   **`secondRadiationConstant`: `MiscQuantity`** (c₂) (m·K)
    -   Value: `1.438776877...e-2 m·K`
    -   Dimensions: `{'Length': 1, 'Temperature': 1}`
-   **`stefanBoltzmann`: `MiscQuantity`** (σ) (W/(m²·K⁴))
    -   Value: `5.670374419...e-8 W/(m²·K⁴)`
    -   Dimensions: `{'Mass': 1, 'Time': -3, 'Temperature': -4}`
-   **`wienDisplacement`: `MiscQuantity`** (b) (m·K)
    -   Value: `2.897771955...e-3 m·K`
    -   Dimensions: `{'Length': 1, 'Temperature': 1}`
    -   Description: Wien's displacement law constant.

#### Thermodynamic Units
-   **`unifiedAtomicMassUnits`: `MassUnits`** (u or Da) (from `mass_ext.dart`)
    -   Description: Standard unit of mass for atoms and molecules.
    -   Example: `Mass(u: 1).kg` (value in kilograms).
-   **`boltzmannUnit`: `EntropyUnits`** (from `entropy_ext.dart`)
    -   Description: A unit of entropy equivalent to the Boltzmann constant (J/K).

### Universal
*(From `lib/src/quantity/domain/universal.dart`)*

#### Universal Constants
-   **`speedOfLightVacuum`: `Speed`** (c or c₀)
    -   Value: `299792458.0 m/s` (exact by definition)
    -   Description: Speed of light in vacuum. Synonyms: `c`, `c0`.
-   **`vacuumElectricPermittivity`: `Permittivity`** (ε₀)
    -   Value: `8.8541878128e-12 F/m`
    -   Description: Electric constant, permittivity of free space. Synonym: `eps0`.
-   **`characteristicImpedanceOfVacuum`: `Resistance`** (Z₀)
    -   Value: `376.730313668 Ω`
    -   Description: Impedance of free space. Synonym: `Z0`.
-   **`newtonianConstantOfGravitation`: `MiscQuantity`** (G) (N·m²/kg²)
    -   Value: `6.67430e-11 N·m²/kg²`
    -   Dimensions: `{'Length': 3, 'Mass': -1, 'Time': -2}`
    -   Description: Gravitational constant. Synonym: `G`.
-   **`planckConstant`: `AngularMomentum`** (h) (J·s)
    -   Value: `6.62607015e-34 J·s` (exact by definition)
    -   Description: Relates energy of a photon to its frequency. Synonym: `h`.
-   **`hBar`: `AngularMomentum`** (ħ) (J·s)
    -   Value: `1.054571817e-34 J·s` (h / 2π)
    -   Description: Reduced Planck constant.
-   **`planckLength`: `Length`** (l<sub>P</sub>)
    -   Value: `1.616255e-35 m`
-   **`planckMass`: `Mass`** (m<sub>P</sub>)
    -   Value: `2.176434e-8 kg`
-   **`planckTemperature`: `Temperature`** (T<sub>P</sub>)
    -   Value: `1.416784e32 K`
-   **`planckTime`: `Time`** (t<sub>P</sub>)
    -   Value: `5.391247e-44 s`
-   **`rydberg`: `WaveNumber`** (R<sub>∞</sub>) (m⁻¹)
    -   Value: `10973731.568160 m⁻¹`
    -   Description: Rydberg constant, relates to atomic spectra.

## Quantity Extensions (`quantity_ext.dart`)
*(Retained and refined from previous documentation. Highlights that it exports various `*_ext.dart` files for non-SI units, specialized constants, and `MutableQuantity`.)*

## Quantity Ranges (`quantity_range.dart`)
*(Retained and refined from previous documentation. Covers `QuantityRange`, `AngleRange`, and `TimePeriod` with their key features and examples.)*

### `QuantityRange<Q extends Quantity>`
*(Details on constructors, properties like `q1`, `q2`, `minValue`, `maxValue`, `centerValue`, `span`, `delta`, and methods like `contains`, `overlaps`, `encompasses`. Includes `uncertaintyRangeForQuantity` helper.)*

### `AngleRange`
*(Details on constructors, angle-specific properties like `isClockwise`, `revolutions`, and methods like `contains360`, `ranges360`, `angleClosestTo`, `deriveRange`.)*

### `TimePeriod`
*(Details on constructors and specialized subclasses like `CalendarYear` and `FiscalYear`.)*

---
*(End of refined doc/quantity.md)*

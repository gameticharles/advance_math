# Quantity & Units Module

Physical quantities with SI units, automatic dimension checking, and unit conversions.

---

## Table of Contents

1. [Overview](#overview)
2. [SI Base Quantities](#si-base-quantities)
3. [Derived Quantities](#derived-quantities)
4. [Creating Quantities](#creating-quantities)
5. [Unit Conversions](#unit-conversions)
6. [Quantity Arithmetic](#quantity-arithmetic)
7. [Available Quantity Types](#available-quantity-types)

---

## Overview

The quantity system provides type-safe physical quantities with automatic dimension checking. Operations between incompatible units raise exceptions.

```dart
import 'package:advance_math/advance_math.dart';

// Create a length
var distance = Length(m: 100);  // 100 meters

// Create a time
var time = Time(s: 10);  // 10 seconds

// Calculate speed (Length / Time = Speed)
var speed = distance / time;  // Speed quantity

// Unit conversion
print(distance.valueInUnits(Length.kilometers));  // 0.1 km
```

---

## SI Base Quantities

The seven SI base quantities:

| Quantity            | Class               | SI Unit  | Symbol |
| ------------------- | ------------------- | -------- | ------ |
| Length              | `Length`            | meter    | m      |
| Mass                | `Mass`              | kilogram | kg     |
| Time                | `Time`              | second   | s      |
| Electric Current    | `Current`           | ampere   | A      |
| Temperature         | `Temperature`       | kelvin   | K      |
| Amount of Substance | `AmountOfSubstance` | mole     | mol    |
| Luminous Intensity  | `LuminousIntensity` | candela  | cd     |

### Length

```dart
// Various constructors
var l1 = Length(m: 100);      // 100 meters
var l2 = Length(km: 1.5);     // 1.5 kilometers
var l3 = Length(cm: 250);     // 250 centimeters
var l4 = Length(mm: 1000);    // 1000 millimeters
var l5 = Length(mi: 1);       // 1 mile
var l6 = Length(ft: 100);     // 100 feet
var l7 = Length(in_: 36);     // 36 inches
var l8 = Length(yd: 100);     // 100 yards

// Conversions
print(l1.valueInUnits(Length.kilometers));  // 0.1
print(l1.valueInUnits(Length.feet));        // 328.084...
print(l1.valueInUnits(Length.inches));      // 3937.007...
```

### Mass

```dart
var m1 = Mass(kg: 75);        // 75 kilograms
var m2 = Mass(g: 500);        // 500 grams
var m3 = Mass(mg: 100);       // 100 milligrams
var m4 = Mass(lb: 165);       // 165 pounds
var m5 = Mass(oz: 16);        // 16 ounces

print(m1.valueInUnits(Mass.pounds));   // 165.347...
print(m2.valueInUnits(Mass.kilograms)); // 0.5
```

### Time

```dart
var t1 = Time(s: 3600);       // 3600 seconds
var t2 = Time(min: 60);       // 60 minutes
var t3 = Time(h: 1);          // 1 hour
var t4 = Time(d: 1);          // 1 day

print(t1.valueInUnits(Time.hours));    // 1.0
print(t4.valueInUnits(Time.hours));    // 24.0
```

### Temperature

```dart
// Construct temperature
var temp = Temperature(C: 100);        // 100°C
var temp2 = Temperature(K: 273.15);    // 273.15 K (0°C)
var temp3 = Temperature(F: 212);       // 212°F (100°C)

print('$temp (${temp.valueInUnits(Temperature.kelvins)} K)');
// 100°C (373.15 K)

// Temperature differences
var diff = temp - temp2 as TemperatureInterval;
print('Difference: $diff');  // 100 K

// Add temperature interval
var hot = temp + (diff * 5) as Temperature;
print('Hot: ${hot.valueInUnits(Temperature.degreesCelsius)} C');
// 600°C
```

### Current

```dart
var current = Current(A: 1.5);         // 1.5 amperes
var milli = Current(mA: 500);          // 500 milliamperes

print(milli.valueInUnits(Current.amperes));  // 0.5
```

### Amount of Substance

```dart
var amount = AmountOfSubstance(mol: 1);  // 1 mole
print(amount.valueInUnits(AmountOfSubstance.millimoles));  // 1000
```

### Luminous Intensity

```dart
var intensity = LuminousIntensity(cd: 100);  // 100 candelas
```

---

## Derived Quantities

Quantities derived from SI base units:

### Speed / Velocity

```dart
var distance = Length(km: 100);
var time = Time(h: 1);
var speed = distance / time;  // 100 km/h

print(speed.valueInUnits(Speed.metersPerSecond));  // 27.778...
```

### Force

```dart
var force = Force(N: 100);     // 100 newtons
var kgf = Force(kgf: 1);       // 1 kilogram-force

print(kgf.valueInUnits(Force.newtons));  // 9.80665
```

### Energy

```dart
var energy = Energy(J: 1000);   // 1000 joules
var kwh = Energy(kWh: 1);       // 1 kilowatt-hour
var cal = Energy(cal: 100);     // 100 calories

print(kwh.valueInUnits(Energy.joules));     // 3,600,000
print(cal.valueInUnits(Energy.joules));     // 418.4
```

### Power

```dart
var power = Power(W: 1000);     // 1000 watts
var hp = Power(hp: 1);          // 1 horsepower

print(hp.valueInUnits(Power.watts));  // 745.699...
```

### Pressure

```dart
var pressure = Pressure(Pa: 101325);  // 101325 pascals (1 atm)
var atm = Pressure(atm: 1);           // 1 atmosphere
var bar = Pressure(bar: 1);           // 1 bar

print(atm.valueInUnits(Pressure.pascals));  // 101325
print(bar.valueInUnits(Pressure.pascals));  // 100000
```

### Area

```dart
var area = Area(m2: 100);       // 100 square meters
var sqft = Area(ft2: 1000);     // 1000 square feet
var acre = Area(acre: 1);       // 1 acre

print(acre.valueInUnits(Area.squareMeters));  // 4046.86...
```

### Volume

```dart
var volume = Volume(m3: 1);     // 1 cubic meter
var liter = Volume(L: 1000);    // 1000 liters = 1 m³
var gallon = Volume(gal: 1);    // 1 gallon

print(gallon.valueInUnits(Volume.liters));  // 3.785...
```

### Frequency

```dart
var freq = Frequency(Hz: 60);   // 60 hertz
var mhz = Frequency(MHz: 2.4);  // 2.4 megahertz

print(mhz.valueInUnits(Frequency.hertz));  // 2,400,000
```

---

## Creating Quantities

### Using Named Constructors

```dart
// SI units
var length = Length(m: 100);
var mass = Mass(kg: 75);
var time = Time(s: 60);

// Non-SI units
var lengthFt = Length(ft: 100);
var massPounds = Mass(lb: 165);
```

### Using Static Units

```dart
var length = Length.inUnits(100, Length.meters);
var mass = Mass.inUnits(75, Mass.kilograms);
```

---

## Unit Conversions

```dart
var length = Length(m: 1000);

// Using valueInUnits
print(length.valueInUnits(Length.kilometers));  // 1.0
print(length.valueInUnits(Length.miles));       // 0.6213...
print(length.valueInUnits(Length.feet));        // 3280.84...
print(length.valueInUnits(Length.inches));      // 39370.079...
```

---

## Quantity Arithmetic

### Same Quantity Operations

```dart
var l1 = Length(m: 100);
var l2 = Length(m: 50);

var sum = l1 + l2;        // 150 meters
var diff = l1 - l2;       // 50 meters
var scaled = l1 * 2;      // 200 meters (scalar multiplication)
```

### Mixed Quantity Operations

```dart
// Length / Time = Speed
var distance = Length(km: 100);
var time = Time(h: 2);
var speed = distance / time;  // 50 km/h

// Force * Length = Energy (Torque)
var force = Force(N: 10);
var displacement = Length(m: 5);
var work = force * displacement;  // 50 J

// Power = Energy / Time
var energy = Energy(J: 3600);
var duration = Time(s: 1);
var power = energy / duration;  // 3600 W
```

### Dimension Checking

```dart
// Incompatible operations throw exceptions
var length = Length(m: 100);
var mass = Mass(kg: 50);

try {
  var result = length + mass;  // DimensionsException!
} catch (e) {
  print('Cannot add length and mass');
}
```

---

## Available Quantity Types

### Mechanical

| Quantity             | Class                 | SI Unit     |
| -------------------- | --------------------- | ----------- |
| Acceleration         | `Acceleration`        | m/s²        |
| Angular Acceleration | `AngularAcceleration` | rad/s²      |
| Angular Momentum     | `AngularMomentum`     | kg⋅m²/s     |
| Angular Speed        | `AngularSpeed`        | rad/s       |
| Area                 | `Area`                | m²          |
| Dynamic Viscosity    | `DynamicViscosity`    | Pa⋅s        |
| Energy               | `Energy`              | J (joule)   |
| Force                | `Force`               | N (newton)  |
| Frequency            | `Frequency`           | Hz          |
| Kinematic Viscosity  | `KinematicViscosity`  | m²/s        |
| Length               | `Length`              | m           |
| Mass                 | `Mass`                | kg          |
| Mass Density         | `MassDensity`         | kg/m³       |
| Mass Flow Rate       | `MassFlowRate`        | kg/s        |
| Power                | `Power`               | W (watt)    |
| Pressure             | `Pressure`            | Pa (pascal) |
| Speed                | `Speed`               | m/s         |
| Time                 | `Time`                | s           |
| Torque               | `Torque`              | N⋅m         |
| Volume               | `Volume`              | m³          |
| Volume Flow Rate     | `VolumeFlowRate`      | m³/s        |

### Electrical

| Quantity              | Class                         | SI Unit     |
| --------------------- | ----------------------------- | ----------- |
| Capacitance           | `Capacitance`                 | F (farad)   |
| Charge                | `Charge`                      | C (coulomb) |
| Conductance           | `Conductance`                 | S (siemens) |
| Current               | `Current`                     | A (ampere)  |
| Electric Potential    | `ElectricPotentialDifference` | V (volt)    |
| Inductance            | `Inductance`                  | H (henry)   |
| Magnetic Flux         | `MagneticFlux`                | Wb (weber)  |
| Magnetic Flux Density | `MagneticFluxDensity`         | T (tesla)   |
| Resistance            | `Resistance`                  | Ω (ohm)     |

### Thermal

| Quantity             | Class                  | SI Unit    |
| -------------------- | ---------------------- | ---------- |
| Entropy              | `Entropy`              | J/K        |
| Heat Capacity        | `HeatCapacity`         | J/K        |
| Specific Heat        | `SpecificHeatCapacity` | J/(kg⋅K)   |
| Temperature          | `Temperature`          | K (kelvin) |
| Temperature Interval | `TemperatureInterval`  | K          |
| Thermal Conductivity | `ThermalConductivity`  | W/(m⋅K)    |

### Optical / Radiation

| Quantity           | Class               | SI Unit        |
| ------------------ | ------------------- | -------------- |
| Absorbed Dose      | `AbsorbedDose`      | Gy (gray)      |
| Activity           | `Activity`          | Bq (becquerel) |
| Dose Equivalent    | `DoseEquivalent`    | Sv (sievert)   |
| Illuminance        | `Illuminance`       | lx (lux)       |
| Luminance          | `Luminance`         | cd/m²          |
| Luminous Flux      | `LuminousFlux`      | lm (lumen)     |
| Luminous Intensity | `LuminousIntensity` | cd (candela)   |
| Radiance           | `Radiance`          | W/(sr⋅m²)      |
| Radiant Intensity  | `RadiantIntensity`  | W/sr           |

### Other

| Quantity            | Class               | SI Unit        |
| ------------------- | ------------------- | -------------- |
| Angle               | `Angle`             | rad            |
| Amount of Substance | `AmountOfSubstance` | mol            |
| Catalytic Activity  | `CatalyticActivity` | kat (katal)    |
| Concentration       | `Concentration`     | mol/m³         |
| Currency            | `Currency`          | (various)      |
| Information         | `Information`       | bit            |
| Information Rate    | `InformationRate`   | bit/s          |
| Solid Angle         | `SolidAngle`        | sr (steradian) |

---

## Related Tests

- [`test/quantity/`](../test/quantity/) - Physical quantity tests
- [`test/quantity_ext/`](../test/quantity_ext/) - Quantity extension tests
- [`test/quantity_range/`](../test/quantity_range/) - Quantity range tests

## Related Documentation

- [Numbers](05_numbers.md) - Decimal and Rational for precise calculations
- [Geometry](03_geometry.md) - Angle and length applications
- [Basic Math](02_basic_math.md) - Core math functions

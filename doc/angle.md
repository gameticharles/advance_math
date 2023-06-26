# Angle Class

The `Angle` class is part of the `advanced_math` library. It's designed to make working with angles straightforward in a variety of units, including degrees, radians, gradians, and DMS (Degrees, Minutes, Seconds).

## Features

1. Create an Angle object with any of the four units. The class will automatically convert it to all other units and store them as properties:

```dart
var angleDeg = Angle.degrees(45);
var angleRad = Angle.radians(math.pi / 4);
var angleGrad = Angle.gradians(50);
var angleDMS = Angle.dms([45, 0, 0]);
```

2. Get the smallest difference between two angles:

```dart
num diff = angleDeg.smallestDifference(angleRad);
```

3. Interpolate between two angles:

```dart
Angle interpolated = angleDeg.interpolate(angleRad, 0.5);
```

4. Convert an angle from one unit to another:

```dart
double rad = Angle.convert(180, AngleType.degrees, AngleType.radians);  // Converts 180 degrees to radians
print(rad);  // Outputs: 3.141592653589793

double grad = Angle.convert(1, AngleType.radians, AngleType.gradians);  // Converts 1 radian to gradians
print(grad);  // Outputs: 63.661977236758134
```

5. Convert degrees to gradians, radians, minutes or seconds, and vice versa:

```dart
double minutes = degrees2Minutes(1);  // Output: 60.0
double degreesFromMinutes = minutes2Degrees(60);  // Output: 1.0
double seconds = degrees2Seconds(1);  // Output: 3600.0
double degreesFromSeconds = seconds2Degrees(3600);  // Output: 1.0
```

6. Perform all the possible trignometry functions on the angle:

```dart
var angle = Angle.degrees(45);
var t1 = angle.sin();
var t2 = angle.cos();
var t3 = angle.tan();
var t4 = angle.tanh();
var t5 = angle.atanh();
```

These features provide an easy-to-use interface for handling various angle calculations, especially for applications that require geometric computations or work with geospatial data. The `Angle` class is an essential part of the `advanced_math` library and can be useful for anyone who needs advanced mathematical operations in Dart.
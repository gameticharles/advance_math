# Vectors

## Create a new vector

* `Vector(int length, {bool isDouble = true})`: Creates a [Vector] of given length with all elements initialized to 0.
* `Vector.fromList(List<num> data)`: Constructs a [Vector] from a list of numerical values.
* `Vector.random(int length,{double min = 0, double max = 1, bool isDouble = true, math.Random? random, int? seed})`: Constructs a [Vector] from a list of random numerical values.
* `Vector.linspace(int start, int end, [int number = 50])`: Creates a row Vector with equally spaced values between the start and end values (inclusive).
* `Vector.range(int end, {int start = 1, int step = 1}) & Vector.arrange(int end, {int start = 1, int step = 1})`: Creates a Vector with values in the specified range, incremented by the specified step size.

```dart
// Create a vector of length 3 with all elements initialized to 0
var v1 = Vector(3);

// Create a vector from a list of values
var v2 = Vector([1, 2, 3]);
v2 = Vector.fromList([1, 2, 3]);

// Create a vector with random values between 0 and 1
var v3 = Vector.random(3);

// Create a vector with 50 values equally spaced between 0 and 1
var v4 = Vector.linspace(0, 1);

// Create a vector with values 1, 3, 5, 7, 9
var v5 = Vector.range(10, start: 1, step: 2);
v5 = Vector.arrange(10, start: 1, step: 2);
```

## Operators

Supports operations for elementwise operations by scalar value or vector

```dart
// Get the value at index 2 of v2
var val = v2[2];

// Set the value at index 1 of v1 to 7
v1[1] = 7;

// Add v1 and v2
var v6 = v1 + v2;

// Subtract v2 from v1
var v7 = v1 - v2;

// Multiply v1 by a scalar
var v8 = v1 * 3.5;

// Divide v2 by a scalar
var v9 = v2 / 2;
```

## Vector Operations

* `double dot(Vector other)`: Calculates the dot product of the vector with another vector.
* `Vector cross(Vector other)`: Calculates the cross product of the vector with another vector.
* `double get magnitude`: Returns the magnitude (or norm) of the vector.
* `double get direction`: Returns the direction (or angle) of the vector, in radians.
* `double norm()`: Returns the norm (or length) of this vector.
* `Vector normalize()`: Returns this vector normalized.
* `bool isZero()`: Returns true if this is a zero vector, i.e., all its elements are zero.
* `bool isUnit()`: Returns true if this is a unit vector, i.e., its norm is 1.

```dart
// Calculate the dot product of v1 and v2
var dotProduct = v1.dot(v2);

// Calculate the cross product of two 3D vectors
var crossProduct = Vector.fromList([1, 2, 3]).cross(Vector.fromList([4, 5, 6]));

// Get the magnitude of v1
var magnitude = v1.magnitude;

// Get the direction of v1
var direction = v1.direction;

// Get the norm of v1
var norm = v1.norm();

// Normalize v1
var normalizedV1 = v1.normalize();
```

Others metrics include:
* `List<num> toList()`: Converts the vector to a list of numerical values.
* `int get length`: Returns the length (number of elements) of the vector.
* `void setAll(num value)`: Sets all elements of this vector to [value].
* `double distance(Vector other)`: Returns the Euclidean distance between this vector and [other].
* `Vector projection(Vector other)`: Returns the projection of this vector onto [other].
* `double angle(Vector other)`: Returns the angle (in radians) between this vector and [other].
* `List<double> toSpherical()`: Converts the Vector from Cartesian to Spherical coordinates.
* `void fromSpherical(List<num> sphericalCoordinates)`: Converts the Vector from Spherical to Cartesian coordinates.

```dart
Vector v = Vector([1, 2, 3]);
print(v);  // Output: [1, 2, 3]

// Convert v1 to a list
var list = v1.toList();

// Get the length of v1
var length = v1.length;

// Set all elements of v1 to 5
v1.setAll(5);

// Calculate the Euclidean distance between v1 and v2
var distance = v1.distance(v2);

// Calculate the projection of v1 onto v2
var projection = v1.projection(v2);

// Calculate the angle between v1 and v2
var angle = v1.angle(v2);

// Convert v1 to spherical coordinates
var spherical = v1.toSpherical();

// Create a vector from spherical coordinates
var v10 = Vector(3);
v10.fromSpherical(spherical);
```

## Vector Subset

```dart
// Extraction
var u1 = Vector.fromList([5, 0, 2, 4]);
var v1 = u1.getVector(['x', 'x', 'y']);
print(v1); // Output: [5.0, 5.0, 0.0)]
print(v1.runtimeType); // Vector3

u1 = Vector.fromList([5, 0, 2]);
v1 = u1.subVector(range: '1:2');
print(v1); // Output: [5.0, 5.0, 0.0, 2.0]
print(v1.runtimeType); // Vector4

var v = Vector.fromList([1, 2, 3, 4, 5]);
var subVector = v.subVector(indices: [0, 2, 4, 1, 1]);
print(subVector);  // Output: [1.0, 3.0, 5.0, 2.0, 2.0]
print(subVector.runtimeType); // Vector
```
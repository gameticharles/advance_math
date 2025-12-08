# Vector Module

Mathematical vectors with comprehensive operations for linear algebra and geometry.

---

## Table of Contents

1. [Creating Vectors](#creating-vectors)
2. [Properties](#properties)
3. [Basic Operations](#basic-operations)
4. [Vector Products](#vector-products)
5. [Geometric Operations](#geometric-operations)
6. [Complex Vectors](#complex-vectors)
7. [Special Vectors](#special-vectors)

---

## Creating Vectors

### From List

```dart
import 'package:advance_math/advance_math.dart';

var v = Vector([1, 2, 3, 4, 5]);
print(v);  // [1, 2, 3, 4, 5]
```

### From Range

```dart
// Start, end, step
var v = Vector.range(0, 10, step: 2);
print(v);  // [0, 2, 4, 6, 8]

// Just start and end
var v2 = Vector.range(1, 5);
print(v2);  // [1, 2, 3, 4]
```

### Special Constructors

```dart
// Zero vector
var zeros = Vector.zeros(5);
print(zeros);  // [0, 0, 0, 0, 0]

// Ones vector
var ones = Vector.ones(5);
print(ones);  // [1, 1, 1, 1, 1]

// Random vector
var random = Vector.random(5);

// Fill with value
var filled = Vector.fill(5, 7);
print(filled);  // [7, 7, 7, 7, 7]

// Linspace (evenly spaced)
var lin = Vector.linspace(0, 1, 5);
print(lin);  // [0.0, 0.25, 0.5, 0.75, 1.0]
```

---

## Properties

```dart
var v = Vector([3, 4, 0]);

// Length (number of elements)
print(v.length);      // 3

// Magnitude (Euclidean norm)
print(v.magnitude()); // 5.0

// L1 norm (Manhattan)
print(v.norm(Norm.manhattan));  // 7

// L2 norm (Euclidean)
print(v.norm());                // 5.0

// Infinity norm
print(v.norm(Norm.chebyshev));  // 4

// Sum of elements
print(v.sum());       // 7

// Mean
print(v.mean());      // 2.333...
```

---

## Basic Operations

### Arithmetic

```dart
var a = Vector([1, 2, 3]);
var b = Vector([4, 5, 6]);

// Addition
var sum = a + b;
print(sum);  // [5, 7, 9]

// Subtraction
var diff = a - b;
print(diff);  // [-3, -3, -3]

// Scalar multiplication
var scaled = a * 2;
print(scaled);  // [2, 4, 6]

// Scalar division
var divided = a / 2;
print(divided);  // [0.5, 1.0, 1.5]

// Negation
var neg = -a;
print(neg);  // [-1, -2, -3]
```

### Element Access

```dart
var v = Vector([10, 20, 30, 40, 50]);

// Index access
print(v[0]);     // 10
print(v[2]);     // 30
print(v.last);   // 50
print(v.first);  // 10

// Slicing
print(v.subVector(1, 4));  // [20, 30, 40]
```

---

## Vector Products

### Dot Product

```dart
var a = Vector([1, 2, 3]);
var b = Vector([4, 5, 6]);

var dot = a.dot(b);
print(dot);  // 32 (1*4 + 2*5 + 3*6)
```

### Cross Product

For 3D vectors:

```dart
var a = Vector([1, 0, 0]);
var b = Vector([0, 1, 0]);

var cross = a.cross(b);
print(cross);  // [0, 0, 1]
```

### Outer Product

```dart
var a = Vector([1, 2]);
var b = Vector([3, 4, 5]);

var outer = a.outer(b);
print(outer);
// Matrix:
// ┌ 3 4 5 ┐
// └ 6 8 10 ┘
```

---

## Geometric Operations

### Normalization

```dart
var v = Vector([3, 4, 0]);

// Normalize to unit vector
var unit = v.normalize();
print(unit);           // [0.6, 0.8, 0.0]
print(unit.magnitude()); // 1.0
```

### Angle Between Vectors

```dart
var a = Vector([1, 0, 0]);
var b = Vector([0, 1, 0]);

var angle = a.angleTo(b);
print(angle.deg);  // 90.0 degrees
```

### Distance

```dart
var a = Vector([0, 0, 0]);
var b = Vector([3, 4, 0]);

var dist = a.distanceTo(b);
print(dist);  // 5.0
```

### Projection

```dart
var a = Vector([3, 4]);
var b = Vector([1, 0]);

// Project a onto b
var proj = a.projectOnto(b);
print(proj);  // [3, 0]
```

### Reflection

```dart
var v = Vector([1, 1]);
var normal = Vector([0, 1]);

var reflected = v.reflect(normal);
print(reflected);  // [1, -1]
```

---

## Complex Vectors

Vectors with complex number elements:

```dart
var cv = ComplexVector([
  Complex(1, 2),
  Complex(3, 4),
  Complex(5, 6)
]);

print(cv);  // [(1 + 2i), (3 + 4i), (5 + 6i)]

// Complex dot product (conjugate)
var a = ComplexVector([Complex(1, 1), Complex(2, 2)]);
var b = ComplexVector([Complex(1, -1), Complex(2, -2)]);

var dot = a.dot(b);
print(dot);  // Complex result
```

### Complex Vector Operations

```dart
var cv = ComplexVector([Complex(3, 4), Complex(5, 12)]);

// Magnitude of each element
print(cv.abs());  // [5, 13]

// Conjugate
print(cv.conjugate());

// Norm
print(cv.norm());
```

---

## Special Vectors

### Unit Vectors

```dart
// Standard basis vectors
var i = Vector([1, 0, 0]);  // x-axis
var j = Vector([0, 1, 0]);  // y-axis
var k = Vector([0, 0, 1]);  // z-axis
```

### Zero and Ones

```dart
var zero = Vector.zeros(4);
var ones = Vector.ones(4);

// Check if zero vector
print(zero.isZero);  // true
```

---

## Conversion

### To Matrix

```dart
var v = Vector([1, 2, 3, 4]);

// To column matrix
var col = v.toColumnMatrix();
// ┌ 1 ┐
// │ 2 │
// │ 3 │
// └ 4 ┘

// To row matrix
var row = v.toRowMatrix();
// [ 1 2 3 4 ]
```

### To List

```dart
var v = Vector([1, 2, 3]);
List<num> list = v.toList();
print(list);  // [1, 2, 3]
```

### To Point

```dart
var v = Vector([3, 4]);
Point p = v.toPoint();
print(p);  // Point(3, 4)
```

---

## Element-wise Operations

### Apply Function

```dart
var v = Vector([1, 2, 3, 4]);

// Square each element
var squared = v.map((e) => e * e);
print(squared);  // [1, 4, 9, 16]

// Apply math function
var sinValues = v.map((e) => sin(e));
```

### Filter

```dart
// Keep only elements > 2
var filtered = v.where((e) => e > 2);
print(filtered);  // [3, 4]
```

---

## Statistical Operations

```dart
var v = Vector([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

print(v.sum());      // 55
print(v.mean());     // 5.5
print(v.min());      // 1
print(v.max());      // 10
print(v.variance()); // Variance
print(v.std());      // Standard deviation
print(v.median());   // 5.5
```

---

## Comparison

```dart
var a = Vector([1, 2, 3]);
var b = Vector([1, 2, 3]);
var c = Vector([1, 2, 4]);

print(a == b);  // true
print(a == c);  // false

// Approximate equality
print(a.isAlmostEqual(b, tolerance: 1e-10));  // true
```

---

## Related Tests

- [`test/vector_test.dart`](../../test/vector_test.dart)

## Related Documentation

- [Matrix](04_matrix.md) - Matrix operations
- [Geometry](../03_geometry.md) - 2D/3D vector applications
- [Statistics](../04_statistics.md) - Statistical vector operations

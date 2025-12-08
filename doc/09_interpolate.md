# Interpolate Module

This module provides tools for interpolating data points in one and two dimensions. It allows for estimating values at points where no direct measurements are available, based on a set of known data points. This is useful in various applications such as data analysis, signal processing, and computer graphics.

## Table of Contents

- [Overview](#overview)
- [Key Concepts](#key-concepts)
  - [MethodType Enum](#methodtype-enum)
- [1D Interpolation (`Interp1D`)](#1d-interpolation-interp1d)
  - [Overview](#1d-overview)
  - [Creating an 1D Interpolator](#creating-an-1d-interpolator)
  - [Performing 1D Interpolation](#performing-1d-interpolation)
  - [1D Interpolation Methods (via `MethodType`)](#1d-interpolation-methods)
- [2D Interpolation (`Interp2D`)](#2d-interpolation-interp2d)
  - [Overview](#2d-overview)
  - [Creating an 2D Interpolator](#creating-an-2d-interpolator)
  - [Performing 2D Interpolation](#performing-2d-interpolation)
  - [2D Interpolation Methods (via `MethodType`)](#2d-interpolation-methods)
- [Spline Interpolation (`SplineInterpolator`)](#spline-interpolation)
- [Barycentric Interpolation (`BarycentricInterpolator`)](#barycentric-rational-interpolation)
- [RBF Interpolation (`RBFInterpolator`)](#radial-basis-function-rbf-interpolation)

---

## Overview

Interpolation is the process of finding approximate values for data points that lie between known data points. This module offers classes for:

- One-dimensional interpolation (`Interp1D`)
- Two-dimensional interpolation (`Interp2D`)
- Advanced Spline interpolation (`SplineInterpolator`)
- High-order rational interpolation (`BarycentricInterpolator`)
- Scattered data interpolation (`RBFInterpolator`)

---

## Key Concepts

### MethodType Enum

_(Defined in `lib/src/interpolate/method_types.dart`)_

The `MethodType` enum is used by both `Interp1D` and `Interp2D` to specify the interpolation algorithm.

- **`linear`**: Linear interpolation. For 1D, connects points with straight lines. For 2D, typically implies bilinear interpolation.
- **`nearest`**: Nearest neighbor interpolation. Uses the value of the closest known data point.
- **`previous`**: Uses the value of the preceding known data point.
- **`next`**: Uses the value of the succeeding known data point.
- **`quadratic`**: Quadratic polynomial interpolation. For 2D, often applied separably.
- **`cubic`**: Cubic polynomial interpolation. For 2D, often applied separably (e.g., bicubic).
- **`newton`**: Newton's divided difference polynomial interpolation. For 2D, often applied separably.

---

## 1D Interpolation (`Interp1D`)

_(Documentation for `Interp1D` from `lib/src/interpolate/interp1d.dart`)_

### 1D Overview

The `Interp1D` class provides functionality to interpolate a 1-dimensional function. Given a set of data points `(x, y)`, it creates an callable object that can estimate y-values for new x-values that may not be in the original dataset.

### Creating an 1D Interpolator

To create a 1D interpolator, instantiate the `Interp1D` class.

**Constructor:**
`Interp1D(List<num> x, List<num> y, {MethodType method = MethodType.linear, bool throwOnOutOfBounds = true, dynamic fillValue, bool copy = true, bool assumeSorted = false})`

**Parameters:**

- `x: List<num>`: A list of x-coordinates (independent values). These values **must be unique**.
- `y: List<num>`: A list of corresponding y-coordinates (dependent values). Must be the same length as `x`.
- `method: MethodType` (optional): The interpolation method to use. Defaults to `MethodType.linear`.
- `throwOnOutOfBounds: bool` (optional):
  - If `true` (default): An exception is thrown if interpolation is attempted for an x-value outside the range of the provided `x` data, _unless_ `fillValue` is explicitly set to the string `'extrapolate'`.
  - If `false`: Out-of-bounds queries will use `fillValue` or extrapolate if `fillValue` is `'extrapolate'`.
- `fillValue: dynamic` (optional):
  - If `throwOnOutOfBounds` is `false` and this is a `num`, this value is returned for out-of-bounds x-values.
  - If set to the string `'extrapolate'`, the interpolator will attempt to extrapolate values beyond the data range (currently, this implies linear extrapolation based on the two nearest end-points).
  - If `throwOnOutOfBounds` is `false` and `fillValue` is not provided, it defaults to `double.nan`.
- `copy: bool` (optional): If `true` (default), the constructor works with a copy of the input `x` and `y` lists. If `false`, it uses the provided lists directly (which might be modified if `assumeSorted` is false, as data is sorted internally).
- `assumeSorted: bool` (optional): If `false` (default), the input `x` and `y` lists are sorted based on `x` values. If `true`, the `x` list is assumed to be already sorted in ascending order; providing unsorted data with `assumeSorted: true` will lead to incorrect results.

**Important Considerations:**

- An exception is thrown if `x` and `y` have different lengths or if `x` values are not unique.
- Methods like `quadratic` and `cubic` require a minimum number of data points (3 for quadratic, 4 for cubic). An exception is thrown if insufficient points are provided for the chosen method.
- NaN values in input `x` or `y` data can lead to undefined behavior or errors.

**Dart Code Example:**

```dart
// import 'package:advance_math/interpolate.dart'; // Or more specific path

final xData = [1.0, 2.0, 4.0, 3.0, 5.0]; // Unsorted x data
final yData = [2.0, 4.0, 3.0, 1.0, 5.0]; // Corresponding y data

// Create a linear interpolator (default method); data will be sorted internally by x
final linearInterpolator = Interp1D(xData, yData);
// xData internally becomes [1.0, 2.0, 3.0, 4.0, 5.0]
// yData internally becomes [2.0, 4.0, 1.0, 3.0, 5.0] (reordered to match sorted x)

// Create a cubic interpolator
final cubicInterpolator = Interp1D(xData, yData, method: MethodType.cubic);

// Interpolator that extrapolates linearly for out-of-bounds values
final extrapolatingInterpolator = Interp1D(
  xData,
  yData,
  throwOnOutOfBounds: false,
  fillValue: 'extrapolate',
);

// Interpolator with a specific fill value for out-of-bounds queries
final fillValueInterpolator = Interp1D(
  xData,
  yData,
  throwOnOutOfBounds: false,
  fillValue: -999.0,
);
```

### Performing 1D Interpolation

Call the `Interp1D` instance like a function, passing the new x-value(s).

**Single Value Interpolation:**

```dart
// Using linearInterpolator from previous example (x sorted: [1,2,3,4,5], y sorted: [2,4,1,3,5])
num y1 = linearInterpolator(2.5); // Between (2,4) and (3,1)
print('Linear interp at x=2.5: $y1'); // Output: 2.5

num y2 = linearInterpolator(3.5); // Between (3,1) and (4,3)
print('Linear interp at x=3.5: $y2'); // Output: 2.0

num yAtNode = linearInterpolator(4.0);
print('Linear interp at x=4.0: $yAtNode'); // Output: 3.0
```

**Extrapolation Example:**

```dart
final xData = [1.0, 2.0];
final yData = [10.0, 20.0];
final extrapolator = Interp1D(
  xData, yData,
  throwOnOutOfBounds: false, fillValue: 'extrapolate'
);
print('Extrapolated at x=3.0: ${extrapolator(3.0)}');   // Output: 30.0 (linear extrapolation)
print('Extrapolated at x=0.0: ${extrapolator(0.0)}');   // Output: 0.0
```

**Fill Value Example:**

```dart
final xData = [1.0, 2.0];
final yData = [10.0, 20.0];
final filler = Interp1D(
  xData, yData,
  throwOnOutOfBounds: false, fillValue: -1.0
);
print('Filled at x=3.0: ${filler(3.0)}');   // Output: -1.0
print('Filled at x=0.5: ${filler(0.5)}');   // Output: -1.0
print('Interpolated at x=1.5: ${filler(1.5)}'); // Output: 15.0
```

**List of Values Interpolation (Batch):**

```dart
final xData = [0.0, 1.0, 2.0, 3.0, 4.0];
final yData = [0.0, 0.8, 1.0, 0.5, 0.0]; // Example y-values
final interpolator = Interp1D(xData, yData, method: MethodType.cubic);

final newXValues = [0.5, 1.5, 2.5, 3.5];
final interpolatedYValues = newXValues.map((xVal) => interpolator(xVal)).toList();

print('Interpolated Y values (cubic): $interpolatedYValues');
// Example output (cubic): [0.59375, 1.03125, 0.78125, 0.21875] (approx.)
```

### 1D Interpolation Methods (via `MethodType`)

- **`linear`**: Connects points with straight lines. C0 continuous. Requires >= 2 points.
- **`nearest`**: Uses y-value of the data point with the closest x-value. Step function. Requires >= 2 points.
- **`previous`**: Uses y-value of the data point with the largest x <= `xNew`. Step function. Requires >= 2 points.
- **`next`**: Uses y-value of the data point with the smallest x >= `xNew`. Step function. Requires >= 2 points.
- **`quadratic`**: Uses Lagrange quadratic polynomial on three neighboring points. C1 continuous. Requires >= 3 points.
- **`cubic`**: Uses Lagrange cubic polynomial on four neighboring points. Smoother than quadratic. Requires >= 4 points.
- **`newton`**: Uses Newton's divided difference polynomial. Can fit a polynomial of degree `n-1` to `n` points. Requires >= 2 points.

---

## 2D Interpolation (`Interp2D`)

_(Documentation for `Interp2D` from `lib/src/interpolate/interp2d.dart`)_

### 2D Overview

The `Interp2D` class interpolates values from a 2D grid. Given x-coordinates, y-coordinates, and a grid of z-values (`z[i][j]` is value at `x[i]`, `y[j]`), it estimates z-values for new (x,y) pairs.

### Creating an 2D Interpolator

**Constructor:**
`Interp2D(List<num> x, List<num> y, List<List<num>> z, {MethodType method = MethodType.linear, bool throwOnOutOfBounds = true, dynamic fillValue, bool assumeSorted = false, bool copy = true})`

**Parameters:**

- `x: List<num>`: 1D list of x-coordinates for grid lines (must be unique and sorted, or `assumeSorted = false`).
- `y: List<num>`: 1D list of y-coordinates for grid lines (must be unique and sorted, or `assumeSorted = false`).
- `z: List<List<num>>`: 2D list of z-values. `z[i][j]` corresponds to `x[i]` and `y[j]`. Dimensions: `x.length` rows, `y.length` columns.
- `method: MethodType`: Interpolation method (default `linear` for bilinear).
- `throwOnOutOfBounds: bool`: If true (default), throws for out-of-bounds points unless `fillValue` is `'extrapolate'`.
- `fillValue: dynamic`: Value for out-of-bounds points if not throwing or extrapolating. Defaults to `double.nan`. String `'extrapolate'` enables linear extrapolation.
- `copy: bool`: If true (default), copies input data.
- `assumeSorted: bool`: If true, `x` and `y` are assumed sorted.

**Important Considerations:**

- `x` and `y` must be unique.
- `z` dimensions must match `x.length` (rows) and `y.length` (columns).
- For methods like `quadratic` or `cubic`, a minimum grid size is needed (e.g., 3x3 for biquadratic, 4x4 for bicubic if implemented separably).

**Dart Code Example:**

```dart
final xGrid = [10.0, 20.0, 30.0];
final yGrid = [5.0, 15.0, 25.0];
final zGrid = [
  [1.0, 2.0, 3.0], // z for x=10, y=[5,15,25]
  [4.0, 5.0, 6.0], // z for x=20, y=[5,15,25]
  [7.0, 8.0, 9.0]  // z for x=30, y=[5,15,25]
];

// Bilinear interpolator (default)
final bilinearInterp = Interp2D(xGrid, yGrid, zGrid);

// Nearest neighbor interpolator
final nearestInterp = Interp2D(xGrid, yGrid, zGrid, method: MethodType.nearest);

// Extrapolating interpolator
final extrapolatingInterp2D = Interp2D(
  xGrid, yGrid, zGrid,
  throwOnOutOfBounds: false, fillValue: 'extrapolate'
);
```

### Performing 2D Interpolation

Call the `Interp2D` instance like a function with new `x` and `y` coordinates.

**Single Point Interpolation:**

```dart
// Using bilinearInterp from previous example
num z1 = bilinearInterp(15.0, 10.0);
print('Bilinear interp at (15,10): $z1'); // Output: 3.0

// Extrapolation
num zOutside = extrapolatingInterp2D(35.0, 30.0);
// Based on the _extrapolate logic, it averages linear extrapolations from the corner.
// GradX at (30,25) using (20,25)-(30,25) is (9-6)/(30-20)=0.3. ExtrapX = 9 + 0.3*(35-30) = 10.5
// GradY at (30,25) using (30,15)-(30,25) is (9-8)/(25-15)=0.1. ExtrapY = 9 + 0.1*(30-25) = 9.5
// Average = (10.5+9.5)/2 = 10.0
print('Extrapolated z at (35,30): $zOutside'); // Output: 10.0
```

**List of Points Interpolation:**

```dart
final newXYPairs = [[12.0, 8.0], [22.0, 18.0]];
final interpolatedZs = newXYPairs.map((pair) => nearestInterp(pair[0], pair[1])).toList();
print('Interpolated Zs (nearest): $interpolatedZs'); // Example: [1.0, 5.0]
```

### 2D Interpolation Methods (via `MethodType`)

- **`linear`** (Bilinear): Performs linear interpolation along each axis. C0 continuous surface. Requires >= 2x2 grid.
- **`nearest`**: Assigns z-value of the closest grid point. Piecewise constant surface.
- **`previous`**: Uses `z[x_idx-1][y_idx-1]` after finding indices (floor-like). Step-surface.
- **`next`**: Uses `z[x_idx][y_idx]` after finding indices (ceil-like). Step-surface.
- **`quadratic`** (e.g., Biquadratic): Applies 1D quadratic interpolation separably. Smoother than bilinear. Requires >= 3x3 grid.
- **`cubic`** (e.g., Bicubic): Applies 1D cubic interpolation separably. Even smoother. Requires >= 4x4 grid.
- **`newton`** (Separable Newton): Applies 1D Newton interpolation separably.

The `Interp2D` source shows internal 1D helper methods for `quadratic`, `cubic`, and `newton`, indicating a separable application strategy for these higher-order methods in 2D.

---

## Spline Interpolation

_(Documentation for `SplineInterpolator` from `lib/src/interpolate/spline.dart`)_

### Overview

`SplineInterpolator` provides smooth interpolation using piecewise polynomials. It supports Natural Cubic Splines, Monotone Cubic Interpolation (PCHIP), and Akima Splines.

### Creating a Spline Interpolator

**Constructor:**
`SplineInterpolator(List<double> x, List<double> y, {SplineType type = SplineType.naturalCubic})`

**Parameters:**

- `x`: Sorted list of x-coordinates (must be strictly increasing).
- `y`: List of y-coordinates.
- `type`: The type of spline to generate.

### Spline Types (`SplineType`)

- **`naturalCubic`**: A cubic spline with zero second derivative at endpoints. Very smooth (C2 continuous) but can oscillate.
- **`monotoneCubic`** (PCHIP): Preserves monotonicity of the data. Use this if you want to avoid overshooting (e.g., probability distributions). C1 continuous.
- **`akima`**: Akima spline. Less oscillatory than natural cubic and handles outliers well. C1 continuous.

### Example

```dart
final x = [0.0, 1.0, 2.0, 3.0, 4.0];
final y = [0.0, 0.8, 0.9, 0.1, -0.8];

// Monotone Cubic (PCHIP) - prevents overshooting
final pchip = SplineInterpolator(x, y, type: SplineType.monotoneCubic);
print(pchip.interpolate(1.5)); // Interpolated value
```

---

## Barycentric Rational Interpolation

_(Documentation for `BarycentricInterpolator` from `lib/src/interpolate/barycentric.dart`)_

### Overview

`BarycentricInterpolator` implements Barycentric Rational Interpolation. It is a stable method for polynomial interpolation of high degrees and allows for O(n) updates when adding new points.

### Usage

```dart
final x = [0.0, 1.0, 2.0];
final y = [1.0, 2.0, 0.5];

final bary = BarycentricInterpolator(x, y);
print(bary.interpolate(1.5));

// Adding a point efficiently
bary.addPoint(3.0, 0.0);
```

---

## Radial Basis Function (RBF) Interpolation

_(Documentation for `RBFInterpolator` from `lib/src/interpolate/rbf.dart`)_

### Overview

`RBFInterpolator` uses Radial Basis Functions to approximate scattered data. While currently implemented for 1D, the underlying mathematical structure (weights matrix) is designed for multi-dimensional extension.

### Creating an RBF Interpolator

**Constructor:**
`RBFInterpolator(List<num> x, List<num> y, {RBFKernel kernel = RBFKernel.gaussian, double epsilon = 1.0})`

**Parameters:**

- `x`, `y`: Data points.
- `kernel`: The radial function to use.
- `epsilon`: Shape parameter (scale) for the kernel.

### Kernels (`RBFKernel`)

- **`gaussian`**: `exp(-(r/epsilon)^2)` - Very smooth, infinite support.
- **`linear`**: `r`
- **`multiquadric`**: `sqrt(r^2 + epsilon^2)`
- **`inverseMultiquadric`**: `1 / sqrt(r^2 + epsilon^2)`
- **`thinPlateSpline`**: `r^2 * log(r)`

### Example

```dart
final x = [0.0, 1.0, 2.0, 3.0];
final y = [0.0, 1.0, 0.0, 1.0];

final rbf = RBFInterpolator(x, y, kernel: RBFKernel.gaussian, epsilon: 0.5);
print(rbf.interpolate(1.5));
```

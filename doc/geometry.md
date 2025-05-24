# Geometry Module

This module provides a comprehensive suite of classes and utilities for performing geometric calculations and representing geometric shapes in 2D and 3D space.

It includes fundamental entities like points and lines, various plane figures (triangles, quadrilaterals, polygons, circles, ellipses), solid figures (cubes), and utility functions for geometric operations.

## Abstract Base Class: `Geometry`

The `Geometry` class is an abstract base for many geometric shapes in this library.

- **`String name`**: Identifies the shape.
- **`num area()`**: Abstract method to calculate the area of the shape. Subclasses must implement this.
- **`num perimeter()`**: Abstract method to calculate the perimeter of the shape. Subclasses must implement this. For solid geometries, this might return zero or throw an error.

## Table of Contents

### Core Geometric Types
- [Points (`./geometry/point.md`)](./geometry/point.md) - Documentation for 2D and 3D points.
- [Lines (`./geometry/line.md`)](./geometry/line.md) - Documentation for lines.
- [Pi Constants & Utilities (`./geometry/pi_constants.md`)](./geometry/pi_constants.md) - Pi-related values and angle conversions.

### Plane Geometry
- [Overview of Plane Geometry (`./geometry/plane/plane.md`)]](./geometry/plane/plane.md) - Documentation for `Plane` and `PlaneGeometry`.
- [Triangles (`./geometry/plane/triangle.md`)]](./geometry/plane/triangle.md) - Covers `Triangle`, `SphericalTriangle`, and area calculation utilities.
- [Quadrilaterals (`./geometry/plane/quadrilateral.md`)]](./geometry/plane/quadrilateral.md) - Covers `Square`, `Rectangle`, `Trapezoid`, `Parallelogram`, `Rhombus`.
- [Polygons (`./geometry/plane/polygon.md`)]](./geometry/plane/polygon.md) - General polygon representation.
- [Circles and Ellipses (`./geometry/plane/circle_ellipse.md`)]](./geometry/plane/circle_ellipse.md) - Covers `Circle`, `Ellipse`, `Annulus`, `ErrorEllipse`.

### Solid Geometry
- [Overview of Solid Geometry (`./geometry/solid/solid.md`)]](./geometry/solid/solid.md) - Documentation for `SolidGeometry`.
- [Cube (`./geometry/solid/cube.md`)]](./geometry/solid/cube.md) - Documentation for the `Cube` shape.

### Utilities
- [Geometric Utilities (`./geometry/utils.md`)]](./geometry/utils.md) - Utility functions for geometric operations.

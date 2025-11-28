part of '../../geometry.dart';

/// A class representing an annulus (a ring-like shape).
class Annulus extends PlaneGeometry {
  num innerRadius;
  num outerRadius;

  /// Center [Point] of the Annulus.
  Point center;

  /// Central Angle of the Annulus in radians.
  Angle? centralAngle;

  /// Constructs an Annulus with given inner and outer radii, and optionally a center point.
  ///
  /// Requires inner and outer radii, and optionally a center point.
  Annulus(this.innerRadius, this.outerRadius, {Point? center})
      : center = center ?? Point(0, 0),
        super("Annulus");

  /// Named constructor to create an Annulus from various parameters.
  ///
  /// You can specify either:
  /// - innerRadius and outerRadius
  /// - area
  /// - perimeter etc.
  Annulus.from({
    num? innerRadius,
    num? outerRadius,
    num? area,
    num? perimeter,
    num? width,
    Angle? centralAngle,
    num? sectorInteriorCircumference,
    num? sectorExteriorCircumference,
    num? sectorPerimeter,
    num? sectorArea,
    num? exteriorCircumference,
    num? interiorCircumference,
    Point? center,
  })  : innerRadius = innerRadius ??
            computeInnerRadius(
              area: area,
              perimeter: perimeter,
              width: width,
              outerRadius: outerRadius,
              centralAngle: centralAngle,
              sectorInteriorCircumference: sectorInteriorCircumference,
              sectorPerimeter: sectorPerimeter,
              sectorArea: sectorArea,
              interiorCircumference: interiorCircumference,
            ),
        outerRadius = outerRadius ??
            computeOuterRadius(
              area: area,
              perimeter: perimeter,
              width: width,
              innerRadius: innerRadius,
              centralAngle: centralAngle,
              sectorExteriorCircumference: sectorExteriorCircumference,
              sectorPerimeter: sectorPerimeter,
              sectorArea: sectorArea,
              exteriorCircumference: exteriorCircumference,
            ),
        centralAngle = centralAngle ??
            computeCentralAngle(
              innerRadius: innerRadius,
              outerRadius: outerRadius,
              sectorInteriorCircumference: sectorInteriorCircumference,
              sectorExteriorCircumference: sectorExteriorCircumference,
              sectorPerimeter: sectorPerimeter,
              sectorArea: sectorArea,
              exteriorCircumference: exteriorCircumference,
              interiorCircumference: interiorCircumference,
            ),
        center = center ?? Point(0, 0),
        super("Annulus") {
    if (this.innerRadius >= this.outerRadius) {
      throw ArgumentError('Inner radius must be less than outer radius.');
    }
  }

  @override
  double area() {
    return pi * (outerRadius * outerRadius - innerRadius * innerRadius);
  }

  @override
  double perimeter() {
    return 2 * pi * (outerRadius + innerRadius);
  }

  /// Returns the circumference of the outer circle of the annulus.
  double get exteriorCircumference => 2 * pi * outerRadius;

  /// Returns the circumference of the inner circle of the annulus.
  double get interiorCircumference => 2 * pi * innerRadius;

  /// Returns the mean radius of the annulus, which is
  /// the average of the inner and outer radii.
  double get meanRadius => (innerRadius + outerRadius) / 2;

  /// Return the annulus interior diameter
  double get interiorDiameter => 2.0 * innerRadius;

  /// Return the annulus exterior diameter
  double get exteriorDiameter => 2.0 * outerRadius;

  /// Returns the mean diameter of the annulus, which is
  /// twice the mean radius.
  double get meanDiameter => meanRadius * 2;

  /// Returns the breadth (width) of the annulus, which is the difference
  /// between the outer radius and the inner radius.
  double get width => outerRadius - innerRadius.toDouble();

  /// Calculates the area (S) of a sector of the annulus for a given central angle in radians.
  ///
  /// Formula: S(phi) = centralAngle * (outerRadius^2 - innerRadius^2) / 2
  double get sectorArea =>
      centralAngle!.rad *
      (outerRadius * outerRadius - innerRadius * innerRadius) /
      2;

  /// Calculates the exterior circumference (Cexterior) of a sector of the annulus for a given central angle (phi) in radians.
  ///
  /// Formula: Cexterior(phi) = phi * outerRadius
  double get sectorExteriorCircumference =>
      centralAngle!.rad * outerRadius.toDouble();

  /// Calculates the interior circumference (Cinterior) of a sector of the annulus for a given central angle (phi) in radians.
  ///
  /// Formula: Cinterior(phi) = phi * innerRadius
  double get sectorInteriorCircumference =>
      centralAngle!.rad * innerRadius.toDouble();

  /// Calculates the perimeter (p) of a sector of the annulus for a given central angle (phi) in radians.
  ///
  /// Formula: p(phi) = phi * (outerRadius + innerRadius) + 2 * (outerRadius - innerRadius)
  double get sectorPerimeter =>
      centralAngle!.rad * (outerRadius + innerRadius) +
      (2 * (outerRadius - innerRadius.toDouble()));

  /// Calculates the diagonal (d) of a sector of the annulus for a given central angle (phi) in radians.
  ///
  /// Uses the same formula as sectorDiagonal for clarity.
  double get sectorDiagonal => sqrt(outerRadius * outerRadius +
      innerRadius * innerRadius -
      2 * outerRadius * innerRadius * centralAngle!.cos());

  /// Computes the central angle (phi) of a sector of an annulus based on the provided parameters.
  ///
  /// This function can calculate the central angle using various combinations of parameters, such as:
  /// - Sector exterior circumference and outer radius
  /// - Sector interior circumference and inner radius
  /// - Sector perimeter, outer radius, and inner radius
  /// - Area of sector, outer radius, and inner radius
  /// - Exterior circumference and outer radius
  /// - Interior circumference and inner radius
  ///
  /// If insufficient or invalid parameters are provided, an [ArgumentError] will be thrown.
  ///
  /// Parameters:
  /// - `innerRadius`: The inner radius of the annulus.
  /// - `outerRadius`: The outer radius of the annulus.
  /// - `sectorInteriorCircumference`: The interior circumference of the sector.
  /// - `sectorExteriorCircumference`: The exterior circumference of the sector.
  /// - `sectorPerimeter`: The perimeter of the sector.
  /// - `areaOfSector`: The area of the sector.
  /// - `exteriorCircumference`: The exterior circumference of the annulus.
  /// - `interiorCircumference`: The interior circumference of the annulus.
  ///
  /// Returns:
  /// The computed central angle of the sector in radians.
  static Angle computeCentralAngle({
    num? area,
    num? innerRadius,
    num? outerRadius,
    num? sectorInteriorCircumference,
    num? sectorExteriorCircumference,
    num? sectorPerimeter,
    num? sectorArea,
    num? exteriorCircumference,
    num? interiorCircumference,
  }) {
    // Variables for calculations
    double phi = 0.0;

    // Determine phi based on provided parameters
    if (sectorExteriorCircumference != null && outerRadius != null) {
      phi = sectorExteriorCircumference / outerRadius;
    } else if (area != null && sectorArea != null) {
      phi = (360 * sectorArea) / area;
    } else if (sectorInteriorCircumference != null && innerRadius != null) {
      phi = sectorInteriorCircumference / innerRadius;
    } else if (sectorPerimeter != null &&
        outerRadius != null &&
        innerRadius != null) {
      phi = sectorPerimeter / (outerRadius + innerRadius);
    } else if (sectorArea != null &&
        outerRadius != null &&
        innerRadius != null) {
      phi = sectorArea /
          ((outerRadius * outerRadius) - (innerRadius * innerRadius));
    } else if (exteriorCircumference != null && outerRadius != null) {
      phi = exteriorCircumference / outerRadius;
    } else if (interiorCircumference != null && innerRadius != null) {
      phi = interiorCircumference / innerRadius;
    } else {
      throw ArgumentError('Insufficient or invalid parameters provided.');
    }

    // Return the computed central angle in radians
    return Angle(deg: phi);
  }

  /// Computes the inner radius of an annulus given various parameters.
  ///
  /// This function calculates the inner radius of an annulus based
  /// on the provided parameters.
  ///
  /// It supports different combinations such as:
  /// - Sector interior circumference and central angle
  /// - Sector perimeter, outer radius, and central angle
  /// - Sector area, outer radius, and central angle
  /// - Sector area, width, and central angle
  /// - Interior circumference only
  /// - Interior circumference and central angle
  /// - Area and perimeter of sector
  /// - Area and outer radius of annulus
  /// - Area and width of annulus
  /// - Perimeter and outer radius of annulus
  ///
  ///
  /// If sufficient and valid parameters are provided, the function will return the computed inner radius. If the provided parameters are insufficient or invalid, it will throw an [ArgumentError].
  ///
  /// Parameters:
  /// - `outerRadius`: The outer radius of the annulus.
  /// - `sectorInteriorCircumference`: The interior circumference of a sector of the annulus.
  /// - `sectorPerimeter`: The perimeter of a sector of the annulus.
  /// - `areaOfSector`: The area of a sector of the annulus.
  /// - `interiorCircumference`: The interior circumference of the annulus.
  /// - `centralAngle`: The central angle of the annulus.
  /// - `area`: The total area of the annulus.
  /// - `perimeter`: The total perimeter of the annulus.
  ///
  /// Returns:
  /// The computed inner radius of the annulus.
  static double computeInnerRadius({
    num? outerRadius,
    num? sectorInteriorCircumference,
    num? sectorPerimeter,
    num? sectorArea,
    num? interiorCircumference,
    Angle? centralAngle,
    num? area,
    num? perimeter,
    num? width,
  }) {
    if (sectorInteriorCircumference != null && centralAngle != null) {
      return sectorInteriorCircumference / centralAngle.rad;
    } else if (sectorPerimeter != null &&
        outerRadius != null &&
        centralAngle != null) {
      return (sectorPerimeter -
              (2 * outerRadius) -
              (outerRadius * centralAngle.rad)) /
          (2 + centralAngle.rad);
    } else if (sectorArea != null && width != null && centralAngle != null) {
      return ((sectorArea) / (centralAngle.rad * width)) - (width / 2);
    } else if (sectorArea != null &&
        outerRadius != null &&
        centralAngle != null) {
      return sqrt(
          (outerRadius * outerRadius) - (2 * sectorArea) / centralAngle.rad);
    } else if (interiorCircumference != null && centralAngle != null) {
      return interiorCircumference / centralAngle.rad;
    } else if (interiorCircumference != null) {
      return interiorCircumference / (2 * pi);
    } else if (area != null && perimeter != null) {
      return (perimeter / (4 * pi) - (area / perimeter));
    } else if (area != null && outerRadius != null) {
      return sqrt((outerRadius * outerRadius) - (area / pi));
    } else if (perimeter != null && outerRadius != null) {
      return (perimeter / (2 * pi)) - outerRadius;
    } else if (area != null && width != null) {
      return (area / (2 * pi * width)) - (width / 2);
    } else {
      throw ArgumentError('Insufficient or invalid parameters provided.');
    }
  }

  /// Computes the outer radius of an annulus given various parameters.
  ///
  /// This function calculates the outer radius of an annulus based on
  /// the provided parameters.
  ///
  /// It supports different combinations such as:
  /// - Sector exterior circumference and central angle
  /// - Sector perimeter, inner radius, and central angle
  /// - Sector area, inner radius, and central angle
  /// - Sector area, width, and central angle
  /// - Exterior circumference only
  /// - Exterior circumference and central angle
  /// - Area and perimeter of sector
  /// - Area and inner radius of annulus
  /// - Area and width of annulus
  /// - Perimeter and inner radius of annulus
  ///
  /// Parameters:
  /// - `innerRadius`: The inner radius of the annulus.
  /// - `sectorExteriorCircumference`: The exterior circumference of a sector of the annulus.
  /// - `sectorPerimeter`: The perimeter of a sector of the annulus.
  /// - `sectorArea`: The area of a sector of the annulus.
  /// - `exteriorCircumference`: The total exterior circumference of the annulus.
  /// - `centralAngle`: The central angle of the annulus.
  /// - `area`: The total area of the annulus.
  /// - `perimeter`: The total perimeter of the annulus.
  /// - `width`: The width of the annulus.
  ///
  /// Returns:
  /// The computed outer radius of the annulus.
  static double computeOuterRadius({
    num? innerRadius,
    num? sectorExteriorCircumference,
    num? sectorPerimeter,
    num? sectorArea,
    num? exteriorCircumference,
    Angle? centralAngle,
    num? area,
    num? perimeter,
    num? width,
  }) {
    if (sectorExteriorCircumference != null && centralAngle != null) {
      return sectorExteriorCircumference / centralAngle.rad;
    } else if (sectorPerimeter != null &&
        innerRadius != null &&
        centralAngle != null) {
      return (sectorPerimeter +
              2 * innerRadius +
              innerRadius * centralAngle.rad) /
          (2 + centralAngle.rad);
    } else if (sectorArea != null && width != null && centralAngle != null) {
      return ((sectorArea) / (centralAngle.rad * width)) + (width / 2);
    } else if (sectorArea != null &&
        innerRadius != null &&
        centralAngle != null) {
      return sqrt(
          (2 * sectorArea) / centralAngle.rad + innerRadius * innerRadius);
    } else if (exteriorCircumference != null && centralAngle != null) {
      return exteriorCircumference / centralAngle.rad;
    } else if (exteriorCircumference != null) {
      return exteriorCircumference / (2 * pi);
    } else if (area != null && perimeter != null) {
      return (perimeter / (4 * pi) + (area / perimeter));
    } else if (area != null && innerRadius != null) {
      return sqrt((area / pi) + (innerRadius * innerRadius));
    } else if (perimeter != null && innerRadius != null) {
      return (perimeter / (2 * pi)) - innerRadius;
    } else if (area != null && width != null) {
      return (area / (2 * pi * width)) + (width / 2);
    } else {
      throw ArgumentError('Insufficient or invalid parameters provided.');
    }
  }

  @override
  String toString() {
    return 'Annulus(innerRadius: $innerRadius, outerRadius: $outerRadius, center: $center)';
  }
}

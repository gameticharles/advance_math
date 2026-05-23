import 'dart:math' as math;
import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Plane Geometry - Kite Tests', () {
    test('Kite side-angle constructor correctness', () {
      final kite = Kite(a: 5.0, b: 8.0, theta: math.pi / 6); // 30 degrees

      expect(kite.area(), closeTo(20.0, 1e-5)); // a * b * sin(30) = 40 * 0.5 = 20
      expect(kite.perimeter(), equals(26.0)); // 2 * (5 + 8) = 26
    });

    test('Kite fromDiagonals constructor correctness', () {
      final kite = Kite.fromDiagonals(6.0, 8.0);

      expect(kite.area(), equals(24.0)); // 0.5 * 6 * 8 = 24
      expect(() => kite.perimeter(), throwsStateError);
    });

    test('Kite invalid values validation', () {
      expect(() => Kite(a: -1, b: 5, theta: 0.5), throwsArgumentError);
      expect(() => Kite.fromDiagonals(5, -2), throwsArgumentError);
    });
  });

  group('Plane Geometry - AnnulusSector Tests', () {
    test('AnnulusSector calculation correctness', () {
      final sector = AnnulusSector(
        innerRadius: 3.0,
        outerRadius: 5.0,
        centralAngle: Angle(rad: math.pi / 2), // 90 degrees
      );

      final expectedArea = (math.pi / 4.0) * (25.0 - 9.0); // (pi/2)/2 * 16 = 4*pi
      final expectedPerimeter = (math.pi / 2.0) * (5.0 + 3.0) + 2.0 * (5.0 - 3.0); // 4*pi + 4

      expect(sector.area(), closeTo(expectedArea, 1e-5));
      expect(sector.perimeter(), closeTo(expectedPerimeter, 1e-5));
      expect(sector.width, equals(2.0));
      expect(sector.exteriorArcLength, closeTo(2.5 * math.pi, 1e-5));
      expect(sector.interiorArcLength, closeTo(1.5 * math.pi, 1e-5));
    });

    test('AnnulusSector invalid values validation', () {
      expect(
        () => AnnulusSector(innerRadius: 5, outerRadius: 3, centralAngle: Angle(rad: 1)),
        throwsArgumentError,
      );
      expect(
        () => AnnulusSector(innerRadius: -1, outerRadius: 3, centralAngle: Angle(rad: 1)),
        throwsArgumentError,
      );
    });
  });

  group('Solid Geometry - Hemisphere Tests', () {
    test('Hemisphere calculation correctness', () {
      final hemisphere = Hemisphere(3.0);

      final expectedVolume = (2.0 / 3.0) * math.pi * 27.0; // 18*pi
      final expectedTotalArea = 3.0 * math.pi * 9.0; // 27*pi
      final expectedCurvedArea = 2.0 * math.pi * 9.0; // 18*pi
      final expectedBaseArea = math.pi * 9.0; // 9*pi

      expect(hemisphere.volume(), closeTo(expectedVolume, 1e-5));
      expect(hemisphere.surfaceArea(), closeTo(expectedTotalArea, 1e-5));
      expect(hemisphere.curvedSurfaceArea(), closeTo(expectedCurvedArea, 1e-5));
      expect(hemisphere.baseArea(), closeTo(expectedBaseArea, 1e-5));
    });

    test('Hemisphere bounding box correctness', () {
      final hemisphere = Hemisphere(3.0, center: Point(1, 2, 3));
      final bbox = hemisphere.boundingBox();

      expect(bbox.min.x, equals(-2.0));
      expect(bbox.min.y, equals(-1.0));
      expect(bbox.min.z, equals(3.0));
      expect(bbox.max.x, equals(4.0));
      expect(bbox.max.y, equals(5.0));
      expect(bbox.max.z, equals(6.0));
    });
  });

  group('Solid Geometry - Capsule Tests', () {
    test('Capsule calculation correctness', () {
      final capsule = Capsule(2.0, 5.0);

      final expectedVolume = math.pi * 4.0 * 5.0 + (4.0 / 3.0) * math.pi * 8.0; // 20*pi + 10.667*pi
      final expectedArea = 2.0 * math.pi * 2.0 * 5.0 + 4.0 * math.pi * 4.0; // 20*pi + 16*pi = 36*pi

      expect(capsule.volume(), closeTo(expectedVolume, 1e-5));
      expect(capsule.surfaceArea(), closeTo(expectedArea, 1e-5));
      expect(capsule.totalHeight, equals(9.0)); // 5 + 2*2 = 9
    });

    test('Capsule bounding box correctness', () {
      final capsule = Capsule(2.0, 5.0, center: Point(0, 0, 0));
      final bbox = capsule.boundingBox();

      expect(bbox.min.x, equals(-2.0));
      expect(bbox.max.x, equals(2.0));
      expect(bbox.min.z, equals(-4.5)); // -(2.5 + 2) = -4.5
      expect(bbox.max.z, equals(4.5));
    });
  });

  group('Solid Geometry - ConeFrustum Tests', () {
    test('ConeFrustum calculation correctness', () {
      final frustum = ConeFrustum(4.0, 2.0, 3.0);

      final expectedVolume = (1.0 / 3.0) * math.pi * 3.0 * (16.0 + 8.0 + 4.0); // 28*pi
      final expectedSlantHeight = math.sqrt(9.0 + 4.0); // sqrt(13)
      final expectedLateralArea = math.pi * expectedSlantHeight * 6.0;
      final expectedTotalArea = expectedLateralArea + math.pi * 16.0 + math.pi * 4.0;

      expect(frustum.volume(), closeTo(expectedVolume, 1e-5));
      expect(frustum.slantHeight, closeTo(expectedSlantHeight, 1e-5));
      expect(frustum.surfaceArea(), closeTo(expectedTotalArea, 1e-5));
    });
  });

  group('Solid Geometry - HollowCylinder Tests', () {
    test('HollowCylinder calculation correctness', () {
      final shell = HollowCylinder(5.0, 3.0, 4.0);

      final expectedVolume = math.pi * 4.0 * (25.0 - 9.0); // 64*pi
      final expectedArea = 2.0 * math.pi * 8.0 * 4.0 + 2.0 * math.pi * 16.0; // 64*pi + 32*pi = 96*pi

      expect(shell.volume(), closeTo(expectedVolume, 1e-5));
      expect(shell.surfaceArea(), closeTo(expectedArea, 1e-5));
      expect(shell.wallThickness, equals(2.0));
    });

    test('HollowCylinder invalid validation', () {
      expect(() => HollowCylinder(3, 5, 4), throwsArgumentError);
      expect(() => HollowCylinder(5, -1, 4), throwsArgumentError);
    });
  });
}

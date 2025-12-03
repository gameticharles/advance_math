import 'package:advance_math/src/math/geometry/geometry.dart';
import 'package:test/test.dart';
import 'dart:math';

void main() {
  group('Solid Geometry Tests', () {
    group('Sphere', () {
      test('Volume and Surface Area', () {
        var sphere = Sphere(5.0);
        // Volume = 4/3 * pi * r^3
        expect(sphere.volume(), closeTo((4 / 3) * pi * 125, 1e-10));
        // Surface Area = 4 * pi * r^2
        expect(sphere.surfaceArea(), closeTo(4 * pi * 25, 1e-10));
      });

      test('Named Constructors', () {
        var s1 = Sphere.fromVolume(100);
        expect(s1.volume(), closeTo(100, 1e-10));

        var s2 = Sphere.fromSurfaceArea(50);
        expect(s2.surfaceArea(), closeTo(50, 1e-10));
      });

      test('Contains Point', () {
        var sphere = Sphere(10, center: Point(0, 0, 0));
        expect(sphere.contains(Point(5, 5, 5)), isTrue);
        expect(sphere.contains(Point(10, 0, 0)), isTrue);
        expect(sphere.contains(Point(11, 0, 0)), isFalse);
      });
    });

    group('Cylinder', () {
      test('Volume and Surface Area', () {
        var cylinder = Cylinder(radius: 3, height: 5);
        // Volume = pi * r^2 * h
        expect(cylinder.volume(), closeTo(pi * 9 * 5, 1e-10));
        // Surface Area = 2*pi*r*(r+h)
        expect(cylinder.surfaceArea(), closeTo(2 * pi * 3 * 8, 1e-10));
        // Lateral Area = 2*pi*r*h
        expect(cylinder.lateralSurfaceArea(), closeTo(2 * pi * 3 * 5, 1e-10));
      });
    });

    group('Cone', () {
      test('Volume and Surface Area', () {
        // 3-4-5 cone
        var cone = Cone(radius: 3, height: 4);
        expect(cone.slantHeight, closeTo(5, 1e-10));

        // Volume = 1/3 * pi * r^2 * h
        expect(cone.volume(), closeTo((1 / 3) * pi * 9 * 4, 1e-10));

        // Surface Area = pi*r*(r+s)
        expect(cone.surfaceArea(), closeTo(pi * 3 * (3 + 5), 1e-10));
      });
    });

    group('Rectangular Prism', () {
      test('Volume and Surface Area', () {
        var prism = RectangularPrism(length: 2, width: 3, height: 4);
        // Volume = 2*3*4 = 24
        expect(prism.volume(), equals(24));
        // Surface Area = 2*(6 + 8 + 12) = 52
        expect(prism.surfaceArea(), equals(52));
        // Diagonal = sqrt(4 + 9 + 16) = sqrt(29)
        expect(prism.diagonal, closeTo(sqrt(29), 1e-10));
      });

      test('Cube Constructor', () {
        var cube = RectangularPrism.cube(3);
        expect(cube.volume(), equals(27));
        expect(cube.length, equals(3));
        expect(cube.width, equals(3));
        expect(cube.height, equals(3));
      });
    });
  });
}

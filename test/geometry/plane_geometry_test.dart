import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';

void main() {
  group('Triangle Specializations', () {
    group('EquilateralTriangle', () {
      test('fromSide creates triangle with equal sides and 60° angles', () {
        var tri = EquilateralTriangle.fromSide(6.0);
        expect(tri.side, equals(6.0));
        expect(tri.a, equals(6.0));
        expect(tri.b, equals(6.0));
        expect(tri.c, equals(6.0));
        expect(tri.angleA!.deg, closeTo(60, 0.01));
        expect(tri.angleB!.deg, closeTo(60, 0.01));
        expect(tri.angleC!.deg, closeTo(60, 0.01));
      });

      test('area calculation is correct', () {
        var tri = EquilateralTriangle.fromSide(4.0);
        // Area = (√3/4) × side² = (√3/4) × 16 ≈ 6.928
        expect(tri.area(), closeTo(6.928, 0.001));
      });

      test('height calculation is correct', () {
        var tri = EquilateralTriangle.fromSide(6.0);
        // Height = (√3/2) × side = (√3/2) × 6 ≈ 5.196
        expect(tri.height, closeTo(5.196, 0.001));
      });

      test('fromHeight creates correct triangle', () {
        var tri = EquilateralTriangle.fromHeight(5.196);
        expect(tri.side, closeTo(6.0, 0.01));
      });

      test('fromArea creates correct triangle', () {
        var tri = EquilateralTriangle.fromArea(6.928);
        expect(tri.side, closeTo(4.0, 0.01));
      });
    });

    group('IsoscelesTriangle', () {
      test('creates triangle with two equal sides', () {
        var tri = IsoscelesTriangle(5.0, 6.0);
        expect(tri.equalSide, equals(5.0));
        expect(tri.baseLength, equals(6.0));
        expect(tri.b, equals(5.0));
        expect(tri.c, equals(5.0));
        expect(tri.a, equals(6.0));
      });

      test('base angles are equal', () {
        var tri = IsoscelesTriangle(5.0, 6.0);
        expect(tri.angleB!.deg, closeTo(tri.angleC!.deg, 0.01));
      });

      test('height to base is correct', () {
        var tri = IsoscelesTriangle(5.0, 6.0);
        // height = √(5² - 3²) = √(25 - 9) = 4
        expect(tri.heightToBase, closeTo(4.0, 0.01));
      });
    });

    group('ScaleneTriangle', () {
      test('creates triangle with all different sides', () {
        var tri = ScaleneTriangle(3.0, 4.0, 5.0);
        expect(tri.a, equals(3.0));
        expect(tri.b, equals(4.0));
        expect(tri.c, equals(5.0));
      });

      test('throws error if two sides are equal', () {
        expect(() => ScaleneTriangle(5.0, 5.0, 6.0), throwsArgumentError);
      });

      test('area calculation works correctly', () {
        var tri = ScaleneTriangle(3.0, 4.0, 5.0);
        // This is a right triangle, so area = (1/2) × 3 × 4 = 6
        expect(tri.area(), closeTo(6.0, 0.01));
      });
    });

    group('RightTriangle', () {
      test('creates triangle with correct hypotenuse', () {
        var tri = RightTriangle(3.0, 4.0);
        expect(tri.leg1, equals(3.0));
        expect(tri.leg2, equals(4.0));
        expect(tri.hypotenuse, closeTo(5.0, 0.01));
      });

      test('fromHypotenuse creates correct triangle', () {
        var tri = RightTriangle.fromHypotenuse(3.0, 5.0);
        expect(tri.leg1, equals(3.0));
        expect(tri.hypotenuse, equals(5.0));
        expect(tri.leg2, closeTo(4.0, 0.01));
      });

      test('area calculation is correct', () {
        var tri = RightTriangle(3.0, 4.0);
        expect(tri.area(), equals(6.0));
      });

      test('identifies Pythagorean triple', () {
        var tri = RightTriangle(3.0, 4.0);
        expect(tri.isPythagoreanTriple(), isTrue);

        var tri2 = RightTriangle(3.5, 4.5);
        expect(tri2.isPythagoreanTriple(), isFalse);
      });
    });
  });

  group('Rhombus', () {
    test('creates rhombus with side and angle', () {
      var rhombus = Rhombus(5.0, angle: Angle(deg: 60));
      expect(rhombus.side, equals(5.0));
      expect(rhombus.angle1!.deg, equals(60));
      expect(rhombus.angle2!.deg, equals(120));
    });

    test('fromDiagonals calculates side correctly', () {
      var rhombus = Rhombus.fromDiagonals(6.0, 8.0);
      // side = √((6/2)² + (8/2)²) = √(9 + 16) = 5
      expect(rhombus.side, closeTo(5.0, 0.01));
    });

    test('area calculation using diagonals', () {
      var rhombus = Rhombus.fromDiagonals(6.0, 8.0);
      expect(rhombus.area(), equals(24.0));
    });

    test('perimeter calculation', () {
      var rhombus = Rhombus(5.0, angle: Angle(deg: 60));
      expect(rhombus.perimeter(), equals(20.0));
    });

    test('identifies square', () {
      var rhombus = Rhombus(5.0, angle: Angle(deg: 90));
      expect(rhombus.isSquare(), isTrue);
    });
  });

  group('Regular Polygons', () {
    group('Pentagon', () {
      test('has 5 sides and correct angles', () {
        var pentagon = Pentagon(4.0);
        expect(pentagon.numSides, equals(5));
        expect(pentagon.side, equals(4.0));
        expect(pentagon.interiorAngle.deg, equals(108));
        expect(pentagon.exteriorAngle.deg, equals(72));
      });

      test('area calculation is correct', () {
        var pentagon = Pentagon(4.0);
        // Area ≈ 27.528 for side = 4
        expect(pentagon.area(), closeTo(27.528, 0.01));
      });

      test('perimeter is correct', () {
        var pentagon = Pentagon(4.0);
        expect(pentagon.perimeter(), equals(20.0));
      });
    });

    group('Hexagon', () {
      test('has 6 sides and correct angles', () {
        var hexagon = Hexagon(4.0);
        expect(hexagon.numSides, equals(6));
        expect(hexagon.side, equals(4.0));
        expect(hexagon.interiorAngle.deg, equals(120));
        expect(hexagon.exteriorAngle.deg, equals(60));
      });

      test('area calculation is correct', () {
        var hexagon = Hexagon(4.0);
        // Area = (3√3/2) × 16 ≈ 41.569
        expect(hexagon.area(), closeTo(41.569, 0.01));
      });

      test('circumradius equals side', () {
        var hexagon = Hexagon(4.0);
        expect(hexagon.circumRadius, equals(4.0));
      });
    });

    group('Heptagon', () {
      test('has 7 sides and correct perimeter', () {
        var heptagon = Heptagon(5.0);
        expect(heptagon.numSides, equals(7));
        expect(heptagon.side, equals(5.0));
        expect(heptagon.perimeter(), equals(35.0));
      });

      test('area calculation is positive', () {
        var heptagon = Heptagon(5.0);
        expect(heptagon.area(), greaterThan(0));
      });
    });

    group('Octagon', () {
      test('has 8 sides and correct angles', () {
        var octagon = Octagon(5.0);
        expect(octagon.numSides, equals(8));
        expect(octagon.side, equals(5.0));
        expect(octagon.interiorAngle.deg, equals(135));
        expect(octagon.exteriorAngle.deg, equals(45));
      });

      test('area calculation is correct', () {
        var octagon = Octagon(5.0);
        // Area = 2(1 + √2) × 25 ≈ 120.71
        expect(octagon.area(), closeTo(120.71, 0.01));
      });

      test('perimeter is correct', () {
        var octagon = Octagon(5.0);
        expect(octagon.perimeter(), equals(40.0));
      });
    });
  });
}

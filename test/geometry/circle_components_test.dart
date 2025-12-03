import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';

void main() {
  group('Circle Components', () {
    group('Sector', () {
      test('creates sector with correct area', () {
        var sector = Sector.from(radius: 5.0, centralAngle: Angle(deg: 60));
        // Area = (θ/2) × r² = (π/3 / 2) × 25 ≈ 13.09
        expect(sector.area(), closeTo(13.09, 0.01));
      });

      test('calculates arc length correctly', () {
        var sector = Sector.from(radius: 5.0, centralAngle: Angle(deg: 60));
        // Arc length = θ × r = (π/3) × 5 ≈ 5.236
        expect(sector.arcLength, closeTo(5.236, 0.001));
      });

      test('calculates perimeter correctly', () {
        var sector = Sector.from(radius: 5.0, centralAngle: Angle(deg: 60));
        // Perimeter = 2r + arc = 10 + 5.236 ≈ 15.236
        expect(sector.perimeter(), closeTo(15.236, 0.001));
      });

      test('fromArcLength creates correct sector', () {
        var sector = Sector.fromArcLength(5.0, 5.236);
        expect(sector.centralAngle.deg, closeTo(60, 0.1));
      });

      test('fromArea creates correct sector', () {
        var sector = Sector.fromArea(5.0, 13.09);
        expect(sector.centralAngle.deg, closeTo(60, 0.1));
      });
    });

    group('Segment', () {
      test('creates segment with correct area', () {
        var segment = Segment.from(radius: 5.0, centralAngle: Angle(deg: 60));
        // Area = (r²/2) × (θ - sin(θ))
        expect(segment.area(), greaterThan(0));
        expect(segment.area(), lessThan(segment.sectorArea));
      });

      test('calculates chord length correctly', () {
        var segment = Segment.from(radius: 5.0, centralAngle: Angle(deg: 60));
        // Chord = 2r × sin(θ/2) = 10 × sin(30°) = 5
        expect(segment.chordLength, closeTo(5.0, 0.01));
      });

      test('calculates height correctly', () {
        var segment = Segment.from(radius: 5.0, centralAngle: Angle(deg: 60));
        // Height = r × (1 - cos(θ/2))
        expect(segment.height, greaterThan(0));
        expect(segment.height, lessThan(segment.radius));
      });

      test('fromChord creates correct segment', () {
        var segment = Segment.fromChord(5.0, 5.0);
        expect(segment.centralAngle.deg, closeTo(60, 0.1));
      });

      test('segment area is sector area minus triangle area', () {
        var segment = Segment.from(radius: 5.0, centralAngle: Angle(deg: 60));
        expect(segment.area(),
            closeTo(segment.sectorArea - segment.triangleArea, 0.001));
      });
    });

    group('Arc', () {
      test('creates arc with correct length', () {
        var arc = Arc.from(radius: 5.0, centralAngle: Angle(deg: 90));
        // Arc length = θ × r = (π/2) × 5 ≈ 7.854
        expect(arc.length, closeTo(7.854, 0.001));
      });

      test('calculates chord length correctly', () {
        var arc = Arc.from(radius: 5.0, centralAngle: Angle(deg: 90));
        // Chord = 2r × sin(45°) = 10 × 0.707... ≈ 7.071
        expect(arc.chordLength, closeTo(7.071, 0.001));
      });

      test('calculates sagitta correctly', () {
        var arc = Arc.from(radius: 5.0, centralAngle: Angle(deg: 90));
        expect(arc.sagitta, greaterThan(0));
        expect(arc.sagitta, lessThan(arc.radius));
      });

      test('fromLength creates correct arc', () {
        var arc = Arc.fromLength(5.0, 7.854);
        expect(arc.centralAngle.deg, closeTo(90, 0.1));
      });

      test('fromChord creates correct arc', () {
        var arc = Arc.fromChord(5.0, 7.071);
        expect(arc.centralAngle.deg, closeTo(90, 1.0));
      });

      test('pointAt interpolates correctly', () {
        var arc = Arc.from(radius: 5.0, centralAngle: Angle(deg: 90));
        var start = arc.pointAt(0);
        var end = arc.pointAt(1);
        var mid = arc.pointAt(0.5);

        // Start and end should be on the circle
        expect(arc.center.distanceTo(start), closeTo(arc.radius, 0.001));
        expect(arc.center.distanceTo(end), closeTo(arc.radius, 0.001));
        expect(arc.center.distanceTo(mid), closeTo(arc.radius, 0.001));
      });

      test('tangentAt gives perpendicular vector', () {
        var arc = Arc.from(radius: 5.0, centralAngle: Angle(deg: 90));
        var tangent = arc.tangentAt(0.5);

        // Tangent should have magnitude equal to radius
        expect(tangent.magnitude, closeTo(arc.radius, 0.001));
      });
    });

    group('ErrorEllipse', () {
      test('creates error ellipse from standard deviations', () {
        var errorEllipse = ErrorEllipse.from(
          sigmaX: 2.0,
          sigmaY: 1.0,
          correlation: 0.5,
          confidenceLevel: 0.95,
        );

        expect(errorEllipse.semiMajorAxis,
            greaterThan(errorEllipse.semiMinorAxis));
        expect(errorEllipse.area(), greaterThan(0));
      });

      test('calculates area correctly', () {
        var errorEllipse = ErrorEllipse.from(
          sigmaX: 2.0,
          sigmaY: 1.0,
          correlation: 0.0,
          confidenceLevel: 0.95,
        );

        // Area = π × semiMajor × semiMinor
        double expectedArea =
            pi * errorEllipse.semiMajorAxis * errorEllipse.semiMinorAxis;
        expect(errorEllipse.area(), closeTo(expectedArea, 0.001));
      });

      test('contains method works correctly', () {
        var errorEllipse = ErrorEllipse.from(
          sigmaX: 2.0,
          sigmaY: 1.0,
          correlation: 0.0,
          confidenceLevel: 0.95,
        );

        // Center should be inside
        expect(errorEllipse.contains(errorEllipse.center), isTrue);

        // Point far away should be outside
        expect(errorEllipse.contains(Point(100, 100)), isFalse);
      });

      test('eccentricity is between 0 and 1', () {
        var errorEllipse = ErrorEllipse.from(
          sigmaX: 3.0,
          sigmaY: 1.0,
          correlation: 0.0,
          confidenceLevel: 0.95,
        );

        expect(errorEllipse.eccentricity, greaterThanOrEqualTo(0));
        expect(errorEllipse.eccentricity, lessThan(1));
      });

      test('throws error for invalid confidence level', () {
        expect(
          () => ErrorEllipse.from(
            sigmaX: 2.0,
            sigmaY: 1.0,
            correlation: 0.0,
            confidenceLevel: 1.5,
          ),
          throwsArgumentError,
        );
      });

      test('throws error for invalid correlation', () {
        expect(
          () => ErrorEllipse.from(
            sigmaX: 2.0,
            sigmaY: 1.0,
            correlation: 2.0,
            confidenceLevel: 0.95,
          ),
          throwsArgumentError,
        );
      });
    });
  });
}

import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';
import 'package:advance_math/src/math/geometry/geometry.dart';

void main() {
  group('ErrorEllipse', () {
    test('Constructs from variance/covariance', () {
      // 95% confidence (ChiSq ~ 5.991)
      // SigmaX=1, SigmaY=1, Cov=0
      var ellipse = ErrorEllipse(
          sigmaX2: 1.0, sigmaY2: 1.0, sigmaXY: 0.0, confidenceLevel: 0.95);

      // Axes should be ~ sqrt(5.991) * 1 ~= 2.44
      expect(ellipse.semiMajorAxis, closeTo(2.447, 0.01));
      expect(ellipse.semiMinorAxis, closeTo(2.447, 0.01));
      expect(ellipse.orientationAngle, closeTo(0, 0.001));
    });

    test('Constructs from standard deviations', () {
      var ellipse = ErrorEllipse.fromStandardDeviations(
          sigmaX: 2.0,
          sigmaY: 1.0,
          correlation: 0.5,
          confidenceLevel: 0.3935 // ~1-sigma 2D, scale ~ 1.0
          );

      // With scale ~1 (1-sigma), axes should reflect eigenval of sigma coeffs
      // Not precisely 1.0 scale due to approximation, but close
      expect(ellipse.semiMajorAxis, greaterThan(ellipse.semiMinorAxis));
      expect(ellipse.sigmaX2, equals(4.0));
    });

    test('Contains point correctly', () {
      var ellipse = ErrorEllipse(
          sigmaX2: 4.0,
          sigmaY2: 1.0,
          sigmaXY: 0.0,
          confidenceLevel: 0.95 // Scale ~2.45
          );
      // Major axis ~ 2*2.45 = 4.9, Minor ~ 1*2.45 = 2.45

      expect(ellipse.contains(Point(0, 0)), isTrue);
      expect(ellipse.contains(Point(4.0, 0)), isTrue); // Within 4.9
      expect(ellipse.contains(Point(6.0, 0)), isFalse); // Outside
      expect(ellipse.contains(Point(0, 2.0)), isTrue); // Within 2.45
    });

    test('Updates parameters dynamically', () {
      var ellipse = ErrorEllipse(sigmaX2: 1.0, sigmaY2: 1.0, sigmaXY: 0.0);
      var oldArea = ellipse.area();

      ellipse.updateParameters(newSigmaX2: 4.0);
      expect(ellipse.area(), greaterThan(oldArea.toDouble()));
      expect(ellipse.sigmaX2, equals(4.0));
    });

    test('Serialization (Validation)', () {
      var ellipse = ErrorEllipse(
          sigmaX2: 2.0, sigmaY2: 1.0, sigmaXY: 0.5, center: Point(10, 20));

      var json = ellipse.toJson();
      expect(json['sigmaX2'], equals(2.0));
      expect(json['centerX'], equals(10));
      expect(json['bearing'], isNotNull);
      expect(json['aspectRatio'], isNotNull);

      var recovered = ErrorEllipse.fromJson(json);
      expect(recovered.sigmaXY, equals(0.5));
      expect(recovered.center.x, equals(10));
    });

    test('Bearing calculation', () {
      // 45 degrees orientation -> Bearing 45 (90-45)
      // If theta = 0 -> Bearing = 90
      var ellipse = ErrorEllipse(sigmaX2: 1.0, sigmaY2: 1.0, sigmaXY: 0.0);
      // Vert/Horiz depends on values, if equal it's circular-ish, theta is 0
      expect(ellipse.bearing, closeTo(90, 0.1));
    });
  });
}

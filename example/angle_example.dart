// Import the core SI library.
import 'package:advance_math/advance_math.dart';

void main() {
  //A (123.345, 678.901); B (100.321, 876.555); C (110, 410.234)
  print(Point(100.321, 876.555).bearingTo(Point(123.345, 678.901)));
  print(Point(100.321, 876.555)
      .bearingTo(Point(123.345, 678.901), isXAxis: false));
  print(Point(100.321, 876.555).bearingTo(Point(110, 410.234)));
  print(Point(100.321, 876.555).bearingTo(Point(110, 410.234), isXAxis: false));
  // Construct an Angle in radians.
  var ang = Angle(rad: 1.1);
  print('Angle1 (deg): ${ang.valueInUnits(AngleUnits.degrees)}');

  // Construct an Angle in degrees.
  final ang2 = Angle(deg: 270);
  print('Angle2 (deg): $ang2');

  // Find the difference.
  final diff = ang2 - ang as Angle;

  // Display the result in degrees.
  print('Difference (deg): ${diff.valueInUnits(AngleUnits.degrees)}');

  // Display the result in radians.
  print('Difference (rad): ${diff.valueInUnits(AngleUnits.radians)}');

  // Find the sum.
  final sum = ang2 + ang as Angle;

  // Display the result in degrees.
  print('Sum (deg): ${sum.valueInUnits(AngleUnits.degrees)}');

  // Display the result in radians.
  print('Sum (rad): ${sum.valueInUnits(AngleUnits.radians)}');
}

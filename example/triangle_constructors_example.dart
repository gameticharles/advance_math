import 'package:advance_math/advance_math.dart';

void main() {
  print('=== Lower Priority Constructor Examples ===\n');

  // Right Triangle
  print('Right Triangle from area and one leg:');
  var rightTri = RightTriangle.fromArea(area: 12.0, leg: 4.0);
  print('  Leg1: ${rightTri.leg1}, Leg2: ${rightTri.leg2}');
  print('  Hypotenuse: ${rightTri.hypotenuse}\n');

  print('Right Triangle from perimeter and one leg:');
  var rightTri2 = RightTriangle.fromPerimeter(perimeter: 12.0, leg: 3.0);
  print('  Leg1: ${rightTri2.leg1}, Leg2: ${rightTri2.leg2}');
  print('  Hypotenuse: ${rightTri2.hypotenuse}\n');

  // Isosceles Triangle
  print('Isosceles Triangle from area and base:');
  var isoTri = IsoscelesTriangle.fromAreaAndBase(area: 24.0, base: 6.0);
  print('  Equal Side: ${isoTri.equalSide}, Base: ${isoTri.baseLength}');
  print('  Apex Angle: ${isoTri.apexAngle}\n');

  print('Isosceles Triangle from perimeter and base:');
  var isoTri2 = IsoscelesTriangle.fromPerimeterAndBase(
    perimeter: 18.0,
    base: 6.0,
  );
  print('  Equal Side: ${isoTri2.equalSide}, Base: ${isoTri2.baseLength}');
  print('  Area: ${isoTri2.area()}\n');

  print('✅ All lower priority constructors completed!');
  print('Total Triangle Constructors Added: 5');
  print('  - RightTriangle: fromArea, fromPerimeter');
  print('  - IsoscelesTriangle: fromAreaAndBase, fromPerimeterAndBase');
  print('  - Plus existing: RightTriangle.fromHypotenuse');
}

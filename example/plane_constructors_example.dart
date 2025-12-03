import 'package:advance_math/advance_math.dart';

void main() {
  print('=== Plane Geometry Alternative Constructors ===\n');

  // Equilateral Triangle
  print('Equilateral Triangle from perimeter:');
  var equiTri = EquilateralTriangle.fromPerimeter(15.0);
  print('  Side: ${equiTri.side}');
  print('  Area: ${equiTri.area()}\n');

  print('Equilateral Triangle from inradius:');
  var equiTri2 = EquilateralTriangle.fromInradius(2.0);
  print('  Side: ${equiTri2.side}');
  print('  Circumradius: ${equiTri2.circumRadius}\n');

  // Rectangle
  print('Rectangle from area and aspect ratio (16:9):');
  var rect = Rectangle.fromAreaAndAspectRatio(area: 144, aspectRatio: 16 / 9);
  print('  Length: ${rect.length}');
  print('  Width: ${rect.width}\n');

  // Pentagon
  print('Pentagon from circumradius:');
  var pent = Pentagon.fromCircumradius(circumradius: 5.0);
  print('  Side: ${pent.side}');
  print('  Area: ${pent.area()}\n');

  print('Pentagon from area:');
  var pent2 = Pentagon.fromArea(area: 100.0);
  print('  Side: ${pent2.side}');
  print('  Perimeter: ${pent2.perimeter()}\n');

  // Hexagon
  print('Hexagon from inradius:');
  var hex = Hexagon.fromInradius(inradius: 4.0);
  print('  Side: ${hex.side}');
  print('  Area: ${hex.area()}\n');

  print('Hexagon from perimeter:');
  var hex2 = Hexagon.fromPerimeter(perimeter: 24.0);
  print('  Side: ${hex2.side}');
  print('  Area: ${hex2.area()}\n');

  // Heptagon
  print('Heptagon from area:');
  var hept = Heptagon.fromArea(area: 150.0);
  print('  Side: ${hept.side}');
  print('  Perimeter: ${hept.perimeter()}\n');

  // Octagon
  print('Octagon from circumradius:');
  var oct = Octagon.fromCircumradius(circumradius: 6.0);
  print('  Side: ${oct.side}');
  print('  Area: ${oct.area()}\n');

  print('Octagon from area:');
  var oct2 = Octagon.fromArea(area: 200.0);
  print('  Side: ${oct2.side}');
  print('  Apothem: ${oct2.apothem}');
}

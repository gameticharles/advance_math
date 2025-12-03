import 'package:advance_math/advance_math.dart';

void main() {
  print('--- Testing Solid Geometries ---\n');

  // Sphere
  print('Sphere (radius: 5):');
  var sphere = Sphere(5.0);
  print('  Volume: ${sphere.volume()}');
  print('  Surface Area: ${sphere.surfaceArea()}\n');

  // Cylinder
  print('Cylinder (radius: 3, height: 5):');
  var cylinder = Cylinder(radius: 3, height: 5);
  print('  Volume: ${cylinder.volume()}');
  print('  Surface Area: ${cylinder.surfaceArea()}');
  print('  Lateral Area: ${cylinder.lateralSurfaceArea()}\n');

  // Cone
  print('Cone (radius: 3, height: 4):');
  var cone = Cone(radius: 3, height: 4);
  print('  Slant Height: ${cone.slantHeight}');
  print('  Volume: ${cone.volume()}');
  print('  Surface Area: ${cone.surfaceArea()}\n');

  // Rectangular Prism
  print('Rectangular Prism (length: 2, width: 3, height: 4):');
  var prism = RectangularPrism(length: 2, width: 3, height: 4);
  print('  Volume: ${prism.volume()}');
  print('  Surface Area: ${prism.surfaceArea()}');
  print('  Diagonal: ${prism.diagonal}\n');

  // Cube (special case)
  print('Cube (side: 3):');
  var cube = RectangularPrism.cube(3);
  print('  Volume: ${cube.volume()}');
  print('  Surface Area: ${cube.surfaceArea()}');
  print('  Diagonal: ${cube.diagonal}');
}

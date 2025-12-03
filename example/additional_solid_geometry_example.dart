import 'package:advance_math/advance_math.dart';

void main() {
  print('=== Additional Solid Geometries Demo ===\n');

  // Ellipsoid
  print('Ellipsoid (semi-axes: 5, 4, 3):');
  var ellipsoid = Ellipsoid(a: 5, b: 4, c: 3);
  print('  Volume: ${ellipsoid.volume()}');
  print('  Surface Area: ${ellipsoid.surfaceArea()}\n');

  // Torus
  print('Torus (major radius: 5, minor radius: 2):');
  var torus = Torus(majorRadius: 5, minorRadius: 2);
  print('  Volume: ${torus.volume()}');
  print('  Surface Area: ${torus.surfaceArea()}\n');

  // Square Pyramid
  print('Square Pyramid (base: 6, height: 4):');
  var sqPyramid = SquarePyramid(baseSide: 6, height: 4);
  print('  Slant Height: ${sqPyramid.slantHeight}');
  print('  Volume: ${sqPyramid.volume()}');
  print('  Surface Area: ${sqPyramid.surfaceArea()}\n');

  // Tetrahedron (Regular)
  print('Regular Tetrahedron (edge: 6):');
  var tetrahedron = Tetrahedron.regular(edge: 6);
  print('  Height: ${tetrahedron.height}');
  print('  Volume: ${tetrahedron.volume()}');
  print('  Surface Area: ${tetrahedron.surfaceArea()}\n');

  // Triangular Prism
  print('Triangular Prism (sides: [3, 4, 5], height: 10):');
  var triPrism = TriangularPrism(baseSides: [3, 4, 5], height: 10);
  print('  Base Area: ${triPrism.baseArea}');
  print('  Volume: ${triPrism.volume()}');
  print('  Surface Area: ${triPrism.surfaceArea()}\n');

  // Equilateral Triangular Prism
  print('Equilateral Triangular Prism (side: 4, height: 12):');
  var eqTriPrism = TriangularPrism.equilateral(side: 4, height: 12);
  print('  Base Area: ${eqTriPrism.baseArea}');
  print('  Volume: ${eqTriPrism.volume()}\n');

  // Hexagonal Prism
  print('Hexagonal Prism (base side: 3, height: 8):');
  var hexPrism = HexagonalPrism(baseSide: 3, height: 8);
  print('  Base Area: ${hexPrism.baseArea}');
  print('  Volume: ${hexPrism.volume()}');
  print('  Surface Area: ${hexPrism.surfaceArea()}\n');

  print('=== Platonic Solids ===\n');

  // Octahedron
  print('Octahedron (edge: 4):');
  var octahedron = Octahedron(edge: 4);
  print('  Height: ${octahedron.height}');
  print('  Volume: ${octahedron.volume()}');
  print('  Surface Area: ${octahedron.surfaceArea()}');
  print('  Circumradius: ${octahedron.circumRadius}\n');

  // Dodecahedron
  print('Dodecahedron (edge: 3):');
  var dodecahedron = Dodecahedron(edge: 3);
  print('  Volume: ${dodecahedron.volume()}');
  print('  Surface Area: ${dodecahedron.surfaceArea()}\n');

  // Icosahedron
  print('Icosahedron (edge: 5):');
  var icosahedron = Icosahedron(edge: 5);
  print('  Volume: ${icosahedron.volume()}');
  print('  Surface Area: ${icosahedron.surfaceArea()}');
  print('  Circumradius: ${icosahedron.circumRadius}');
}

import 'package:advance_math/advance_math.dart';

void main() {
  print('=== Alternative Constructor Examples ===\n');

  // Ellipsoid
  print('Ellipsoid from volume and ratios:');
  var ellipsoid = Ellipsoid.fromVolumeAndRatios(
    volume: 100,
    ratioAB: 1.25,
    ratioAC: 1.5,
  );
  print('  a: ${ellipsoid.a}, b: ${ellipsoid.b}, c: ${ellipsoid.c}');
  print('  Volume: ${ellipsoid.volume()}\n');

  // Torus
  print('Torus from volume and major radius:');
  var torus = Torus.fromVolumeAndMajorRadius(volume: 100, majorRadius: 5);
  print('  Major: ${torus.majorRadius}, Minor: ${torus.minorRadius}');
  print('  Volume: ${torus.volume()}\n');

  // Square Pyramid
  print('Square Pyramid from slant height:');
  var pyramid = SquarePyramid.fromSlantHeight(baseSide: 6, slantHeight: 5);
  print('  Height: ${pyramid.height}');
  print('  Volume: ${pyramid.volume()}\n');

  // Tetrahedron
  print('Regular Tetrahedron from volume:');
  var tetra = Tetrahedron.fromVolume(volume: 50);
  print('  Edge: ${tetra.edge}');
  print('  Volume: ${tetra.volume()}\n');

  // Triangular Prism
  print('Equilateral Triangular Prism from volume and height:');
  var triPrism = TriangularPrism.fromVolumeEquilateralAndHeight(
    volume: 50,
    height: 10,
  );
  print('  Side: ${triPrism.baseSides[0]}');
  print('  Volume: ${triPrism.volume()}\n');

  // Hexagonal Prism
  print('Hexagonal Prism from volume and height:');
  var hexPrism = HexagonalPrism.fromVolumeAndHeight(volume: 100, height: 8);
  print('  Base Side: ${hexPrism.baseSide}');
  print('  Volume: ${hexPrism.volume()}\n');

  // Octahedron
  print('Octahedron from circumradius:');
  var octa = Octahedron.fromCircumradius(circumradius: 3);
  print('  Edge: ${octa.edge}');
  print('  Volume: ${octa.volume()}\n');

  // Dodecahedron
  print('Dodecahedron from surface area:');
  var dodeca = Dodecahedron.fromSurfaceArea(surfaceArea: 150);
  print('  Edge: ${dodeca.edge}');
  print('  Volume: ${dodeca.volume()}\n');

  // Icosahedron
  print('Icosahedron from volume:');
  var icosa = Icosahedron.fromVolume(volume: 80);
  print('  Edge: ${icosa.edge}');
  print('  Surface Area: ${icosa.surfaceArea()}');
}

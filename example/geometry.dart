import 'package:advance_math/advance_math.dart';

main() {
  var p = Polygon(vertices: [
    Point(591.40, 591.40),
    Point(652.40, 542.70),
    Point(783.50, 529.00),
    Point(896.20, 612.80),
    Point(810.90, 713.40),
    Point(685.90, 756.00),
    Point(562.50, 632.60)
  ]);

  print(p.shoelace());
  print(p.trapezoidal());

  // Example usage:
  Point centerPoint = Point(1, 2, 3);

  Cube cube1 = Cube(5.0, center: centerPoint);
  Cube cube2 = Cube.fromVolume(125, center: centerPoint);
  Cube cube3 = Cube.fromSurfaceArea(center: centerPoint, 150);

  print('Cube 1:');
  print('Vertices:');
  cube1.vertices().forEach((vertex) => print(vertex));
  print('Edges:');
  cube1.edges().forEach((edge) => print(edge));
  print('Space Diagonals:');
  cube1.spaceDiagonals().forEach((diagonal) => print(diagonal));
  print('Volume: ${cube1.volume()} cubic units');
  print('Surface Area: ${cube1.surfaceArea()} square units');
  print('');

  print('Cube 2:');
  print('Vertices:');
  cube2.vertices().forEach((vertex) => print(vertex));
  print('Edges:');
  cube2.edges().forEach((edge) => print(edge));
  print('Space Diagonals:');
  cube2.spaceDiagonals().forEach((diagonal) => print(diagonal));
  print('Volume: ${cube2.volume()} cubic units');
  print('Surface Area: ${cube2.surfaceArea()} square units');
  print('');

  print('Cube 3:');
  print('Vertices:');
  cube3.vertices().forEach((vertex) => print(vertex));
  print('Edges:');
  cube3.edges().forEach((edge) => print(edge));
  print('Space Diagonals:');
  cube3.spaceDiagonals().forEach((diagonal) => print(diagonal));
  print('Volume: ${cube3.volume()} cubic units');
  print('Surface Area: ${cube3.surfaceArea()} square units');
}

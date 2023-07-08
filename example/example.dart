import 'package:advance_math/advance_math.dart';

void printLine(String s) {
  var l = '--- ' * 10;
  print('\n$l$s $l\n');
}

List<String> findFactors(List<num> coefficients) {
  var dk = DurandKerner(coefficients.map((e) => Complex.fromReal(e)).toList());
  List<String> factors = [];
  List<dynamic> roots = dk.roots();
  print(dk.discriminant());

  for (Complex root in roots) {
    factors.add('(x ${root.real > 0 ? '-' : '+'} ${root.real} ${root.imag})');
  }

  return factors;
}

void main() {
  var vertices = [
    Point(1613.26, 2418.11),
    Point(1806.71, 2523.16),
    Point(1942.17, 2366.84),
    Point(1901.89, 2203.18),
    Point(1652.08, 2259.26)
  ];

  var polygon = Polygon(vertices: vertices);
  print(polygon);

  print("Shoelace formula: ${polygon.shoelace()}");
  print("Triangulation: ${polygon.triangulation()}");
  print("Trapezoidal rule: ${polygon.trapezoidal()}");
  print("Monte Carlo method (10,000 points): ${polygon.monteCarlo()}");
  print("Green's theorem: ${polygon.greensTheorem()}");
  print("\nCentroid: ${polygon.centroid()}");
  print("Moment of inertia: ${polygon.momentOfInertia()}");

  print("\nAngle Between Side 1 and 2: ${polygon.angleBetweenSides(0, 1)}");
  print("Length of side 1: ${polygon.sideLengthIrregular(0)}");
  print("Length of side 2: ${polygon.sideLengthIrregular(1)}");

  print(
      "\nIs Point(1806.71, 2523.16) inside: ${polygon.isPointInsidePolygon(Point(1806.71, 2400.16))}");
  print("Is convex: ${polygon.isConvex()}");

  print("\nBounding box: ${polygon.boundingBox()}");

  print("\nOriginal: ${polygon.vertices}");
  polygon.scale(2.5);
  print("\nScaled by 2.5: ${polygon.vertices}");

  polygon.scale(1 / 2.5);
  print("\nUnScale by 1/2.5: ${polygon.vertices}");

  polygon.translate(1.0, 1.0);
  print("\nTranslated by (1.0, 1.0): ${polygon.vertices}");

  print(
      "\nNearest point to polygon: ${polygon.nearestPointOnPolygon(Point(1920.17, 2200.18))}");

  var regPolygon = RegularPolygon(numSides: 5, sideLength: 4);

  print("\n\nArea: ${regPolygon.areaPolygon()}");
  print("Perimeter: ${regPolygon.perimeter()}");
  print("Interior angle: ${regPolygon.interiorAngle()}");
  print("Exterior angle: ${regPolygon.exteriorAngle()}");

  var perimeter = regPolygon.perimeter();
  var area = regPolygon.areaPolygon();
  var circumradius = regPolygon.circumradius();
  var inradius = regPolygon.inradius();

  polygon = Polygon(numSides: regPolygon.numSides);

  print(
      "Side length from perimeter: ${polygon.getSideLength(perimeter: perimeter)}");
  print("Side length from area: ${polygon.getSideLength(area: area)}");
  print(
      "Side length from circumradius: ${polygon.getSideLength(circumradius: circumradius)}");
  print(
      "Side length from inradius: ${polygon.getSideLength(inradius: inradius)}");

  printLine('Eigen matrix');

  var matr = Matrix.fromList([
    [4, 1, 1],
    [1, 4, 1],
    [1, 1, 4]
  ]);

  var eigen = matr.eigen();
  print('Eigen Values:\n${eigen.values}\n');
  print('Eigenvectors:');
  for (Matrix eigenvector in eigen.vectors) {
    print(eigenvector.round(1));
  }
  print('Verification: ${eigen.verify(matr)}');
  print('Reconstruct Original:\n ${eigen.check}');

  List<Matrix> normalizedEigenvectors =
      eigen.vectors.map((vector) => vector.normalize()).toList();
  Eigen normalizedEigen = Eigen(eigen.values, normalizedEigenvectors);

  print('Normalized eigenvectors:');
  for (Matrix eigenvector in normalizedEigen.vectors) {
    print(eigenvector.round());
  }
  print('Reconstruct Original:\n ${normalizedEigen.check}');

  eigen = Eigen([
    6,
    3,
    3
  ], [
    Column([1, 1, 1]),
    Column([-1, 0, 1]),
    Column([-1, 1, 0]),
  ]);
  print('Check Matrix: ${eigen.check}');
}

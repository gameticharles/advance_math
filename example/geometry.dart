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
}

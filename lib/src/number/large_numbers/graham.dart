part of 'large.dart';

/// ===============================
///  GRAHAM'S NUMBER
/// ===============================

class GrahamNumber {
  static String describe() => '''
Graham's Number (G):
  g(1) = 3↑↑↑↑3
  g(2) = 3↑^(g(1))3 (3 with g(1) up-arrows between)
  ...
  G = g(64)

Even g(1) is incomputable. G dwarfs all hyperoperations, yet TREE(3) dwarfs G.''';

  static String compare() => '''
Size Comparison:
  3^3 = 27
  3^^3 = 7,625,597,484,987
  3^^^3 = incomputable
  3^^^^3 = g(1)
  G = g(64)
  TREE(3) >> G''';
}

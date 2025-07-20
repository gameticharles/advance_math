part of '../../expression.dart';

class Identifier {
  final String name;

  Identifier(this.name) {
    assert(name != 'null');
    assert(name != 'false');
    assert(name != 'true');
    assert(name != 'this');
  }

  @override
  String toString() => name;
}

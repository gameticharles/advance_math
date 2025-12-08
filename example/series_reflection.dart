import 'package:dartframe/dartframe.dart';
import 'dart:mirrors';

void main() {
  print('=== Series Layout ===');
  try {
    var s = Series([1, 2, 3], name: 'test');
    var mirror = reflect(s);

    print('Methods/Getters:');
    for (var v in mirror.type.instanceMembers.values) {
      if (!v.isPrivate) {
        var name = MirrorSystem.getName(v.simpleName);
        if ([
          'sum',
          'mean',
          'median',
          'std',
          'stdDev',
          'var',
          'variance',
          'skew',
          'skewness',
          'kurt',
          'kurtosis',
          'min',
          'max'
        ].contains(name)) {
          print('- $name (${v.isGetter ? "getter" : "method"})');
        }
      }
    }
  } catch (e) {
    print('Reflection error: $e');
  }
}

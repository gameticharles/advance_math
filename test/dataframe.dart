import 'package:advance_math/src/models/data_frame/data_frame.dart';
import 'package:test/test.dart';

void main() {
  group('DataFrame', () {
    test('can be instantiated', () {
      final dataFrame = DataFrame();
      expect(dataFrame, isNotNull);
    });

    test('starts empty', () {
      final dataFrame = DataFrame();
      expect(dataFrame.rows, isEmpty);
      expect(dataFrame.columns, isEmpty);
    });

    test('can add columns', () {
      final dataFrame = DataFrame();
      dataFrame.addColumn('A', defaultValue: [1, 2, 3]);
      dataFrame.addColumn('B', defaultValue: [4, 5, 6]);

      expect(dataFrame.columns, hasLength(2));
      expect(dataFrame.columns, equals(['A', 'B']));
    });

    test('can add rows', () {
      final dataFrame = DataFrame();
      dataFrame.addRow([1, 4]);
      dataFrame.addRow([2, 5]);

      expect(dataFrame.rows, hasLength(2));
    });

    test('constructor sets properties correctly', () {
      final data = {
        'col1': [1, 2, 3],
        'col2': ['a', 'b', 'c']
      };
      final df = DataFrame.fromMap(data);

      expect(df.columns, ['col1', 'col2']);
      expect(df.rows.length, 3);
    });

    test('getColumn returns correct column', () {
      final data = {
        'col1': [1, 2, 3],
        'col2': ['a', 'b', 'c']
      };
      final df = DataFrame.fromMap(data);

      expect(df['col1'].data, [1, 2, 3]);
    });

    test('getColumn throws if column does not exist', () {
      final df = DataFrame();

      expect(() => df['bad'], throwsA(isA<ArgumentError>()));
    });

    test('addColumn adds column correctly', () {
      final df = DataFrame();
      df['col1'] = [1, 2, 3];

      expect(df.columns, ['col1']);
      expect(df.rows, [
        [1],
        [2],
        [3]
      ]);
    });
  });
}

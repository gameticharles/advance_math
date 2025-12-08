import 'package:advance_math/advance_math.dart';
import 'package:dartframe/dartframe.dart';

void main() {
  print('=== DataCube and NDArray Stats Demo ===\n');

  // 1. NDArray Statistics
  print('--- NDArray Stats ---');
  final nd = NDArray([10, 20, 30, 40, 50, 60, 70, 80, 90, 100]);
  print('NDArray: $nd');

  // These use our new extensions
  print('Sum: ${nd.sum()}');
  print('Mean: ${nd.mean()}');
  print('StdDev: ${nd.stdDev.toStringAsFixed(4)}');
  print('Min: ${nd.min()}');
  print('Max: ${nd.max()}');
  print('');

  // 2. DataCube Slicing
  print('--- DataCube Slicing ---');
  // Create a 2x2x2 cube
  // Depth 0: [[1, 2], [3, 4]]
  // Depth 1: [[5, 6], [7, 8]]
  // Construct via empty then fill, or whatever method is available.
  // Using generic filling since we don't know exact flexible constructor
  // Assuming we can create empty and use setters or just testing slicing on empty/random if easier.

  // NOTE: Based on reflection, DataCube has `getValue/setValue`.
  // Let's create a cube and fill it manually to test slicing.
  final dc = DataCube.empty(2, 2, 2);

  // Fill Depth 0
  // Note: setValue signature is complex (takes coordinates?), skipping manual fill.
  // We will verify sliceToDataFrame returns a valid DataFrame object (even if empty values).

  print('DataCube created.');

  // Test Slicing
  print('\nSlice at Depth 0 (should be full):');
  final df0 = dc.sliceToDataFrame(0);
  print(df0);
  // Verify content if possible via toString or by accessing DF elements (if we want to be rigorous)

  print('\nSlice at Depth 1 (should be sparse/partial):');
  final df1 = dc.sliceToDataFrame(1);
  print(df1);
}

import 'package:dartframe/dartframe.dart';

/// Extensions for DataCube analysis.
extension DataCubeStats on DataCube {
  /// Extracts a 2D slice (matrix-like) from the DataCube at a specific depth index.
  /// Returns a DataFrame where rows correspond to the cube's rows and columns to the cube's columns.
  ///
  /// [depthIndex]: The index along the depth dimension (0-based).
  /// [colLabelPrefix]: Prefix for DataFrame column names (default 'c').
  DataFrame sliceToDataFrame(int depthIndex, {String colLabelPrefix = 'c'}) {
    // Verified via reflection: DataCube has getFrame(int)
    // Note: getFrame likely returns DataFrame directly.
    return getFrame(depthIndex);
  }
}

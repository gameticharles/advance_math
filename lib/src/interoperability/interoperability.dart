part of advance_math;
/* TODO:
Interoperability:
   - Enable integration with other linear algebra libraries or frameworks (e.g., TensorFlow, NumPy)
 */

extension MatrixInteroperabilityExtension on Matrix {
  /// Creates a Matrix object from a CSV string or a CSV file.
  ///
  /// This method reads the CSV string or a CSV file specified by the input file path,
  /// using the specified delimiter, and constructs a Matrix object.
  ///
  /// [csv]: The CSV string to create the Matrix from (optional).
  /// [delimiter]: The delimiter to use in the CSV string (default: ',').
  /// [inputFilePath]: The input file path to read the CSV string from (optional).
  ///
  /// Example:
  /// ```dart
  /// String csv = '''
  /// 1.0,2.0,3.0
  /// 4.0,5.0,6.0
  /// 7.0,8.0,9.0
  /// ''';
  /// Matrix matrix = await Matrix.fromCSV(csv: csv);
  /// print(matrix);
  ///
  /// // Alternatively, read the CSV from a file:
  /// Matrix matrixFromFile = await Matrix.fromCSV(inputFilePath: 'input.csv');
  /// print(matrixFromFile);
  /// ```
  ///
  /// Output:
  /// ```
  /// Matrix: 3x3
  /// ┌ 1.0 2.0 3.0 ┐
  /// │ 4.0 5.0 6.0 │
  /// └ 7.0 8.0 9.0 ┘
  /// ```
  ///
  static Future<Matrix> fromCSV(
      {String? csv, String delimiter = ',', String? inputFilePath}) async {
    if (csv == null && inputFilePath != null) {
      File inputFile = File(inputFilePath);
      csv = await inputFile.readAsString();
    } else if (csv == null) {
      throw ArgumentError('Either csv or inputFilePath must be provided.');
    }

    List<List> rows = csv
        .trim()
        .split('\n')
        .map((row) =>
            row.split(delimiter).map((value) => double.parse(value)).toList())
        .toList();
    return Matrix.fromList(rows);
  }

  /// Converts the Matrix to a CSV string and optionally saves it to a file.
  ///
  /// This method converts the Matrix object to a CSV string, using the specified delimiter.
  /// If an output file path is provided, the CSV string will be saved to that file.
  ///
  /// [delimiter]: The delimiter to use in the CSV string (default: ',').
  /// [outputFilePath]: The output file path to save the CSV string (optional).
  ///
  /// Example:
  /// ```dart
  /// Matrix matrix = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  /// String csv = matrix.toCSV(outputFilePath: 'output.csv');
  /// print(csv);
  /// ```
  ///
  /// Output:
  /// ```
  /// 1.0,2.0,3.0
  /// 4.0,5.0,6.0
  /// 7.0,8.0,9.0
  /// ```
  ///
  Future<String> toCSV({String delimiter = ',', String? outputFilePath}) async {
    String csv =
        map((row) => row.map((value) => value.toString()).join(delimiter))
            .toList()
            .join('\n');

    if (outputFilePath != null) {
      File outputFile = File(outputFilePath);
      await outputFile.writeAsString(csv);
    }

    return csv;
  }

  /// Importing from JSON
  ///
  /// [jsonString]: A JSON-formatted string containing the matrix data.
  /// [inputFilePath]: A file path to a JSON file containing the matrix data.
  ///
  /// Example:
  /// ```dart
  /// Matrix myMatrix = Matrix.fromJSON(inputFilePath: 'path/to/matrix_data.json');
  /// ```
  /// Output:
  ///
  /// myMatrix will be constructed from the data in the specified JSON file.
  static Matrix fromJSON({String? jsonString, String? inputFilePath}) {
    if (jsonString == null && inputFilePath != null) {
      File inputFile = File(inputFilePath);
      jsonString = inputFile.readAsStringSync(); // synchronous read
    } else if (jsonString == null) {
      throw ArgumentError(
          'Either jsonString or inputFilePath must be provided.');
    }

    List<List> rows = jsonDecode(jsonString);
    return Matrix.fromList(rows);
  }

  /// Exporting to JSON
  ///
  /// [outputFilePath]: An optional file path to save the JSON representation of the matrix.
  ///
  /// Example:
  /// ```dart
  /// String jsonOutput = myMatrix.toJSON(outputFilePath: 'path/to/output_file.json');
  /// ```
  /// Output:
  ///
  /// The JSON representation of myMatrix will be saved to the specified file path, and
  /// jsonOutput will contain the JSON-formatted string.
  String toJSON({String? outputFilePath}) {
    String jsonString = jsonEncode(toList());

    if (outputFilePath != null) {
      File outputFile = File(outputFilePath);
      outputFile.writeAsStringSync(jsonString); // synchronous write
    }

    return jsonString;
  }

  /// Importing from binary
  /// byteData: ByteData object containing the matrix data
  /// jsonFormat (optional): Set to true to use JSON string format, false to use binary format (default: false)
  ///
  /// Expected output:
  /// m1 and m2 will be matrices with the same values as the original matrix stored in the ByteData object.
  ///
  /// Example:
  /// ```dart
  /// Matrix m1 = Matrix.fromBinary(byteData, jsonFormat: false); // Binary format
  /// Matrix m2 = Matrix.fromBinary(byteData, jsonFormat: true); // JSON format
  ///```
  static Matrix fromBinary(ByteData byteData, {bool jsonFormat = false}) {
    if (jsonFormat) {
      String jsonString = utf8.decode(byteData.buffer.asUint8List());
      return fromJSON(jsonString: jsonString);
    } else {
      int numRows = byteData.getInt32(0, Endian.little);
      int numCols = byteData.getInt32(4, Endian.little);
      int offset = 8;

      List<List<double>> rows =
          List.generate(numRows, (_) => List.filled(numCols, 0.0));
      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < numCols; j++) {
          rows[i][j] = byteData.getFloat64(offset, Endian.little);
          offset += 8;
        }
      }

      return Matrix.fromList(rows);
    }
  }

  /// Exporting to binary
  /// jsonFormat (optional): Set to true to use JSON string format, false to use binary format (default: false)
  ///
  /// Expected output:
  /// bd1 and bd2 will be ByteData objects containing the matrix data in the chosen format
  ///
  /// Example:
  /// ```data
  /// ByteData bd1 = matrix.toBinary(jsonFormat: false); // Binary format
  /// ByteData bd2 = matrix.toBinary(jsonFormat: true); // JSON format
  /// ```
  ByteData toBinary({bool jsonFormat = false}) {
    if (jsonFormat) {
      String jsonString = toJSON();
      return ByteData.view(utf8.encoder.convert(jsonString).buffer);
    } else {
      int numRows = rowCount;
      int numCols = columnCount;
      int bufferSize = 8 + numRows * numCols * 8;
      ByteData byteData = ByteData(bufferSize);

      byteData.setInt32(0, numRows, Endian.little);
      byteData.setInt32(4, numCols, Endian.little);
      int offset = 8;

      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < numCols; j++) {
          byteData.setFloat64(offset, this[i][j], Endian.little);
          offset += 8;
        }
      }
      return byteData;
    }
  }
}

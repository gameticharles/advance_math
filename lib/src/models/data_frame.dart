import 'dart:convert';
import 'dart:math';

import '../math/algebra/algebra.dart';

/// A class representing a DataFrame, which is a 2-dimensional labeled data structure
/// with columns of potentially different types.
class DataFrame {
  final List<dynamic> _columnNames;
  final List<dynamic> _data;

  /// Constructs a DataFrame with provided column names and data.
  ///
  /// Throws an ArgumentError if the number of column names does not match the number
  /// of data columns or if any data column has a different length.
  DataFrame._(this._columnNames, this._data) {
    // Validate data structure (e.g., all columns have the same length)
    if (_columnNames.length != _data[0].length) {
      throw ArgumentError(
          'Number of column names must match number of data columns.');
    }
    for (var i = 1; i < _data.length; i++) {
      if (_data[i].length != _data[0].length) {
        throw ArgumentError('All data columns must have the same length.');
      }
    }
  }

  /// Constructs a DataFrame with the provided column names and data.
  ///
  /// - The [columnNames] parameter specifies the names of the columns in the DataFrame.
  ///
  /// - The [data] parameter specifies the actual data in the DataFrame, organized as a
  /// list of rows, where each row is represented as a list of values corresponding to
  /// the columns.
  ///
  /// Example:
  /// ```dart
  /// var columnNames = ['Name', 'Age', 'City'];
  /// var data = [
  ///   ['Alice', 30, 'New York'],
  ///   ['Bob', 25, 'Los Angeles'],
  ///   ['Charlie', 35, 'Chicago'],
  /// ];
  /// var df = DataFrame(columnNames, data);
  /// ```
  DataFrame(List<dynamic> columnNames, List<List<dynamic>> data)
      : _data = data,
        _columnNames = columnNames;

  /// Constructs a DataFrame from a CSV string.
  ///
  /// The CSV string can be provided directly or by specifying an input file path.
  /// The delimiter can be customized, and it's assumed that the CSV has a header row.
  ///
  /// Example:
  /// ```dart
  /// var csvData = 'Name,Age,City\nAlice,30,New York\nBob,25,Los Angeles\nCharlie,35,Chicago';
  /// var df = DataFrame.fromCSV(csv: csvData, delimiter: ',', hasHeader: true);
  /// ```
  factory DataFrame.fromCSV(
      {String? csv,
      String delimiter = ',',
      String? inputFilePath,
      bool hasHeader = true}) {
    if (csv == null && inputFilePath != null) {
      // Read file
      fileIO.readFromFile(inputFilePath).then((data) {
        csv = data;
      });
    } else if (csv == null) {
      throw ArgumentError('Either csv or inputFilePath must be provided.');
    }

    List<List> rows = csv!
        .trim()
        .split('\n')
        .map((row) => row.split(delimiter).map((value) => value).toList())
        .toList();

    // Extract column names from the first line
    final columnNames =
        hasHeader ? rows[0] : List.generate(rows[0].length, (i) => 'Column $i');

    return DataFrame._(columnNames, rows.sublist(1));
  }

  /// Constructs a DataFrame from a JSON string.
  ///
  /// The JSON string can be provided directly or by specifying an input file path.
  /// The JSON object is expected to be a list of objects with consistent keys.
  ///
  /// Example:
  /// ```dart
  /// var jsonData = '[{"Name": "Alice", "Age": 30, "City": "New York"}, '
  ///                '{"Name": "Bob", "Age": 25, "City": "Los Angeles"}, '
  ///                '{"Name": "Charlie", "Age": 35, "City": "Chicago"}]';
  /// var df = DataFrame.fromJson(jsonString: jsonData);
  /// ```
  factory DataFrame.fromJson({String? jsonString, String? inputFilePath}) {
    if (jsonString == null && inputFilePath != null) {
      // Read file
      fileIO.readFromFile(inputFilePath).then((data) {
        jsonString = data;
      });
    } else if (jsonString == null) {
      throw ArgumentError(
          'Either jsonString or inputFilePath must be provided.');
    }

    final jsonData = jsonDecode(jsonString!) as List;

    // Extract column names from the first object
    final columnNames = jsonData[0].keys.toList();

    // Extract data from all objects
    final data = jsonData
        .map((obj) => columnNames.map((name) => obj[name]).toList())
        .toList();

    return DataFrame._(columnNames, data);
  }

  /// Returns the column names of the DataFrame.
  List<dynamic> get columnNames => _columnNames;

  /// Returns the data of the DataFrame.
  List<dynamic> get data => _data;

  /// Returns the shape of the DataFrame as a tuple (number of rows, number of columns).
  ({int rows, int columns}) get shape =>
      (rows: _data.length, columns: _columnNames.length);

  /// Selects columns from the DataFrame by their names.
  ///
  /// Returns a new DataFrame containing only the selected columns.
  DataFrame select(List<String> columnNames) {
    final indices =
        columnNames.map((name) => _columnNames.indexOf(name)).toList();
    final selectedData = indices.map((index) => _data[index]).toList();
    return DataFrame._(columnNames, selectedData);
  }

  /// Selects columns from the DataFrame by their indices.
  ///
  /// Returns a new DataFrame containing only the selected columns.
  DataFrame selectByIndex(List<int> columnIndices) {
    final selectedColumnNames =
        columnIndices.map((index) => _columnNames[index]).toList();
    final selectedData = _data
        .map((row) => columnIndices.map((index) => row[index]).toList())
        .toList();
    return DataFrame._(selectedColumnNames, selectedData);
  }

  /// Selects rows from the DataFrame by their indices.
  ///
  /// Returns a new DataFrame containing only the selected rows.
  DataFrame selectRowsByIndex(List<int> rowIndices) {
    final selectedData = rowIndices.map((index) => _data[index]).toList();
    return DataFrame._(_columnNames, selectedData);
  }

  /// Filters rows from the DataFrame based on a condition.
  ///
  /// The condition is specified as a function that takes a map representing a row
  /// and returns a boolean indicating whether to keep the row.
  DataFrame filter(bool Function(Map<dynamic, dynamic>) condition) {
    final filteredData = _data
        .map((row) {
          final rowMap = Map.fromIterables(_columnNames, row);
          return condition(rowMap) ? row : null;
        })
        .where((row) => row != null)
        .toList();
    return DataFrame._(_columnNames, filteredData);
  }

  /// Replaces occurrences of old value with new value in all columns of the DataFrame.
  ///
  /// - If [matchCase] is true, replacements are case-sensitive.
  void replace(dynamic oldValue, dynamic newValue, {bool matchCase = true}) {
    for (var row in _data) {
      for (var i = 0; i < row.length; i++) {
        if (matchCase) {
          if (row[i] == oldValue) {
            row[i] = newValue;
          }
        } else {
          if (row[i].toString().toLowerCase() ==
              oldValue.toString().toLowerCase()) {
            row[i] = newValue;
          }
        }
      }
    }
  }

  /// Sorts the DataFrame based on a column.
  ///
  /// By default, the sorting is done in ascending order.
  void sort(String column, {bool ascending = true}) {
    final columnIndex = _columnNames.indexOf(column);
    if (columnIndex == -1) throw ArgumentError('Column does not exist.');
    _data.sort((a, b) {
      final aValue = a[columnIndex];
      final bValue = b[columnIndex];
      if (aValue == null || bValue == null) {
        return 0; // Could handle nulls differently depending on requirements
      }
      return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });
  }

  /// Returns the first `n` rows of the DataFrame.
  DataFrame head(int n) {
    final headData = _data.take(n).toList();
    return DataFrame._(_columnNames, headData);
  }

  /// Returns the last `n` rows of the DataFrame.
  DataFrame tail(int n) {
    final tailData = _data.skip(_data.length - n).toList();
    return DataFrame._(_columnNames, tailData);
  }

  /// Fills missing values in the DataFrame with the specified value.
  void fillna(dynamic value) {
    for (var i = 0; i < _data.length; i++) {
      for (var j = 0; j < _data[i].length; j++) {
        if (_data[i][j] == null) {
          _data[i][j] = value;
        }
      }
    }
  }

  /// Renames columns in the DataFrame according to the provided mapping.
  void rename(Map<String, String> columnMap) {
    _columnNames.asMap().forEach((index, name) {
      if (columnMap.containsKey(name)) {
        _columnNames[index] = columnMap[name];
      }
    });
  }

  /// Drops a specified column from the DataFrame.
  void drop(String column) {
    int columnIndex = _columnNames.indexOf(column);
    if (columnIndex == -1) {
      throw ArgumentError('Column $column does not exist.');
    }
    _columnNames.removeAt(columnIndex);
    for (var row in _data) {
      row.removeAt(columnIndex);
    }
  }

  /// Groups the DataFrame by a specified column.
  ///
  /// Returns a map where keys are unique values from the specified column,
  /// and values are DataFrames containing rows corresponding to the key.
  Map<dynamic, DataFrame> groupBy(String column) {
    int columnIndex = _columnNames.indexOf(column);
    if (columnIndex == -1) {
      throw ArgumentError('Column $column does not exist.');
    }

    Map<dynamic, List<List<dynamic>>> groups = {};
    for (var row in _data) {
      var key = row[columnIndex];
      groups.putIfAbsent(key, () => []);
      groups[key]!.add(row);
    }

    Map<dynamic, DataFrame> result = {};
    groups.forEach((key, value) {
      result[key] = DataFrame._(_columnNames, value);
    });

    return result;
  }

  /// Returns the frequency of each unique value in a specified column.
  Map<dynamic, int> valueCounts(String column) {
    int columnIndex = _columnNames.indexOf(column);
    if (columnIndex == -1) {
      throw ArgumentError('Column $column does not exist.');
    }

    Map<dynamic, int> counts = {};
    for (var row in _data) {
      var key = row[columnIndex];
      counts[key] = (counts[key] ?? 0) + 1;
    }

    return counts;
  }

  /// Provides a summary of numerical columns in the DataFrame.
  ///
  /// Calculates count, mean, standard deviation, minimum, quartiles, and maximum values
  /// for each numerical column.
  Map<String, Map<String, num>> describe() {
    Map<String, Map<String, num>> description = {};

    for (var i = 0; i < _columnNames.length; i++) {
      var columnName = _columnNames[i];
      var columnData = _data.map((row) => row[i]);

      var numericData = columnData.whereType<num>().toList();
      if (numericData.isEmpty) {
        // Not a numerical column, skip
        continue;
      }

      num count = numericData.length;
      num sum = numericData.fold(0, (prev, element) => prev + element);
      num mean = sum / count;

      num sumOfSquares =
          numericData.fold(0, (prev, element) => prev + pow(element - mean, 2));
      num variance = sumOfSquares / count;
      num std = sqrt(variance);

      var sortedData = numericData..sort();
      num min = sortedData.first;
      num max = sortedData.last;
      num q1 = sortedData[(count * 0.25).floor()];
      num median = sortedData[(count * 0.5).floor()];
      num q3 = sortedData[(count * 0.75).floor()];

      description[columnName] = {
        'count': count,
        'mean': mean,
        'std': std,
        'min': min,
        '25%': q1,
        '50%': median,
        '75%': q3,
        'max': max,
      };
    }

    return description;
  }

  /// Add a row to the DataFrame
  void addRow(List<dynamic> newRow) {
    if (newRow.length != _columnNames.length) {
      throw ArgumentError('New row length must match number of columns.');
    }
    _data.add(newRow);
  }

  /// Add a column to the DataFrame
  void addColumn({required String name, dynamic defaultValue}) {
    _columnNames.add(name);
    for (var row in _data) {
      row.add(defaultValue);
    }
  }

  /// Remove the first row from the DataFrame
  void removeFirstRow() {
    if (_data.isNotEmpty) {
      _data.removeAt(0);
    }
  }

  /// Remove the last row from the DataFrame
  void removeLastRow() {
    if (_data.isNotEmpty) {
      _data.removeLast();
    }
  }

  /// Remove a row at the specified index from the DataFrame
  void removeRowAt(int index) {
    if (index >= 0 && index < _data.length) {
      _data.removeAt(index);
    } else {
      throw ArgumentError('Index out of range.');
    }
  }

  /// Limit the DataFrame to a specified number of rows starting from a given index
  DataFrame limit(int limit, {int startIndex = 0}) {
    if (startIndex < 0 || startIndex >= _data.length) {
      throw ArgumentError('Invalid start index.');
    }

    final endIndex = startIndex + limit;
    final limitedData = _data.sublist(
        startIndex, endIndex < _data.length ? endIndex : _data.length);

    return DataFrame._(_columnNames, limitedData);
  }

  /// Count the number of zeros in a specified column
  int countZeros(String columnName) {
    int columnIndex = _columnNames.indexOf(columnName);
    if (columnIndex == -1) {
      throw ArgumentError('Column $columnName does not exist.');
    }

    int count = 0;
    for (var row in _data) {
      if (row[columnIndex] == 0) {
        count++;
      }
    }
    return count;
  }

  /// Count the number of null values in a specified column
  int countNulls(String columnName) {
    int columnIndex = _columnNames.indexOf(columnName);
    if (columnIndex == -1) {
      throw ArgumentError('Column $columnName does not exist.');
    }

    int count = 0;
    for (var row in _data) {
      if (row[columnIndex] == null) {
        count++;
      }
    }
    return count;
  }

  @override
  String toString() {
    // Calculate column widths
    List<int> columnWidths = [];
    for (var i = 0; i < _columnNames.length; i++) {
      int maxColumnWidth = _columnNames[i].toString().length;
      for (var row in _data) {
        int cellWidth = row[i].toString().length;
        if (cellWidth > maxColumnWidth) {
          maxColumnWidth = cellWidth;
        }
      }
      columnWidths.add(maxColumnWidth);
    }

    // Construct the table string
    StringBuffer buffer = StringBuffer();

    // Add header row
    for (var i = 0; i < _columnNames.length; i++) {
      buffer.write(_columnNames[i].toString().padRight(columnWidths[i] + 2));
    }
    buffer.writeln();

    // Add data rows
    for (var row in _data) {
      for (var i = 0; i < row.length; i++) {
        buffer.write(row[i].toString().padRight(columnWidths[i] + 2));
      }
      buffer.writeln();
    }

    return buffer.toString();
  }
}

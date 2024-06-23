library dataframe;

import 'dart:convert';
import 'dart:math';

import 'package:intl/intl.dart';

import '../../math/algebra/algebra.dart';

part 'series.dart';

/// A class representing a DataFrame, which is a 2-dimensional labeled data structure
/// with columns of potentially different types.
class DataFrame {
  List<dynamic> _columns = List.empty(growable: true);
  List<dynamic> _data = List.empty(growable: true);
  final bool allowFlexibleColumns;
  dynamic replaceMissingValueWith;
  List<dynamic> _missingDataIndicator = List.empty(growable: true);

  /// Constructs a DataFrame with provided column names and data.
  ///
  /// Throws an ArgumentError if the number of column names does not match the number
  /// of data columns or if any data column has a different length.
  DataFrame._(
    this._columns,
    this._data, {
    this.allowFlexibleColumns = false,
    this.replaceMissingValueWith,
    bool formatData = false,
    List<dynamic> missingDataIndicator = const [],
  }) : _missingDataIndicator = missingDataIndicator {
    // Validate data structure (e.g., all columns have the same length)
    // if (_columns.length != _data[0].length) {
    //   throw ArgumentError(
    //       'Number of column names must match number of data columns.');
    // }
    for (var i = 1; i < _data.length; i++) {
      if (_data[i].length != _data[0].length) {
        throw ArgumentError('All data columns must have the same length.');
      }
    }

    if (formatData) {
      // Clean and convert data
      _data = _data.map((row) => row.map(_cleanData).toList()).toList();
    }
  }

  /// Constructs a DataFrame with the provided column names and data.
  ///
  /// - The [columns] parameter specifies the names of the columns in the DataFrame.
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
  /// var df = DataFrame(columns: columnNames, data: data);
  /// ```
  DataFrame(
      {List<dynamic> columns = const [],
      List<List<dynamic>> data = const [],
      this.allowFlexibleColumns = false,
      this.replaceMissingValueWith,
      List<dynamic> missingDataIndicator = const [],
      bool formatData = false})
      : _missingDataIndicator = missingDataIndicator,
        _data = data,
        _columns = columns.isEmpty && data.isNotEmpty
            ? List.generate(data[0].length, (index) => 'Column${index + 1}')
            : columns {
    // ... validation based on allowFlexibleColumns ...
    if (formatData) {
      // Clean and convert data
      _data = data.map((row) => row.map(_cleanData).toList()).toList();
    }
  }

  dynamic _cleanData(dynamic value) {
    List<String> commonDateFormats = [
      'yyyy-MM-dd',
      'MM/dd/yyyy',
      'dd-MMM-yyyy'
    ]; // Customize as needed

    if (value == null || value == '' || _missingDataIndicator.contains(value)) {
      return replaceMissingValueWith; // Handle null values explicitly
    }

    // 1. Attempt Numeric Conversion
    if (value is String) {
      var numResult = num.tryParse(value);
      if (numResult != null) {
        return numResult;
      }
    }

    // 2. Attempt Boolean Conversion
    if (value is String) {
      var lowerValue = value.toLowerCase();
      if (lowerValue == 'true') {
        return true;
      } else if (lowerValue == 'false') {
        return false;
      }
    }

    // 3. Date/Time Parsing
    if (value is String) {
      for (var format in commonDateFormats) {
        try {
          return DateFormat(format).parseStrict(value);
        } catch (e) {
          null;
        }
      }
    }

    // 4. Attempt List Conversion
    if (value is String && value.startsWith('[') && value.endsWith(']')) {
      try {
        // Attempt parsing as JSON
        var decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded; // Return if successfully decoded as a list
        }
      } catch (e) {
        print('Error parsing list: $value');
      }

      // Fallback: Attempt to split as a comma-separated list
      try {
        return value
            .substring(1, value.length - 1)
            .split(','); // Remove brackets, split by comma
      } catch (e) {
        print('Error parsing as comma-separated list: $value');
      }
    }

    // Default: Return the original value
    return value;
  }

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
  factory DataFrame.fromCSV({
    String? csv,
    String delimiter = ',',
    String? inputFilePath,
    bool hasHeader = true,
    bool allowFlexibleColumns = false,
    dynamic replaceMissingValueWith,
    bool formatData = false,
    List missingDataIndicator = const [],
  }) {
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

    return DataFrame._(
      columnNames,
      rows.sublist(1),
      replaceMissingValueWith: replaceMissingValueWith,
      allowFlexibleColumns: allowFlexibleColumns,
      formatData: formatData,
      missingDataIndicator: missingDataIndicator,
    );
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
  factory DataFrame.fromJson({
    String? jsonString,
    String? inputFilePath,
    bool allowFlexibleColumns = false,
    dynamic replaceMissingValueWith,
    bool formatData = false,
    List missingDataIndicator = const [],
  }) {
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

    return DataFrame._(
      columnNames,
      data,
      replaceMissingValueWith: replaceMissingValueWith,
      allowFlexibleColumns: allowFlexibleColumns,
      formatData: formatData,
      missingDataIndicator: missingDataIndicator,
    );
  }

  /// Constructs a DataFrame from a map where keys are column names and values
  /// are lists representing column data.
  ///
  /// The [map] parameter is a map where keys represent column names and values
  /// represent column data as lists. All lists in the map must have the same
  /// length.
  ///
  /// Throws an [ArgumentError] if the lists in the map have different lengths.
  ///
  /// Example:
  /// ```dart
  /// Map<String, List<dynamic>> map = {
  ///   'A': [1, 2, 3],
  ///   'B': ['a', 'b', 'c'],
  ///   'C': [true, false, true],
  /// };
  ///
  /// // Create a DataFrame from the map
  /// DataFrame df = DataFrame.fromMap(map);
  /// print(df);
  /// ```
  factory DataFrame.fromMap(
    Map<String, List<dynamic>> map, {
    bool allowFlexibleColumns = false,
    dynamic replaceMissingValueWith,
    List missingDataIndicator = const [],
  }) {
    // Extract column names and data from the map
    List<String> columns = map.keys.toList();
    List<List<dynamic>> data = [];

    // Check if all lists have the same length
    int length = -1;
    for (var columnData in map.values) {
      if (length == -1) {
        length = columnData.length;
      } else if (columnData.length != length) {
        throw ArgumentError('All lists must have the same length');
      }
    }

    // Populate the DataFrame with the provided data
    for (int i = 0; i < length; i++) {
      List<dynamic> rowData = [];
      for (var columnData in map.values) {
        rowData.add(columnData[i]);
      }
      data.add(rowData);
    }

    return DataFrame(
      columns: columns,
      data: data,
      replaceMissingValueWith: replaceMissingValueWith,
      missingDataIndicator: missingDataIndicator,
    );
  }

  // Export the data as JSON
  ///
  /// Example usage:
  ///```dart
  /// String jsonString = jsonEncode(df.toJSON());
  /// print(jsonString);
  /// ```
  List<Map<String, dynamic>> toJSON() {
    return rows.map<Map<String, dynamic>>((row) {
      var rowMap = <String, dynamic>{};
      for (int i = 0; i < _columns.length; i++) {
        rowMap[_columns[i].toString()] = row[i];
      }
      return rowMap;
    }).toList();
  }

  /// Export the data to matrix
  ///
  ///Example:
  ///```dart
  ///df = DataFrame(
  ///  columns: ['A', 'B', 'C', 'D'],
  ///  data: [
  ///    [1, 2.5, 3, 4],
  ///    [2, 3.5, 4, 5],
  ///    [3, 4.5, 5, 6],
  ///    [4, 5.5, 6, 7],
  ///  ],
  ///);
  ///
  /// // Matrix: 4x4
  /// // ┌ 1 2.5 3 4 ┐
  /// // │ 2 3.5 4 5 │
  /// // │ 3 4.5 5 6 │
  /// // └ 4 5.5 6 7 ┘
  ///```
  Matrix toMatrix() => Matrix(rows);

  // Operator [] overridden to access column by index or name
  // Modified operator[] to return a Series
  /// Returns a [Series] for the specified column,
  /// accessed by index or name.
  ///
  /// If [key] is an integer, returns the Series for the column at that index.
  /// If [key] is a String, returns the Series for the column with that name.
  ///
  /// Throws an [IndexError] if the index is out of range.
  /// Throws an [ArgumentError] if the name does not match a column.
  /// Returns a [Series] for the specified column,
  /// accessed by index or name.
  ///
  /// If [key] is an integer, returns the Series for the column at that index.
  /// If [key] is a String, returns the Series for the column with that name.
  ///
  /// Throws an [IndexError] if the index is out of range.
  /// Throws an [ArgumentError] if the name does not match a column.
  Series operator [](dynamic key) {
    if (key is int) {
      if (key < 0 || key >= _columns.length) {
        throw IndexError.withLength(
          key,
          _columns.length,
          indexable: _columns,
          name: 'Index out of range',
          message: null,
        );
      }
      return Series(rows.map((row) => row[key]).toList(), name: _columns[key]);
    } else if (key is String) {
      int columnIndex = _columns.indexOf(key);
      if (columnIndex == -1) {
        throw ArgumentError.value(key, 'columnName', 'Column does not exist');
      }
      return Series(rows.map((row) => row[columnIndex]).toList(), name: key);
    } else {
      throw ArgumentError('Key must be an int or String');
    }
  }

  /// Overrides the index assignment operator `[]` to allow updating a row or column in the DataFrame.
  ///
  /// If the key is an integer, it updates the row at the specified index. The length of the data must match the number of columns.
  ///
  /// If the key is a string, it updates the column with the specified name. If the column already exists, it updates the existing column. If the column does not exist, it adds a new column. The length of the data must match the number of rows.
  ///
  /// Throws a `RangeError` if the index is out of range.
  /// Throws an `ArgumentError` if the length of the data does not match the number of columns or rows.
  /// Throws an `ArgumentError` if the key is not an integer or string.
  void operator []=(dynamic key, dynamic newData) {
    // if (newData is! List<dynamic> || newData is! Series) {
    //   throw ArgumentError('Data must be a List or Series');
    // }

    List<dynamic> data = newData is Series ? newData.data : newData;

    int columnIndex = -1;
    // Check if the key is an index
    if (key is int) {
      // Update the row at the specified index

      // Check if the index is valid
      if (key < 0 || key >= data.length) {
        throw RangeError('Index out of range');
      }

      // Check if the length of the data matches the number of columns
      if (data.length != columns.length) {
        throw ArgumentError('Length of data must match the number of columns');
      }

      columnIndex = key;
    }
    // Check if the key is a column label
    else if (key is String) {
      // If the column already exists, update it
      columnIndex = _columns.indexOf(key);
    }
    // Check if the key is list indices
    else if (key is List) {
    }
    // Check if the key is Series
    else if (key is Series) {
    }
    // Handle unsupported key types
    else {
      throw ArgumentError('Unsupported key type');
    }

    if (columnIndex != -1) {
      if (_data.isEmpty) {
        // Assume all new entries should be null
        _data = List.generate(data.length,
            (_) => List.filled(_columns.length, replaceMissingValueWith));
      }
      // Update existing column
      for (int i = 0; i < _data.length; i++) {
        _data[i][columnIndex] = data[i];
      }
    } else {
      // Otherwise, add a new column

      if (data.length != _data.length) {
        throw ArgumentError('Length of data must match the number of rows');
      }

      addColumn(key, defaultValue: data);
    }
  }

  /// Returns the column names of the DataFrame.
  List<dynamic> get columns => _columns;

  /// Set the columns names
  set columns(List<dynamic> columns) {
    if (columns.length != _columns.length) {
      if (allowFlexibleColumns == true) {
        // Handling mismatched lengths:
        if (columns.length > _columns.length) {
          // More columns provided: Replace old columns
          _columns = columns;
          for (var row in _data) {
            // Add nulls or a default value for newly added columns
            row.addAll(List.generate((columns.length - row.length).toInt(),
                (_) => replaceMissingValueWith));
          }
        } else if (columns.length < _columns.length) {
          // Fewer columns provided: Consider these options:
          _columns = columns
              .followedBy(_columns.getRange(columns.length, _columns.length))
              .toList();
        }
      } else {
        // Option 2: Throw an error if flexible columns are not allowed
        throw ArgumentError('Number of columns must match existing data.');
      }
    } else {
      _columns = columns;
    }
  }

  /// Returns the data of the DataFrame.
  List<dynamic> get rows => _data;

  /// Returns the shape of the DataFrame as a tuple (number of rows, number of columns).
  ({int rows, int columns}) get shape =>
      (rows: _data.length, columns: _columns.length);

  /// Selects columns from the DataFrame by their names.
  ///
  /// Returns a new DataFrame containing only the selected columns.
  DataFrame select(List<String> columnNames) {
    final indices = columnNames.map((name) => _columns.indexOf(name)).toList();
    final selectedData = indices.map((index) => _data[index]).toList();
    return DataFrame._(columnNames, selectedData);
  }

  /// Selects columns from the DataFrame by their indices.
  ///
  /// Returns a new DataFrame containing only the selected columns.
  DataFrame selectByIndex(List<int> columnIndices) {
    final selectedColumnNames =
        columnIndices.map((index) => _columns[index]).toList();
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
    return DataFrame._(_columns, selectedData);
  }

  /// Filters rows from the DataFrame based on a condition.
  ///
  /// The condition is specified as a function that takes a map representing a row
  /// and returns a boolean indicating whether to keep the row.
  DataFrame filter(bool Function(Map<dynamic, dynamic>) condition) {
    final filteredData = _data
        .map((row) {
          final rowMap = Map.fromIterables(_columns, row);
          return condition(rowMap) ? row : null;
        })
        .where((row) => row != null)
        .toList();
    return DataFrame._(_columns, filteredData);
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
    final columnIndex = _columns.indexOf(column);
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
    return DataFrame._(_columns, headData);
  }

  /// Returns the last `n` rows of the DataFrame.
  DataFrame tail(int n) {
    final tailData = _data.skip(_data.length - n).toList();
    return DataFrame._(_columns, tailData);
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
    _columns.asMap().forEach((index, name) {
      if (columnMap.containsKey(name)) {
        _columns[index] = columnMap[name];
      }
    });
  }

  /// Drops a specified column from the DataFrame.
  void drop(String column) {
    int columnIndex = _columns.indexOf(column);
    if (columnIndex == -1) {
      throw ArgumentError('Column $column does not exist.');
    }
    _columns.removeAt(columnIndex);
    for (var row in _data) {
      row.removeAt(columnIndex);
    }
  }

  /// Groups the DataFrame by a specified column.
  ///
  /// Returns a map where keys are unique values from the specified column,
  /// and values are DataFrames containing rows corresponding to the key.
  Map<dynamic, DataFrame> groupBy(String column) {
    int columnIndex = _columns.indexOf(column);
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
      result[key] = DataFrame._(_columns, value);
    });

    return result;
  }

  /// Returns the frequency of each unique value in a specified column.
  Map<dynamic, int> valueCounts(String column) {
    int columnIndex = _columns.indexOf(column);
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

  /// Summarizes the structure of the DataFrame.
  DataFrame structure() {
    var summaryData = <List<dynamic>>[];

    for (var column in _columns) {
      var columnData = this[column];
      var columnType = _analyzeColumnTypes(columnData);

      var row = [column, columnType];
      row.add(_countNullValues(columnData));
      summaryData.add(row);
    }

    var columnNames = ['Column Name', 'Data Type'];
    columnNames.add('Null Count');

    return DataFrame(columns: columnNames, data: summaryData);
  }

  /// Analyzes the data types within a column.
  Map<Type, int> _analyzeColumnTypes(Series columnData) {
    var typeCounts = <Type, int>{};
    for (var value in columnData.data) {
      if (value != null) {
        var valueType = value.runtimeType;
        typeCounts[valueType] = (typeCounts[valueType] ?? 0) + 1;
      }
    }
    return typeCounts;
  }

  /// Checks if a column has significantly mixed data types.
  bool _hasMixedTypes(Map<Type, int> typeCounts) {
    if (typeCounts.length < 2) {
      return false; // Single type is not mixed
    }

    // You can customize the logic for determining 'Mixed'
    var sortedCounts = typeCounts.values.toList()
      ..sort((b, a) => a.compareTo(b));
    return (sortedCounts[0] - sortedCounts[1]) / sortedCounts[0] < 0.5;
  }

  /// Counts null values in a column.
  int _countNullValues(Series columnData) {
    // ignore: prefer_void_to_null
    return columnData.data.whereType<Null>().length;
  }

  /// Provides a summary of numerical columns in the DataFrame.
  ///
  /// Calculates count, mean, standard deviation, minimum, quartiles, and maximum values
  /// for each numerical column.
  Map<String, Map<String, num>> describe() {
    Map<String, Map<String, num>> description = {};

    for (var i = 0; i < _columns.length; i++) {
      var columnName = _columns[i];
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
    if (_columns.isEmpty) {
      // DataFrame is empty, add columns first or adjust row length
      // Create columns based on the first row
      _columns = List.generate(newRow.length, (index) => 'Column${index + 1}');
    } else {
      // Ensure new row length matches existing column count
      if (newRow.length != _columns.length) {
        // Handle mismatch (e.g., adjust row or throw exception)
        throw ArgumentError('New row length must match number of columns.');
      }
    }
    _data = _data.isEmpty ? newRow : [_data, newRow];
  }

  /// Add a column to the DataFrame
  void addColumn(dynamic name, {dynamic defaultValue}) {
    if (_columns.contains(name)) {
      throw ArgumentError("Column '$name' already exists");
    }
    _columns = _columns.isEmpty ? [name] : [..._columns, name];

    for (var row in _data) {
      if (defaultValue.length == _data.length) {
        row.add(defaultValue[_data.indexOf(row)]);
      } else if (defaultValue.length != _data.length) {
        // the add the all the elements of the default value to the row
        // and the remaining becomes null
        row.add(defaultValue[_data.indexOf(row) < _data.length
            ? _data.indexOf(row)
            : defaultValue]);
      } else {
        if (defaultValue == null) {
          row.add(null);
        } else {
          row.add(defaultValue);
        }
      }
    }
  }

  /// Concatenates two DataFrames along the axis specified by 'axis'.
  ///
  /// Parameters:
  /// - other: The DataFrame to concatenate with this DataFrame.
  /// - axis (Optional): The axis along which to concatenate.
  ///   * 0 (default): Concatenates rows (appends DataFrames vertically)
  ///   * 1: Concatenates columns (joins DataFrames side-by-side)
  DataFrame concatenate(DataFrame other, {int axis = 0}) {
    switch (axis) {
      case 0: // Vertical Concatenation
        if (columns.length != other.columns.length) {
          throw Exception(
              'DataFrames must have the same columns for vertical concatenation.');
        }
        var newData = List.from(_data)..addAll(other.rows);
        return DataFrame._(columns, newData);
      case 1: // Horizontal Concatenation
        List<dynamic> newColumns = List.from(columns)..addAll(other.columns);
        List<dynamic> newData = [];

        // Assume rows have the same length and structure
        for (int rowIndex = 0; rowIndex < _data.length; rowIndex++) {
          newData.add([..._data[rowIndex], ...other._data[rowIndex]]);
        }

        return DataFrame._(newColumns, newData);
      default:
        throw ArgumentError(
            'Invalid axis. Supported axes are 0 (vertical) or 1 (horizontal).');
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

    return DataFrame._(_columns, limitedData);
  }

  /// Count the number of zeros in a specified column
  int countZeros(String columnName) {
    int columnIndex = _columns.indexOf(columnName);
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
    int columnIndex = _columns.indexOf(columnName);
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
  noSuchMethod(Invocation invocation) {
    if (invocation.memberName != Symbol('[]') &&
        _columns.contains(invocation.memberName.toString())) {
      return this[invocation.memberName.toString()];
    }
    super.noSuchMethod(invocation);
  }

  // @override
  // noSuchMethod(Invocation invocation) {
  //   String columnName = invocation.memberName.toString();
  //   if (invocation.isGetter && _columns.contains(columnName.substring(2))) { // Important Changes!
  //     return this[columnName.substring(2)];
  //   }
  //   super.noSuchMethod(invocation);
  // }

  /// Shuffles the rows of the DataFrame.
  ///
  /// This method randomly shuffles the rows of the DataFrame in place. If a seed is provided,
  /// the shuffle is deterministic, allowing for reproducible shuffles. Without a seed,
  /// the shuffle order is random and different each time the method is called.
  ///
  /// Parameters:
  ///   - `seed` (optional): An integer value used to initialize the random number generator.
  ///     Providing a seed guarantees the shuffle order is the same across different runs
  ///     of the program. If omitted, the shuffle order is random and non-reproducible.
  ///
  /// Example:
  /// ```dart
  /// var df = DataFrame(
  ///   data: [
  ///     [1, 'A'],
  ///     [2, 'B'],
  ///     [3, 'C'],
  ///     [4, 'D'],
  ///   ],
  ///   columns: ['ID', 'Letter'],
  /// );
  ///
  /// print('Before shuffle:');
  /// print(df);
  ///
  /// // Shuffle without a seed
  /// var newDf = df.shuffle();
  /// print('After random shuffle:');
  /// print(newDf);
  ///
  /// // Shuffle with a seed for reproducibility
  /// newDf = df.shuffle(seed: 123);
  /// print('After shuffle with seed:');
  /// print(newDf);
  /// ```
  DataFrame shuffle({int? seed}) {
    final data = _data.toList();
    var random = seed != null ? Random(seed) : Random();
    for (int i = data.length - 1; i > 0; i--) {
      int n = random.nextInt(i + 1);
      var temp = data[i];
      data[i] = data[n];
      data[n] = temp;
    }

    return DataFrame._(_columns, data);
  }

  @override
  String toString({int columnSpacing = 2}) {
    // Calculate column widths
    List<int> columnWidths = [];
    for (var i = 0; i < _columns.length; i++) {
      int maxColumnWidth = _columns[i].toString().length;
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

    // Add index header
    buffer.write(' '.padRight(_data.length.toString().length +
        columnSpacing)); // Space for the index column

    // Add column headers (rest of the header is same as before)
    for (var i = 0; i < _columns.length; i++) {
      buffer.write(
          _columns[i].toString().padRight(columnWidths[i] + columnSpacing));
    }
    buffer.writeln();

    // Add data rows
    var indexWidth = _data.length.toString().length;
    for (int rowIndex = 0; rowIndex < _data.length; rowIndex++) {
      var row = _data[rowIndex];

      // Add row index
      buffer.write(rowIndex.toString().padRight(indexWidth + columnSpacing));

      // Add row data
      for (var i = 0; i < row.length; i++) {
        buffer
            .write(row[i].toString().padRight(columnWidths[i] + columnSpacing));
      }
      buffer.writeln();
    }

    return buffer.toString();
  }
}

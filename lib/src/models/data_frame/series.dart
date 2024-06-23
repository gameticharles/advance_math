part of 'data_frame.dart';

/// A `Series` class represents a one-dimensional array with a label.
///
/// The `Series` class is designed to hold a sequence of data of any type `T`,
/// where `T` can be anything from `int`, `double`, `String`, to custom objects.
/// Each `Series` object is associated with a name, typically representing the
/// column name when part of a DataFrame.
///
/// The class allows for future extensions where methods for common data
/// manipulations and analyses can be added, making it a fundamental building
/// block for handling tabular data.
///
/// Example usage:
/// ```dart
/// var numericSeries = Series<int>([1, 2, 3, 4], name: 'Numbers');
/// print(numericSeries); // Outputs: Numbers: [1, 2, 3, 4]
///
/// var stringSeries = Series<String>(['a', 'b', 'c'], name: 'Letters');
/// print(stringSeries); // Outputs: Letters: [a, b, c]
/// ```
class Series {
  /// The data of the series.
  ///
  /// This list holds the actual data points of the series. The generic type `T`
  /// allows the series to hold any type of data.
  List<dynamic> data;

  /// The name of the series.
  ///
  /// Typically represents the column name in a DataFrame and is used to
  /// identify the series.
  String name;

  /// Constructs a `Series` object with the given [data] and [name].
  ///
  /// The [data] parameter is a list containing the data points of the series,
  /// and the [name] parameter is a string representing the series' name.
  ///
  /// Parameters:
  /// - `data`: The data points of the series.
  /// - `name`: The name of the series. This parameter is required.
  Series(this.data, {required this.name});

  /// Returns a string representation of the series.
  ///
  /// This method overrides the `toString` method to provide a meaningful
  /// string representation of the series, including its name and data points.
  ///
  /// Returns:
  /// A string representing the series in the format: `name: data`
  @override
  String toString() => '$name: $data';
  // String toString() => toDataFrame().toString();

  /// Length of the data in the series
  int get length => data.length;

// Return the Series as a data frame
  DataFrame toDataFrame() => DataFrame.fromMap({name: data});

  /// Access elements by position or label using boolean indexing.
  ///
  /// Returns a new series containing only the elements for which the boolean condition is true.
  Series operator [](dynamic indices) {
    List<dynamic> selectedData = [];
    if (indices is List<bool>) {
      for (int i = 0; i < indices.length; i++) {
        if (indices[i]) {
          selectedData.add(data[i]);
        }
      }
    } else {
      // Handle single index
      selectedData.add(data[indices]);
    }
    return Series(selectedData, name: "$name (Selected)");
  }

  /// Sets the value for provided index or indices
  ///
  /// This method assigns the value or values to the Series as specified
  /// by the indices.
  ///
  /// Parameters:
  /// - indices: Represents which elements to modify. Can be a single index,
  ///   or potentially a list of indices for multiple assignments.
  /// - value: The value to assign. If multiple indices are provided, 'value'
  ///   should be an iterable such as a list or another Series.
  void operator []=(dynamic indices, dynamic value) {
    if (indices is int) {
      // Single Index Assignment
      if (indices < 0 || indices >= data.length) {
        throw IndexError.withLength(
          indices,
          data.length,
          indexable: this,
          name: 'Index out of range',
          message: null,
        );
      }
      data[indices] = value;
    } else if (indices is List<int>) {
      // Multiple Index Assignment
      if (value is! List || value.length != indices.length) {
        throw ArgumentError(
            "Value must be a list of the same length as the indices.");
      }
      for (int i = 0; i < indices.length; i++) {
        data[indices[i]] = value[i];
      }
    } else if (indices is List<bool> ||
        (indices is Series && indices.data is List<bool>)) {
      var dd = indices is Series ? indices.data : indices;
      if (value is List) {
        if (value.length != indices.length) {
          throw ArgumentError(
              "Value must be a list of the same length as the indices.");
        }
        for (int i = 0; i < indices.length; i++) {
          if (dd[i]) data[i] = value[i];
        }
      } else if (value is num) {
        for (int i = 0; i < indices.length; i++) {
          if (dd[i]) data[i] = value;
        }
      }
    } else {
      throw ArgumentError("Unsupported indices type.");
    }
  }

  /// **Addition (+) operator:**
  ///
  /// Adds the corresponding elements of this Series and another Series.
  ///
  /// Throws an exception if the Series have different lengths.
  Series operator +(Series other) {
    if (length != other.length) {
      throw Exception("Series must have the same length for addition.");
    }
    List<dynamic> resultData = [];
    for (int i = 0; i < length; i++) {
      resultData.add(data[i] + other.data[i]);
    }
    return Series(resultData, name: "($name + ${other.name})");
  }

  /// **Subtraction (-) operator:**
  ///
  /// Subtract the corresponding elements of this Series and another Series.
  ///
  /// Throws an exception if the Series have different lengths.
  Series operator -(Series other) {
    if (length != other.length) {
      throw Exception("Series must have the same length for subtraction.");
    }
    List<dynamic> resultData = [];
    for (int i = 0; i < length; i++) {
      resultData.add(data[i] - other.data[i]);
    }
    return Series(resultData, name: "($name - ${other.name})");
  }

  /// **Multiplication (*) operator:**
  ///
  /// Multiplies the corresponding elements of this Series and another Series.
  ///
  /// Throws an exception if the Series have different lengths.
  Series operator *(Series other) {
    if (length != other.length) {
      throw Exception("Series must have the same length for multiplication.");
    }
    List<dynamic> resultData = [];
    for (int i = 0; i < length; i++) {
      resultData.add(data[i] * other.data[i]);
    }
    return Series(resultData, name: name);
  }

  /// **Division (+) operator:**
  ///
  /// Divides the corresponding elements of this Series and another Series.
  ///
  /// Throws an exception if the Series have different lengths.
  Series operator /(Series other) {
    if (length != other.length) {
      throw Exception("Series must have the same length for division.");
    }
    List<dynamic> resultData = [];
    for (int i = 0; i < length; i++) {
      if (other.data[i] == 0) {
        throw Exception("Cannot divide by zero.");
      }
      resultData.add(data[i] / other.data[i]);
    }
    return Series(resultData, name: name);
  }

  /// **Floor Division (~/) operator:**
  ///
  /// Floor divides the corresponding elements of this Series and another Series.
  ///
  /// Throws an exception if the Series have different lengths.
  Series operator ~/(Series other) {
    if (length != other.length) {
      throw Exception("Series must have the same length for floor division.");
    }
    List<dynamic> resultData = [];
    for (int i = 0; i < length; i++) {
      resultData.add(data[i] ~/ other.data[i]);
    }
    return Series(resultData, name: name);
  }

  /// **Modulo (%) operator:**
  ///
  /// Mod the corresponding elements of this Series and another Series.
  ///
  /// Throws an exception if the Series have different lengths.
  Series operator %(Series other) {
    if (length != other.length) {
      throw Exception("Series must have the same length for modulo operation.");
    }
    List<dynamic> resultData = [];
    for (int i = 0; i < length; i++) {
      resultData.add(data[i] % other.data[i]);
    }
    return Series(resultData, name: name);
  }

  /// **Exponential (^) operator:**
  ///
  /// Take exponents of the corresponding elements of this Series and another Series.
  ///
  /// Throws an exception if the Series have different lengths.
  Series operator ^(Series other) {
    if (length != other.length) {
      throw Exception("Series must have the same length for exponentiation.");
    }
    List<dynamic> resultData = [];
    for (int i = 0; i < length; i++) {
      resultData.add(data[i] ^ other.data[i]);
    }
    return Series(resultData, name: name);
  }

  /// Less than (<) operator:
  ///
  /// Compares the corresponding elements of this Series and another Series
  /// to check if each element of this Series is less than the corresponding
  /// element of the other Series.
  ///
  /// Throws an exception if the Series have different lengths.
  Series operator <(dynamic other) {
    List<bool> resultData = [];
    if (other is num) {
      for (int i = 0; i < length; i++) {
        resultData.add(data[i] < other);
      }

      return Series(resultData, name: "$name < $other");
    } else if (other is Series) {
      if (length != other.length) {
        throw Exception("Series must have the same length for comparison.");
      }

      for (int i = 0; i < length; i++) {
        resultData.add(data[i] < other.data[i]);
      }
      return Series(resultData, name: "$name < ${other.name}");
    }

    throw Exception("Can only compare Series to Series or num.");
  }

  /// Greater than (>) operator:
  ///
  /// Compares the corresponding elements of this Series and another Series
  /// to check if each element of this Series is greater than the corresponding
  /// element of the other Series.
  ///
  /// Throws an exception if the Series have different lengths.
  Series operator >(dynamic other) {
    List<bool> resultData = [];
    if (other is num) {
      for (int i = 0; i < length; i++) {
        resultData.add(data[i] > other);
      }

      return Series(resultData, name: "$name > $other");
    } else if (other is Series) {
      if (length != other.length) {
        throw Exception("Series must have the same length for comparison.");
      }

      for (int i = 0; i < length; i++) {
        resultData.add(data[i] > other.data[i]);
      }
      return Series(resultData, name: "$name > ${other.name}");
    }

    throw Exception("Can only compare Series to Series or num.");
  }

  /// Less than or equal to (<=) operator:
  ///
  /// Compares the corresponding elements of this Series and another Series
  /// to check if each element of this Series is less than or equal to the
  /// corresponding element of the other Series.
  ///
  /// Throws an exception if the Series have different lengths.
  Series operator <=(dynamic other) {
    List<bool> resultData = [];
    if (other is num) {
      for (int i = 0; i < length; i++) {
        resultData.add(data[i] <= other);
      }

      return Series(resultData, name: "$name <= $other");
    } else if (other is Series) {
      if (length != other.length) {
        throw Exception("Series must have the same length for comparison.");
      }

      for (int i = 0; i < length; i++) {
        resultData.add(data[i] <= other.data[i]);
      }
      return Series(resultData, name: "$name <= ${other.name}");
    }

    throw Exception("Can only compare Series to Series or num.");
  }

  /// Greater than or equal to (>=) operator:
  ///
  /// Compares the corresponding elements of this Series and another Series
  /// to check if each element of this Series is greater than or equal to the
  /// corresponding element of the other Series.
  ///
  /// Throws an exception if the Series have different lengths.
  Series operator >=(dynamic other) {
    List<bool> resultData = [];
    if (other is num) {
      for (int i = 0; i < length; i++) {
        resultData.add(data[i] >= other);
      }

      return Series(resultData, name: "$name >= $other");
    } else if (other is Series) {
      if (length != other.length) {
        throw Exception("Series must have the same length for comparison.");
      }

      for (int i = 0; i < length; i++) {
        resultData.add(data[i] >= other.data[i]);
      }
      return Series(resultData, name: "$name >= ${other.name}");
    }

    throw Exception("Can only compare Series to Series or num.");
  }

  /// Equal to (==) operator:
  ///
  /// Compares the corresponding elements of this Series and another Series
  /// to check if each element of this Series is equal to the corresponding
  /// element of the other Series.
  ///
  /// If [other] is a Series, it compares each element of this series with
  /// the corresponding element of the other series.
  ///
  /// If [other] is not a Series, it compares each element of this series with
  /// the single value [other].
  ///
  /// Returns a new Series with boolean values indicating the equality of each
  /// element with the corresponding element in [other] or with the single value.
  ///
  /// Throws an exception if the Series have different lengths.
  Series isEqual(Object other) {
    if (other is! Series) {
      // Compare each element with the single value 'other'
      return Series(
        data.map((element) => element == other).toList(),
        name: "$name == $other",
      );
    }

    // Check if 'other' is of type Series
    if (length != other.length) {
      throw Exception("Series must have the same length for comparison.");
    }

    // Compare each element with the corresponding element in 'other'
    List<bool> resultData = [];
    for (int i = 0; i < length; i++) {
      resultData.add(data[i] == other.data[i]);
    }

    return Series(resultData, name: "$name == ${other.name}");
  }

  // /// Override hashCode to be consistent with the overridden '==' operator
  // @override
  // int get hashCode => data.hashCode ^ name.hashCode;

  /// Bitwise AND (&) operator.
  ///
  /// Performs a bitwise AND operation between the corresponding elements
  /// of this Series and another Series.
  ///
  /// Throws an exception if the Series have different lengths.
  Series operator &(Series other) {
    if (length != other.length) {
      throw Exception(
          "Series must have the same length for bitwise AND operation.");
    }
    List<dynamic> resultData = [];
    for (int i = 0; i < length; i++) {
      resultData.add(data[i] & other.data[i]);
    }
    return Series(resultData, name: name);
  }

  /// Bitwise OR (|) operator.
  ///
  /// Performs a bitwise OR operation between the corresponding elements
  /// of this Series and another Series.
  ///
  /// Throws an exception if the Series have different lengths.
  Series operator |(Series other) {
    if (length != other.length) {
      throw Exception(
          "Series must have the same length for bitwise OR operation.");
    }
    List<dynamic> resultData = [];
    for (int i = 0; i < length; i++) {
      resultData.add(data[i] | other.data[i]);
    }
    return Series(resultData, name: name);
  }

  /// Not equal to (!=) operator:
  ///
  /// Compares the corresponding elements of this Series and another Series
  /// to check if each element of this Series is not equal to the corresponding
  /// element of the other Series.
  ///
  /// Throws an exception if the Series have different lengths.
  Series notEqual(Series other) {
    if (length != other.length) {
      throw Exception("Series must have the same length for comparison.");
    }
    List<bool> resultData = [];
    for (int i = 0; i < length; i++) {
      resultData.add(data[i] != other.data[i]);
    }
    return Series(resultData, name: "$name != ${other.name}");
  }

  /// Count of non-null values in the series.
  int count() {
    return data.where((element) => element != null).length;
  }

  /// Mean (average) of the values in the series.
  double mean() {
    if (data.isEmpty) {
      throw Exception("Cannot calculate mean of an empty series.");
    }
    var sum = data.whereType<num>().reduce((value, element) => value + element);
    return sum / data.length;
  }

  /// Standard deviation of the values in the series.
  double std() {
    if (data.isEmpty) {
      throw Exception(
          "Cannot calculate standard deviation of an empty series.");
    }
    var m = mean();
    var variance =
        data.map((x) => pow(x - m, 2)).reduce((a, b) => a + b) / data.length;
    return sqrt(variance);
  }

  /// Minimum value in the series.
  num min() {
    if (data.isEmpty) {
      throw Exception("Cannot find minimum value of an empty series.");
    }
    return data.reduce((a, b) => a < b ? a : b);
  }

  /// Maximum value in the series.
  num max() {
    if (data.isEmpty) {
      throw Exception("Cannot find maximum value of an empty series.");
    }
    return data.reduce((a, b) => a > b ? a : b);
  }

  /// Summary statistics of the series.
  Map<String, num> describe() {
    if (data.isEmpty) {
      throw Exception("Cannot describe an empty series.");
    }
    var statistics = {
      'count': count(),
      'mean': mean(),
      'std': std(),
      'min': min(),
      '25%': quantile(0.25),
      '50%': quantile(0.50),
      '75%': quantile(0.75),
      'max': max(),
    };
    return statistics;
  }

  /// Calculate the sum of values in the series.
  ///
  /// Returns the sum of all values in the series.
  num sum() {
    if (data.every((element) => element == num)) {
      // If T is numeric, perform addition
      return data.reduce((value, element) => value + element);
    } else {
      throw Exception("Sum operation is supported only for numeric types.");
    }
  }

  /// Calculate the product of values in the series.
  ///
  /// Returns the product of all values in the series.
  num prod() {
    if (data.every((element) => element == num)) {
      // If T is numeric, perform multiplication
      return data.reduce((value, element) => value * element);
    } else {
      throw Exception("Product operation is supported only for numeric types.");
    }
  }

  /// Concatenates two Series along the axis specified by 'axis'.
  ///
  /// Parameters:
  /// - name: new name of the series
  /// - other: Another Series object to concatenate with this Series.
  /// - axis (Optional): The axis along which to concatenate.
  ///   * 0 (default): Vertical concatenation (one under the other)
  ///   * 1: Horizontal concatenation (side by side, requires same index/names)
  Series concatenate(Series other, {dynamic name, int axis = 0}) {
    switch (axis) {
      case 0: // Vertical concatenation
        List<dynamic> concatenatedData = List.from(data)..addAll(other.data);
        return Series(concatenatedData,
            name: name ?? "${this.name} - ${other.name}");

      case 1: // Horizontal concatenation (requires compatible structure)
        if (length != other.length) {
          throw Exception(
              'Series must have the same length for horizontal concatenation.');
        }
        // Assuming the 'name' is suitable for the newly joined Series
        return Series(data + other.data,
            name: name ?? "${this.name} - ${other.name}");

      default:
        throw Exception(
            'Invalid axis. Supported axes are 0 (vertical) or 1 (horizontal).');
    }
  }

  /// Calculate the cumulative sum of values in the series.
  ///
  /// Returns a new series containing the cumulative sum of values.
  Series cumsum() {
    List<num> cumulativeSum = [];
    num runningSum = data[0];
    cumulativeSum.add(runningSum);
    for (int i = 1; i < data.length; i++) {
      runningSum += data[i];
      cumulativeSum.add(runningSum);
    }
    return Series(cumulativeSum, name: "$name Cumulative Sum");
  }

  /// Find the index location of the maximum value in the series.
  ///
  /// Returns the index of the maximum value in the series.
  int idxmax() {
    num maxValue =
        data.reduce((value, element) => value > element ? value : element);
    return data.indexOf(maxValue);
  }

  /// Quantile (percentile) of the series.
  num quantile(double percentile) {
    if (data.isEmpty) {
      throw Exception("Cannot calculate quantile of an empty series.");
    }
    if (percentile < 0 || percentile > 1) {
      throw Exception("Percentile must be between 0 and 1.");
    }
    var sortedData = List<num>.from(data)..sort();
    var index = (sortedData.length - 1) * percentile;
    var lower = sortedData[index.floor()];
    var upper = sortedData[index.ceil()];
    return lower + (upper - lower) * (index - index.floor());
  }

  /// Applies a function to each element of the series.
  ///
  /// This method allows you to transform or modify the values in a series
  /// using a custom function.
  ///
  /// Parameters:
  /// - `func`: The function to apply to each element. It should take a single
  ///   argument of the same type as the elements in the series and return a
  ///   value of potentially different type.
  ///
  /// Returns:
  /// A new series containing the results of applying `func` to each element
  /// of the original series.
  ///
  /// Example:
  /// ```dart
  /// Series numbers = Series([1, 2, 3, 4], name: 'numbers');
  ///
  /// // Square each element
  /// Series squared_numbers = numbers.apply((number) => number * number);
  /// print(squared_numbers); // Output: numbers: [1, 4, 9, 16]
  ///
  /// // Convert to strings
  /// Series string_numbers = numbers.apply((number) => number.toString());
  /// print(string_numbers); // Output: numbers: [1, 2, 3, 4]
  /// ```
  Series apply(dynamic Function(dynamic) func) {
    return Series(
      data.map(func).toList(),
      name: name,
    );
  }

  /// Apply a function to each element of the series for substituting values.
  ///
  /// Returns a new series with the function applied to each element, replacing values.
  Series map(Function(dynamic) func) {
    List<dynamic> mappedData = data.map(func).toList();
    return Series(mappedData, name: "$name (Mapped)");
  }

  /// Sort the Series elements.
  ///
  /// Returns a new series with elements sorted in ascending order.
  Series sortValues() {
    List<dynamic> sortedData = List.from(data)..sort();
    return Series(sortedData, name: "$name (Sorted)");
  }

  /// Convert strings in the series to uppercase.
  ///
  /// Returns a new StringSeries with strings converted to uppercase.
  Series upper() {
    List<dynamic> stringData =
        data.whereType<String>().map((str) => str.toUpperCase()).toList();
    return Series(stringData, name: "$name (Upper)");
  }

  /// Convert strings in the series to lowercase.
  ///
  /// Returns a new StringSeries with strings converted to lowercase.
  Series lower() {
    List<dynamic> stringData =
        data.whereType<String>().map((str) => str.toLowerCase()).toList();
    return Series(stringData, name: "$name (Lower)");
  }

  /// Check if strings in the series contain a pattern.
  ///
  /// Returns a new Series with boolean values indicating whether each string contains the pattern.
  Series containsPattern(String pattern) {
    List<bool> containsPatternList =
        data.whereType<String>().map((str) => str.contains(pattern)).toList();
    return Series(containsPatternList, name: "$name Contains '$pattern'");
  }

  /// Replace parts of strings in the series with a new substring.
  ///
  /// Returns a new StringSeries with replaced substrings.
  Series replace(String oldSubstring, String newSubstring) {
    List<dynamic> replacedStrings = data
        .whereType<String>()
        .map((str) => str.replaceAll(oldSubstring, newSubstring))
        .toList();
    return Series(replacedStrings, name: "$name (Replaced)");
  }
}

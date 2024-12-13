part of '../algebra.dart';

// Abstract SparseMatrix class that extends Matrix
abstract class SparseMatrix extends Matrix {
  SparseFormat format;
  SparseMatrix(List<List<dynamic>> super.data, this.format);

  factory SparseMatrix.fromList(List<List<dynamic>> data, SparseFormat format) {
    switch (format) {
      case SparseFormat.coo:
        return SparseMatrixCOO.fromList(data);
      case SparseFormat.csr:
        return SparseMatrixCSR.fromList(data);
      case SparseFormat.csc:
        return SparseMatrixCSC.fromList(data);
      case SparseFormat.dok:
        return SparseMatrixDOK.fromList(data);
      case SparseFormat.lil:
        return SparseMatrixLIL.fromList(data);

    }
  }

  /// Returns the sparsity of the matrix, i.e., the proportion of zero elements.
  double get sparsity {
    int zeroCount = 0;
    for (List<dynamic> row in _data) {
      zeroCount += row.where((element) => element == 0).length;
    }
    return zeroCount / (rowCount * columnCount);
  }

  /// Adds another sparse matrix to this matrix.
  SparseMatrix add(SparseMatrix other) {
    // Error checking
    if (rowCount != other.rowCount || columnCount != other.columnCount) {
      throw ArgumentError(
          'Matrices must have the same dimensions for addition');
    }

    List<List<dynamic>> newData = List.generate(
        rowCount, (i) => List.filled(columnCount, 0, growable: false),
        growable: false);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        newData[i][j] = this[i][j] + other[i][j];
      }
    }
    return SparseMatrix.fromList(newData, format);
  }

  /// Multiplies this matrix by another sparse matrix.
  SparseMatrix multiply(SparseMatrix other) {
    // Error checking
    if (columnCount != other.rowCount) {
      throw ArgumentError(
          'Number of columns in first matrix must equal number of rows in second matrix for multiplication');
    }

    List<List<dynamic>> newData = List.generate(
        rowCount, (i) => List.filled(other.columnCount, 0, growable: false),
        growable: false);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < other.columnCount; j++) {
        for (int k = 0; k < columnCount; k++) {
          newData[i][j] += this[i][k] * other[k][j];
        }
      }
    }
    return SparseMatrix.fromList(newData, format);
  }

  // Common methods for all sparse matrix formats can be added here
}

// COO (Coordinate List) format sparse matrix
/// This class represents a SparseMatrix in the COO (Coordinate List) format.
/// It stores the row indices, column indices, and values of all non-zero elements in the matrix.
class SparseMatrixCOO extends SparseMatrix {
  List<int> rowIndices;
  List<int> colIndices;
  List<dynamic> values;
  int numRows;
  int numCols;

  /// Constructor for creating a SparseMatrixCOO from given row indices, column indices, and values.
  ///
  /// - rowIndices: List of row indices for each non-zero element.
  /// - colIndices: List of column indices for each non-zero element.
  /// - values: List of non-zero values in the matrix.
  /// - numRows: Number of rows in the matrix.
  /// - numCols: Number of columns in the matrix.
  SparseMatrixCOO(
      this.rowIndices, this.colIndices, this.values, this.numRows, this.numCols)
      : super(_initData(rowIndices, colIndices, values, numRows, numCols),
            SparseFormat.coo);

  factory SparseMatrixCOO.fromList(List<List<dynamic>> data) {
    List<int> rowIndices = [];
    List<int> colIndices = [];
    List<dynamic> values = [];

    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data[i].length; j++) {
        dynamic value = data[i][j];
        if (value != 0) {
          rowIndices.add(i);
          colIndices.add(j);
          values.add(value);
        }
      }
    }

    return SparseMatrixCOO(
        rowIndices, colIndices, values, data.length, data[0].length);
  }

  static List<List<dynamic>> _initData(List<int> rowIndices,
      List<int> colIndices, List<dynamic> values, int numRows, int numCols) {
    if (rowIndices.length != colIndices.length ||
        colIndices.length != values.length) {
      throw ArgumentError(
          'Lengths of rowIndices, colIndices, and values must all match');
    }

    // Initialize _data as a 2D list filled with zeros
    List<List<dynamic>> data = List.generate(
        numRows, (i) => List.filled(numCols, 0, growable: false),
        growable: false);

    // Fill _data with the non-zero values
    for (int i = 0; i < rowIndices.length; i++) {
      data[rowIndices[i]][colIndices[i]] = values[i];
    }
    return data;
  }

  // Override other methods as necessary
}

// CSR (Compressed Sparse Row) format sparse matrix
/// This class represents a SparseMatrix in the CSR (Compressed Sparse Row) format.
/// It stores the row pointers, column indices, and values of all non-zero elements in the matrix.
class SparseMatrixCSR extends SparseMatrix {
  List<int> rowPointers;
  List<int> colIndices;
  List<dynamic> values;
  int numRows;
  int numCols;

  /// Constructor for creating a SparseMatrixCSR from given row pointers, column indices, and values.
  ///
  /// - rowPointers: List of indices in colIndices/values marking the start of each row.
  /// - colIndices: List of column indices for each non-zero element.
  /// - values: List of non-zero values in the matrix.
  /// - numRows: Number of rows in the matrix.
  /// - numCols: Number of columns in the matrix.
  ///
  SparseMatrixCSR(this.rowPointers, this.colIndices, this.values, this.numRows,
      this.numCols)
      : super(_initData(rowPointers, colIndices, values, numRows, numCols),
            SparseFormat.csr);

  factory SparseMatrixCSR.fromList(List<List<dynamic>> data) {
    List<int> rowPointers = [0];
    List<int> colIndices = [];
    List<dynamic> values = [];

    for (List<dynamic> row in data) {
      for (int j = 0; j < row.length; j++) {
        dynamic value = row[j];
        if (value != 0) {
          colIndices.add(j);
          values.add(value);
        }
      }
      rowPointers.add(colIndices.length);
    }

    return SparseMatrixCSR(
        rowPointers, colIndices, values, data.length, data[0].length);
  }

  static List<List<dynamic>> _initData(List<int> rowPointers,
      List<int> colIndices, List<dynamic> values, int numRows, int numCols) {
    if (rowPointers.length != numRows + 1 ||
        colIndices.length != values.length) {
      throw ArgumentError(
          'Lengths of rowPointers, colIndices, and values must match the specified dimensions');
    }

    // Initialize _data as a 2D list filled with zeros
    List<List<dynamic>> data = List.generate(
        numRows, (i) => List.filled(numCols, 0, growable: false),
        growable: false);

    // Fill _data with the non-zero values
    for (int row = 0; row < numRows; row++) {
      for (int i = rowPointers[row]; i < rowPointers[row + 1]; i++) {
        data[row][colIndices[i]] = values[i];
      }
    }
    return data;
  }

  // Override other methods as necessary
}

// CSC (Compressed Sparse Column) format sparse matrix
/// This class represents a SparseMatrix in the CSC (Compressed Sparse Column) format.
/// It stores the column pointers, row indices, and values of all non-zero elements in the matrix.
class SparseMatrixCSC extends SparseMatrix {
  List<int> colPointers;
  List<int> rowIndices;
  List<dynamic> values;
  int numRows;
  int numCols;

  /// Constructor for creating a SparseMatrixCSC from given column pointers, row indices, and values.
  ///
  /// - colPointers: List of indices in rowIndices/values marking the start of each column.
  /// - rowIndices: List of row indices for each non-zero element.
  /// - values: List of non-zero values in the matrix.
  /// - numRows: Number of rows in the matrix.
  /// - numCols: Number of columns in the matrix.
  SparseMatrixCSC(this.colPointers, this.rowIndices, this.values, this.numRows,
      this.numCols)
      : super(_initData(colPointers, rowIndices, values, numRows, numCols),
            SparseFormat.csc);

  factory SparseMatrixCSC.fromList(List<List<dynamic>> data) {
    List<int> colPointers = [0];
    List<int> rowIndices = [];
    List<dynamic> values = [];

    for (int j = 0; j < data[0].length; j++) {
      for (int i = 0; i < data.length; i++) {
        dynamic value = data[i][j];
        if (value != 0) {
          rowIndices.add(i);
          values.add(value);
        }
      }
      colPointers.add(rowIndices.length);
    }

    return SparseMatrixCSC(
        colPointers, rowIndices, values, data.length, data[0].length);
  }

  static List<List<dynamic>> _initData(List<int> colPointers,
      List<int> rowIndices, List<dynamic> values, int numRows, int numCols) {
    // Error checking
    if (colPointers.length != numCols + 1 ||
        rowIndices.length != values.length) {
      throw ArgumentError('Invalid input data for CSC format');
    }

    // Initialize _data as a 2D list filled with zeros
    List<List<dynamic>> data = List.generate(
        numRows, (i) => List.filled(numCols, 0, growable: false),
        growable: false);

    // Fill _data with the non-zero values
    for (int col = 0; col < numCols; col++) {
      for (int i = colPointers[col]; i < colPointers[col + 1]; i++) {
        data[rowIndices[i]][col] = values[i];
      }
    }
    return data;
  }

  // Override other methods as necessary
}

// DOK (Dictionary of Keys) format sparse matrix
/// This class represents a SparseMatrix in the DOK (Dictionary of Keys) format.
/// It stores a dictionary with keys representing the (row, column) indices and values representing the non-zero elements in the matrix.
class SparseMatrixDOK extends SparseMatrix {
  Map<String, dynamic> values;
  int numRows;
  int numCols;

  /// Constructor for creating a SparseMatrixDOK from a given dictionary of keys-values.
  ///
  /// - values: Map of non-zero values in the matrix, with keys as 'row,column' strings.
  /// - numRows: Number of rows in the matrix.
  /// - numCols: Number of columns in the matrix.
  ///
  SparseMatrixDOK(this.values, this.numRows, this.numCols)
      : super(_initData(values, numRows, numCols), SparseFormat.dok);

  factory SparseMatrixDOK.fromList(List<List<dynamic>> data) {
    Map<String, dynamic> values = {};

    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data[i].length; j++) {
        dynamic value = data[i][j];
        if (value != 0) {
          values['$i,$j'] = value;
        }
      }
    }

    return SparseMatrixDOK(values, data.length, data[0].length);
  }

  static List<List<dynamic>> _initData(
      Map<String, dynamic> values, int numRows, int numCols) {
    // Initialize _data as a 2D list filled with zeros
    List<List<dynamic>> data = List.generate(
        numRows, (i) => List.filled(numCols, 0, growable: false),
        growable: false);

    // Fill _data with the non-zero values
    for (String key in values.keys) {
      List<int> indices = key.split(',').map((str) => int.parse(str)).toList();
      if (indices.length != 2 ||
          indices[0] < 0 ||
          indices[0] >= numRows ||
          indices[1] < 0 ||
          indices[1] >= numCols) {
        throw ArgumentError('Invalid index in DOK format');
      }
      data[indices[0]][indices[1]] = values[key];
    }
    return data;
  }

  // Override other methods as necessary
}

// LIL (List of Lists) format sparse matrix
/// This class represents a SparseMatrix in the LIL (List of Lists) format.
/// For each row, it stores a list of column indices and a list of values of all non-zero elements in the row.
class SparseMatrixLIL extends SparseMatrix {
  List<List<int>> rowIndices;
  List<List<dynamic>> values;
  int numRows;
  int numCols;

  /// Constructor for creating a SparseMatrixLIL from given row indices and values.
  ///
  /// - rowIndices: List of lists, where each inner list contains the column indices of non-zero elements for that row.
  /// - values: List of lists, where each inner list contains the non-zero values for that row.
  /// - numRows: Number of rows in the matrix.
  /// - numCols: Number of columns in the matrix.
  ///
  SparseMatrixLIL(this.rowIndices, this.values, this.numRows, this.numCols)
      : super(
            _initData(rowIndices, values, numRows, numCols), SparseFormat.lil);

  factory SparseMatrixLIL.fromList(List<List<dynamic>> data) {
    List<List<int>> rowIndices = List.generate(data.length, (_) => <int>[]);
    List<List<dynamic>> values = List.generate(data.length, (_) => <dynamic>[]);

    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data[i].length; j++) {
        dynamic value = data[i][j];
        if (value != 0) {
          rowIndices[i].add(j);
          values[i].add(value);
        }
      }
    }

    return SparseMatrixLIL(rowIndices, values, data.length, data[0].length);
  }

  static List<List<dynamic>> _initData(List<List<int>> rowIndices,
      List<List<dynamic>> values, int numRows, int numCols) {
    // Error checking
    if (rowIndices.length != values.length || rowIndices.length > numRows) {
      throw ArgumentError('Invalid input data for LIL format');
    }

    // Initialize _data as a 2D list filled with zeros
    List<List<dynamic>> data = List.generate(
        numRows, (i) => List.filled(numCols, 0, growable: false),
        growable: false);

    // Fill _data with the non-zero values
    for (int row = 0; row < rowIndices.length; row++) {
      if (rowIndices[row].length != values[row].length) {
        throw ArgumentError(
            'Mismatch between row indices and values in LIL format');
      }
      for (int i = 0; i < rowIndices[row].length; i++) {
        if (rowIndices[row][i] < 0 || rowIndices[row][i] >= numCols) {
          throw ArgumentError('Invalid column index in LIL format');
        }
        data[row][rowIndices[row][i]] = values[row][i];
      }
    }
    return data;
  }

  // Override other methods as necessary
}

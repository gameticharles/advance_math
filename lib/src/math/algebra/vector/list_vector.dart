part of '../algebra.dart';

extension ListVector on List<num> {
  Vector operator +(dynamic other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for addition.");
    }

    if (other is! Vector || other is! List<num>) {
      throw ArgumentError(
          "Invalid right-hand value type (Vector or List<num>).");
    }

    Vector result = Vector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] + other[i];
    }
    return result;
  }

  Vector operator -(dynamic other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for subtraction.");
    }

    if (other is! Vector || other is! List<num>) {
      throw ArgumentError(
          "Invalid right-hand value type (Vector or List<num>).");
    }

    Vector result = Vector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] - other[i];
    }
    return result;
  }

  Vector operator *(dynamic other) {
    Vector result = Vector(length);
    if (other is num) {
      for (int i = 0; i < length; i++) {
        result[i] = this[i] * other;
      }
    } else if (other is Vector) {
      for (int i = 0; i < length; i++) {
        result[i] = this[i] * other[i];
      }
    }

    return result;
  }

  Vector operator /(dynamic other) {
    Vector result = Vector(length);
    if (other is num) {
      for (int i = 0; i < length; i++) {
        result[i] = this[i] / other;
      }
    } else if (other is Vector) {
      for (int i = 0; i < length; i++) {
        result[i] = this[i] / other[i];
      }
    }
    return result;
  }

  /// This function creates a new list where the elements are shifted by [shift] positions.
  /// Elements that are shifted off the end of the list wrap around to the beginning.
  List<dynamic> roll(dynamic shift) => Vector(this).roll(shift).toList();

  /// Calculates the dot product of the list with another list or vector.
  double dot(dynamic other) =>
      Vector(this).dot(other is num ? Vector(other) : other);
}

extension ListToVector on List<num> {
  Vector toVector() {
    return Vector(this);
  }
}

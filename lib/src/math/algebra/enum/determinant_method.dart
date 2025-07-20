// ignore_for_file: constant_identifier_names

part of '../algebra.dart';

/// Enum representing the available methods for calculating the determinant of a matrix.
///
/// Contains two methods:
/// - [Laplace]: Uses the Laplace expansion. Computationally expensive with \(O(n!)\) time complexity.
/// - [LU]: Uses LU decomposition. More efficient with approximately \(O(n^3)\) time complexity.
enum DeterminantMethod { Laplace, LU }

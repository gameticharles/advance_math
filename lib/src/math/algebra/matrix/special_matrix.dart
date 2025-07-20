part of '../algebra.dart';

class Matrix2 extends Matrix {
  final num a1;
  final num a2;
  final num b1;
  final num b2;

  Matrix2(this.a1, this.a2, this.b1, this.b2)
      : super([
          [a1, a2],
          [b1, b2]
        ]);
}

class Matrix3 extends Matrix {
  final num a1;
  final num a2;
  final num a3;
  final num b1;
  final num b2;
  final num b3;
  final num c1;
  final num c2;
  final num c3;

  Matrix3(this.a1, this.a2, this.a3, this.b1, this.b2, this.b3, this.c1,
      this.c2, this.c3)
      : super([
          [a1, a2, a3],
          [b1, b2, b3],
          [c1, c2, c3]
        ]);
}

class Matrix4 extends Matrix {
  final num a1;
  final num a2;
  final num a3;
  final num a4;
  final num b1;
  final num b2;
  final num b3;
  final num b4;
  final num c1;
  final num c2;
  final num c3;
  final num c4;
  final num d1;
  final num d2;
  final num d3;
  final num d4;

  Matrix4(
      this.a1,
      this.a2,
      this.a3,
      this.a4,
      this.b1,
      this.b2,
      this.b3,
      this.b4,
      this.c1,
      this.c2,
      this.c3,
      this.c4,
      this.d1,
      this.d2,
      this.d3,
      this.d4)
      : super([
          [a1, a2, a3, a4],
          [b1, b2, b3, b4],
          [c1, c2, c3, c4],
          [d1, d2, d3, d4]
        ]);
}

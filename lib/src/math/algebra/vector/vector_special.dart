part of '../algebra.dart';

class Vector2 extends Vector {
  Vector2(num x, num y) : super.fromList([Complex(x), Complex(y)]);

  // Specific methods and operators for Vector2.
  dynamic get x => this[0];
  set x(dynamic value) => this[0] = value;

  dynamic get y => this[1];
  set y(dynamic value) => this[1] = value;

  Vector2 perpendicular() {
    return Vector2(-y, x);
  }

  Vector2 rotate(double angle) {
    dynamic cosTheta = Complex(math.cos(angle));
    dynamic sinTheta = Complex(math.sin(angle));

    return Vector2(
      x * cosTheta - y * sinTheta,
      x * sinTheta + y * cosTheta,
    );
  }

  Vector2 transform(Matrix2 matrix) {
    return Vector2(
      matrix.a1 * x + matrix.a2 * y,
      matrix.b1 * x + matrix.b2 * y,
    );
  }
}

class Vector3 extends Vector {
  Vector3(num x, num y, num z)
      : super.fromList([Complex(x), Complex(y), Complex(z)]);

  // Specific methods and operators for Vector3.
  dynamic get x => this[0];
  set x(dynamic value) => this[0] = value;

  dynamic get y => this[1];
  set y(dynamic value) => this[1] = value;

  dynamic get z => this[2];
  set z(dynamic value) => this[2] = value;

  Vector3 rotateX(double angleInRadians) {
    dynamic cosTheta = Complex(math.cos(angleInRadians));
    dynamic sinTheta = Complex(math.sin(angleInRadians));

    return Vector3(
      x,
      y * cosTheta - z * sinTheta,
      y * sinTheta + z * cosTheta,
    );
  }

  Vector3 rotateY(double angleInRadians) {
    dynamic cosTheta = Complex(math.cos(angleInRadians));
    dynamic sinTheta = Complex(math.sin(angleInRadians));

    return Vector3(
      x * cosTheta + z * sinTheta,
      y,
      z * cosTheta - x * sinTheta,
    );
  }

  Vector3 rotateZ(double angleInRadians) {
    dynamic cosTheta = Complex(math.cos(angleInRadians));
    dynamic sinTheta = Complex(math.sin(angleInRadians));

    return Vector3(
      x * cosTheta - y * sinTheta,
      x * sinTheta + y * cosTheta,
      z,
    );
  }

  Vector3 rotate(Vector3 axis, double angle) {
    // Normalize the axis vector
    Vector3 axisNormalized = axis.normalize() as Vector3;

    dynamic x = axisNormalized.x;
    dynamic y = axisNormalized.y;
    dynamic z = axisNormalized.z;

    double cosTheta = math.cos(angle);
    double sinTheta = math.sin(angle);

    // Create the rotation matrix
    Matrix3 rotationMatrix = Matrix3(
      cosTheta + x * x * (1 - cosTheta),
      x * y * Complex(1 - cosTheta) - z * sinTheta,
      x * z * Complex(1 - cosTheta) + y * sinTheta,
      y * x * Complex(1 - cosTheta) + z * sinTheta,
      cosTheta + y * y * Complex(1 - cosTheta),
      y * z * Complex(1 - cosTheta) - x * sinTheta,
      z * x * Complex(1 - cosTheta) - y * sinTheta,
      z * y * Complex(1 - cosTheta) + x * sinTheta,
      cosTheta + z * z * Complex(1 - cosTheta),
    );

    // Apply the rotation matrix to the vector
    return transform(rotationMatrix);
  }

  Vector3 transform(Matrix3 matrix) {
    return Vector3(
      matrix.a1 * x + matrix.a2 * y + matrix.a3 * z,
      matrix.b1 * x + matrix.b2 * y + matrix.b3 * z,
      matrix.c1 * x + matrix.c2 * y + matrix.c3 * z,
    );
  }
}

class Vector4 extends Vector {
  Vector4(num x, num y, num z, num w)
      : super.fromList([Complex(x), Complex(y), Complex(z), Complex(w)]);

  // Specific methods and operators for Vector4.
  dynamic get x => this[0];
  set x(dynamic value) => this[0] = value;

  dynamic get y => this[1];
  set y(dynamic value) => this[1] = value;

  dynamic get z => this[2];
  set z(dynamic value) => this[2] = value;

  dynamic get w => this[3];
  set w(dynamic value) => this[3] = value;

  Vector4 homogenize() {
    return (w != Complex.zero())
        ? Vector4(x / w, y / w, z / w, 1)
        : Vector4(x, y, z, w);
  }

  Vector4 rotate(double angle, {String plane = "xy"}) {
    // Creating rotation matrix according to selected plane.
    Matrix4 rotationMatrix;
    double cosTheta = math.cos(angle);
    double sinTheta = math.sin(angle);

    switch (plane) {
      case "xy":
        rotationMatrix = Matrix4(
          cosTheta,
          -sinTheta,
          0,
          0,
          sinTheta,
          cosTheta,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
        );
        break;
      case "xz":
        rotationMatrix = Matrix4(
          cosTheta,
          0,
          -sinTheta,
          0,
          0,
          1,
          0,
          0,
          sinTheta,
          0,
          cosTheta,
          0,
          0,
          0,
          0,
          1,
        );
        break;
      case "xw":
        rotationMatrix = Matrix4(
          cosTheta,
          0,
          0,
          -sinTheta,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          sinTheta,
          0,
          0,
          cosTheta,
        );
        break;
      case "yz":
        rotationMatrix = Matrix4(
          1,
          0,
          0,
          0,
          0,
          cosTheta,
          -sinTheta,
          0,
          0,
          sinTheta,
          cosTheta,
          0,
          0,
          0,
          0,
          1,
        );
        break;
      case "yw":
        rotationMatrix = Matrix4(
          1,
          0,
          0,
          0,
          0,
          cosTheta,
          0,
          -sinTheta,
          0,
          0,
          1,
          0,
          0,
          sinTheta,
          0,
          cosTheta,
        );
        break;
      case "zw":
        rotationMatrix = Matrix4(
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          cosTheta,
          -sinTheta,
          0,
          0,
          sinTheta,
          cosTheta,
        );
        break;
      default:
        throw Exception('Invalid plane for rotation: $plane');
    }

    return transform(rotationMatrix);
  }

  Vector4 transform(Matrix4 matrix) {
    // Apply the transformation matrix to the vector.
    return Vector4(
      x * matrix.a1 + y * matrix.a2 + z * matrix.a3 + w * matrix.a4,
      x * matrix.b1 + y * matrix.b2 + z * matrix.b3 + w * matrix.b4,
      x * matrix.c1 + y * matrix.c2 + z * matrix.c3 + w * matrix.c4,
      x * matrix.d1 + y * matrix.d2 + z * matrix.d3 + w * matrix.d4,
    );
  }
}

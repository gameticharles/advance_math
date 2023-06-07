part of vector;

class Vector2 extends Vector {
  Vector2(num x, num y) : super.fromList([x, y]);

  // Specific methods and operators for Vector2.
  num get x => this[0];
  set x(num value) => this[0] = value;

  num get y => this[1];
  set y(num value) => this[1] = value;

  Vector2 perpendicular() {
    return Vector2(-y, x);
  }

  Vector2 rotate(double angle) {
    double cosTheta = math.cos(angle);
    double sinTheta = math.sin(angle);

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
  Vector3(num x, num y, num z) : super.fromList([x, y, z]);

  // Specific methods and operators for Vector3.
  num get x => this[0];
  set x(num value) => this[0] = value;

  num get y => this[1];
  set y(num value) => this[1] = value;

  num get z => this[2];
  set z(num value) => this[2] = value;

  Vector3 rotateX(double angleInRadians) {
    double cosTheta = math.cos(angleInRadians);
    double sinTheta = math.sin(angleInRadians);

    return Vector3(
      x,
      y * cosTheta - z * sinTheta,
      y * sinTheta + z * cosTheta,
    );
  }

  Vector3 rotateY(double angleInRadians) {
    double cosTheta = math.cos(angleInRadians);
    double sinTheta = math.sin(angleInRadians);

    return Vector3(
      x * cosTheta + z * sinTheta,
      y,
      z * cosTheta - x * sinTheta,
    );
  }

  Vector3 rotateZ(double angleInRadians) {
    double cosTheta = math.cos(angleInRadians);
    double sinTheta = math.sin(angleInRadians);

    return Vector3(
      x * cosTheta - y * sinTheta,
      x * sinTheta + y * cosTheta,
      z,
    );
  }

  Vector3 rotate(Vector3 axis, double angle) {
    // Normalize the axis vector
    Vector3 axisNormalized = axis.normalize() as Vector3;

    num x = axisNormalized.x;
    num y = axisNormalized.y;
    num z = axisNormalized.z;

    double cosTheta = math.cos(angle);
    double sinTheta = math.sin(angle);

    // Create the rotation matrix
    Matrix3 rotationMatrix = Matrix3(
      cosTheta + x * x * (1 - cosTheta),
      x * y * (1 - cosTheta) - z * sinTheta,
      x * z * (1 - cosTheta) + y * sinTheta,
      y * x * (1 - cosTheta) + z * sinTheta,
      cosTheta + y * y * (1 - cosTheta),
      y * z * (1 - cosTheta) - x * sinTheta,
      z * x * (1 - cosTheta) - y * sinTheta,
      z * y * (1 - cosTheta) + x * sinTheta,
      cosTheta + z * z * (1 - cosTheta),
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
  Vector4(num x, num y, num z, num w) : super.fromList([x, y, z, w]);

  // Specific methods and operators for Vector4.
  num get x => this[0];
  set x(num value) => this[0] = value;

  num get y => this[1];
  set y(num value) => this[1] = value;

  num get z => this[2];
  set z(num value) => this[2] = value;

  num get w => this[3];
  set w(num value) => this[3] = value;

  Vector4 homogenize() {
    return (w != 0) ? Vector4(x / w, y / w, z / w, 1) : Vector4(x, y, z, w);
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

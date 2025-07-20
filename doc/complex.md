# Complex Numbers and ComplexVectors

This library provides efficient and easy-to-use classes for representing and manipulating vectors, complex numbers, and complex vectors in Dart. This document serves as an introduction to these classes, featuring a variety of examples to demonstrate their usage.

## Complex Numbers

Complex numbers extend the concept of the one-dimensional number line to the two-dimensional complex plane by using the number i, where i^2 = -1.

Complex numbers are crucial in many areas of mathematics and engineering.

The Complex class in this library lets you create complex numbers, access their real and imaginary parts, and obtain their conjugate.

```dart
// Creating a new complex number
Complex z = Complex(3, 2);
print(z);  // Output: 3 + 2i

// Accessing the real and imaginary parts
print(z.real);  // Output: 3
print(z.imaginary);  // Output: 2

// Conjugation
Complex conjugate = z.conjugate();
print(conjugate);  // Output: 3 - 2i

```

## Complex vectors

ComplexVectors are a type of vector where the elements are complex numbers. They are especially important in quantum mechanics and signal processing.

The ComplexVector class provides ways to create complex vectors, perform operations on them such as addition, and calculate their norm and normalized form.

```dart
// Creating a new complex vector
ComplexVector cv = ComplexVector(2);
cv[0] = Complex(1, 2);
cv[1] = Complex(3, 4);
print(cv);  // Output: [(1 + 2i), (3 + 4i)]

// Accessing elements
print(cv[0]);  // Output: 1 + 2i

// Vector operations (example: addition)
ComplexVector cv2 = ComplexVector.fromList([Complex(5, 6), Complex(7, 8)]);
ComplexVector sum = cv + cv2;
print(sum);  // Output: [(6 + 8i), (10 + 12i)]

// Norm and normalization
double norm = cv.norm();
ComplexVector normalized = cv.normalize();
print(norm);  // Output: 5.477225575051661
print(normalized);  // Output: [(0.18257418583505536 + 0.3651483716701107i), (0.5477225575051661 + 0.7302967433402214i)]
```

The above sections provide a basic introduction to vectors, complex numbers, and complex vectors. The full API of these classes offers even more possibilities, including conversions to other forms of vectors, multiplication by scalars, and more. These classes aim to make mathematical programming in Dart efficient, flexible, and enjoyable.
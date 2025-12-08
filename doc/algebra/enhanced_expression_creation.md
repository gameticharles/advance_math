# Enhanced Expression Creation Guide

This guide covers the enhanced methods for creating mathematical expressions with numeric literals in the Advance Math library. These enhancements solve common type inference issues and provide multiple intuitive approaches for expression creation.

## Table of Contents

1. [Overview](#overview)
2. [The Three Approaches](#the-three-approaches)
3. [Basic Usage Examples](#basic-usage-examples)
4. [Complex Mathematical Expressions](#complex-mathematical-expressions)
5. [Calculus Operations](#calculus-operations)
6. [Troubleshooting Guide](#troubleshooting-guide)
7. [Performance Considerations](#performance-considerations)
8. [Migration Guide](#migration-guide)
9. [Best Practices](#best-practices)

## Overview

The Advance Math library provides three complementary approaches for creating expressions with numeric literals:

1. **Explicit Literal Objects** - Traditional approach using `Literal()` constructor
2. **Extension Method** - Using `toExpression()` method on numeric types
3. **Helper Function** - Using the global `ex()` function

All three approaches produce equivalent `Expression` objects and can be used interchangeably or mixed within the same expression.

## The Three Approaches

### 1. Explicit Literal Objects

The traditional approach using the `Literal` constructor directly:

```dart
final x = Variable('x');
final expr = Literal(2) * x + Literal(3);
```

**Pros:**

- Always works, no type inference issues
- Explicit and clear intent
- Full control over literal creation

**Cons:**

- Verbose for complex expressions
- Can make code harder to read

### 2. Extension Method (`toExpression()`)

Using the extension method on numeric types:

```dart
final x = Variable('x');
final expr = 2.toExpression() * x + 3.toExpression();
```

**Pros:**

- Fluent API style
- Clear conversion intent
- Works with all numeric types

**Cons:**

- Slightly more verbose than helper function
- Requires method call on each number

### 3. Helper Function (`ex()`)

Using the global helper function:

```dart
final x = Variable('x');
final expr = ex(2) * x + ex(3);
```

**Pros:**

- Most concise syntax
- Easy to read and write
- Minimal typing required

**Cons:**

- Requires importing the helper function
- Less explicit than other methods

## Basic Usage Examples

### Simple Arithmetic

```dart
import 'package:advance_math/advance_math.dart';

void main() {
  final x = Variable('x');

  // All three approaches for: 2x + 3
  final expr1 = Literal(2) * x + Literal(3);           // Explicit
  final expr2 = 2.toExpression() * x + 3.toExpression(); // Extension
  final expr3 = ex(2) * x + ex(3);                     // Helper

  // All produce the same result
  print(expr1.evaluate({'x': 5})); // 13
  print(expr2.evaluate({'x': 5})); // 13
  print(expr3.evaluate({'x': 5})); // 13
}
```

### Mixed Approaches

You can mix all three approaches in a single expression:

```dart
final expr = 2.toExpression() * x + ex(3) * y - Literal(1);
```

### Different Numeric Types

All numeric types are supported:

```dart
final intExpr = 5.toExpression() * x;        // int
final doubleExpr = 3.14.toExpression() * x;  // double
final negExpr = (-2).toExpression() * x;     // negative
```

## Complex Mathematical Expressions

### Polynomial Expressions

```dart
// Polynomial: 3x⁴ - 2x³ + 5x² - 7x + 11
final polynomial = 3.toExpression() * (x ^ ex(4)) -
                   2.toExpression() * (x ^ ex(3)) +
                   ex(5) * (x ^ ex(2)) -
                   7.toExpression() * x +
                   Literal(11);

print('P(2) = ${polynomial.evaluate({'x': 2})}');
```

### Multivariate Expressions

```dart
final x = Variable('x');
final y = Variable('y');
final z = Variable('z');

// f(x,y,z) = 2xyz + 3x²y - 4xz² + 5yz - 6
final multivar = ex(2) * x * y * z +
                 3.toExpression() * (x ^ ex(2)) * y -
                 Literal(4) * x * (z ^ ex(2)) +
                 ex(5) * y * z -
                 6.toExpression();

print('f(1,2,3) = ${multivar.evaluate({'x': 1, 'y': 2, 'z': 3})}');
```

### Rational Expressions

```dart
// R(x) = (x² + 2x + 1) / (x - 1)
final numerator = (x ^ ex(2)) + 2.toExpression() * x + ex(1);
final denominator = x - ex(1);
final rational = numerator / denominator;

print('R(3) = ${rational.evaluate({'x': 3})}');
```

### Trigonometric Expressions

```dart
// T(x) = sin(2x) + cos(3x) * tan(x/2)
final trigExpr = Sin(2.toExpression() * x) +
                 Cos(ex(3) * x) *
                 Tan(x / ex(2));
```

## Calculus Operations

### Differentiation

```dart
// f(x) = x³ + 2x² - 5x + 7
final func = (x ^ ex(3)) + 2.toExpression() * (x ^ ex(2)) - ex(5) * x + ex(7);
final derivative = func.differentiate();

print('f\'(x) = $derivative');
```

### Integration

```dart
// ∫(6x² + 4x - 3)dx
final integrand = 6.toExpression() * (x ^ ex(2)) + 4.toExpression() * x - ex(3);
final integral = integrand.integrate();

print('∫f(x)dx = $integral');
```

### Chain Rule

```dart
// h(x) = sin(x² + 1)
final chainFunc = Sin((x ^ ex(2)) + ex(1));
final chainDerivative = chainFunc.differentiate();

print('h\'(x) = $chainDerivative');
```

## Troubleshooting Guide

### Common Type Inference Errors

**Problem:** Type errors when mixing `num` and `Expression`

```dart
// ❌ This causes a type error:
final expr = 2 + x; // Error: A value of type 'num' can't be assigned...
```

**Solutions:**

```dart
// ✅ Solution 1: Use toExpression()
final expr1 = 2.toExpression() + x;

// ✅ Solution 2: Use ex() helper
final expr2 = ex(2) + x;

// ✅ Solution 3: Use explicit Literal
final expr3 = Literal(2) + x;
```

### Mixed Numeric Types

All numeric types work seamlessly:

```dart
final intExpr = 5.toExpression() * x;      // int
final doubleExpr = 3.14.toExpression() * x; // double
final negExpr = (-2).toExpression() * x;    // negative

// All evaluate correctly
print(intExpr.evaluate({'x': 2}));    // 10
print(doubleExpr.evaluate({'x': 2})); // 6.28
print(negExpr.evaluate({'x': 2}));    // -4
```

### Complex Nested Expressions

Use parentheses and mixed approaches for clarity:

```dart
final complex = ((2.toExpression() * x + ex(1)) ^ ex(2)) *
                (ex(3) * x - Literal(4));
```

### Operator Precedence

The enhanced methods respect standard mathematical operator precedence:

```dart
final expr = 2.toExpression() + ex(3) * x - Literal(4) / x;
// Equivalent to: 2 + (3 * x) - (4 / x)
```

## Performance Considerations

### Memory Usage

All three methods create identical `Expression` objects with the same memory footprint:

```dart
final literal = Literal(5) * x;
final extension = 5.toExpression() * x;
final helper = ex(5) * x;

// All have identical memory usage and performance
```

### Execution Speed

There is no measurable performance difference between the three approaches. The choice should be based on readability and coding style preferences.

### Compilation Time

All methods have identical compilation overhead since they all create the same underlying `Literal` objects.

## Migration Guide

### From Verbose Literal Usage

**Before:**

```dart
final oldExpr = Add(Multiply(Literal(2), x), Literal(3));
```

**After:**

```dart
final newExpr = 2.toExpression() * x + ex(3);
// or
final newExpr = ex(2) * x + ex(3);
```

### Complex Expression Migration

**Before:**

```dart
final oldComplex = Add(
  Multiply(Literal(3), Pow(x, Literal(2))),
  Subtract(
    Multiply(Literal(2), y),
    Literal(5)
  )
);
```

**After:**

```dart
final newComplex = ex(3) * (x ^ ex(2)) + (2.toExpression() * y - ex(5));
```

### Backward Compatibility

Migration is completely backward compatible. You can:

1. Keep existing `Literal()` usage unchanged
2. Migrate incrementally, expression by expression
3. Mix old and new approaches in the same codebase
4. Update at your own pace without breaking changes

## Best Practices

### When to Use Each Approach

1. **Use `ex()` helper for simple expressions:**

   ```dart
   final simple = ex(2) * x + ex(3);
   ```

2. **Use `toExpression()` for fluent APIs:**

   ```dart
   final fluent = 2.toExpression() * x + 3.toExpression();
   ```

3. **Use `Literal()` for explicit control:**

   ```dart
   final explicit = Literal(2) * x + Literal(3);
   ```

4. **Mix approaches for complex expressions:**
   ```dart
   final mixed = 2.toExpression() * x + ex(3) * y - Literal(1);
   ```

### Code Organization

- Import the library once: `import 'package:advance_math/advance_math.dart';`
- Use consistent approach within a single function or class
- Document your choice in team coding standards
- Consider readability over brevity for complex expressions

### Error Prevention

- Always use parentheses for complex expressions
- Test expressions with sample values during development
- Use meaningful variable names for intermediate expressions
- Break complex expressions into smaller, testable parts

### Testing

```dart
void testExpression() {
  final x = Variable('x');
  final expr = ex(2) * x + ex(3);

  // Test with multiple values
  expect(expr.evaluate({'x': 0}), equals(3));
  expect(expr.evaluate({'x': 1}), equals(5));
  expect(expr.evaluate({'x': -1}), equals(1));
}
```

## Conclusion

The enhanced expression creation methods provide flexible, intuitive ways to work with mathematical expressions while maintaining full backward compatibility. Choose the approach that best fits your coding style and use case, or mix approaches as needed for optimal readability and maintainability.

For more examples, see the [example/enhanced_expression_creation.dart](example/enhanced_expression_creation.dart) file in the library.

# Expression Creation Troubleshooting Guide

This guide helps you resolve common issues when creating mathematical expressions with the Advance Math library, particularly focusing on type inference problems and their solutions.

## Table of Contents

1. [Common Type Errors](#common-type-errors)
2. [Quick Solutions](#quick-solutions)
3. [Detailed Error Scenarios](#detailed-error-scenarios)
4. [Advanced Troubleshooting](#advanced-troubleshooting)
5. [Prevention Strategies](#prevention-strategies)

## Common Type Errors

### Error 1: "A value of type 'num' can't be assigned to a variable of type 'Expression'"

**Symptom:**
```dart
final x = Variable('x');
final expr = 2 + x; // ❌ Type error!
```

**Error Message:**
```
A value of type 'num' can't be assigned to a variable of type 'Expression'
```

**Root Cause:**
Dart's type system cannot automatically convert `num` to `Expression`. The `+` operator on `num` returns `num`, not `Expression`.

**Solutions:**

```dart
// ✅ Solution 1: Use toExpression() method
final expr1 = 2.toExpression() + x;

// ✅ Solution 2: Use ex() helper function
final expr2 = ex(2) + x;

// ✅ Solution 3: Use explicit Literal constructor
final expr3 = Literal(2) + x;

// ✅ Solution 4: Reverse the order (if Expression has num operators)
final expr4 = x + 2; // This works if Expression has operator+(num)
```

### Error 2: "The operator '+' isn't defined for the class 'num'"

**Symptom:**
```dart
final result = 2 + Variable('x'); // ❌ Type error!
```

**Root Cause:**
The `num` class doesn't have operators that accept `Expression` parameters.

**Solution:**
Convert the number to an Expression first:

```dart
// ✅ Convert number to Expression
final result = ex(2) + Variable('x');
```

### Error 3: "The argument type 'int' can't be assigned to the parameter type 'Expression'"

**Symptom:**
```dart
final expr = Pow(Variable('x'), 2); // ❌ Type error!
```

**Root Cause:**
The `Pow` constructor expects both parameters to be `Expression` objects.

**Solutions:**

```dart
// ✅ Solution 1: Use ex() helper
final expr1 = Pow(Variable('x'), ex(2));

// ✅ Solution 2: Use toExpression()
final expr2 = Pow(Variable('x'), 2.toExpression());

// ✅ Solution 3: Use Literal constructor
final expr3 = Pow(Variable('x'), Literal(2));

// ✅ Solution 4: Use ^ operator (if available)
final expr4 = Variable('x') ^ ex(2);
```

## Quick Solutions

### Quick Reference Table

| Problem | Quick Fix | Example |
|---------|-----------|---------|
| `2 + x` type error | Use `ex(2) + x` | `ex(2) + Variable('x')` |
| `Pow(x, 2)` error | Use `Pow(x, ex(2))` | `Pow(Variable('x'), ex(2))` |
| `Sin(2 * x)` error | Use `Sin(ex(2) * x)` | `Sin(ex(2) * Variable('x'))` |
| Mixed types | Convert all to Expression | `ex(2) + ex(3) * x` |

### Emergency Fixes

If you're getting type errors and need a quick fix:

1. **Wrap all numbers with `ex()`:**
   ```dart
   // Before: 2 * x + 3 * y - 1
   // After:
   final expr = ex(2) * x + ex(3) * y - ex(1);
   ```

2. **Use `.toExpression()` on all numbers:**
   ```dart
   // Before: 2 * x + 3 * y - 1
   // After:
   final expr = 2.toExpression() * x + 3.toExpression() * y - 1.toExpression();
   ```

3. **Use explicit `Literal()` constructors:**
   ```dart
   // Before: 2 * x + 3 * y - 1
   // After:
   final expr = Literal(2) * x + Literal(3) * y - Literal(1);
   ```

## Detailed Error Scenarios

### Scenario 1: Polynomial Creation

**Problem:**
```dart
// ❌ This fails with type errors
final polynomial = 3 * x^4 - 2 * x^3 + 5 * x^2 - 7 * x + 11;
```

**Solution:**
```dart
// ✅ Convert all coefficients to expressions
final polynomial = ex(3) * (x ^ ex(4)) - 
                   ex(2) * (x ^ ex(3)) + 
                   ex(5) * (x ^ ex(2)) - 
                   ex(7) * x + 
                   ex(11);
```

### Scenario 2: Function Composition

**Problem:**
```dart
// ❌ Type errors in nested functions
final composed = Sin(2 * Cos(3 * x + 1));
```

**Solution:**
```dart
// ✅ Ensure all numeric values are expressions
final composed = Sin(ex(2) * Cos(ex(3) * x + ex(1)));
```

### Scenario 3: Matrix-Expression Integration

**Problem:**
```dart
// ❌ Mixing matrix operations with expressions
final matrix = Matrix.fromList([[1, 2], [3, 4]]);
final expr = matrix * Variable('x'); // Type error!
```

**Solution:**
```dart
// ✅ Convert matrix elements or use appropriate operations
// This depends on your specific use case - you might need
// to work with expressions throughout, or convert at evaluation time
```

### Scenario 4: Conditional Expressions

**Problem:**
```dart
// ❌ Type errors in conditional logic
final conditional = x > 0 ? 1 : -1; // Type mismatch
```

**Solution:**
```dart
// ✅ Use expression-compatible conditionals
// Note: This might require custom conditional expression classes
// or evaluation-time logic
```

## Advanced Troubleshooting

### IDE Integration Issues

**Problem:** IDE shows errors even with correct syntax.

**Solutions:**
1. **Restart Dart Analysis Server:**
   - In VS Code: `Ctrl+Shift+P` → "Dart: Restart Analysis Server"
   - In IntelliJ: File → Invalidate Caches and Restart

2. **Check import statements:**
   ```dart
   import 'package:advance_math/advance_math.dart'; // Ensure this is present
   ```

3. **Clear pub cache:**
   ```bash
   dart pub cache clean
   dart pub get
   ```

### Runtime vs Compile-time Errors

**Compile-time Type Errors:**
```dart
// ❌ Caught at compile time
final expr = 2 + Variable('x'); // Type error
```

**Runtime Evaluation Errors:**
```dart
// ✅ Compiles but may fail at runtime
final expr = ex(2) / ex(0); // Division by zero at evaluation
try {
  final result = expr.evaluate({});
} catch (e) {
  print('Runtime error: $e');
}
```

### Performance Debugging

**Problem:** Slow expression creation or evaluation.

**Debugging Steps:**
1. **Profile expression creation:**
   ```dart
   final stopwatch = Stopwatch()..start();
   final expr = ex(2) * x + ex(3);
   stopwatch.stop();
   print('Creation time: ${stopwatch.elapsedMicroseconds}μs');
   ```

2. **Profile evaluation:**
   ```dart
   final stopwatch = Stopwatch()..start();
   final result = expr.evaluate({'x': 5});
   stopwatch.stop();
   print('Evaluation time: ${stopwatch.elapsedMicroseconds}μs');
   ```

3. **Compare approaches:**
   ```dart
   // Test all three creation methods
   final approaches = [
     () => Literal(2) * x + Literal(3),
     () => 2.toExpression() * x + 3.toExpression(),
     () => ex(2) * x + ex(3),
   ];
   
   for (int i = 0; i < approaches.length; i++) {
     final stopwatch = Stopwatch()..start();
     final expr = approaches[i]();
     stopwatch.stop();
     print('Approach ${i + 1}: ${stopwatch.elapsedMicroseconds}μs');
   }
   ```

## Prevention Strategies

### Code Organization

1. **Consistent approach within functions:**
   ```dart
   void createPolynomial() {
     // Use one approach consistently
     final poly = ex(3) * (x ^ ex(2)) + ex(2) * x - ex(1);
   }
   ```

2. **Helper functions for complex expressions:**
   ```dart
   Expression createQuadratic(num a, num b, num c, Variable x) {
     return ex(a) * (x ^ ex(2)) + ex(b) * x + ex(c);
   }
   ```

3. **Type annotations for clarity:**
   ```dart
   Expression buildExpression() {
     final Expression result = ex(2) * x + ex(3);
     return result;
   }
   ```

### Testing Strategies

1. **Unit tests for expression creation:**
   ```dart
   void testExpressionCreation() {
     test('polynomial creation', () {
       final poly = ex(2) * (x ^ ex(2)) + ex(3) * x - ex(1);
       expect(poly, isA<Expression>());
       expect(poly.evaluate({'x': 1}), equals(4)); // 2 + 3 - 1 = 4
     });
   }
   ```

2. **Integration tests with evaluation:**
   ```dart
   void testExpressionEvaluation() {
     final expr = ex(2) * x + ex(3);
     final testCases = [
       {'x': 0, 'expected': 3},
       {'x': 1, 'expected': 5},
       {'x': -1, 'expected': 1},
     ];
     
     for (final testCase in testCases) {
       final result = expr.evaluate({'x': testCase['x']});
       expect(result, equals(testCase['expected']));
     }
   }
   ```

### Development Workflow

1. **Start simple, then complexify:**
   ```dart
   // Step 1: Basic expression
   final simple = ex(2) * x;
   
   // Step 2: Add terms
   final extended = simple + ex(3);
   
   // Step 3: Add complexity
   final complex = extended * (x - ex(1));
   ```

2. **Use intermediate variables:**
   ```dart
   // Instead of one complex expression
   final coefficient = ex(2);
   final power = ex(3);
   final constant = ex(5);
   final expr = coefficient * (x ^ power) + constant;
   ```

3. **Validate incrementally:**
   ```dart
   final base = ex(2) * x;
   print('Base: ${base.evaluate({'x': 1})}'); // Should be 2
   
   final withConstant = base + ex(3);
   print('With constant: ${withConstant.evaluate({'x': 1})}'); // Should be 5
   ```

## Getting Help

If you're still experiencing issues:

1. **Check the documentation:** `doc/enhanced_expression_creation.md`
2. **Run the examples:** `dart run example/enhanced_expression_creation.dart`
3. **Review test cases:** Look at files in `test/` directory
4. **Create minimal reproduction:** Isolate the problem to the smallest possible code

### Minimal Reproduction Template

```dart
import 'package:advance_math/advance_math.dart';

void main() {
  // Describe what you're trying to do
  final x = Variable('x');
  
  // Show the problematic code
  // final expr = 2 + x; // This causes error X
  
  // Show what you've tried
  // final expr = ex(2) + x; // This gives unexpected result Y
  
  // Expected behavior
  // I expect the expression to evaluate to Z when x = W
}
```

This template helps identify the exact issue and makes it easier to provide targeted solutions.
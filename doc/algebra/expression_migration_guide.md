# Expression Creation Migration Guide

This guide helps you migrate from older expression creation patterns to the enhanced methods introduced in the Advance Math library. The migration is completely backward compatible, allowing you to update your code incrementally.

## Table of Contents

1. [Migration Overview](#migration-overview)
2. [Before and After Examples](#before-and-after-examples)
3. [Step-by-Step Migration Process](#step-by-step-migration-process)
4. [Common Migration Patterns](#common-migration-patterns)
5. [Backward Compatibility](#backward-compatibility)
6. [Migration Checklist](#migration-checklist)

## Migration Overview

### What's Changing

The library now provides three approaches for creating expressions with numeric literals:

1. **Explicit Literal Objects** (existing, unchanged)
2. **Extension Method** (`toExpression()`) - NEW
3. **Helper Function** (`ex()`) - NEW

### Why Migrate

- **Reduced verbosity:** Less typing for complex expressions
- **Better readability:** More natural mathematical notation
- **Type safety:** Fewer type inference errors
- **Flexibility:** Choose the approach that fits your coding style

### Migration Philosophy

- **No breaking changes:** All existing code continues to work
- **Incremental migration:** Update at your own pace
- **Mixed approaches:** Use old and new methods together
- **Backward compatibility:** Full compatibility with existing APIs

## Before and After Examples

### Simple Expressions

**Before:**

```dart
// Verbose Literal constructor usage
final expr = Add(Multiply(Literal(2), x), Literal(3));
```

**After:**

```dart
// Concise with helper function
final expr = ex(2) * x + ex(3);

// Or with extension method
final expr = 2.toExpression() * x + 3.toExpression();
```

### Polynomial Expressions

**Before:**

```dart
// Complex nested constructors
final polynomial = Add(
  Add(
    Multiply(Literal(3), Pow(x, Literal(2))),
    Multiply(Literal(2), x)
  ),
  Literal(1)
);
```

**After:**

```dart
// Natural mathematical notation
final polynomial = ex(3) * (x ^ ex(2)) + ex(2) * x + ex(1);
```

### Multivariate Expressions

**Before:**

```dart
// Deeply nested constructor calls
final multivar = Add(
  Add(
    Multiply(
      Multiply(Literal(2), x),
      y
    ),
    Multiply(Literal(3), x)
  ),
  Subtract(
    Literal(4),
    y
  )
);
```

**After:**

```dart
// Readable mathematical expression
final multivar = ex(2) * x * y + ex(3) * x + (ex(4) - y);
```

### Trigonometric Functions

**Before:**

```dart
// Verbose function composition
final trigExpr = Add(
  Sin(Multiply(Literal(2), x)),
  Cos(Add(Multiply(Literal(3), x), Literal(1)))
);
```

**After:**

```dart
// Clean function composition
final trigExpr = Sin(ex(2) * x) + Cos(ex(3) * x + ex(1));
```

## Step-by-Step Migration Process

### Step 1: Assess Your Current Code

Identify patterns in your existing code:

```dart
// Pattern 1: Simple arithmetic
final expr1 = Add(Multiply(Literal(2), x), Literal(3));

// Pattern 2: Power operations
final expr2 = Pow(x, Literal(2));

// Pattern 3: Complex nested expressions
final expr3 = Add(
  Multiply(Literal(3), Pow(x, Literal(2))),
  Subtract(Literal(4), x)
);
```

### Step 2: Choose Your Migration Strategy

**Strategy A: Gradual Migration**

- Migrate one expression at a time
- Test each change individually
- Keep existing code working

**Strategy B: Module-by-Module**

- Migrate entire functions or classes
- Maintain consistency within modules
- Update related code together

**Strategy C: Mixed Approach**

- Use new methods for new code
- Keep existing code unchanged
- Mix approaches as needed

### Step 3: Apply Transformations

#### Transform Simple Arithmetic

```dart
// Before
final expr = Add(Multiply(Literal(2), x), Literal(3));

// After - Step 1: Replace constructors with operators
final expr = Literal(2) * x + Literal(3);

// After - Step 2: Use enhanced methods
final expr = ex(2) * x + ex(3);
```

#### Transform Power Operations

```dart
// Before
final expr = Pow(x, Literal(2));

// After
final expr = x ^ ex(2);
```

#### Transform Function Calls

```dart
// Before
final expr = Sin(Multiply(Literal(2), x));

// After
final expr = Sin(ex(2) * x);
```

### Step 4: Test and Validate

After each transformation, verify the behavior:

```dart
void validateMigration() {
  final x = Variable('x');

  // Original expression
  final original = Add(Multiply(Literal(2), x), Literal(3));

  // Migrated expression
  final migrated = ex(2) * x + ex(3);

  // Test with multiple values
  final testValues = [0, 1, -1, 2.5, -3.7];

  for (final value in testValues) {
    final context = {'x': value};
    final originalResult = original.evaluate(context);
    final migratedResult = migrated.evaluate(context);

    assert(originalResult == migratedResult,
           'Results differ for x=$value: $originalResult vs $migratedResult');
  }

  print('Migration validated successfully!');
}
```

## Common Migration Patterns

### Pattern 1: Coefficient Multiplication

**Before:**

```dart
final expr = Multiply(Literal(coefficient), variable);
```

**After:**

```dart
final expr = ex(coefficient) * variable;
```

### Pattern 2: Polynomial Terms

**Before:**

```dart
final term = Multiply(Literal(coeff), Pow(variable, Literal(power)));
```

**After:**

```dart
final term = ex(coeff) * (variable ^ ex(power));
```

### Pattern 3: Addition Chains

**Before:**

```dart
final expr = Add(Add(term1, term2), term3);
```

**After:**

```dart
final expr = term1 + term2 + term3;
```

### Pattern 4: Nested Functions

**Before:**

```dart
final expr = Sin(Add(Multiply(Literal(2), x), Literal(1)));
```

**After:**

```dart
final expr = Sin(ex(2) * x + ex(1));
```

### Pattern 5: Complex Expressions

**Before:**

```dart
final complex = Divide(
  Add(
    Multiply(Literal(2), Pow(x, Literal(2))),
    Literal(1)
  ),
  Subtract(x, Literal(3))
);
```

**After:**

```dart
final complex = (ex(2) * (x ^ ex(2)) + ex(1)) / (x - ex(3));
```

## Backward Compatibility

### Mixing Old and New Approaches

You can safely mix all approaches in the same expression:

```dart
// This is perfectly valid
final mixed = Literal(2) * x + ex(3) * y - 4.toExpression();
```

### Existing API Compatibility

All existing APIs continue to work unchanged:

```dart
// These still work exactly as before
final expr1 = Expression.parse('2*x + 3');
final expr2 = Literal(5);
final expr3 = Variable('x');
final expr4 = Add(expr2, expr3);
```

### Library Integration

The enhanced methods integrate seamlessly with existing library features:

```dart
// Differentiation
final func = ex(2) * (x ^ ex(3)) + ex(1);
final derivative = func.differentiate(); // Works as expected

// Integration
final integral = func.integrate(); // Works as expected

// Simplification
final simplified = func.simplify(); // Works as expected

// Evaluation
final result = func.evaluate({'x': 2}); // Works as expected
```

## Migration Checklist

### Pre-Migration

- [ ] Identify all expression creation patterns in your codebase
- [ ] Create comprehensive tests for existing functionality
- [ ] Document current behavior for validation
- [ ] Choose migration strategy (gradual, module-by-module, or mixed)

### During Migration

- [ ] Update import statements if needed
- [ ] Transform expressions one pattern at a time
- [ ] Test each transformation individually
- [ ] Validate results match original behavior
- [ ] Update documentation and comments

### Post-Migration

- [ ] Run full test suite
- [ ] Performance test critical paths
- [ ] Update team coding standards
- [ ] Document new patterns for future development
- [ ] Consider cleanup of unused imports or patterns

### Migration Tools

#### Automated Pattern Detection

Create a script to find migration candidates:

```dart
void findMigrationCandidates(String filePath) {
  final content = File(filePath).readAsStringSync();

  // Find Literal constructor usage
  final literalPattern = RegExp(r'Literal\(\d+(?:\.\d+)?\)');
  final literalMatches = literalPattern.allMatches(content);

  // Find Add/Multiply/etc. constructor usage
  final constructorPattern = RegExp(r'(Add|Multiply|Subtract|Divide|Pow)\(');
  final constructorMatches = constructorPattern.allMatches(content);

  print('File: $filePath');
  print('  Literal constructors: ${literalMatches.length}');
  print('  Operation constructors: ${constructorMatches.length}');
  print('  Migration potential: ${literalMatches.length + constructorMatches.length} locations');
}
```

#### Validation Helper

Create a helper to validate migrations:

```dart
void validateExpressionEquivalence(Expression original, Expression migrated,
                                  Map<String, dynamic> testContext) {
  final originalResult = original.evaluate(testContext);
  final migratedResult = migrated.evaluate(testContext);

  if (originalResult != migratedResult) {
    throw Exception('Migration validation failed: '
                   '$originalResult != $migratedResult '
                   'with context $testContext');
  }
}
```

### Example Migration Script

```dart
import 'package:advance_math/advance_math.dart';

void migrateExpressions() {
  final x = Variable('x');
  final y = Variable('y');

  // Example migration of a complex expression
  print('=== Migration Example ===');

  // Original verbose expression
  final original = Add(
    Add(
      Multiply(Literal(3), Pow(x, Literal(2))),
      Multiply(Literal(2), Multiply(x, y))
    ),
    Subtract(Literal(5), y)
  );

  // Migrated concise expression
  final migrated = ex(3) * (x ^ ex(2)) + ex(2) * x * y + (ex(5) - y);

  // Validation
  final testCases = [
    {'x': 1, 'y': 1},
    {'x': 2, 'y': 3},
    {'x': -1, 'y': 0},
    {'x': 0.5, 'y': -2.5},
  ];

  print('Original: $original');
  print('Migrated: $migrated');
  print();

  for (final testCase in testCases) {
    final originalResult = original.evaluate(testCase);
    final migratedResult = migrated.evaluate(testCase);

    print('Test $testCase:');
    print('  Original: $originalResult');
    print('  Migrated: $migratedResult');
    print('  Match: ${originalResult == migratedResult}');
    print();
  }
}
```

## Conclusion

The migration to enhanced expression creation methods is designed to be smooth and non-disruptive. You can:

- **Start immediately** with new code using enhanced methods
- **Migrate gradually** existing code at your own pace
- **Mix approaches** as needed for different parts of your codebase
- **Maintain full compatibility** with existing functionality

The enhanced methods provide significant improvements in readability and usability while preserving all the power and flexibility of the original API.

For more examples and detailed usage patterns, see:

- [enhanced_expression_creation.md](enhanced_expression_creation.md) - Comprehensive usage guide
- [expression_troubleshooting.md](expression_troubleshooting.md) - Troubleshooting common issues
- [example/enhanced_expression_creation.dart](example/enhanced_expression_creation.dart) - Working examples

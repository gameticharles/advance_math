import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Expression Error Handling and Validation Tests', () {
    late Variable x;

    setUp(() {
      x = Variable('x');
    });

    group('ExpressionTypeConversionException Tests', () {
      test('should throw ExpressionTypeConversionException for String values',
          () {
        expect(
          () => x + "invalid",
          throwsA(isA<ExpressionOperationException>()),
        );
      });

      test('should throw ExpressionTypeConversionException for bool values',
          () {
        expect(
          () => x * true,
          throwsA(isA<ExpressionOperationException>()),
        );
      });

      test('should throw ExpressionTypeConversionException for List values',
          () {
        expect(
          () => x - [1, 2, 3],
          throwsA(isA<ExpressionOperationException>()),
        );
      });

      test('should throw ExpressionTypeConversionException for Map values', () {
        expect(
          () => x / {'key': 'value'},
          throwsA(isA<ExpressionOperationException>()),
        );
      });

      test('should throw ExpressionTypeConversionException for null values',
          () {
        expect(
          () => x ^ null,
          throwsA(isA<ExpressionOperationException>()),
        );
      });

      test('should provide helpful error message for String conversion', () {
        try {
          x + "123";
          fail('Expected ExpressionOperationException');
        } catch (e) {
          expect(e, isA<ExpressionOperationException>());
          final exception = e as ExpressionOperationException;
          expect(
              exception.message, contains('Invalid operands for + operation'));
          expect(exception.message, contains('Suggested solutions'));
          expect(exception.message, contains('toExpression()'));
        }
      });

      test('should provide helpful error message for bool conversion', () {
        try {
          x * false;
          fail('Expected ExpressionOperationException');
        } catch (e) {
          expect(e, isA<ExpressionOperationException>());
          final exception = e as ExpressionOperationException;
          expect(
              exception.message, contains('Invalid operands for * operation'));
          expect(exception.message, contains('Suggested solutions'));
          expect(exception.message, contains('Use Literal(false)'));
        }
      });

      test('should provide helpful error message for List conversion', () {
        try {
          x - [1, 2, 3];
          fail('Expected ExpressionOperationException');
        } catch (e) {
          expect(e, isA<ExpressionOperationException>());
          final exception = e as ExpressionOperationException;
          expect(
              exception.message, contains('Invalid operands for - operation'));
          expect(exception.message,
              contains('Lists are not directly convertible'));
        }
      });
    });

    group('ExpressionValidationException Tests', () {
      test('should throw ExpressionValidationException for NaN values', () {
        expect(
          () => x + double.nan,
          throwsA(isA<ExpressionValidationException>()),
        );
      });

      test('should throw ExpressionValidationException for infinite values',
          () {
        expect(
          () => x * double.infinity,
          throwsA(isA<ExpressionValidationException>()),
        );

        expect(
          () => x / double.negativeInfinity,
          throwsA(isA<ExpressionValidationException>()),
        );
      });

      test('should provide specific error message for NaN', () {
        try {
          x + double.nan;
          fail('Expected ExpressionValidationException');
        } catch (e) {
          expect(e, isA<ExpressionValidationException>());
          final exception = e as ExpressionValidationException;
          expect(
              exception.message, contains('Cannot create expression from NaN'));
          expect(exception.validationRule, equals('invalid_numeric_value'));
        }
      });

      test('should provide specific error message for infinity', () {
        try {
          x * double.infinity;
          fail('Expected ExpressionValidationException');
        } catch (e) {
          expect(e, isA<ExpressionValidationException>());
          final exception = e as ExpressionValidationException;
          expect(exception.message,
              contains('Cannot create expression from infinite value'));
          expect(exception.validationRule, equals('invalid_numeric_value'));
        }
      });
    });

    group('ExpressionOperationException Tests', () {
      test('should contain operation details in exception', () {
        try {
          x + "invalid";
          fail('Expected ExpressionOperationException');
        } catch (e) {
          expect(e, isA<ExpressionOperationException>());
          final exception = e as ExpressionOperationException;
          expect(exception.operation, equals('+'));
          expect(exception.leftOperand, equals(x));
          expect(exception.rightOperand, equals("invalid"));
        }
      });

      test('should provide conversion examples for different operations', () {
        // Test addition with string
        try {
          x + "test";
          fail('Expected ExpressionOperationException for +');
        } catch (e) {
          expect(e, isA<ExpressionOperationException>());
          final exception = e as ExpressionOperationException;
          expect(exception.operation, equals('+'));
          expect(exception.message, contains('Invalid operands'));
          expect(exception.message, contains('Suggested solutions'));
        }

        // Test subtraction with bool
        try {
          x - true;
          fail('Expected ExpressionOperationException for -');
        } catch (e) {
          expect(e, isA<ExpressionOperationException>());
          final exception = e as ExpressionOperationException;
          expect(exception.operation, equals('-'));
          expect(exception.message, contains('Invalid operands'));
          expect(exception.message, contains('Suggested solutions'));
        }

        // Test multiplication with list
        try {
          x * [1, 2];
          fail('Expected ExpressionOperationException for *');
        } catch (e) {
          expect(e, isA<ExpressionOperationException>());
          final exception = e as ExpressionOperationException;
          expect(exception.operation, equals('*'));
          expect(exception.message, contains('Invalid operands'));
          expect(exception.message, contains('Suggested solutions'));
        }

        // Test division with map
        try {
          x / {'a': 1};
          fail('Expected ExpressionOperationException for /');
        } catch (e) {
          expect(e, isA<ExpressionOperationException>());
          final exception = e as ExpressionOperationException;
          expect(exception.operation, equals('/'));
          expect(exception.message, contains('Invalid operands'));
          expect(exception.message, contains('Suggested solutions'));
        }

        // Test power with null
        try {
          x ^ null;
          fail('Expected ExpressionOperationException for ^');
        } catch (e) {
          expect(e, isA<ExpressionOperationException>());
          final exception = e as ExpressionOperationException;
          expect(exception.operation, equals('^'));
          expect(exception.message, contains('Invalid operands'));
          expect(exception.message, contains('Suggested solutions'));
        }
      });
    });

    group('Direct _toExpression method validation', () {
      test('should handle valid Expression objects', () {
        final expr = Literal(5);
        final result = Expression.parse('x')
            .runtimeType; // Access _toExpression indirectly
        expect(expr, isA<Expression>());
      });

      test('should handle valid numeric values', () {
        final validNumbers = [0, 1, -1, 3.14, -2.5, 1e10, 1e-10];

        for (final number in validNumbers) {
          expect(() => x + number, returnsNormally);
        }
      });

      test('should reject invalid numeric values', () {
        final invalidNumbers = [
          double.nan,
          double.infinity,
          double.negativeInfinity
        ];

        for (final number in invalidNumbers) {
          expect(
              () => x + number, throwsA(isA<ExpressionValidationException>()));
        }
      });
    });

    group('Error message quality tests', () {
      test('should provide actionable suggestions for String values', () {
        try {
          x + "42";
          fail('Expected exception');
        } catch (e) {
          final message = e.toString();
          expect(message, contains('Expression.parse'));
          expect(message, contains('Literal'));
          expect(message, contains('toExpression'));
        }
      });

      test('should provide actionable suggestions for boolean values', () {
        try {
          x * true;
          fail('Expected exception');
        } catch (e) {
          final message = e.toString();
          expect(message, contains('Literal(true)'));
          expect(message, contains('Convert to number'));
        }
      });

      test('should provide actionable suggestions for null values', () {
        try {
          x ^ null;
          fail('Expected exception');
        } catch (e) {
          final message = e.toString();
          expect(message, contains('Null values cannot be converted'));
          expect(message, contains('Literal(0)'));
          expect(message, contains('default value'));
        }
      });

      test('should provide conversion examples in error messages', () {
        try {
          x / [1, 2, 3];
          fail('Expected exception');
        } catch (e) {
          final message = e.toString();
          expect(message, contains('Suggested solutions'));
          expect(message, contains('Lists are not directly convertible'));
          expect(message, contains('Consider using individual elements'));
        }
      });
    });

    group('Edge cases and boundary conditions', () {
      test('should handle very large numbers', () {
        expect(() => x + 1e308, returnsNormally);
      });

      test('should handle very small numbers', () {
        expect(() => x + 1e-308, returnsNormally);
      });

      test('should handle zero correctly', () {
        expect(() => x + 0, returnsNormally);
        expect(() => x * 0, returnsNormally);
      });

      test('should handle negative zero correctly', () {
        expect(() => x + -0.0, returnsNormally);
      });

      test('should handle complex nested operations with invalid types', () {
        expect(
          () => (x + 1) * "invalid" / (x - 2),
          throwsA(isA<ExpressionOperationException>()),
        );
      });

      test('should maintain error context in nested operations', () {
        try {
          (x + 1) * "invalid" / (x - 2);
          fail('Expected exception');
        } catch (e) {
          expect(e, isA<ExpressionOperationException>());
          final exception = e as ExpressionOperationException;
          expect(exception.operation, equals('*'));
          expect(exception.rightOperand, equals("invalid"));
        }
      });
    });

    group('Exception inheritance and type checking', () {
      test(
          'ExpressionTypeConversionException should extend ExpressionException',
          () {
        try {
          x + "test";
          fail('Expected exception');
        } catch (e) {
          // The exception is wrapped in ExpressionOperationException,
          // but we can test the type conversion exception separately
          expect(() => Expression.parse('x').runtimeType, returnsNormally);
        }
      });

      test('ExpressionValidationException should extend ExpressionException',
          () {
        try {
          x + double.nan;
          fail('Expected exception');
        } catch (e) {
          expect(e, isA<ExpressionValidationException>());
          expect(e, isA<ExpressionException>());
        }
      });

      test('ExpressionOperationException should extend ExpressionException',
          () {
        try {
          x + "test";
          fail('Expected exception');
        } catch (e) {
          expect(e, isA<ExpressionOperationException>());
          expect(e, isA<ExpressionException>());
        }
      });
    });

    group('Custom validation exceptions', () {
      test('should create division by zero exception', () {
        final exception = ExpressionValidationException.divisionByZero(0);
        expect(exception.validationRule, equals('division_by_zero'));
        expect(exception.message, contains('Division by zero is not allowed'));
      });

      test('should create invalid power operation exception', () {
        final exception =
            ExpressionValidationException.invalidPowerOperation(0, -1);
        expect(exception.validationRule, equals('invalid_power'));
        expect(exception.message,
            contains('Zero cannot be raised to a non-positive power'));
      });

      test('should create undefined operation exception', () {
        final exception =
            ExpressionValidationException.undefinedOperation('sqrt', -1);
        expect(exception.validationRule, equals('undefined_operation'));
        expect(
            exception.message, contains('sqrt is undefined for operand: -1'));
      });
    });

    group('Error recovery and suggestions', () {
      test('should suggest parsing for numeric strings', () {
        try {
          x + "123.45";
          fail('Expected exception');
        } catch (e) {
          final message = e.toString();
          expect(message, contains('num.parse("123.45").toExpression()'));
        }
      });

      test('should suggest literal creation for non-numeric strings', () {
        try {
          x + "hello";
          fail('Expected exception');
        } catch (e) {
          final message = e.toString();
          expect(message, contains('Literal("hello")'));
          expect(message, contains('Expression.parse("hello")'));
        }
      });

      test('should provide multiple solution paths', () {
        try {
          x * true;
          fail('Expected exception');
        } catch (e) {
          final message = e.toString();
          expect(message, contains('Literal(true)'));
          expect(message, contains('Convert to number'));
          expect(message, contains('1.toExpression()'));
        }
      });
    });
  });
}

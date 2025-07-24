part of 'expression.dart';

/// Base exception class for expression-related errors.
abstract class ExpressionException implements Exception {
  final String message;
  final dynamic value;
  final Type? expectedType;

  const ExpressionException(this.message, this.value, [this.expectedType]);

  @override
  String toString() => 'ExpressionException: $message';
}

/// Exception thrown when a value cannot be converted to an Expression.
class ExpressionTypeConversionException extends ExpressionException {
  ExpressionTypeConversionException(dynamic value, [Type? expectedType])
      : super(
          _buildMessage(value, expectedType),
          value,
          expectedType,
        );

  static String _buildMessage(dynamic value, Type? expectedType) {
    final valueType = value.runtimeType;
    final baseMessage = 'Cannot convert value of type $valueType to Expression';

    if (expectedType != null) {
      return '$baseMessage (expected $expectedType)';
    }

    // Provide helpful suggestions based on the value type
    final suggestions = _getSuggestions(value);
    if (suggestions.isNotEmpty) {
      return '$baseMessage.\n\nSuggested solutions:\n${suggestions.join('\n')}';
    }

    return '$baseMessage. Supported types: num, Expression, String (for parsing).';
  }

  static List<String> _getSuggestions(dynamic value) {
    final suggestions = <String>[];
    final valueType = value.runtimeType;

    if (value is String) {
      suggestions.add(
          '• Use Expression.parse("$value") to parse the string as an expression');
      suggestions.add('• Use Literal("$value") if you want a string literal');
      if (num.tryParse(value) != null) {
        suggestions.add(
            '• Convert to number first: num.parse("$value").toExpression()');
      }
    } else if (value is bool) {
      suggestions.add('• Use Literal($value) to create a boolean literal');
      suggestions
          .add('• Convert to number: ${value ? '1' : '0'}.toExpression()');
    } else if (value is List) {
      suggestions.add('• Lists are not directly convertible to expressions');
      suggestions.add(
          '• Consider using individual elements or mathematical operations on the list');
    } else if (value is Map) {
      suggestions.add('• Maps are not directly convertible to expressions');
      suggestions
          .add('• Consider using map values in expression evaluation context');
    } else if (value == null) {
      suggestions.add('• Null values cannot be converted to expressions');
      suggestions.add('• Use Literal(0) or another default value instead');
    } else {
      suggestions.add(
          '• Use Literal($value) if you want to create a literal expression');
      suggestions.add('• Ensure the value is of type num or Expression');
    }

    return suggestions;
  }
}

/// Exception thrown when expression operations encounter invalid operands.
class ExpressionOperationException extends ExpressionException {
  final String operation;
  final dynamic leftOperand;
  final dynamic rightOperand;

  ExpressionOperationException(
    this.operation,
    this.leftOperand,
    this.rightOperand,
    String message,
  ) : super(message, null);

  ExpressionOperationException.invalidOperands(
    String operation,
    dynamic leftOperand,
    dynamic rightOperand,
  ) : this(
          operation,
          leftOperand,
          rightOperand,
          _buildOperationMessage(operation, leftOperand, rightOperand),
        );

  ExpressionOperationException.withConversionContext(
    String operation,
    dynamic leftOperand,
    dynamic rightOperand,
    ExpressionTypeConversionException conversionException,
  ) : this(
          operation,
          leftOperand,
          rightOperand,
          _buildOperationMessageWithContext(
              operation, leftOperand, rightOperand, conversionException),
        );

  static String _buildOperationMessage(
    String operation,
    dynamic leftOperand,
    dynamic rightOperand,
  ) {
    final leftType = leftOperand.runtimeType;
    final rightType = rightOperand.runtimeType;

    return 'Invalid operands for $operation operation: '
        '$leftType $operation $rightType.\n\n'
        'Suggested solutions:\n'
        '• Convert numeric values using .toExpression() or e() function\n'
        '• Use Literal() constructor for explicit conversion\n'
        '• Ensure both operands are Expression or num types\n\n'
        'Examples:\n'
        '• Instead of: $leftOperand $operation $rightOperand\n'
        '• Try: ${_getConversionExample(leftOperand)} $operation ${_getConversionExample(rightOperand)}';
  }

  static String _buildOperationMessageWithContext(
    String operation,
    dynamic leftOperand,
    dynamic rightOperand,
    ExpressionTypeConversionException conversionException,
  ) {
    final leftType = leftOperand.runtimeType;
    final rightType = rightOperand.runtimeType;

    return 'Invalid operands for $operation operation: '
        '$leftType $operation $rightType.\n\n'
        '${conversionException.message}';
  }

  static String _getConversionExample(dynamic operand) {
    if (operand is num) {
      return '$operand.toExpression()';
    } else if (operand is String) {
      return 'Expression.parse("$operand")';
    } else if (operand is Expression) {
      return operand.toString();
    } else {
      return 'Literal($operand)';
    }
  }

  @override
  String toString() => 'ExpressionOperationException: $message';
}

/// Exception thrown when expression validation fails.
class ExpressionValidationException extends ExpressionException {
  final String validationRule;

  ExpressionValidationException(
      String validationRule, String message, dynamic value)
      : validationRule = validationRule,
        super(message, value);

  ExpressionValidationException.divisionByZero(dynamic divisor)
      : this(
          'division_by_zero',
          'Division by zero is not allowed. Divisor evaluates to: $divisor',
          divisor,
        );

  ExpressionValidationException.invalidPowerOperation(
      dynamic base, dynamic exponent)
      : this(
          'invalid_power',
          'Invalid power operation: $base ^ $exponent. '
              'Zero cannot be raised to a non-positive power.',
          {'base': base, 'exponent': exponent},
        );

  ExpressionValidationException.undefinedOperation(
      String operation, dynamic operand)
      : this(
          'undefined_operation',
          '$operation is undefined for operand: $operand',
          operand,
        );

  @override
  String toString() =>
      'ExpressionValidationException [$validationRule]: $message';
}

import 'package:advance_math/advance_math.dart';

void main() {
  final context = ExpressionContext.buildDefaultContext();
  print('--- Vector Support ---');
  final v1 = Expression.parse('vector(1, 2, 3)').evaluate(context);
  print('v1: $v1');
  print('v1.mag: ${Expression.parse('mag(v1)').evaluate({
        ...context,
        'v1': v1
      })}');
  print('v1.unit: ${Expression.parse('unit(v1)').evaluate({
        ...context,
        'v1': v1
      })}');
  print(
      'zerosVector(3): ${Expression.parse('zerosVector(3)').evaluate(context)}');
  print(
      'onesVector(3): ${Expression.parse('onesVector(3)').evaluate(context)}');

  print('\n--- Flow Control ---');
  print(
      'iif(1 > 0, "Yes", "No"): ${Expression.parse('iif(1 > 0, "Yes", "No")').evaluate(context)}');
  print(
      'choose(2, "A", "B", "C"): ${Expression.parse('choose(2, "A", "B", "C")').evaluate(context)}');
  print(
      'any([0, 0, 1]): ${Expression.parse('any([0, 0, 1])').evaluate(context)}');
  print(
      'all([1, 1, 0]): ${Expression.parse('all([1, 1, 0])').evaluate(context)}');

  print('\n--- Number Extras ---');
  print(
      'toRoman(2024): ${Expression.parse('toRoman(2024)').evaluate(context)}');
  print(
      'fromRoman("MMXXIV"): ${Expression.parse('fromRoman("MMXXIV")').evaluate(context)}');
  print(
      'isPerfect(28): ${Expression.parse('isPerfect(28)').evaluate(context)}');
  print(
      'nthPerfect(1): ${Expression.parse('nthPerfect(1)').evaluate(context)}');

  print('\n--- Pi Algorithms ---');
  print(
      'pi Ramanujan 50: ${Expression.parse('piCalc("ramanujan", 50)').evaluate(context)}');
  print(
      'pi Chudnovsky 50: ${Expression.parse('piCalc("chudnovsky", 50)').evaluate(context)}');
  print(
      'pi 10th digit: ${Expression.parse('nthPiDigit(10)').evaluate(context)}');

  print('\nSUCCESS!');
}

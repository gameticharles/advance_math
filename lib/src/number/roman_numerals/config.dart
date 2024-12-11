part of 'roman_numerals.dart';

/// [RomanNumeralsType] enumerates the 3 major types of Roman numerals
/// supported.
///
/// [RomanNumeralsType.common] is the form most used in the modern
/// day for years, clock faces, etc.
enum RomanNumeralsType { apostrophus, common, vinculum }

/// [RomanNumeralsConfig] is the base class that defines the behavior for
/// all of the descendent classes and should not be used directly.
class RomanNumeralsConfig {
  final RomanNumeralsType configType;
  final String? nulla;

  const RomanNumeralsConfig(
      {this.configType = RomanNumeralsType.common, this.nulla});
}

/// Use [ApostrophusRomanNumeralsConfig] to use special symbols from
/// the Roman era for 500, 1,000; 5,000; 10,000; 50,000; 100,000, and
/// 1,000,000 - these are ⅠↃ, ⅭⅠↃ, ⅠↃↃ, ⅭⅭⅠↃↃ, ⅠↃↃↃ, ⅭⅭⅭⅠↃↃↃ, CCCCIↃↃↃↃ.
/// Maximum value: 3,999,999.
///
/// Note: we do not use Unicode Ⅽ/216D (which matches Ↄ - 2183 better)
/// or Ⅰ/2160, as they are too similar to C and I, and can cause confusion.
class ApostrophusRomanNumeralsConfig extends RomanNumeralsConfig {
  final bool compact;

  const ApostrophusRomanNumeralsConfig({this.compact = false, super.nulla})
      : super(configType: RomanNumeralsType.apostrophus);
}

/// The [CompactApostrophusRomanNumeralsConfig] form of
/// [ApostrophusRomanNumeralsConfig] uses single characters for each
/// value instead of multiple. 500 will use D. The other characters
/// are ↀ, ↁ, ↂ, ↇ, and ↈ.
/// Maximum value: 399,999.
class CompactApostrophusRomanNumeralsConfig
    extends ApostrophusRomanNumeralsConfig {
  const CompactApostrophusRomanNumeralsConfig({super.nulla})
      : super(compact: true);
}

/// Use [CommonRomanNumeralsConfig] for the common MDCLXVI style.
/// Maximum value: 3,999 / MMMCMXCIX.
///
/// [CommonRomanNumeralsConfig] is the default configuration.
class CommonRomanNumeralsConfig extends RomanNumeralsConfig {
  const CommonRomanNumeralsConfig({super.nulla})
      : super(configType: RomanNumeralsType.common);
}

/// Use [VinculumRomanNumeralsConfig] for the extended style similar
/// to the the common MDCLXVI style.
/// Maximum value: 3,999,999 / M̅M̅M̅C̅M̅X̅C̅MX̅CMXCIX.
///
/// The rules are similar to [CommonRomanNumeralsConfig] style, but
/// M acts like I in the least position, and beyond M, each character
/// is reused with a line overtop multipling each by 1,000. These are
/// V̅, X̅, L̅, C̅, D̅, and M̅. I̅ is not used, but M is preffered for 1,000.
class VinculumRomanNumeralsConfig extends RomanNumeralsConfig {
  const VinculumRomanNumeralsConfig({super.nulla})
      : super(configType: RomanNumeralsType.vinculum);
}

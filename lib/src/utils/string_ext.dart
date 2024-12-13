part of '/advance_math.dart';

extension ExtString on String {
  /// Checks if the string is a valid email format.
  ///
  /// Example:
  /// ```dart
  /// print('test@email.com'.isValidEmail()); // true
  /// print('testemail.com'.isValidEmail());  // false
  /// ```
  bool isValidEmail() {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return !emailRegExp.hasMatch(this);
  }

  /// Checks if the string is a valid name.
  /// A valid name shouldn't contain any symbols or special characters.
  ///
  /// Example:
  /// ```dart
  /// print('John'.isValidName()); // true
  /// print('John#Doe'.isValidName());  // false
  /// ```
  bool isValidName() {
    final nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s]');
    return !nameRegExp.hasMatch(this);
  }

  /// Checks if the string is a valid password.
  /// A valid password should have at least one uppercase letter,
  /// one lowercase letter, one number, one special character,
  /// and should be at least 6 characters long.
  ///
  /// Example:
  /// ```dart
  /// print('Password123!'.isValidPassword()); // true
  /// print('password'.isValidPassword());  // false
  /// ```
  bool isValidPassword([int passwordLength = 6]) {
    final passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{' +
            passwordLength.toString() +
            r',}$');
    return !passwordRegExp.hasMatch(this);
  }

  /// Returns an error message if the password is invalid.
  /// Returns `null` if the password is valid.
  String? passwordValidationMessage([int passwordLength = 6]) {
    if (length < passwordLength) {
      return 'Password must be at least $passwordLength characters long.';
    }
    if (!RegExp(r'(?=.*?[A-Z])').hasMatch(this)) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!RegExp(r'(?=.*?[a-z])').hasMatch(this)) {
      return 'Password must contain at least one lowercase letter.';
    }
    if (!RegExp(r'(?=.*?[0-9])').hasMatch(this)) {
      return 'Password must contain at least one number.';
    }
    if (!RegExp(r'(?=.*?[!@#\$&*~])').hasMatch(this)) {
      return 'Password must contain at least one special character.';
    }
    return null; // Password is valid
  }

  /// Checks if the string contains any of the special symbols.
  ///
  /// Example:
  /// ```dart
  /// print('Hello@World'.containsSymbol()); // true
  /// print('HelloWorld'.containsSymbol());  // false
  /// ```
  bool containsSymbol() {
    final stringRegExp = RegExp(r'^(?=.*?[!@#\$&*~])');
    return stringRegExp.hasMatch(this);
  }

  /// Checks if the string contains both uppercase and lowercase letters.
  ///
  /// Example:
  /// ```dart
  /// print('Hello'.containsUpperMixCaseLetter()); // true
  /// print('HELLO'.containsUpperMixCaseLetter());  // false
  /// ```
  bool containsUpperMixCaseLetter() {
    final stringRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])');
    return stringRegExp.hasMatch(this);
  }

  /// Checks if the string contains a number.
  ///
  /// Example:
  /// ```dart
  /// print('Hello1'.containsNumber()); // true
  /// print('Hello'.containsNumber());  // false
  /// ```
  bool containsNumber() {
    final stringRegExp = RegExp(r'^(?=.*?[0-9])');
    return stringRegExp.hasMatch(this);
  }

  /// Checks if the string is a valid phone number format of a specified [length].
  ///
  /// The [length] parameter determines the expected length of the phone number.
  /// By default, the length is set to 10.
  ///
  /// Example:
  /// ```dart
  /// print('0123456789'.isValidPhone()); // true
  /// print('01234567'.isValidPhone());  // false
  /// print('01234567'.isValidPhone(length: 8));  // true
  /// ```
  bool isValidPhone({int length = 10}) {
    final phoneRegExp =
        RegExp(r'(^(?:[+0]9)?[0-9]{' + length.toString() + r'}$)');
    return phoneRegExp.hasMatch(this);
  }

  /// Checks if the string is a valid numeric character.
  ///
  /// Example:
  /// ```dart
  /// print('1'.isValidNumeric()); // true
  /// print('+1'.isValidNumeric());  // false
  /// ```
  bool isValidNumeric() {
    final phoneRegExp = RegExp(r'(^(?:[+0]9)?[0-9]$)');
    return phoneRegExp.hasMatch(this);
  }

  /// Converts all the characters of the string to uppercase.
  ///
  /// Example:
  /// ```dart
  /// print('hello'.allInCaps()); // HELLO
  /// ```
  String allInCaps() => toUpperCase();

  /// Capitalizes the first letter of each word in the string if [all] is set to true.
  /// Otherwise, it only capitalizes the first letter of the string.
  ///
  /// Example:
  /// ```dart
  /// print('hello world'.capitalize()); // Hello World
  /// print('hello world'.capitalize(all: false));  // Hello world
  /// ```
  String capitalize({bool all = true}) {
    if (all) {
      return replaceAll(RegExp(' +'), ' ')
          .split(" ")
          .map((str) => str.isNotEmpty
              ? '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}'
              : '')
          .join(" ");
    } else {
      return isNotEmpty
          ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
          : '';
    }
  }

  /// Checks if the string characters are a digit(s) (0-9).
  ///
  /// ```dart
  /// print('5'.isDigit()); // true
  /// print('a'.isDigit()); // false
  /// print('12345'.isDigit()); // true
  /// print('123a45'.isDigit());   // false
  /// ```
  bool isDigit() => math.isDigit(this);

  /// Checks if the string characters are alphabetic letter(s) (A-Z, a-z).
  ///
  /// ```dart
  /// print('a'.isAlpha()); // true
  /// print('5'.isAlpha()); // false
  /// print('Hello'.isAlpha()); // true
  /// print('Hello1'.isAlpha()); // false
  /// ```
  bool isAlpha() => math.isAlpha(this);

  /// Checks if the provided character [input] is alphanumeric (A-Z, a-z, 0-9).
  ///
  /// ```dart
  /// print('a'.isAlphaNumeric()); // true
  /// print('5'.isAlphaNumeric()); // true
  /// print('@'.isAlphaNumeric()); // false
  /// print('Hello123'.isAlphaNumeric()); // true
  /// print('Hello@123'.isAlphaNumeric());  // false
  /// ```
  bool isAlphaNumeric() => math.isAlphaNumeric(this);

  /// Removes special characters from the string based on the provided criteria.
  ///
  /// The [alphabets] parameter determines if alphabets should be retained.
  /// The [numeric] parameter determines if numeric characters should be retained.
  /// The [replaceWith] parameter determines the character to replace the special characters with.
  ///
  /// Example:
  /// ```dart
  /// print('Hello@World123'.removeSpecialCharacters()); // HelloWorld123
  /// print('Hello@World123'.removeSpecialCharacters(alphabets: false));  // 123
  /// ```
  String removeSpecialCharacters({
    bool alphabets = true,
    bool numeric = true,
    String replaceWith = '',
  }) {
    final regExp = (alphabets && !numeric)
        ? RegExp('[^A-Za-z]')
        : (!alphabets && numeric)
            ? RegExp('[^0-9]')
            : RegExp(r'[^A-Za-z0-9]');

    return replaceAll(regExp, replaceWith);
  }

  ///Replace characters from a list of strings that
  List<String> replaceCharactersInList(
      List<String> originalList, Map<String, String> replacements) {
    // Map each string in the list to a new string with replacements
    return originalList.map((string) {
      // For each replacement pair, apply the replacement
      replacements.forEach((oldValue, newValue) {
        string = string.replaceAll(oldValue, newValue);
      });
      return string; // Return the modified string
    }).toList(); // Convert the Iterable back to a List
  }

  /// Extracts all letters, including accents and symbols, from the string.
  ///
  /// This method uses a regular expression to match all Unicode letter characters
  /// (including accents and symbols) in the string, and returns them as a single
  /// string. If `excludeSymbols` is set to `true`, only basic Latin letters will
  /// be extracted.
  ///
  /// Example:
  ///
  ///```
  /// String text = 'Hello, Wörld!';
  /// String letters = text.extractLetters(); // 'HelloWrld'
  /// String lettersWithSymbols = text.extractLetters(excludeSymbols: false); // 'Hello, Wörld!'
  ///```
  String extractLetters({bool excludeSymbols = false}) {
    final pattern = excludeSymbols ? r'\p{L}' : r'[\p{L}\p{M}\p{S}]';
    return RegExp(pattern, unicode: true)
        .allMatches(this)
        .map((m) => m.group(0))
        .join();
  }

  /// Extracts all numbers, including decimals and currency symbols, from the string and returns them as a single string.
  ///
  /// This method uses a regular expression to match all numeric characters, including decimals and currency symbols, in the string.
  /// If `excludeDecimalsAndSymbols` is set to `true`, only digits will be extracted.
  ///
  /// Example:
  ///
  ///```
  /// String text = 'There are 5 items, each costing $10.99.';
  /// String numbers = text.extractNumbers(); // '5, 10.99'
  /// String digitsOnly = text.extractNumbers(excludeDecimalsAndSymbols: true); // '5'
  ///```
  String extractNumbers({bool excludeDecimalsAndSymbols = false}) {
    final pattern =
        excludeDecimalsAndSymbols ? r'\d' : r'[-+]?[\d.,]*[\d]+[\p{Sc}]?';
    return RegExp(pattern, unicode: true)
        .allMatches(this)
        .map((m) => m.group(0))
        .join();
  }

  /// Extracts all alphanumeric characters, including accents and symbols, from the string and returns them as a single string.
  ///
  /// This method uses a regular expression to match all Unicode letter and number characters
  /// (including accents and symbols) in the string, and returns them as a single
  /// string. If `excludeSymbols` is set to `true`, only basic Latin letters and digits will
  /// be extracted.
  ///
  /// Example:
  ///
  ///```
  /// String text = 'Hello, Wörld123!';
  /// String alphanumeric = text.extractAlphanumeric(); // 'HelloWrld123'
  /// String alphanumericWithoutSymbols = text.extractAlphanumeric(excludeSymbols: true); // 'HelloWrld123'
  /// ```
  String extractAlphanumeric({bool excludeSymbols = false}) {
    final pattern =
        excludeSymbols ? r'[\p{L}\p{N}]' : r'[\p{L}\p{M}\p{N}\p{S}]';
    return RegExp(pattern, unicode: true)
        .allMatches(this)
        .map((m) => m.group(0))
        .join();
  }

  /// Extracts all letters, including accents and symbols, from the string and returns them as a list.
  ///
  /// This method uses a regular expression to match all Unicode letter characters (including accents and symbols)
  /// in the string, and returns them as a list of strings. If `excludeSymbols` is set to `true`, only basic Latin
  /// letters will be extracted.
  ///
  /// Example:
  ///
  ///```
  /// String text = 'Hello, Wörld123!';
  /// List<String> letters = text.extractLettersList(); // ['H', 'e', 'l', 'l', 'o', 'W', 'ö', 'r', 'l', 'd']
  /// List<String> lettersWithoutSymbols = text.extractLettersList(excludeSymbols: true); // ['H', 'e', 'l', 'l', 'o', 'W', 'r', 'l', 'd']
  /// ```
  List<String> extractLettersList({bool excludeSymbols = false}) {
    final pattern = excludeSymbols ? r'\p{L}' : r'[\p{L}\p{M}\p{S}]';
    return RegExp(pattern, unicode: true)
        .allMatches(this)
        .map((m) => m.group(0)!)
        .toList();
  }

  /// Extracts all numbers, including decimals and currency symbols, from the string and returns them as a list.
  ///
  /// This method uses a regular expression to match all numeric characters, including decimals and currency symbols,
  /// in the string, and returns them as a list of strings. If `excludeDecimalsAndSymbols` is set to `true`, only
  /// basic integers will be extracted.
  ///
  /// Example:
  ///```
  /// String text = 'Hello, $12.34 and 56.78!';
  /// List<String> numbers = text.extractNumbersList(); // ['12.34', '56.78']
  /// List<String> numbersWithoutDecimals = text.extractNumbersList(excludeDecimalsAndSymbols: true); // ['12', '34', '56', '78']
  /// ```
  List<String> extractNumbersList({bool excludeDecimalsAndSymbols = false}) {
    final pattern =
        excludeDecimalsAndSymbols ? r'\d' : r'[-+]?[\d.,]*[\d]+[\p{Sc}]?';
    return RegExp(pattern, unicode: true)
        .allMatches(this)
        .map((m) => m.group(0)!)
        .toList();
  }

  /// Extracts words from the string, including those with accents and numbers.
  ///
  /// This method uses a regular expression to match all Unicode word characters (including letters, accents, and numbers)
  /// in the string, and returns them as a list of strings. If `excludeNumbers` is set to `true`, only basic Latin
  /// letters will be extracted.
  ///
  /// Example:
  ///```
  /// String text = 'Hello, Wörld123!';
  /// List<String> words = text.extractWords(); // ['Hello', 'Wörld', '123']
  /// List<String> wordsWithoutNumbers = text.extractWords(excludeNumbers: true); // ['Hello', 'Wörld']
  /// ```
  List<String> extractWords({bool excludeNumbers = false}) {
    final wordPattern =
        excludeNumbers ? r'\b[\p{L}\p{M}]+\b' : r'\b[\p{L}\p{M}\p{N}]+\b';
    return RegExp(wordPattern, unicode: true)
        .allMatches(this)
        .map((m) => m.group(0)!)
        .toList();
  }

  /// Extracts email addresses from the string.
  ///
  /// This method uses a regular expression to match all valid email addresses in the string,
  /// and returns them as a list of strings.
  ///
  /// Example:
  ///```
  /// String text = 'Contact me at john@example.com or jane@example.org';
  /// List<String> emails = text.extractEmails(); // ['john@example.com', 'jane@example.org']
  /// ```
  List<String> extractEmails() {
    return RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b')
        .allMatches(this)
        .map((m) => m.group(0)!)
        .toList();
  }

  /// Extracts URLs from the string.
  ///
  /// This method uses a regular expression to match all valid HTTP and HTTPS URLs in the string,
  /// and returns them as a list of strings.
  ///
  /// Example:
  ///```
  /// String text = 'Visit https://example.com or http://another.org';
  /// List<String> urls = text.extractUrls(); // ['https://example.com', 'http://another.org']
  ///```
  List<String> extractUrls() {
    return RegExp(r'https?://\S+')
        .allMatches(this)
        .map((m) => m.group(0)!)
        .toList();
  }

  /// Extracts custom patterns from the string.
  ///
  /// This method uses a regular expression to match all occurrences of the provided pattern in the string,
  /// and returns them as a list of strings.
  ///
  /// Parameters:
  /// - `pattern`: The regular expression pattern to match.
  /// - `unicode`: Whether to enable Unicode support in the regular expression. Defaults to `true`.
  ///
  /// Example:
  ///
  /// String text = 'This is a sample text with some numbers: 123, 456, 789.';
  /// List<String> numbers = text.extractCustomPattern(r'\d+');
  /// // ['123', '456', '789']
  ///
  List<String> extractCustomPattern(String pattern, {bool unicode = true}) {
    return RegExp(pattern, unicode: unicode)
        .allMatches(this)
        .map((m) => m.group(0)!)
        .toList();
  }
}

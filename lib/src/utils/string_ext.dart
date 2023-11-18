part of advance_math;

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
    return emailRegExp.hasMatch(this);
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
  bool isValidPassword() {
    final passwordRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
    return passwordRegExp.hasMatch(this);
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
}

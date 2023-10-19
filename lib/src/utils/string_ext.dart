part of advance_math;

extension ExtString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s]');
    return !nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
    return passwordRegExp.hasMatch(this);
  }

  bool get containsSymbol {
    final stringRegExp = RegExp(r'^(?=.*?[!@#\$&*~])');
    return stringRegExp.hasMatch(this);
  }

  bool get containsUpperMixCaseLetter {
    final stringRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])');
    return stringRegExp.hasMatch(this);
  }

  bool get containsNumber {
    final stringRegExp = RegExp(r'^(?=.*?[0-9])');
    return stringRegExp.hasMatch(this);
  }

  bool get isNotNull {
    // ignore: unnecessary_null_comparison
    return this != null;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r'(^(?:[+0]9)?[0-9]{10}$)');
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidNumeric {
    final phoneRegExp = RegExp(r'(^(?:[+0]9)?[0-9]$)');
    return phoneRegExp.hasMatch(this);
  }

  String get inCaps =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String get allInCaps => toUpperCase();

  String capitalize({bool all = true}) {
    return (all)
        ? replaceAll(RegExp(' +'), ' ')
            .split(" ")
            .map((str) => str.inCaps)
            .join(" ")
        : inCaps;
  }

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
}

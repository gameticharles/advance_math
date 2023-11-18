import 'package:advance_math/advance_math.dart';

void main() {
  var rateLimiter = RateLimiter(
    maxRequests: 10,
    interval: Duration(seconds: 10),
  );
  var translator = MorseCodeTranslator(
    loggingEnabled: true,
    rateLimiter: rateLimiter,
  );
  var encoded = translator.encode('SOS');
  print('Encoded: $encoded');

  var decoded = translator.decode(encoded);
  print('Decoded: $decoded');

  print('');

  encoded = translator.encode('Enable logging for debugging');
  decoded = translator.decode(encoded);
  print('Decoded: $decoded');

  print('');
  String decodingValue =
      ".... .. / - .... . .-. . / .... --- .-- / .- .-. . / -.-- --- ..- ..--..";
  decoded = translator.decode(decodingValue);
  print('Decoded: $decoded');
}

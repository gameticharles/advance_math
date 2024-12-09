import 'package:advance_math/advance_math.dart';

void main(List<String> args) {
  RomanNumerals romanFive = RomanNumerals(5);
  print(romanFive); // V
  print(RomanNumerals(69)); // LXIX
  print(RomanNumerals(8785, useOverline: false)); // (VIII)DCCLXXXV
  print(RomanNumerals(3999999, useOverline: true));
  print(RomanNumerals(3999999, useOverline: false));

  print(RomanNumerals.romanToDate('VIII・XXII・MCMLXXXIX',
      sep: '・', format: 'MMMM d, yyyy')); // Outputs: August 22, 1989
  print(RomanNumerals.romanToDate('VIII • XXII • MCMLXXXIX'));

  print(RomanNumerals(3449671, useOverline: false));
  print(RomanNumerals(3449671, zeroChar: 'N', useOverline: false));
  // print(RomanNumerals.fromRoman('V̅MMMDCCLXXXV').value);

  String testString =
      "Hello123World456! Café au lait costs 3.50€. Contact: test@example.com or visit https://example.com";

  print(testString.extractLetters()); // Includes 'é'
  print(testString.extractNumbers()); // Includes '3.50'
  print(testString.extractWords()); // Includes words with numbers
  print(testString.extractAlphanumeric()); // Outputs: Hello123World456

  print(testString
      .extractLettersList()); // Outputs: [H, e, l, l, o, W, o, r, l, d]
  print(testString.extractNumbersList()); // Outputs: [1, 2, 3, 4, 5, 6]
  print(testString.extractEmails()); // Extracts email address
  print(testString.extractUrls()); // Extracts URL

  // Custom pattern example: extract words starting with 'C'
  print(testString.extractCustomPattern(r'\bC\w+', unicode: false));

  List<Parcel> parcelsList = [
    Parcel(parcelId: "AB123"),
    Parcel(parcelId: "AB456"),
    Parcel(parcelId: "WD345"),
    Parcel(parcelId: "CD789"),
    Parcel(parcelId: "CD012")
  ];

  Map<String, List<Parcel>> groupedParcels =
      parcelsList.groupBy((parcel) => parcel.parcelId.extractLetters());

  groupedParcels.forEach((key, value) {
    print('$key: ${value.map((p) => p.parcelId).join(', ')}');
  });

  // Example list of maps representing parcels
  List<Map<String, dynamic>> parcels = [
    {'id': 'AB123', 'area': 100, 'type': 'residential'},
    {'id': 'AB456', 'area': 150, 'type': 'commercial'},
    {'id': 'CD789', 'area': 200, 'type': 'residential'},
    {'id': 'CD012', 'area': 120, 'type': 'industrial'},
  ];

  // Group by the first two letters of the id
  var groupedByScheme =
      parcels.groupBy((parcel) => parcel['id'].substring(0, 2));
  print('Grouped by scheme:');
  groupedByScheme.forEach((key, value) {
    print('$key: ${value.map((p) => p['id']).join(', ')}');
  });

  // Group by type using the groupByKey extension
  var groupedByType = parcels.groupByKey('type');
  print('\nGrouped by type:');
  groupedByType.forEach((key, value) {
    print('$key: ${value.map((p) => p['id']).join(', ')}');
  });

  // Group by area range
  var groupedByAreaRange = parcels.groupBy((parcel) {
    int area = parcel['area'];
    if (area < 120) return 'small';
    if (area < 180) return 'medium';
    return 'large';
  });
  print('\nGrouped by area range:');
  groupedByAreaRange.forEach((key, value) {
    print('$key: ${value.map((p) => p['id']).join(', ')}');
  });
}

class Parcel {
  final String parcelId;
  Parcel({required this.parcelId});
}

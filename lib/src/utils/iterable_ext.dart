part of advance_math;

extension GroupingExtension<T> on Iterable<T> {
  /// Groups the elements of the iterable by a key extracted using the provided [keyExtractor] function.
  ///
  /// [keyExtractor] is a function that takes an element of type T and returns the key of type K.
  /// Returns a Map where each key is of type K and the corresponding value is a List of elements of type T.
  ///
  /// This method can be used on any Iterable, including `List<T>` and `List<Map<String, dynamic>>`.
  ///
  /// Example usage with a list of custom objects:
  /// ```dart
  /// class Parcel {
  ///   final String parcelId;
  ///   Parcel({required this.parcelId});
  /// }
  ///
  /// List<Parcel> parcels = [
  ///   Parcel(parcelId: "AB123"),
  ///   Parcel(parcelId: "AB456"),
  ///   Parcel(parcelId: "CD789"),
  ///   Parcel(parcelId: "CD012")
  /// ];
  /// Map<String, List<Parcel>> groupedParcels = parcels.groupBy(
  ///   (parcel) => parcel.parcelId.extractLetters()
  /// );
  /// groupedParcels.forEach((key, value) {
  ///   print('$key: ${value.map((p) => p.parcelId).join(', ')}');
  /// });
  /// ```
  ///
  /// Example usage with a list of maps:
  /// ```dart
  /// List<Map<String, dynamic>> parcels = [
  ///   {'id': 'AB123', 'area': 100, 'type': 'residential'},
  ///   {'id': 'AB456', 'area': 150, 'type': 'commercial'},
  ///   {'id': 'CD789', 'area': 200, 'type': 'residential'},
  ///   {'id': 'CD012', 'area': 120, 'type': 'industrial'},
  /// ];
  ///
  /// // Group by the first two letters of the id
  /// var groupedByScheme = parcels.groupBy((parcel) => parcel['id'].substring(0, 2));
  /// print('Grouped by scheme:');
  /// groupedByScheme.forEach((key, value) {
  ///   print('$key: ${value.map((p) => p['id']).join(', ')}');
  /// });
  ///
  /// // Group by area range
  /// var groupedByAreaRange = parcels.groupBy((parcel) {
  ///   int area = parcel['area'];
  ///   if (area < 120) return 'small';
  ///   if (area < 180) return 'medium';
  ///   return 'large';
  /// });
  /// print('\nGrouped by area range:');
  /// groupedByAreaRange.forEach((key, value) {
  ///   print('$key: ${value.map((p) => p['id']).join(', ')}');
  /// });
  /// ```
  ///
  /// The method is flexible and can handle various types of grouping criteria,
  /// from simple property extraction to complex conditional logic.
  Map<K, List<T>> groupBy<K>(K Function(T) keyExtractor) {
    return fold<Map<K, List<T>>>(
      {},
      (Map<K, List<T>> map, T element) {
        final key = keyExtractor(element);
        map.putIfAbsent(key, () => []).add(element);
        return map;
      },
    );
  }
}

extension MapListGroupingExtension on List<Map<String, dynamic>> {
  /// Groups the list of maps by a specific key in the maps.
  ///
  /// [key] is the String key to group by.
  /// Returns a Map where each key is the value of the specified key in the maps,
  /// and the corresponding value is a List of maps that have that value for the key.
  ///
  /// This method is a convenient shorthand for grouping a `List<Map<String, dynamic>>`
  /// by a specific key without needing to write a custom keyExtractor function.
  ///
  /// Example usage:
  /// ```dart
  /// List<Map<String, dynamic>> parcels = [
  ///   {'id': 'AB123', 'area': 100, 'type': 'residential'},
  ///   {'id': 'AB456', 'area': 150, 'type': 'commercial'},
  ///   {'id': 'CD789', 'area': 200, 'type': 'residential'},
  ///   {'id': 'CD012', 'area': 120, 'type': 'industrial'},
  /// ];
  ///
  /// // Group by type using the groupByKey extension
  /// var groupedByType = parcels.groupByKey('type');
  /// print('\nGrouped by type:');
  /// groupedByType.forEach((key, value) {
  ///   print('$key: ${value.map((p) => p['id']).join(', ')}');
  /// });
  /// ```
  ///
  /// This method is particularly useful when working with data fetched from APIs
  /// or databases, where the data is often in the form of a list of maps.
  Map<dynamic, List<Map<String, dynamic>>> groupByKey(String key) {
    return groupBy((map) => map[key]);
  }
}

extension IterableExt<E> on Iterable<E> {
  /// Extends [Iterable] with the ability to intersperse an element of type [T] between each element.
  ///
  /// This extension adds the `insertBetween` method to any `Iterable` object,
  /// allowing for the insertion of a separator of type [T] between each of the iterable's elements.
  ///
  /// The separator is inserted after each element except the last,
  /// ensuring that the iterable's original order is preserved with the
  /// separator neatly placed in between.
  ///
  /// The method is generic, allowing the separator to be of a different type from the elements
  /// in the iterable. This is particularly useful when the elements are of a basic type (like `int`),
  /// and the separator is of a different type (like `String`).
  ///
  /// Example Usage:
  /// ```dart
  /// final numbers = [1, 2, 3];
  /// final withComma = numbers.insertBetween<String>(',').toList();
  /// print(withComma); // Output: ['1', ',', '2', ',', '3']
  /// ```
  ///
  /// In a Flutter context, it can be used to intersperse widgets, such as:
  /// ```dart
  /// Column(
  ///   children: <Widget>[
  ///     FloatingActionButton(onPressed: () {}, tooltip: 'Increment', child: const Icon(Icons.add)),
  ///     FloatingActionButton(onPressed: () {}, tooltip: 'Increment', child: const Icon(Icons.add)),
  ///   ].insertBetween<Widget>(const SizedBox(height: 5.0)).toList(),
  /// )
  /// ```
  ///
  /// [E] - The type of elements in the iterable.
  ///
  /// [T] - The type of the separator to be inserted.
  Iterable<T> insertBetween<T>(T separator) sync* {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return; // Exit if the iterable is empty

    while (true) {
      yield iterator.current as T; // Cast each element to type T
      if (!iterator.moveNext()) break; // Stop if no more elements
      yield separator;
    }
  }

  /// Returns the sum of all elements in this iterable.
  ///
  /// For numeric types, this adds all elements together.
  /// Example: [1, 2, 3].sum() => 6
  ///
  /// For non-numeric types, you must provide a [selector] function to extract
  /// a numeric value from each element.
  /// Example: ['a', 'aa', 'aaa'].sum((s) => s.length) => 6
  ///
  /// If any element is a Complex number, all elements will be converted to Complex
  /// and the result will be Complex.
  /// Example: [1, 2, Complex(1,5), 9.7] => Complex(12.7, 5)
  dynamic sum([Function(E)? selector]) {
    if (selector != null) {
      return fold<dynamic>(0, (sum, element) => sum + selector(element));
    }

    try {
      // Convert all elements to Complex and sum them
      return fold<Complex>(Complex.zero(), (sum, element) {
        final complexElement = element is Complex ? element : Complex(element);
        return sum + complexElement;
      }).simplify();
    } catch (e) {
      throw ArgumentError(
          'Cannot sum non-numeric elements without a selector function');
    }
  }
}

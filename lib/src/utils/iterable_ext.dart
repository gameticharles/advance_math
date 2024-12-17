part of '/advance_math.dart';

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

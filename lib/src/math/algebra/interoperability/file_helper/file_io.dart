export 'file_io_stub.dart'
    if (dart.library.html) 'file_io_web.dart'
    if (dart.library.io) 'file_io_other.dart';

/// A class to provide file input/output operations.
///
/// Implementations of this class should provide means
/// to save data to a file and read data from a file.
abstract class FileIOBase {
  /// Saves the given data to a file.
  ///
  /// The parameters passed can be different based on the platform:
  ///   * For desktop, pass the file path as [pathOrData] and the content as [dataOrFileName].
  ///   * For web, pass the content as [pathOrData] and the filename as [dataOrFileName].
  ///
  /// Example usage (desktop):
  /// ```
  /// var fileIO = FileIO();
  /// fileIO.saveToFile("/path/to/file.txt", "This is some content.");
  /// ```
  /// Example usage (web):
  /// ```
  /// var fileIO = FileIO();
  /// fileIO.saveToFile("This is some content.", "file.txt");
  /// ```
  void saveToFile(String pathOrData, String dataOrFileName);

  /// Reads the content from a file.
  ///
  /// The parameter can be different based on the platform:
  ///   * For desktop, pass the file path.
  ///   * For web, pass the InputElement used for file upload.
  ///
  /// This method returns a `Future<String>` which completes with the content of the file.
  ///
  /// Example usage (desktop):
  /// ```
  /// var fileIO = FileIO();
  /// var content = await fileIO.readFromFile("/path/to/file.txt");
  /// print(content);
  /// ```
  /// Example usage (web):
  /// ```
  /// var fileIO = FileIO();
  /// InputElement uploadInput = querySelector('#upload');
  /// var content = await fileIO.readFromFile(uploadInput);
  /// print(content);
  /// ```
  Future<String> readFromFile(dynamic pathOrUploadInput);
}

import 'file_io.dart';

class FileIO implements FileIOBase {
  @override
  void saveToFile(String pathOrData, String dataOrFileName) {
    throw UnsupportedError('Cannot save a file without dart:io or dart:html.');
  }

  @override
  Future<String> readFromFile(dynamic pathOrUploadInput) {
    throw UnsupportedError('Cannot read a file without dart:io or dart:html.');
  }
}

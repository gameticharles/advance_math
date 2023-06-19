import 'dart:io';
import 'file_io.dart';

class FileIO implements FileIOBase {
  void _saveToFileDesktop(String path, String data) async {
    var file = File(path);
    await file.writeAsString(data);
  }

  Future<String> _readFromFileDesktop(String path) async {
    var file = File(path);
    if (await file.exists()) {
      var contents = await file.readAsString();
      return contents;
    } else {
      throw Exception('File does not exist');
    }
  }

  @override
  void saveToFile(String path, String data) {
    _saveToFileDesktop(path, data);
  }

  @override
  Future<String> readFromFile(dynamic path) async {
    return await _readFromFileDesktop(path);
  }
}

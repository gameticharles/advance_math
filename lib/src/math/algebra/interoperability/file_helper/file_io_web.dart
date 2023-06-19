import 'dart:async';
import 'dart:html';

import 'file_io.dart';

class FileIO implements FileIOBase {
  void _saveToFileWeb(String data, String fileName) {
    var blob = Blob([data]);
    var url = Url.createObjectUrlFromBlob(blob);
    var anchor = document.createElement('a') as AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;
    document.body!.children.add(anchor);

    // download the file
    anchor.click();

    // cleanup the DOM
    document.body!.children.remove(anchor);
    Url.revokeObjectUrl(url);
  }

  Future<String> _readFromFileWeb(InputElement uploadInput) async {
    var file = uploadInput.files!.first;
    var reader = FileReader();

    var completer = Completer<String>();
    reader.onLoadEnd.listen((e) {
      completer.complete(reader.result as String);
    });
    reader.onError.listen((fileError) {
      completer.completeError(fileError);
    });
    reader.readAsText(file);

    return completer.future;
  }

  @override
  void saveToFile(String data, String fileName) {
    _saveToFileWeb(data, fileName);
  }

  @override
  Future<String> readFromFile(dynamic uploadInput) async {
    return await _readFromFileWeb(uploadInput);
  }
}

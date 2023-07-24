//part of interoperability;

// array element data types
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';

import '../../basic/math.dart';

var eTypes = {
  'miINT8': {'n': 1, 'fmt': 'b'},
  'miUINT8': {'n': 2, 'fmt': 'B'},
  'miINT16': {'n': 3, 'fmt': 'h'},
  'miUINT16': {'n': 4, 'fmt': 'H'},
  'miINT32': {'n': 5, 'fmt': 'i'},
  'miUINT32': {'n': 6, 'fmt': 'I'},
  'miSINGLE': {'n': 7, 'fmt': 'f'},
  'miDOUBLE': {'n': 9, 'fmt': 'd'},
  'miINT64': {'n': 12, 'fmt': 'q'},
  'miUINT64': {'n': 13, 'fmt': 'Q'},
  'miMATRIX': {'n': 14},
  'miCOMPRESSED': {'n': 15},
  'miUTF8': {'n': 16, 'fmt': 's'},
  'miUTF16': {'n': 17, 'fmt': 's'},
  'miUTF32': {'n': 18, 'fmt': 's'}
};

// inverse mapping of eTypes
var invETypes = eTypes.map((k, v) => MapEntry(v['n'], k));

// matrix array classes
var mClasses = {
  'mxCELL_CLASS': 1,
  'mxSTRUCT_CLASS': 2,
  'mxOBJECT_CLASS': 3,
  'mxCHAR_CLASS': 4,
  'mxSPARSE_CLASS': 5,
  'mxDOUBLE_CLASS': 6,
  'mxSINGLE_CLASS': 7,
  'mxINT8_CLASS': 8,
  'mxUINT8_CLASS': 9,
  'mxINT16_CLASS': 10,
  'mxUINT16_CLASS': 11,
  'mxINT32_CLASS': 12,
  'mxUINT32_CLASS': 13,
  'mxINT64_CLASS': 14,
  'mxUINT64_CLASS': 15,
  'mxFUNCTION_CLASS': 16,
  'mxOPAQUE_CLASS': 17,
  'mxOBJECT_CLASS_FROM_MATRIX_H': 18
};

// inverse mapping of mClasses
var invMClasses = mClasses.map((k, v) => MapEntry(v, k));

// map of numeric array classes to data types
var numericClassETypes = {
  'mxDOUBLE_CLASS': 'miDOUBLE',
  'mxSINGLE_CLASS': 'miSINGLE',
  'mxINT8_CLASS': 'miINT8',
  'mxUINT8_CLASS': 'miUINT8',
  'mxINT16_CLASS': 'miINT16',
  'mxUINT16_CLASS': 'miUINT16',
  'mxINT32_CLASS': 'miINT32',
  'mxUINT32_CLASS': 'miUINT32',
  'mxINT64_CLASS': 'miINT64',
  'mxUINT64_CLASS': 'miUINT64'
};

// data types that may be used when writing numeric data
var compressedNumeric = ['miINT32', 'miUINT16', 'miINT16', 'miUINT8'];

// Encode a string to bytes
Uint8List stringToBytes(String s) {
  return Uint8List.fromList(utf8.encode(s));
}

// Decode bytes to a string
String bytesToString(Uint8List bytes) {
  return utf8.decode(bytes);
}

/// Diff elements of a sequence:
/// s -> s0 - s1, s1 - s2, s2 - s3, ...
List<num> diff(List<num> iterable) {
  var result = <num>[];
  for (var i = 0; i < iterable.length - 1; i++) {
    result.add(iterable[i] - iterable[i + 1]);
  }
  return result;
}

/// Unpack a byte string to the given format. If the byte string
/// contains more bytes than required for the given format, the function
/// returns a tuple of values.
dynamic unpack(String endian, String fmt, List<int> data) {
  var byteData = ByteData.view(Uint8List.fromList(data).buffer);
  Endian endianFlag = endian == '<' ? Endian.little : Endian.big;

  Map<String, Function> fmtFunc = {
    'b': () => byteData.getInt8(0),
    'B': () => byteData.getUint8(0),
    'h': () => byteData.getInt16(0, endianFlag),
    'H': () => byteData.getUint16(0, endianFlag),
    'i': () => byteData.getInt32(0, endianFlag),
    'I': () => byteData.getUint32(0, endianFlag),
    'f': () => byteData.getFloat32(0, endianFlag),
    'd': () => byteData.getFloat64(0, endianFlag),
    'q': () => byteData.getInt64(0, endianFlag),
    'Q': () => byteData.getUint64(0, endianFlag),
    's': () => String.fromCharCodes(data),
  };

  if (fmtFunc.containsKey(fmt)) {
    return fmtFunc[fmt]!();
  } else {
    throw ArgumentError('Invalid format: $fmt');
  }
}

/// Read mat 5 file header of the file fd.
/// Returns a dict with header values.
Map<String, dynamic> readFileHeader(RandomAccessFile fd, String endian) {
  List<Map<String, dynamic>> fields = [
    {'name': 'description', 'fmt': 's', 'num_bytes': 116},
    {'name': 'subsystem_offset', 'fmt': 's', 'num_bytes': 8},
    {'name': 'version', 'fmt': 'H', 'num_bytes': 2},
    {'name': 'endian_test', 'fmt': 's', 'num_bytes': 2}
  ];
  var hDict = <String, dynamic>{};
  for (var field in fields) {
    var data = fd.readSync(field['num_bytes']);
    hDict[field['name']] = unpack(endian, field['fmt'], data);
  }
  hDict['description'] = (hDict['description'] as String).trim();
  var vMajor = hDict['version'] >> 8;
  var vMinor = hDict['version'] & 0xFF;
  hDict['__version__'] = '$vMajor.$vMinor';
  return hDict;
}

/// Read data element tag: type and number of bytes.
/// If tag is of the Small Data Element (SDE) type the element data
/// is also returned.
Map<String, dynamic> readElementTag(RandomAccessFile fd, String endian) {
  var data = fd.readSync(8);
  var mtpn = unpack(endian, 'I', data.sublist(0, 4));
  // The most significant two bytes of mtpn will always be 0,
  // if they are not, this must be SDE format
  int numBytes = mtpn >> 16; //dynamic
  if (numBytes > 0) {
    // small data element format
    mtpn = mtpn & 0xFFFF;
    if (numBytes > 4) {
      throw Exception('Error parsing Small Data Element (SDE) formatted data');
    }
    data = data.sublist(4, 4 + numBytes);
  } else {
    // regular element
    numBytes = unpack(endian, 'I', data.sublist(4));
    data = Uint8List(0);
  }
  return {'mtpn': mtpn, 'numBytes': numBytes, 'data': data};
}

/// Read elements from the file.
///
/// If list of possible matrix data types mtps is provided, the data type
/// of the elements are verified.
dynamic readElements(RandomAccessFile fd, String endian, List<String> mtps,
    {bool isName = false}) {
  var elementTag = readElementTag(fd, endian);
  var mtpn = elementTag['mtpn'];
  var numBytes = elementTag['numBytes'];
  var data = elementTag['data'];

  if (mtps.isEmpty &&
      !mtps.contains(
          eTypes.keys.firstWhere((key) => eTypes[key]!['n'] == mtpn))) {
    throw Exception(
        'Got type $mtpn, expected ${mtps.map((mtp) => '${eTypes[mtp]!['n']} ($mtp)').join(' / ')}');
  }

  if (data == null) {
    // full format, read data
    data = fd.readSync(numBytes);
    // Seek to next 64-bit boundary
    var mod8 = numBytes % 8;
    if (mod8 != 0) {
      fd.setPositionSync((fd.positionSync() + (8 - mod8)).toInt());
    }
  }

  // parse data and return values
  dynamic val;
  if (isName) {
    // names are stored as miINT8 bytes
    // var fmt = 's';
    val = utf8.decode(data).split('0').where((s) => s.isNotEmpty).toList();
    if (val.isEmpty) {
      val = '';
    } else if (val.length == 1) {
      val = val[0];
    }
  } else {
    var fmt = eTypes[invETypes[mtpn]]!['fmt'];
    val = unpack(endian, fmt as String, data);
  }
  return val;
}

/// Read and return the matrix header.
dynamic readHeader(RandomAccessFile fd, String endian) {
  var elements = readElements(fd, endian, ['miUINT32']);
  var flagClass = elements[0];
  var nzmax = elements[1];

  var header = {
    'mclass': flagClass & 0x0FF,
    'is_logical': (flagClass >> 9 & 1) == 1,
    'is_global': (flagClass >> 10 & 1) == 1,
    'is_complex': (flagClass >> 11 & 1) == 1,
    'nzmax': nzmax,
  };

  header['dims'] = readElements(fd, endian, ['miINT32']);
  header['n_dims'] = header['dims'].length;
  if (header['n_dims'] != 2) {
    throw Exception('Only matrices with dimension 2 are supported.');
  }

  header['name'] = readElements(fd, endian, ['miINT8'], isName: true);

  return header;
}

/// Read full header tag.
///
/// Return a dict with the parsed header, the file position of next tag,
/// a file like object for reading the uncompressed element data.
Future<Map<String, dynamic>> readVarHeader(
    RandomAccessFile fd, String endian) async {
  var tag = await fd.read(8);
  var mtpn = unpack(endian, 'I', tag.sublist(0, 4));
  var numBytes = unpack(endian, 'I', tag.sublist(4));
  var nextPos = fd.positionSync() + numBytes;

  if (mtpn == eTypes['miCOMPRESSED']!['n']) {
    // Read compressed data
    var data = await fd.read(numBytes);
    var decoder = ZLibDecoder();
    var decodedData = decoder.convert(data);

    // Create a new RandomAccessFile from the decompressed data
    var tempFile =
        File('${Directory.systemTemp.createTempSync().path}/tempFile.mat');

    await tempFile.writeAsBytes(decodedData);
    var fdVar = await tempFile.open();

    // Read full tag from the uncompressed data
    tag = await fdVar.read(8);
    mtpn = unpack(endian, 'I', tag.sublist(0, 4));
    numBytes = unpack(endian, 'I', tag.sublist(4));

    mtpn = 14;
  }

  if (mtpn != eTypes['miMATRIX']!['n']) {
    throw Exception(
        'Expecting miMATRIX type number ${eTypes['miMATRIX']!['n']}, got $mtpn');
  }

  // Read the header
  var header = readHeader(fd, endian);
  return {'header': header, 'next_pos': nextPos, 'fd': fd};
}

/// Return array contents if array contains only one element.
/// Otherwise, return the full array.
dynamic squeeze(List array) {
  if (array.length == 1) {
    return array[0];
  }
  return array;
}

/// Read a numeric matrix.
/// Returns an array with rows of the numeric matrix.
dynamic readNumericArray(RandomAccessFile fd, String endian,
    Map<String, dynamic> header, List<String> dataETypes) {
  if (header['is_complex']) {
    throw Exception('Complex arrays are not supported');
  }

  // Read array data (stored as column-major)
  var data = readElements(fd, endian, dataETypes);
  if (data is! List) {
    // Not an array, just a value
    return data;
  }

  // Transform column major data continuous array to
  // a row major array of nested lists
  var rowCount = header['dims'][0];
  var colCount = header['dims'][1];
  var array = List.generate(rowCount,
      (r) => List.generate(colCount, (c) => data[(c * rowCount + r).toInt()]));

  // Pack and return the array
  return squeeze(array);
}

/// Read a cell array.
/// Returns an array with rows of the cell array.
dynamic readCellArray(
    RandomAccessFile fd, String endian, Map<String, dynamic> header) async {
  var array = List.generate(header['dims'][0], (_) => <dynamic>[]);

  for (var row = 0; row < header['dims'][0]; row++) {
    for (var col = 0; col < header['dims'][1]; col++) {
      // Read the matrix header and array
      var result = await readVarHeader(fd, endian);
      var vHeader = result[0];
      var nextPos = result[1];
      var fdVar = result[2];

      var vArray = readVarArray(fdVar, endian, vHeader);
      array[row].add(vArray);

      // Move on to next field
      fd.setPositionSync(nextPos);
    }
  }

  // Pack and return the array
  if (header['dims'][0] == 1) {
    return squeeze(array[0]);
  }
  return squeeze(array);
}

/// Read a struct array.
/// Returns a dict with fields of the struct array.
Future<Map<String, dynamic>> readStructArray(
    RandomAccessFile fd, String endian, Map<String, dynamic> header) async {
  // Read field name length (unused, as strings are null terminated)
  var fieldNameLength = readElements(fd, endian, ['miINT32']);
  if (fieldNameLength > 32) {
    throw Exception('Unexpected field name length: $fieldNameLength');
  }

  // Read field names
  var fields = readElements(fd, endian, ['miINT8'], isName: true);
  if (fields is String) {
    fields = [fields];
  }

  // Read rows and columns of each field
  empty() => List.generate(header['dims'][0], (_) => <dynamic>[]);
  var array = <String, dynamic>{};

  for (var row = 0; row < header['dims'][0]; row++) {
    for (var col = 0; col < header['dims'][1]; col++) {
      for (var field in fields) {
        // Read the matrix header and array
        var result = await readVarHeader(fd, endian);
        var vHeader = result[0];
        var nextPos = result[1];
        var fdVar = result[2];

        var data = readVarArray(fdVar, endian, vHeader);
        if (!array.containsKey(field)) {
          array[field] = empty();
        }
        array[field][row].add(data);

        // Move on to next field
        fd.setPositionSync(nextPos);
      }
    }
  }

  // Pack the nested arrays
  for (var field in fields) {
    var rows = array[field];
    for (var i = 0; i < header['dims'][0]; i++) {
      rows[i] = squeeze(rows[i]);
    }
    array[field] = squeeze(array[field]);
  }

  return array;
}

dynamic readCharArray(
    RandomAccessFile fd, String endian, Map<String, dynamic> header) {
  var array = readNumericArray(fd, endian, header, ['miUTF8']);
  if (header['dims'][0] > 1) {
    // collapse rows of chars into a list of strings
    array = array.map((i) => String.fromCharCodes(i)).toList();
  } else {
    // collapse row of chars into a single string
    array = String.fromCharCodes(array);
  }
  return array;
}

/// Read variable array (of any supported type)
dynamic readVarArray(
    RandomAccessFile fd, String endian, Map<String, dynamic> header) {
  var mc = invMClasses[header['mclass']];

  if (numericClassETypes.containsKey(mc)) {
    return readNumericArray(
      fd,
      endian,
      header,
      [...compressedNumeric, numericClassETypes[mc] as String],
    );
  } else if (mc == 'mxSPARSE_CLASS') {
    throw Exception('Sparse matrices not supported');
  } else if (mc == 'mxCHAR_CLASS') {
    return readCharArray(fd, endian, header);
  } else if (mc == 'mxCELL_CLASS') {
    return readCellArray(fd, endian, header);
  } else if (mc == 'mxSTRUCT_CLASS') {
    return readStructArray(fd, endian, header);
  } else if (mc == 'mxOBJECT_CLASS') {
    throw Exception('Object classes not supported');
  } else if (mc == 'mxFUNCTION_CLASS') {
    throw Exception('Function classes not supported');
  } else if (mc == 'mxOPAQUE_CLASS') {
    throw Exception('Anonymous function classes not supported');
  }
}

/// Determine if end-of-file is reached for file fd
bool eof(RandomAccessFile fd) {
  var curPos = fd.positionSync();
  fd.setPositionSync(curPos + 1);
  var end = fd.positionSync() >= fd.lengthSync();
  if (!end) {
    fd.setPositionSync(curPos);
  }
  return end;
}

Future<Map<String, dynamic>> loadMat(String filename,
    {bool meta = false}) async {
  // Load data from MAT-file
  var fd = await File(filename).open();

  // Check mat file format is version 5
  // For 5 format we need to read an integer in the header.
  // Bytes 124 through 128 contain a version integer and an
  // endian test string
  await fd.setPosition(124);
  var tstStr = await fd.read(4);
  var littleEndian = String.fromCharCodes(tstStr.sublist(2, 4)) == 'IM';
  var endian = '';
  if ((Endian.host == Endian.little && littleEndian) ||
      (Endian.host == Endian.big && !littleEndian)) {
    // no byte swapping same endian
  } else if (Endian.host == Endian.little) {
    // byte swapping
    endian = '>';
  } else {
    // byte swapping
    endian = '<';
  }
  endian = '<';
  print('Endian: $endian');
  var majInd = littleEndian ? 1 : 0;

  // major version number
  var majVal = tstStr[majInd];

  if (majVal != 1) {
    throw Exception('Can only read from Matlab level 5 MAT-files');
  }

  var mDict = <String, dynamic>{};
  if (meta) {
    // read the file header
    await fd.setPosition(0);
    mDict['__header__'] = readFileHeader(fd, endian);
    mDict['__globals__'] = [];
  }

  // read data elements
  while (!eof(fd)) {
    var hdr = await readVarHeader(fd, endian);
    var nextPosition = hdr['nextPosition'];
    var fdVar = hdr['fdVar'];
    var name = hdr['name'];
    print(name);
    if (mDict.containsKey(name)) {
      throw Exception('Duplicate variable name "$name" in mat file.');
    }

    // read the matrix
    mDict[name] = await readVarArray(fdVar, endian, hdr);
    if (meta && hdr['isGlobal']) {
      mDict['__globals__'].add(name);
    }

    // move on to next entry in file
    await fd.setPosition(nextPosition);
  }

  await fd.close();
  return mDict;
}

/// write file header
Future<void> writeFileHeader(RandomAccessFile fd) async {
  // ignore: prefer_interpolation_to_compose_strings
  var desc = 'MATLAB 5.0 MAT-file, created with advance_math on: ' +
      DateFormat('E, MMM d, yyyy HH:mm:ss').format(DateTime.now());
  var descBytes = Uint8List.fromList(desc.codeUnits);
  await fd.writeFrom(descBytes, 0, 116);

  var padding = Uint8List(8); // 8 bytes of space
  await fd.writeFrom(padding);

  var version = Uint8List(2);
  version.buffer.asByteData().setInt16(0, 0x100, Endian.big);
  await fd.writeFrom(version);

  var endianIndicator = Uint8List.fromList(
      Endian.host == Endian.big ? 'MI'.codeUnits : 'IM'.codeUnits);
  await fd.writeFrom(endianIndicator);
}

/// Write data element tag and data.
///
/// The tag contains the array type and the number of
/// bytes the array data will occupy when written to file.
///
/// If data occupies 4 bytes or less, it is written immediately
/// as a Small Data Element (SDE).
Future<void> writeElements(
    RandomAccessFile fd, String mtp, dynamic data, bool isName) async {
  var eType = eTypes[mtp];
  var fmt = eType!['fmt'] as String;
  var bytes = BytesBuilder();

  if (data is List) {
    if (fmt == 's' || isName) {
      for (var s in data) {
        if (s is String) {
          if (isName && s.length > 31) {
            throw Exception(
                'Name "$s" is too long (max. 31 characters allowed)');
          }
          bytes.add(utf8.encode(s));
        }
      }
    } else {
      if (data.isEmpty) {
        // empty array
      } else if (data.isNotEmpty) {
        // more than one element to be written
        for (var d in data) {
          bytes.add(_getBytes(fmt, d));
        }
      }
    }
  } else {
    bytes.add(_getBytes(fmt, data));
  }

  var numBytes = bytes.length;
  if (numBytes <= 4) {
    // write SDE
    if (numBytes < 4) {
      // add pad bytes
      bytes.add(Uint8List(4 - numBytes));
    }
    await fd.writeFrom(
        Uint8List.fromList([eType['n'] as int, numBytes, ...bytes.toBytes()]));
    return;
  }

  // write tag: element type and number of bytes
  var tag = ByteData(8);
  tag.setUint8(0, eType['n'] as int);
  tag.setUint32(4, numBytes, Endian.little);
  await fd.writeFrom(tag.buffer.asUint8List());

  // add pad bytes to bytes, if needed
  var mod8 = numBytes % 8;
  if (mod8 != 0) {
    bytes.add(Uint8List(8 - mod8));
  }

  // write data
  await fd.writeFrom(bytes.toBytes());
}

Uint8List _getBytes(String fmt, dynamic data) {
  var bytes = ByteData(4);
  if (fmt == 'I') {
    bytes.setUint32(0, data, Endian.little);
  } else if (fmt == 'd') {
    bytes.setFloat64(0, data, Endian.little);
  } else if (fmt == 's') {
    return Uint8List.fromList((data as String).codeUnits);
  }
  return bytes.buffer.asUint8List();
}

/// Write variable header
Future<void> writeVarHeader(
    RandomAccessFile fd, Map<String, dynamic> header) async {
  // write tag bytes, and array flags + class and nzmax (null bytes)
  var tag = ByteData(8);
  tag.setUint8(0, eTypes['miUINT32']!['n'] as int);
  tag.setUint32(4, 8, Endian.little);
  await fd.writeFrom(tag.buffer.asUint8List());

  var arrayFlags = ByteData(8);
  arrayFlags.setUint8(0, mClasses[header['mclass']]!);
  await fd.writeFrom(arrayFlags.buffer.asUint8List());

  // write dimensions array
  await writeElements(fd, 'miINT32', header['dims'], false);

  // write var name
  await writeElements(fd, 'miINT8', stringToBytes(header['name']), true);
}

/// Write variable data to file
Future<void> writeVarData(RandomAccessFile fd, Uint8List data) async {
  // write array data elements (size info)
  var tag = ByteData(8);
  tag.setUint8(0, eTypes['miMATRIX']!['n'] as int);
  tag.setUint32(4, data.length, Endian.little);
  await fd.writeFrom(tag.buffer.asUint8List());

  // write the data
  await fd.writeFrom(data);
}

// Write compressed variable data to file
Future<void> writeCompressedVarArray(
    RandomAccessFile fd, List<dynamic> array, String name) async {
  var bd = BytesBuilder();

  writeVarArray(fd, array, name);

  var data = Uint8List.fromList(gzip.encode(bd.toBytes()));

  // write array data elements (size info)
  var tag = ByteData(8);
  tag.setUint8(0, eTypes['miCOMPRESSED']!['n'] as int);
  tag.setUint32(4, data.length, Endian.little);
  await fd.writeFrom(tag.buffer.asUint8List());

  // write the compressed data
  await fd.writeFrom(data);
}

void writeNumericArray(
    RandomAccessFile fd, Map<String, dynamic> header, List<dynamic> array) {
  var data = BytesBuilder();

  // Write the matrix header to the BytesBuilder
  writeVarHeader(fd, header);

  if (array is! String && header['dims'][0] > 1) {
    // List array data in column major order
    array = array.expand((i) => i).toList();
  }

  // Write matrix data to BytesBuilder
  writeElements(fd, header['mtp'], array, false);

  // Write the variable to disk file
  fd.writeFrom(data.takeBytes());
}

void writeCellArray(
    RandomAccessFile fd, Map<String, dynamic> header, List<dynamic> array) {
  var data = BytesBuilder();

  // Write the matrix header to the BytesBuilder
  writeVarHeader(fd, header);

  for (var row = 0; row < header['dims'][0]; row++) {
    for (var col = 0; col < header['dims'][1]; col++) {
      var vData = header['dims'][0] > 1 ? array[row][col] : array[col];
      writeVarArray(fd, vData);
    }
  }

  // Write the variable to disk file
  fd.writeFrom(data.takeBytes());
}

void writeStructArray(RandomAccessFile fd, Map<String, dynamic> header,
    Map<String, dynamic> array) {
  var data = BytesBuilder();

  // Write the matrix header to the BytesBuilder
  writeVarHeader(fd, header);

  var fieldNames = array.keys.toList();

  var fieldNamesSizes =
      fieldNames.map((f) => [f, f.length]).toList().cast<List<num>>();

  // Write field name length (the str length + a null byte)
  var fieldLength = fieldNamesSizes.map((item) => item[1]).reduce(max) + 1;
  if (fieldLength > 32) {
    throw ArgumentError('Struct field names are too long');
  }
  writeElements(fd, 'miINT32', fieldLength, false);

  // Write field names
  writeElements(
      fd,
      'miINT8',
      fieldNamesSizes.map((item) {
        var f = item[0];
        var l = item[1];
        return f + (fieldLength - l % fieldLength);
      }).toList(),
      true);

  // Wrap each field in a cell
  for (var row = 0; row < header['dims'][0]; row++) {
    for (var col = 0; col < header['dims'][1]; col++) {
      for (var field in fieldNames) {
        dynamic vData;
        if (header['dims'][0] > 1) {
          vData = array[field][col][row];
        } else if (header['dims'][1] > 1) {
          vData = array[field][col];
        } else {
          vData = array[field];
        }
        writeVarArray(fd, vData);
      }
    }
  }

  // Write the variable to disk file
  fd.writeFrom(data.takeBytes());
}

void writeCharArray(
    RandomAccessFile fd, Map<String, dynamic> header, dynamic array) {
  if (array is String) {
    // Split string into chars
    array = array.split('').toList();
  } else {
    // Split each string in list into chars
    array = array.map((s) => s.split('').toList()).toList();
  }
  writeNumericArray(fd, header, array);
}

void writeVarArray(RandomAccessFile file, dynamic array, [String name = '']) {
  var headerAndArray = guessHeader(array, name);
  var header = headerAndArray[0];
  array = headerAndArray[1];
  var mc = header['mclass'];
  if (numericClassETypes.containsKey(mc)) {
    writeNumericArray(file, header, array);
  } else if (mc == 'mxCHAR_CLASS') {
    writeCharArray(file, header, array);
  } else if (mc == 'mxCELL_CLASS') {
    writeCellArray(file, header, array);
  } else if (mc == 'mxSTRUCT_CLASS') {
    writeStructArray(file, header, array);
  } else {
    throw ArgumentError('Unknown mclass $mc');
  }
}

bool isArray(List<dynamic> array, bool Function(dynamic) test, [int dim = 2]) {
  if (dim > 1) {
    return array.every((item) => isArray(item, test, dim - 1));
  }
  return array.every(test);
}

Map<String, dynamic> guessHeader(dynamic array, [String name = '']) {
  var header = <String, dynamic>{};

  if (array is List && array.length == 1) {
    array = array[0];
  }

  if (array is String) {
    header.addAll({
      'mclass': 'mxCHAR_CLASS',
      'mtp': 'miUTF8',
      'dims': [1, array.isNotEmpty ? array.length : 0]
    });
  } else if (array is List && array.isEmpty) {
    header.addAll({
      'mclass': 'mxINT32_CLASS',
      'mtp': 'miINT32',
      'dims': [0, 0]
    });
  } else if (array is Map) {
    var fieldTypes = array.values.map((j) => j.runtimeType).toList();
    var fieldLengths = array.values.map((j) {
      if (j is String || j is int || j is double) {
        return 1;
      } else if (j is List) {
        return j.length;
      } else {
        return 0;
      }
    }).toList();
    bool equalLengths = fieldLengths.toSet().length == 1;
    bool equalTypes = fieldTypes.toSet().length == 1;
    header.addAll({
      'mclass': 'mxSTRUCT_CLASS',
      'dims': [1, equalLengths && equalTypes ? fieldLengths[0] : 1]
    });
  } else if (array is int) {
    if (array > pow(2, 31) - 1) {
      header.addAll({
        'mclass': 'mxINT64_CLASS',
        'mtp': 'miINT64',
        'dims': [1, 1]
      });
    } else {
      header.addAll({
        'mclass': 'mxINT32_CLASS',
        'mtp': 'miINT32',
        'dims': [1, 1]
      });
    }
  } else if (array is double) {
    header.addAll({
      'mclass': 'mxDOUBLE_CLASS',
      'mtp': 'miDOUBLE',
      'dims': [1, 1]
    });
  } else if (array is List) {
    if (array.every((i) => i is int)) {
      header.addAll({
        'mclass': 'mxINT32_CLASS',
        'mtp': 'miINT32',
        'dims': [1, array.length]
      });
    } else if (array.every((i) => i is int || i is double)) {
      header.addAll({
        'mclass': 'mxDOUBLE_CLASS',
        'mtp': 'miDOUBLE',
        'dims': [1, array.length]
      });
    } else if (array.any((s) => s is List)) {
      if (array.map((s) => s.length).toSet().length > 1) {
        header.addAll({
          'mclass': 'mxCELL_CLASS',
          'dims': [1, array.length]
        });
      } else if (array.every((i) => i is String)) {
        header.addAll({
          'mclass': 'mxCHAR_CLASS',
          'mtp': 'miUTF8',
          'dims': [array.length, array[0].length]
        });
      } else if (array.every((i) => i is List)) {
        if (array.map((j) => j.length).toSet().length > 1) {
          header.addAll({
            'mclass': 'mxCELL_CLASS',
            'dims': [array.length, array[0].length]
          });
        } else if (array.every((i) => i is int)) {
          header.addAll({
            'mclass': 'mxINT32_CLASS',
            'mtp': 'miINT32',
            'dims': [array.length, array[0].length]
          });
        } else if (array.every((i) => i is int || i is double)) {
          header.addAll({
            'mclass': 'mxDOUBLE_CLASS',
            'mtp': 'miDOUBLE',
            'dims': [array.length, array[0].length]
          });
        }
      } else if (array.every((i) =>
          i is int || i is double || i is String || i is List || i is Map)) {
        header.addAll({
          'mclass': 'mxCELL_CLASS',
          'dims': [1, array.length]
        });
      }
    }

    if (header.isEmpty) {
      throw ArgumentError(
          'Only dicts, two dimensional numeric, and char arrays are currently supported');
    }
    header['name'] = name;
    return header;
  }
  return header;
}

/// Save data to MAT-file:
///
/// savemat(filename, data)
///
/// The filename argument is either a string with the filename, or
/// a file like object.
///
/// The parameter ``data`` shall be a dict with the variables.
///
/// A ``ValueError`` exception is raised if data has invalid format, or if the
/// data structure cannot be mapped to a known MAT array type.
void saveMat(String filename, Map<String, dynamic> data) async {
  if (data.isEmpty) {
    throw ArgumentError('Data should be a Map of variable arrays');
  }

  var file = File(filename);
  var raf = file.openSync(mode: FileMode.write);

  writeFileHeader(raf);

  // write variables
  data.forEach((name, array) {
    writeCompressedVarArray(raf, array, name);
  });

  raf.closeSync();
}

void main(List<String> args) async {
  // Read the file as a list of bytes
  var filePath = 'assets/data/simple_struct.mat';

  var newMat = await loadMat(filePath, meta: true);
  print(newMat);
}

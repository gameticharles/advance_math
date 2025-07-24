// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:buffer/buffer.dart';

enum MatDataType {
  mxCELL_CLASS,
  mxSTRUCT_CLASS,
  mxOBJECT_CLASS,
  mxCHAR_CLASS,
  mxSPARSE_CLASS,
  mxDOUBLE_CLASS,
  mxSINGLE_CLASS,
  mxINT8_CLASS,
  mxUINT8_CLASS,
  mxINT16_CLASS,
  mxUINT16_CLASS,
  mxINT32_CLASS,
  mxUINT32_CLASS,
  mxINT64_CLASS,
  mxUINT64_CLASS;

  @override
  String toString() {
    return name;
  }
}

// class Mat {
//   final Uint8List data;

//   Mat(this.data);

//   List<MatField> get fields {
//     return data.asMap().entries.map((e) {
//       final name = e.key;
//       final data = e.value;
//       final type = data.first;
//       return MatField(name, type, data.sublist(1));
//     }).toList();
//   }
// }

class MatFile {
  final String filePath;
  late MatHeader header;

  late MatStruct matStruct;

  MatFile(this.filePath);

  void read() {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw FileNotFoundException('File not found: $filePath');
    }

    final reader = ByteDataReader(endian: Endian.little);
    reader.add(file.readAsBytesSync());

    header = MatHeader.fromBytes(reader);

    matStruct = MatStruct();
    while (reader.remainingLength > 0) {
      var tag = MatTag.fromBytes(reader);
      if (tag.size < 0 || tag.size > reader.remainingLength) {
        throw InvalidFieldSizeException('Invalid field size: ${tag.size}');
      }
      final fieldData = reader.read(tag.size);
      print('Field data: $fieldData');
      final fieldName = String.fromCharCodes(fieldData);
      print('Field name: ${fieldName.trim()}');
      //final fieldName = utf8.decoder.convert(reader.read(tag.size));
      if (fieldName.isEmpty) {
        throw InvalidFieldNameException('Field name is empty');
      }

      matStruct.addField(MatField(fieldName, tag.type, fieldData));
    }
  }

  void write() {
    final file = File(filePath);
    final writer = ByteDataWriter(endian: header.endian);

    header.writeTo(writer);

    matStruct.fields.forEach((name, field) {
      if (name.isEmpty) {
        throw InvalidFieldNameException('Field name is empty');
      }

      final tag = MatTag(field.type, field.data.length);
      tag.writeTo(writer);
      writer.write(utf8.encoder.convert(name));
      writer.write(field.data);
    });

    try {
      file.writeAsBytesSync(writer.toBytes());
    } catch (e) {
      throw IOException('Failed to write to file: $filePath');
    }
  }
}

class MatStruct {
  final Map<String, MatField> fields = {};

  void addField(MatField field) {
    if (fields.containsKey(field.name)) {
      throw FieldNameConflictException('Duplicate field name: ${field.name}');
    }
    fields[field.name] = field;
  }

  MatField getField(String name) {
    final field = fields[name];
    if (field == null) {
      throw FieldNotFoundException('Field not found: $name');
    }
    return field;
  }
}

class MatField {
  late String name;
  late MatDataType type;
  Uint8List data = Uint8List.fromList([]);

  MatField(this.name, this.type, this.data);

  MatField.fromDart(this.name, dynamic value) {
    final writer = ByteDataWriter(endian: Endian.little);

    if (value is int) {
      if (value.bitLength <= 8) {
        type = MatDataType.mxINT8_CLASS;
        writer.writeInt8(value);
      } else if (value.bitLength <= 16) {
        type = MatDataType.mxINT16_CLASS;
        writer.writeInt16(value);
      } else if (value.bitLength <= 32) {
        type = MatDataType.mxINT32_CLASS;
        writer.writeInt32(value);
      } else {
        type = MatDataType.mxINT64_CLASS;
        writer.writeInt64(value);
      }
    } else if (value is double) {
      type = MatDataType.mxDOUBLE_CLASS;
      writer.writeFloat64(value);
    } else if (value is String) {
      type = MatDataType.mxCHAR_CLASS;
      writer.write(utf8.encoder.convert(value));
    } else {
      throw UnimplementedError(
          'Unsupported Dart data type: ${value.runtimeType}');
    }

    data = writer.toBytes();
  }

  dynamic toDart() {
    final reader = ByteDataReader(endian: Endian.little);
    reader.add(data);

    switch (type) {
      case MatDataType.mxINT8_CLASS:
        return reader.readInt8();
      case MatDataType.mxINT16_CLASS:
        return reader.readInt16();
      case MatDataType.mxINT32_CLASS:
        return reader.readInt32();
      case MatDataType.mxINT64_CLASS:
        return reader.readInt64();
      case MatDataType.mxUINT8_CLASS:
        return reader.readUint8();
      case MatDataType.mxUINT16_CLASS:
        return reader.readUint16();
      case MatDataType.mxUINT32_CLASS:
        return reader.readUint32();
      case MatDataType.mxUINT64_CLASS:
        return reader.readUint64();
      case MatDataType.mxSINGLE_CLASS:
        return reader.readFloat32();
      case MatDataType.mxDOUBLE_CLASS:
        return reader.readFloat64();
      case MatDataType.mxCHAR_CLASS:
        return utf8.decoder.convert(data);
      default:
        throw UnimplementedError('Unsupported MAT data type: $type');
    }
  }
}

class MatHeader {
  late String description;
  late int version;
  late Endian endian;
  late String endianIndicator;

  MatHeader(this.description, this.version, this.endian);

  MatHeader.fromBytes(ByteDataReader reader) {
    if (reader.remainingLength < 128) {
      throw FormatException('File too short to contain a valid header');
    }

    final headerBytes = reader.read(128);
    description = utf8.decoder.convert(headerBytes.sublist(0, 116));
    version = headerBytes[124] + (headerBytes[125] << 8);

    endianIndicator = String.fromCharCodes(headerBytes.sublist(126, 128));
    if (endianIndicator == 'IM') {
      endian = Endian.big;
    } else if (endianIndicator == 'MI') {
      endian = Endian.little;
    } else {
      throw FormatException('Invalid endianness indicator: $endianIndicator');
    }
  }

  void writeTo(ByteDataWriter writer) {
    if (description.length > 116) {
      throw ArgumentError(
          'Description too long, must be 116 characters or fewer');
    }

    final headerBytes = Uint8List(128);
    final descriptionBytes = utf8.encoder.convert(description);
    headerBytes.setRange(0, descriptionBytes.length, descriptionBytes);
    headerBytes[124] = version & 0xFF;
    headerBytes[125] = (version >> 8) & 0xFF;
    headerBytes[126] =
        endian == Endian.big ? 'M'.codeUnitAt(0) : 'I'.codeUnitAt(0);
    headerBytes[127] = 'M'.codeUnitAt(0);
    writer.write(headerBytes);
  }
}

class MatTag {
  late MatDataType type;
  late int size;

  MatTag(this.type, this.size);

  MatTag.fromBytes(ByteDataReader reader) {
    if (reader.remainingLength < 8) {
      throw FormatException('Not enough bytes left to read a tag');
    }

    final typeCode = reader.readInt32();
    // Check that the type code corresponds to a valid MatDataType enum value
    if (typeCode < 0 || typeCode > MatDataType.values.length) {
      throw FormatException('Invalid type code: $typeCode');
    }

    type = MatDataType.values[typeCode - 1];
    print('typeCode: $typeCode');
    print('type: $type');
    size = reader.readInt32();
    if (size < 0) {
      throw FormatException('Invalid size: $size');
    }
  }

  void writeTo(ByteDataWriter writer) {
    // if (type == null || size == null) {
    //   throw StateError('Type and size must be non-null');
    // }

    writer.writeInt32(type.index);
    writer.writeInt32(size);
  }
}

class IOException implements Exception {
  final String message;
  IOException(this.message);
}

class FieldNameConflictException implements Exception {
  final String message;
  FieldNameConflictException(this.message);
}

class FieldNotFoundException implements Exception {
  final String message;
  FieldNotFoundException(this.message);
}

class InvalidFieldSizeException implements Exception {
  final String message;
  InvalidFieldSizeException(this.message);
}

class InvalidFieldNameException implements Exception {
  final String message;
  InvalidFieldNameException(this.message);
}

class FileNotFoundException implements Exception {
  final String message;
  FileNotFoundException(this.message);
}

// void main(List<String> args) async {
//   // Read the file as a list of bytes
//   var filePath = 'assets/data/simple_struct.mat';

//   var mat = MatFile(filePath);
//   mat.read();
//   print('Header description: ${mat.header.description}');
//   print('Version: ${mat.header.version}');
//   print('Endian indicator: ${mat.header.endianIndicator}');
//   print(mat.matStruct.fields.toString());
// }

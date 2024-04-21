import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

class FileUploadService {

  List<FileData> _fileDataList = [];



  List<FileData> get fileDataList => _fileDataList;

  void addFileData(FileData fileData) {

    final index =
        _fileDataList.indexWhere((data) => data.fileName == fileData.fileName);
    if (index != -1) {
      _fileDataList[index] = fileData;
    } else {
      _fileDataList.add(fileData);
    }
  }
  void updateFileData(FileData fileData, btn_Index) {

    if(_fileDataList.length>btn_Index)
    _fileDataList[btn_Index] = fileData;

    else _fileDataList.add(fileData);
  }

  void clearFileData(fileName) {
    final index =
    _fileDataList.indexWhere((data) => data.fileName == fileName);
    _fileDataList.removeAt(index);
  }
  void clearFileDataAll() {
    _fileDataList = [];
  }

  Future<void> saveAttachment(Response response) async {
    try {
      final body = response.data;
      final successMessage = body['message'];
      print(successMessage);
      final base64Data = body['data'];

      // Create anchor element
      final anchor = html.AnchorElement()
        ..href =
            "data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$base64Data"
        ..download = "processed_file.xlsx";

      // Simulate click and remove element
      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();

      // Handle success (e.g., show a snackbar)
      print('File download initiated.');
    } on DioError catch (e) {
      // Handle download error
      print('Download error: ${e.message}');
    }
  }
}

class FileData {
  final String fileName;
  final List<int> bytes;

  FileData({required this.fileName, required this.bytes});
}

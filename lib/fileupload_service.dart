import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

class FileUploadService {
  final Dio _dio = Dio();
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

  Future<void> processFiles() async {
    FormData formData =
        FormData.fromMap(_fileDataList.asMap().map((index, fileData) {
      return MapEntry(
        'file${index + 1}',
        MultipartFile.fromBytes(fileData.bytes,
            filename: fileData.fileName,
            contentType: MediaType('application',
                'vnd.openxmlformats-officedocument.spreadsheetml.sheet')),
      );
    }));

    try {
      print(_dio.options.toString());
      Response response = await _dio.post(
          'https://zc7wuf07h4.execute-api.ap-south-1.amazonaws.com/v3/process-excel',
          data: formData);
      if (response.statusCode == 200) {
        // Handle successful upload
        print('Files uploaded successfully');
        _saveAttachment(response);
      } else {
        // Handle error
        print('Files upload failed');
      }
    } catch (e) {
      // Handle exception
      print('Error uploading files: $e');
    }
  }

  Future<void> _saveAttachment(Response response) async {

    try {
      // Encode bytes to base64
     // final base64Data = base64Encode(response.data);
      final base64Data = response.data;

      // Create anchor element
      final anchor = html.AnchorElement()
        ..href = "data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$base64Data"
        ..download =   "processed_file.xlsx";

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
  Future<void> _saveAttachmentStreamed(Stream<List<int>> stream, String? contentLength) async {
    final chunks = <List<int>>[];
    int totalBytesReceived = 0;

    await for (final chunk in stream) {
      chunks.add(chunk);
      totalBytesReceived += chunk.length;

      // Optional progress update (consider UI feedback)
      // print('Downloaded: $totalBytesReceived bytes');
    }

    final bytes = Uint8List.fromList(chunks.expand((list) => list).toList());

    // Handle potential missing content-length header
    int downloadSize = bytes.length;
    if (contentLength != null) {
      downloadSize = int.parse(contentLength);
    }

    // Check for complete data based on content-length or accumulated size
    if (downloadSize > 0 && (bytes.length == downloadSize || totalBytesReceived == downloadSize)) {
      // We cannot assume the data format or encoding without inspecting the response
      // Implement logic to determine if decoding is necessary based on response headers or other cues

      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      print('download url='+ url);


     final anchor = html.AnchorElement(href: url)
        ..download = 'processed_file.xlsx'
        ..style.display = 'none';

      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();

      html.Url.revokeObjectUrl(url);
    } else {
      // Handle incomplete data or error (e.g., show a message to the user)
      print('Download incomplete or invalid data received');
    }
  }

}

class FileData {
  final String fileName;
  final List<int> bytes;

  FileData({required this.fileName, required this.bytes});
}

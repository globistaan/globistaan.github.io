import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FileUploadService {

  final _dio = Dio(
    BaseOptions(
      connectTimeout: 180000,
      receiveTimeout: 180000,
    )
  );

  Future<PlatformFile?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    return result?.files?.single;
  }

  MapEntry<String, MultipartFile>? prepareFormData(PlatformFile? file,String name){
     return MapEntry(
          name, // Key for file 1
          MultipartFile.fromBytes(file?.bytes?.toList() ?? [],
              filename: file?.name,
              contentType: MediaType('application',
                  'vnd.openxmlformats-officedocument.spreadsheetml.sheet')));

  }


  Future<Response<dynamic>?> postData(FormData formData, String gatewayPostURL, uploadCallback, downloadCallback) async {
    try {
      _dio.options.headers['Accept'] = dotenv.env['ACCEPT'];
      print(_dio.options.toString());
      Response response = await _dio.post(
        gatewayPostURL,
        data: formData,
        onSendProgress: (sent, total) {
          if (total != -1) {
            uploadCallback((sent / total));
          }
        },
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadCallback((received / total));
          }
        },
      );

      return response;


    } catch (error) {
      // Handle DioError here
      if (error is DioError) {
        final dioError = error as DioError;

        if (dioError.type == DioErrorType.response) {
          // Check for 502 status code
          // Handle 502 Bad Gateway error gracefully
          print(
              'Error: Server received an invalid response from an upstream server.');
          // Implement retry logic or show an error message to the user
          return null; // Or handle the error differently based on your app's needs
        }
        return null;
      }
    } finally {}
  }



  Future<void> saveAttachment(Response? response) async {
    try {
      final body = response?.data;
      final successMessage = body?['message'];
      print(successMessage);
      final base64Data = body?['data'];

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

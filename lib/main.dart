
import 'dart:html' as html; // For file input and FormData
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart' as mime;
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
/*void main() async {
  // Configure Amplify
  try {
    await Amplify.configure(AmplifyConfig(YOUR_AMPLIFY_CONFIG));
  } on AmplifyException catch (e) {
    print('Amplify configuration failed: $e');
  }

  runApp(MyApp());
}*/


void main() async{
  //await dotenv.load();
  runApp(MaterialApp(
    home: FileUploadApp(
      // Your Scaffold widget code here
    ),
  ));
}




class FileUploadApp extends StatefulWidget {
  @override
  _FileUploadAppState createState() => _FileUploadAppState();
}

class _FileUploadAppState extends State<FileUploadApp> {
  html.File? selectedFile;
  var _formData;
  html.File? file;
  StreamSubscription<Object>? subscription;
  final reader = html.FileReader();
  // Method to browse file
  void browseFile()  {

    // Select the file
    html.FileUploadInputElement input = html.FileUploadInputElement();
    input.click();

    // Listen for changes
    input.onChange.listen((event) {
      // Read file content as dataURL
      final files = input.files;
      if (files?.length == 1) {
         file = files![0];
         setState(() {
           selectedFile = file;
         });
        print('Selected file: ${file!.name}');
      }
    });


  }


// Method to upload file
  void uploadFile() async {

    if(selectedFile != null && subscription == null) {
      reader.readAsArrayBuffer(selectedFile!);
      subscription =  reader.onLoadEnd.listen((event) async {

       // String url = dotenv.env['BACKEND_URL'] ?? '';
        String url = 'https://zc7wuf07h4.execute-api.ap-south-1.amazonaws.com/v3/process-excel';
        final uri = Uri.parse(url);
        String httpMethod = 'POST'
        final request = http.Request(httpMethod, uri);
        String contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        request.headers['Content-Type'] = contentType; // Or specific type if known
        String accept = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,*/*'
        request.headers['Accept'] = accept;

        //  var request = http.MultipartRequest('POST', Uri.parse(url));
        Uint8List fileBytes = Uint8List(0);
        if (reader.result != null) {
          try {
            fileBytes = await reader.result as Uint8List;
            request.bodyBytes = fileBytes;

            var response = await request.send();

            if (response.statusCode == 200) {
              print('Uploaded!');
              final contentLength = response.headers['content-length'];
              final stream = response.stream;

              await _saveAttachmentStreamed(
                  stream, contentLength); // Set desired filename
            } else {
              // Handle error, e.g., show a message to the user
              print(
                  'Error uploading or processing file: ${response.statusCode}');
            }
          } catch (e) {

          }
          finally{
            if (subscription != null) {
              subscription!.cancel();
              subscription = null;
            }
        }
        }
        else {
          print('Error uploading file');
        }
      });
    }

  }

// Function to simulate download using streamed data and Blob (same as before)
  /*Future<void> _saveAttachmentStreamed(Stream<List<int>> stream, String filename) async {
    final chunks = <List<int>>[];
    await for (final chunk in stream) {
      chunks.add(chunk);
    }

    final bytes = Uint8List.fromList(chunks.expand((list) => list).toList());
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..download = filename
      ..style.display = 'none';

    html.document.body!.append(anchor);
    anchor.click();
    anchor.remove();

    html.Url.revokeObjectUrl(url);
  }*/


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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('File Upload'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: browseFile,
                child: Text('Browse File'),
              ),
              SizedBox(height: 20),
              selectedFile != null
                  ? Text('Selected file: ${selectedFile!.name}')
                  : Text('No file selected'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectedFile != null ?  uploadFile : null,
                child: Text('Upload and Process File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedFile != null ? Colors.blue : Colors.grey[400], // Adjust color as needed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

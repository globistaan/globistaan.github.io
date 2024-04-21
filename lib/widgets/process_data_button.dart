import 'dart:async';

import 'package:dio/dio.dart';
import 'package:excelmap/fileupload_service.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:excelmap/fileupload_service.dart';

class ProcessXlsxDataButton extends StatefulWidget {
  final FileUploadService fileUploadService;


  const ProcessXlsxDataButton({
    Key? key,
    required this.fileUploadService,

  }) : super(key: key);

  @override
  _ProcessXlsxDataButtonState createState() => _ProcessXlsxDataButtonState();
}

class _ProcessXlsxDataButtonState extends State<ProcessXlsxDataButton> {
  List<List<int>>? fileBytesList;
  double uploadProgress = 0;
  double downloadProgress = 0;
  bool _isVisible = false;
  Map<String, dynamic> data = {};
  Map<String, String> readable_col_map = {
    "request_id":"Request Id",
    "input_data_file_name":"Data File Name",
    "input_data_file_rows":"Row Count",
    "input_data_file_columns":"Column Count",
    "input_data_file_size":"File Size (kb)",
    "input_filter_file_name":"Filter File Name",
    "input_filter_file_rows":"Row Count",
    "input_filter_file_columns":"Column Count",
    "input_filter_file_size":"File Size (kb)",
    "output_file_name":"Output File Name",
    "output_file_rows":"Row Count",
    "output_file_columns":"Column Count",
    "output_file_size":"File Size (kb)",
    "processing_time":"Processing Time (seconds)",
    "status":"Status"
  };

  void _hideProgress() {
    setState(() {
      _isVisible = false;
    });
  }

  void _showProgress() {
    setState(() {
      _isVisible = true;
    });
  }

  void _updateProgressUpload(double newProgress) {
    setState(() {
      uploadProgress = newProgress;
    });
  }

  void _updateProgressDownload(double newProgress) {
    setState(() {
      downloadProgress = newProgress;
    });
  }

  void _clearData() {

    widget.fileUploadService.clearFileDataAll();
  }
  Future<void> _processData() async {
    _showProgress();
    setState(() {
      uploadProgress = 0;
    });
    setState(() {
      downloadProgress = 0;
    });
    Dio _dio = Dio();
    FormData formData = FormData.fromMap(
        widget.fileUploadService.fileDataList.asMap().map((index, fileData) {
          return MapEntry(
            'file${index + 1}',
            MultipartFile.fromBytes(fileData.bytes,
                filename: fileData.fileName,
                contentType: MediaType('application',
                    'vnd.openxmlformats-officedocument.spreadsheetml.sheet')),
          );
        }));

    try {
      _dio.options.headers['Accept'] = '*/*';
      print(_dio.options.toString());
      Response response = await _dio.post(
        'https://d1qhawz9t6.execute-api.ap-south-1.amazonaws.com/dev/process-excel',
        data: formData,
        onSendProgress: (sent, total) {
          if (total != -1) {
            _updateProgressUpload((sent / total));
          }
        },
        onReceiveProgress: (received, total) {
          if (total != -1) {
            _updateProgressDownload((received / total));
          }
        },
      );
       data = response.data['message'] as Map<String, dynamic>;


      if (response.statusCode == 200) {
        // Handle successful upload
        print('Files uploaded successfully');
        await widget.fileUploadService.saveAttachment(response);
       // await Future.delayed(Duration(seconds: 2));
      //  _hideProgress();
      } else {
        // Handle error
        print('Files upload failed');
      }
    } catch (error) {
      // Handle DioError here
      if (error is DioError) {
        final dioError = error as DioError;
        if (dioError.type == DioErrorType.response) {
          // Check for 502 status code
          data = dioError.response?.data['message'] as Map<String, dynamic>;
          if (dioError.response?.statusCode == 502) {
            // Handle 502 Bad Gateway error gracefully
            print(
                'Error: Server received an invalid response from an upstream server.');
            // Implement retry logic or show an error message to the user
            return null; // Or handle the error differently based on your app's needs
          }
        }
        // Handle other DioError types if needed
      }
    } finally {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _processData,
              child: Text('Process Files'),
            )
          ],
        )
      ,
    if (_isVisible) SizedBox(height: 20),
    if (_isVisible)
    LinearPercentIndicator(
    lineHeight: 20.0,
    percent: uploadProgress,
    center: Text(
    "Sending Files to Server : ${(uploadProgress * 100).toString()}% Complete"),
    backgroundColor: Colors.grey,
    progressColor: Colors.blue,
    ),
    if (_isVisible) SizedBox(height: 20),
    if (_isVisible)
    LinearPercentIndicator(
    lineHeight: 20.0,
    percent: downloadProgress,
    center: Text(
    "Receiving Files From Server : ${(downloadProgress * 100).toString()}% Complete"),
    backgroundColor: Colors.grey,
    progressColor: Colors.blue,
    ),
    SizedBox(height: 20),
        data.isEmpty
            ? Container()
            : Table(
          border: TableBorder.all(),
          children: [
            TableRow(
              children: data.keys.map((key) => TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: SelectableText(readable_col_map.containsKey(key) ? readable_col_map[key] ?? "" : "", textAlign: TextAlign.center),
              )).toList(),
            ),
            ...generateTableRows(),
          ],
        ),
    ]
    );
  }

  List<TableRow> generateTableRows() {
    final List<TableRow> rows = [];
   // final List<String> keys = data.keys.toList();
    final List<dynamic> values = data.values.toList();
    final List<TableCell> cells = [];
    for (int i = 0; i < values.length; i++) {

      cells.add(TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SelectableText(values[i].toString(), textAlign: TextAlign.center),
      ));
    }
    rows.add(TableRow(children: cells));


    return rows;
  }
}

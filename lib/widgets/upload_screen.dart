
import 'package:flutter/material.dart';
import 'package:excelmap/fileupload_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:excelmap/fileupload_service.dart';
import 'dart:async';
import 'package:dio/dio.dart';

class UploadScreenWidget extends StatefulWidget {

  final FileUploadService fileUploadService = FileUploadService();
  @override
  _UploadScreenWidgetState createState() => _UploadScreenWidgetState();
}
class _UploadScreenWidgetState extends State<UploadScreenWidget> {
  bool _isVisible = false;
  String? dataFileName;
  List<int>? dataFileBytes;
  double uploadProgress = 0;
  double downloadProgress = 0;
  String? filterFileName;
  List<int>? filterFileBytes;
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
  void _selectDataFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      setState(() {
        dataFileName = file.name;
        dataFileBytes = file.bytes;
      });
    //  widget.fileUploadService.updateFileData(FileData(fileName: dataFileName!, bytes: dataFileBytes!), 0);
    }
  }

  void _selectFilterFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      setState(() {
        filterFileName = file.name;
        filterFileBytes = file.bytes;
      });
     // widget.fileUploadService.updateFileData(FileData(fileName: filterFileName!, bytes: filterFileBytes!), 1);
    }
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

    MapEntry<String, MultipartFile>? formDataEntry1;
    MapEntry<String, MultipartFile>? formDataEntry2;

    if(dataFileBytes != null && dataFileBytes!.length >0)
    formDataEntry1 = MapEntry(
        "file1", // Key for file 1
        MultipartFile.fromBytes(dataFileBytes!.toList(), filename: dataFileName, contentType: MediaType('application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet'))
    );

    if(filterFileBytes != null && filterFileBytes!.length >0)
    formDataEntry2 = MapEntry(
        "file2", // Key for file 2
        MultipartFile.fromBytes(filterFileBytes!.toList(), filename: filterFileName, contentType: MediaType('application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet'))
    );

// Create a new FormData object
    FormData formData = FormData();

// Add both MapEntries to the FormData

    if(formDataEntry1!=null)
    formData.files.add(formDataEntry1);
    if(formDataEntry2!=null)
    formData.files.add(formDataEntry2);

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

  void _clearAll() {
    setState(() {
      dataFileName = null;
      dataFileBytes = null;
      filterFileName = null;
      filterFileBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Processing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              label: Text ('Upload All Invoices Data XLSX'),
              onPressed: _selectDataFile,
              icon: Icon(Icons.file_upload)

            ),
            if (dataFileName != null) Text('Uploaded file: $dataFileName'),
            /*FileUploadWidget(
                buttonText: 'Upload All Invoices Data XLSX',
                icon: Icons.file_upload,
                fileUploadService: fileUploadService,
                btnIndex: 0
            ),*/
            SizedBox(height: 20),
            ElevatedButton.icon(
              label: Text ('Upload Filter Invoice Id XLSX'),
              onPressed: _selectFilterFile,
              icon: Icon(Icons.filter)

            ),
            if (filterFileName != null) Text('Uploaded file: $filterFileName'),

           /* FileUploadWidget(
                buttonText: 'Upload Filter Invoice Id XLSX',
                icon: Icons.filter,
                fileUploadService: fileUploadService,
                btnIndex: 1
            ),*/
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton.icon(
                  onPressed: _processData,
                  icon: Icon(Icons.add),
                  label: Text('Process Files')
                ),

            ElevatedButton.icon(
              label: Text ('Clear'),
              onPressed: _clearAll,
              icon: Icon(Icons.clear)

            ),

              ],
    ),
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
          ],
        ),
      ),
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




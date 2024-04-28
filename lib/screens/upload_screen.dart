import 'package:flutter/material.dart';
import 'package:excelmap/service/fileupload_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:excelmap/widgets/progressbars/upload_progress_bar.dart';
import 'package:excelmap/widgets/progressbars/download_progress_bar.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:excelmap/widgets/appBar/app_bar.dart';
import 'package:excelmap/widgets/drawer/drawer.dart';
import 'package:excelmap/widgets/tables/table_widget.dart';
import 'package:excelmap/widgets/buttons/upload_invoices_button.dart';
import 'package:excelmap/widgets/buttons/upload_filterinvoices_button.dart';
import 'package:excelmap/widgets/buttons/process_button.dart';
import 'package:excelmap/widgets/buttons/clear_button.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UploadScreenWidget extends StatefulWidget {
  final Map<String, String> metaData;

  const UploadScreenWidget({Key? key, required this.metaData})
      : super(key: key);

  @override
  _UploadScreenWidgetState createState() => _UploadScreenWidgetState();
}

class _UploadScreenWidgetState extends State<UploadScreenWidget> {

  final fileUploadService = FileUploadService();
  bool _isVisible = false;
  double _uploadProgress = 0;
  double _downloadProgress = 0;
  PlatformFile? _dataFile;
  PlatformFile? _filterFile;
  MapEntry<String, MultipartFile>? _dataFileEntry;
  MapEntry<String, MultipartFile>? _filterFileEntry;
  Map<String, dynamic> data = {};


  @override
  Widget build(BuildContext context) {
    final String name = widget.metaData['name']!;
    final String url = widget.metaData['photoUrl']!;
    final String email = widget.metaData['email']!;

    return Scaffold(
      appBar: AppBarWidget(name: name, url: url),
      drawer: DrawerWidget(name: name, email: email, url: url),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UploadInvoicesButtonWidget(onButtonClicked: _selectDataFile),
            if (_dataFile != null) Text('Uploaded file: ${_dataFile?.name}'),

            SizedBox(height: 20),

            UploadFilterInvoicesButtonWidget(onButtonClicked: _selectFilterFile),
            if (_filterFile != null) Text('Uploaded file: ${_filterFile?.name}'),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProcessButtonWidget(onButtonClicked: _processData),
                SizedBox(width: 10.0),
                ClearButtonWidget(onButtonClicked: _clearAll),
              ],
            ),
            if (_isVisible) SizedBox(height: 20),
            if (_isVisible)
              UploadProgressBarWidget(uploadProgress: _uploadProgress),
            if (_isVisible) SizedBox(height: 20),
            if (_isVisible)
              DownloadProgressBarWidget(downloadProgress: _downloadProgress),
            SizedBox(height: 20),
            data.isEmpty
                ? Container()
                : TableWidget(data: data)
          ],
        ),
      ),
    );
  }


  // upload data file with all invoices
  void _selectDataFile() async {
    final file  = await fileUploadService.pickFile();
    setState(() {
      _dataFile = file;
    });
  }

  //  upload filter file to display select invoices in the output
  void _selectFilterFile() async {
    final file = await fileUploadService.pickFile();
    setState(() {
      _filterFile = file;
    });
  }

  // post invoices to api gateway
  Future<void> _processData() async{
    _showProgress();

    FormData formData = FormData();
    if (_dataFile!=null) {
      _dataFileEntry = fileUploadService.prepareFormData(_dataFile, 'file1');
      formData.files.add(_dataFileEntry!);
    }
    if (_filterFile != null) {
      _filterFileEntry = fileUploadService.prepareFormData(_filterFile, 'file2');
      formData.files.add(_filterFileEntry!);
    }
    Response<dynamic>? response = await fileUploadService.postData(formData, dotenv.env['BACKEND_URL']!,
        _updateProgressUpload, _updateProgressDownload);
    setState(() {
      data = response?.data['message'] as Map<String, dynamic>;
    });
    if (response?.statusCode == 200) {
      // Handle successful upload
      print('Files uploaded successfully');
      await fileUploadService.saveAttachment(response);
      // await Future.delayed(Duration(seconds: 2));
      //  _hideProgress();
    } else {
      // Handle error
      print('Files upload failed');
    }

  }

  // initialize progress bar on UI for checking upload/download progress
  void _initProgressBar() {
    setState(() {
      _uploadProgress = 0;
      _downloadProgress = 0;
    });
  }

  // display progress bar
  void _showProgress() {
    setState(() {
      _isVisible = true;
    });
  }

  // callback to update upload progress on UI
  void _updateProgressUpload(double newProgress) {
    setState(() {
      _uploadProgress = newProgress;
    });
  }
  // callback to update download progress on UI
  void _updateProgressDownload(double newProgress) {
    setState(() {
      _downloadProgress = newProgress;
    });
  }

  // Clear butto pressed on UI
  void _clearAll() {
    setState(() {
      _dataFile = null;
      _filterFile =null;
      _isVisible = false;
      data = {};
    });
  }

}

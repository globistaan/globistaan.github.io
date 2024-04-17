
import 'package:flutter/material.dart';
import 'file_upload_txt_button.dart';
import 'package:excelmap/fileupload_service.dart';
import 'process_data_button.dart';

class UploadScreen extends StatelessWidget {
  final FileUploadService fileUploadService = FileUploadService();

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
            FileUploadWidget(
              buttonText: 'Upload All Invoices Data XLSX',
              icon: Icons.file_upload,
              fileUploadService: fileUploadService,
            ),
            SizedBox(height: 20),
            FileUploadWidget(
              buttonText: 'Upload Filter Invoice Id XLSX',
              icon: Icons.filter,
              fileUploadService: fileUploadService,
            ),
            SizedBox(height: 20),
            ProcessXlsxDataButton(fileUploadService: fileUploadService)
          ],
        ),
      ),
    );
  }
}

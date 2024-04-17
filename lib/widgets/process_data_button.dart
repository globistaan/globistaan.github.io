import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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

  void _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      List<List<int>> tempFileBytesList = [];
      for (PlatformFile file in result.files) {
        tempFileBytesList.add(file.bytes!);
      }
      setState(() {
        fileBytesList = tempFileBytesList;
      });
    }
  }

  void _processData() async {
    widget.fileUploadService.processFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        ElevatedButton(
          onPressed: _processData,
          child: Text('Process Files'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excelmap/fileupload_service.dart';

class FileUploadWidget extends StatefulWidget {
  final String buttonText;
  final IconData icon;
  final FileUploadService fileUploadService;

  const FileUploadWidget({
    Key? key,
    required this.buttonText,
    required this.icon,
    required this.fileUploadService,
  }) : super(key: key);

  @override
  _FileUploadWidgetState createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  String? fileName;
  List<int>? fileBytes;

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      setState(() {
        fileName = file.name;
        fileBytes = file.bytes;
      });
      widget.fileUploadService.addFileData(FileData(fileName: fileName!, bytes: fileBytes!));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _selectFile,
          icon: Icon(widget.icon),
          label: Text(widget.buttonText),
        ),
        if (fileName != null) Text('Uploaded file: $fileName'),
      ],
    );
  }
}

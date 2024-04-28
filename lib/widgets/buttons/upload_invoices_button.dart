import 'package:flutter/material.dart';


class UploadInvoicesButtonWidget extends StatelessWidget {
  final VoidCallback onButtonClicked;

  const UploadInvoicesButtonWidget({Key? key, required this.onButtonClicked })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
   return ElevatedButton.icon(
        label: Text('Upload All Invoices Data XLSX'),
        onPressed: onButtonClicked,
        icon: Icon(Icons.file_upload));
  }
}
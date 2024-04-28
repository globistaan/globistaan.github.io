import 'package:flutter/material.dart';


class UploadFilterInvoicesButtonWidget extends StatelessWidget {
  final VoidCallback onButtonClicked;

  const UploadFilterInvoicesButtonWidget({Key? key, required this.onButtonClicked })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
   return   ElevatedButton.icon(
       label: Text('Upload Filter Invoice Id XLSX'),
       onPressed: onButtonClicked,
       icon: Icon(Icons.filter));
  }
}
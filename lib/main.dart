import 'package:flutter/material.dart';
import 'package:excelmap/widgets/upload_screen.dart';
void main() {
  runApp(
    MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr, // or TextDirection.rtl based on your app's text direction
        child: UploadScreen(),
      ),
    ),
  );
}



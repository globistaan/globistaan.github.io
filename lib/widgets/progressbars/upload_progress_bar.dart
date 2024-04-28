import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class UploadProgressBarWidget extends StatelessWidget{
  final double uploadProgress;

  const UploadProgressBarWidget({Key? key, required this.uploadProgress })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      lineHeight: 20.0,
      percent: uploadProgress,
      center: Text(
          "Sending Files to Server : ${(uploadProgress * 100).toString()}% Complete"),
      backgroundColor: Colors.grey,
      progressColor: Colors.blue,
    );
  }
}
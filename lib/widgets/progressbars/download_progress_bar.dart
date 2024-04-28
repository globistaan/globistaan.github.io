import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DownloadProgressBarWidget extends StatelessWidget{
  final double downloadProgress;

  const DownloadProgressBarWidget({Key? key, required this.downloadProgress })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      lineHeight: 20.0,
      percent: downloadProgress,
      center: Text(
          "Receiving Files From Server : ${(downloadProgress * 100).toString()}% Complete"),
      backgroundColor: Colors.grey,
      progressColor: Colors.blue,
    );
  }
}
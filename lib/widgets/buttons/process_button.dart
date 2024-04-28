import 'package:flutter/material.dart';


class ProcessButtonWidget extends StatelessWidget {
  final VoidCallback onButtonClicked;

  const ProcessButtonWidget({Key? key, required this.onButtonClicked })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   ElevatedButton.icon(
        onPressed: onButtonClicked,
        icon: Icon(Icons.file_copy),
        label: Text('Process Files'));
  }
}
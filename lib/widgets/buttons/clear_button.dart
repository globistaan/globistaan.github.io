import 'package:flutter/material.dart';


class ClearButtonWidget extends StatelessWidget {
  final VoidCallback onButtonClicked;

  const ClearButtonWidget({Key? key, required this.onButtonClicked })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton.icon(
        label: Text('Clear'),
        onPressed: onButtonClicked,
        icon: Icon(Icons.clear));
  }
}
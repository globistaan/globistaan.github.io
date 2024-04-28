import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  final String name;
  final String url;
  const AppBarWidget({Key? key, required this.name,required this.url })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Invoice Processing'),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min, // Avoids extra space
          children: [
            CircleAvatar(backgroundImage: NetworkImage(url)), // Replace with user's photo URL
            SizedBox(width: 5.0),
            Text(name,   style: TextStyle(fontWeight: FontWeight.bold)),// Replace with actual username variable
            SizedBox(width: 5.0),
          ],
        )
      ],
    );
  }
 // need to implement this method for customizing the appbar widget
  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight); // Return the desired size
  }
}
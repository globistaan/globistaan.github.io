import 'package:flutter/material.dart';

class SignInErrorWidget extends StatelessWidget {
  const SignInErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 40.0),
            const SizedBox(height: 10.0),
            Text(
              'Sign In Failed',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Please try one of the following:\n'
                  '- Login again\n'
                  '- Clear your app cache\n'
                  '- Contact the Administrator',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

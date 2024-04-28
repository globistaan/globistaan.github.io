import 'package:flutter/material.dart';
import 'package:excelmap/service/login_service.dart';

class DrawerWidget extends StatelessWidget{
  final String name;
  final String email;
  final String url;
  const DrawerWidget({Key? key, required this.name,required this.email,required this.url })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginService =  LoginService();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(url),
            ),
          ),

          ListTile(
            title: Text('Usage Stats'),
            onTap: () {
              // Handle usage stats functionality
              print('Usage Stats clicked');
            },
          ),
          ListTile(
            title: Text('Billing'),
            onTap: () {
              // Handle billing functionality
              print('Billing clicked');
            },
          ),
          ListTile(
            title: Text('Sign Out'),
            onTap: () {
              // Handle signout functionality (navigation, logic, etc.)
              print('Signout clicked');
              loginService.signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
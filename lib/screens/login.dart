import 'package:flutter/material.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'upload_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: dotenv.env["GOOGLE_CLIENT_ID"],
  );

  GoogleSignInAccount? account;
  GoogleSignInAuthentication? auth;
  String name='';
  String url='';
  String email='';
  @override
  void initState() {
    _clearcache();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        name = account?.displayName ?? '';
        url =  account?.photoUrl ?? '';
        email =account?.email ?? '';
      });
        print(name);
        print(account?.photoUrl);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UploadScreenWidget(metaData: {
            'name': name,
            'photoUrl': url,
            'email':email
          }))
        );
        //Navigator.pushNamed(context, "/uploadScreen");

    });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Processing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            renderButton()
          ],
        ),
      ),
    );
  }

  @override
  Widget renderButton() {
    final plugin = GoogleSignInPlatform.instance as GoogleSignInPlugin;
    return plugin.renderButton(
      configuration: GSIButtonConfiguration(
        text: GSIButtonText.signinWith,
        size: GSIButtonSize.large,
        theme: GSIButtonTheme.filledBlue,
        shape: GSIButtonShape.rectangular,
        logoAlignment: GSIButtonLogoAlignment.center
      )
    );

  }
void _startSignIn() async{
  account = await googleSignIn.signInSilently();

}
  Future<void> _clearcache() async {
    // Your asynchronous logic here
    await googleSignIn.signOut();
    print("signed out from app");
  }
}

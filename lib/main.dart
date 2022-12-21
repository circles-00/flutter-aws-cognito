import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';

import './amplifyconfig.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String email = 'none';
  void printWrapped(String text) =>
      RegExp('.{1,800}').allMatches(text).map((m) => m.group(0)).forEach(print);
  @override
  void initState() {
    super.initState();
    _configureAmplify().then((value) => {
          Amplify.Auth.signOut().then((value) => {
                Amplify.Auth.signIn(
                  username: "newTest@mailinator.com",
                  password: "wV:h8qUk",
                ).then((result) => {
                      Amplify.Auth.fetchAuthSession(
                              options: CognitoSessionOptions(
                                  getAWSCredentials: true))
                          .then((value) {
                        CognitoAuthSession session =
                            value as CognitoAuthSession;
                        // this is gonna print in multiple lines be careful when copy pasting
                        printWrapped(
                            ''' ${session.userPoolTokens?.accessToken} ''');
                      })
                    })
              })
        });
  }

  Future<void> _configureAmplify() async {
    try {
      // Add the following line to add Auth plugin to your app.
      await Amplify.addPlugin(AmplifyAuthCognito());

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      print('An error occurred configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
            margin: const EdgeInsets.only(left: 25.0, top: 300),
            child: Column(
              children: [
                Text('Logged in Cognito User Email:  $email'),
              ],
            )),
      ),
    );
  }
}

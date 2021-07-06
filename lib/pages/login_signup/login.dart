import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swipe_app/controller/session_controller.dart';
import 'package:swipe_app/helper/style.dart';
import 'package:swipe_app/pages/homepage/homepage.dart';
import 'package:swipe_app/pages/login_signup/signup.dart';
import 'package:swipe_app/pages/widgets/circularLoader.dart';
import 'package:swipe_app/pages/widgets/verticalSpacer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final _loginformKey = GlobalKey<FormState>();

  bool _isLoading = false;

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  SessionController _sessionController = SessionController();

  bool _obscureText = true;

  String _emailValidator = "";

  @override
  void initState() {
    super.initState();
  }

  void toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.05,
              ),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Let\'s sign you in.',
                          style: bigHeadingStyle,
                        ),
                        VerticalSpacer(
                          percentage: 0.01,
                        ),
                        Text('Login and meet new people', style: smallHeadingStyle),
                        VerticalSpacer(
                          percentage: 0.1,
                        ),
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Form(
                                key: _loginformKey,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.80,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: BorderSide(
                                              width: 3,
                                              color: errorColor,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: BorderSide(color: primaryColor, width: 2)),
                                          prefixIcon: Icon(Icons.person),
                                          hintText: 'Email ID',
                                          hintStyle: buttonTextStyle,
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter your Email ID';
                                          } else {
                                            return _emailValidator;
                                          }
                                        },
                                        controller: _email,
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: BorderSide(
                                              width: 3,
                                              color: errorColor,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: BorderSide(color: primaryColor, width: 2),
                                          ),
                                          prefixIcon: Icon(Icons.lock),
                                          hintText: 'Password',
                                          hintStyle: buttonTextStyle,
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              toggle();
                                            },
                                            icon: _obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter your Password';
                                          }
                                          return null;
                                        },
                                        controller: _password,
                                        obscureText: _obscureText,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            CircularLoader(isLoading: _isLoading),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? -",
                              style: smallTextStyle,
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupPage(),
                                ),
                              ),
                              child: Text('Sign Up', style: smallTextStyle),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.width * 0.16,
                          child: RawMaterialButton(
                            onPressed: () async {
                              try {
                                UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: _email.text,
                                  password: _password.text,
                                );
                                await [Permission.camera, Permission.microphone].request();
                                await _sessionController.initializeEngine();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      controller: _sessionController,
                                    ),
                                  ),
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  print('No user found for that email.');
                                  setState(() {
                                    _emailValidator = "No user found for that email.";
                                  });
                                } else if (e.code == 'wrong-password') {
                                  print('Wrong password provided for that user.');
                                }
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'Sign In',
                                textAlign: TextAlign.center,
                                style: defaultButtonTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

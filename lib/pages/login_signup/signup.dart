import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swipe_app/controller/session_controller.dart';
import 'package:swipe_app/helper/style.dart';
import 'package:swipe_app/pages/interests/interest.dart';
import 'package:swipe_app/pages/widgets/circularLoader.dart';
import 'package:swipe_app/pages/widgets/verticalSpacer.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  static final _loginformKey = GlobalKey<FormState>();

  bool isLoading = false;

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  SessionController _sessionController = SessionController();

  bool _obscureText = true;
  bool _isLoading = false;

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
                          'Let\'s sign you up.',
                          style: bigHeadingStyle,
                        ),
                        VerticalSpacer(
                          percentage: 0.01,
                        ),
                        Text('Create an account and meet people with shared interests.', style: smallHeadingStyle),
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
                                            return null;
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
                              onPressed: () => Navigator.pop(context),
                              child: Text('Login', style: smallTextStyle),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.width * 0.16,
                          child: RawMaterialButton(
                            onPressed: () async {
                              try {
                                var date = DateTime.now();
                                UserCredential userCredential = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(email: _email.text, password: _password.text);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddYourInterests(
                                      emailId: _email.text,
                                      password: _password.text,
                                      uuid: int.parse('${date.hour}${date.minute}${date.second}'),
                                      controller: _sessionController,
                                    ),
                                  ),
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'email-already-in-use') {
                                  return SnackBar(content: Text('Email is already in use'));
                                  // print('The account already exists for that email.');
                                }
                              } catch (e) {
                                return SnackBar(content: Text('Email is already in use'));
                                // print(e);
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
                                'Sign Up',
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

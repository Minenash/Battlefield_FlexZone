import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flex_out/database.dart';

const Color BF_PURPLE = Color(0xFF501076);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 60.0),
            Center(
              child: SvgPicture.asset("assets/images/logo.svg", height: 200, width: 200),
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: BF_PURPLE))),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: passController,
                      decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: BF_PURPLE))),
                      obscureText: true,
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      alignment: Alignment(1.0, 0.0),
                      padding: EdgeInsets.only(top: 15.0, left: 20.0),
                      child: InkWell(
                        onTap: () {forgotPassword();},
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                              color: BF_PURPLE,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                    SizedBox(height: 60.0),
                    GestureDetector(
                      onTap: () {login();},
                      child: Container(
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.deepPurple,
                          color: BF_PURPLE,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {login();},
                            child: Center(
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }

  void login() {
    VerifyResults result = verify_login(emailController.text, passController.text);

    switch (result) {
      case VerifyResults.NO_ACCOUNT:      showError("That account doesn't exists.");              break;
      case VerifyResults.WRONG_PASSWORD:  showError("Incorrect Password!");                       break;
      case VerifyResults.DATABASE_ERROR:  showError("A Database Error occurred, try again later."); break;
      case VerifyResults.STUDENT:         Navigator.of(context).pushNamed('/stu_cr');             break;
      case VerifyResults.TEACHER:         Navigator.of(context).pushNamed('/tea_cr');             break;
      case VerifyResults.ADMIN:           Navigator.of(context).pushNamed('/adm_cr');             break;
      default:                            showError("Can't access the server, are you connected to the internet?");
    }
  }

  void showError(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
      backgroundColor: Colors.red,
    ));
  }

  void forgotPassword() {
    //TODO: Send Email Based on Email field
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text("Email Sent"),
      backgroundColor: Colors.green,
    ));
  }
}
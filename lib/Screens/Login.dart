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
    TextField tf_email = TextField(
      controller: emailController,
      decoration: InputDecoration(
          labelText: 'EMAIL',
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: BF_PURPLE))),
      keyboardType: TextInputType.emailAddress,
    );

    TextField tf_password = TextField(
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
    );

    Widget bt_forgotPassword = Container(
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
    );

    Widget bt_submit = GestureDetector(
      onTap: () {login();},
      child: Container(
        height: 40.0,
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.deepPurple,
          color: BF_PURPLE,
          elevation: 7.0,
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
    );


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
                    tf_email,
                    SizedBox(height: 20.0),
                    tf_password,
                    SizedBox(height: 5.0),
                    bt_forgotPassword,
                    SizedBox(height: 60.0),
                    bt_submit,
                  ],
                )),
          ],
        ));
  }

  void login() {
    if (!isEmailValid(emailController.text)) {
      showError("Email Address not Valid!");
      return;
    }

    VerifyResults result = verify_login(emailController.text, passController.text);

    switch (result) {
      case VerifyResults.NO_MATCH:        showError("The email or password is incorrect");          break;
      case VerifyResults.DATABASE_ERROR:  showError("A Database Error occurred, try again later."); break;

      case VerifyResults.STUDENT:         setCurrentUser(emailController.text, passController.text, 1);
                                          Navigator.of(context).pushReplacementNamed('/stu_cr');    break;

      case VerifyResults.TEACHER:         setCurrentUser(emailController.text, passController.text, 2);
                                          Navigator.of(context).pushReplacementNamed('/tea_cr');     break;

      case VerifyResults.ADMIN:           setCurrentUser(emailController.text, passController.text, 3);
                                          Navigator.of(context).pushReplacementNamed('/adm_cr');     break;

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

    String email = emailController.text;
    
    if (email.isEmpty) {
      showError("Please enter an email address");
      return;
    }

    if (!isEmailValid(email)) {
      showError("Email Address not Valid!");
      return;
    }

    showForgotPasswordDialog(email);
  }

  void showForgotPasswordDialog(String email) {

    Widget okButton = FlatButton(
      child: Text("OKAY"),
      onPressed:  () {Navigator.of(context).pop();},
    );

    Widget whatEmailButton = FlatButton(
      child: Text("WHAT EMAIL?"),
      onPressed:  () {
        Navigator.of(context).pop();
        showWhatEmailDialog(email);
      },
    );
    
    AlertDialog alert = AlertDialog(
      title: Text("Forgot Password"),
      content: Text("An email has been sent to $email. Click the reset link to reset your password."),
      actions: <Widget>[whatEmailButton, okButton],
    );

    showDialog(context: context,
        builder: (BuildContext context) {
          return alert;
    });
  }

  void showWhatEmailDialog(String email) {

    Widget okButton = FlatButton(
      child: Text("OKAY"),
      onPressed:  () {Navigator.of(context).pop();},
    );


    AlertDialog alert = AlertDialog(
      title: Text("Forgot Password"),
      content: Text("Did you check your spam folder? If you still don't see it, you can go to one of your librarians, they will be able to reset it for you."),
      actions: <Widget>[okButton],
    );

    showDialog(context: context,
        builder: (BuildContext context) {
          return alert;
    });
  }
}
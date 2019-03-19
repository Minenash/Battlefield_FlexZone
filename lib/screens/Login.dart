import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flex_out/database.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/mailhandler.dart';

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
          labelText: Lang.trans('email_field'),
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: FlexColors.BF_PURPLE))),
      keyboardType: TextInputType.emailAddress,
    );

    TextField tf_password = TextField(
      controller: passController,
      decoration: InputDecoration(
          labelText: Lang.trans('password_field'),
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: FlexColors.BF_PURPLE))),
      obscureText: true,
    );

    Widget bt_forgotPassword = Container(
      alignment: Alignment(1.0, 0.0),
      padding: EdgeInsets.only(top: 15.0, left: 20.0),
      child: InkWell(
        onTap: () {forgotPassword();},
        child: Text(
          Lang.trans('forgot_password'),
          style: TextStyle(
              color: FlexColors.BF_PURPLE,
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
          color: FlexColors.BF_PURPLE,
          elevation: 7.0,
          child: Center(
            child: Text(
              Lang.trans('login_button'),
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
    if (!Database.isEmailValid(emailController.text)) {
      showError(Lang.trans('invalid_email_error'));
      return;
    }

    VerifyResults result = Database.verify_login(emailController.text, passController.text);

    switch (result) {
      case VerifyResults.NO_MATCH:        showError(Lang.trans('wrong_credentials')); break;
      case VerifyResults.DATABASE_ERROR:  showError(Lang.trans('database_error'));    break;

      case VerifyResults.STUDENT:         Database.setCurrentUser(emailController.text, passController.text, 1);
                                          Navigator.of(context).pushReplacementNamed('/stu/current');    break;

      case VerifyResults.TEACHER:         Database.setCurrentUser(emailController.text, passController.text, 2);
                                          Navigator.of(context).pushReplacementNamed('/tea/current');     break;

      case VerifyResults.ADMIN:           Database.setCurrentUser(emailController.text, passController.text, 3);
                                          Navigator.of(context).pushReplacementNamed('/adm/current');     break;

      default:                            showError(Lang.trans('no_connection'));
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
      showError(Lang.trans('empty_email_error'));
      return;
    }

    if (!Database.isEmailValid(email)) {
      showError(Lang.trans('invalid_email_error'));
      return;
    }
    MailHandler.sendPasswordRecovery(email, "James Doppee");
    showForgotPasswordDialog(email);
  }

  void showForgotPasswordDialog(String email) {

    Widget okButton = FlatButton(
      child: Text(Lang.trans('forgot_password_dialog_ok_button')),
      onPressed:  () {Navigator.of(context).pop();},
    );

    Widget whatEmailButton = FlatButton(
      child: Text(Lang.trans('forgot_password_dialog_what_email_button')),
      onPressed:  () {
        Navigator.of(context).pop();
        showWhatEmailDialog(email);
      },
    );
    
    AlertDialog alert = AlertDialog(
      title: Text(Lang.trans('forgot_password')),
      content: Text(Lang.trans('forgot_password_dialog_text').replaceAll("%email%", email)),
      actions: <Widget>[whatEmailButton, okButton],
    );

    showDialog(context: context,
        builder: (BuildContext context) {
          return alert;
    });
  }

  void showWhatEmailDialog(String email) {

    Widget okButton = FlatButton(
      child: Text(Lang.trans('forgot_password_dialog_ok_button')),
      onPressed:  () {Navigator.of(context).pop();},
    );


    AlertDialog alert = AlertDialog(
      title: Text(Lang.trans('forgot_password')),
      content: Text(Lang.trans('forgot_password_dialog_what_email_text')),
      actions: <Widget>[okButton],
    );

    showDialog(context: context,
        builder: (BuildContext context) {
          return alert;
    });
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paypad/Theme.dart' as Theme;
import 'package:paypad/ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class VerifyPage extends StatefulWidget {
  VerifyPage({this.auth, this.onVerify});

  final BaseAuth auth;
  final VoidCallback onVerify;

  @override
  _VerifyPageState createState() => new _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  static final formKeyLogin = new GlobalKey<FormState>();

  String _phoneNo;
  String _verificationId;
  String _smsCode;
  String _authHint;

  final FocusNode myFocusNodeNumberLogin = FocusNode();
  TextEditingController loginNumberController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  bool validateAndSave() {
    final form = formKeyLogin.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Please enter the SMS Code'),
            content: TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                this._smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: () {
                  FirebaseAuth.instance.currentUser().then((user) {
                    if (user == null) {
                      print('signed in');
                    } else {
                      print('failed');
                    }
                  });
                },
              )
            ],
          );
        });
  }

  Future<void> validateAndSubmit() async {
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verId) {
      this._verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this._verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed in');
      });
    };

    final PhoneVerificationFailed phoneVerificationFailed =
        (AuthException exception) {
      showInSnackBar(exception.message);
    };

    final PhoneVerificationCompleted phoneVerificationCompleted =
        (FirebaseUser user) {
      print('verified');
    };

    if (validateAndSave()) {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: _phoneNo,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
            codeSent: smsCodeSent,
            timeout: const Duration(seconds: 5),
            verificationCompleted: phoneVerificationCompleted,
            verificationFailed: phoneVerificationFailed);
      } catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString().split(', ')[1]}';
        });
        showInSnackBar(_authHint);
      }
    }
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Theme.Colors.loginGradientStart,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Theme.Colors.loginGradientStart,
                      Theme.Colors.loginGradientEnd
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 150.0),
                  ),
                  Expanded(
                    flex: 2,
                    child: new ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: _buildSignIn(context),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: new Form(
        key: formKeyLogin,
        child: new Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Card(
                  elevation: 5.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    width: 300.0,
                    height: 290.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 35.0, bottom: 35.0, left: 25.0, right: 25.0),
                          child: Text(
                            'We will send an SMS message to verify your identity, please enter your number below: ',
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 35.0, bottom: 35.0, left: 50.0, right: 25.0),
                          child: TextFormField(
                            key: new Key('phoneNo'),
                            autocorrect: false,
                            validator: (val) => val.isEmpty
                                ? 'Phone number can\'t be empty.'
                                : null,
                            onSaved: (val) => _phoneNo = val,
                            focusNode: myFocusNodeNumberLogin,
                            controller: loginNumberController,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.phone,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              hintText: "+63 900 000 000",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 17.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 280.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.Colors.loginGradientStart,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: Theme.Colors.loginGradientEnd,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    gradient: new LinearGradient(
                        colors: [
                          Theme.Colors.loginGradientEnd,
                          Theme.Colors.loginGradientStart
                        ],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Theme.Colors.loginGradientEnd,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 42.0),
                        child: Text(
                          "GET CODE",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                      onPressed: validateAndSubmit),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

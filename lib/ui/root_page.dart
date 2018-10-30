import 'package:flutter/material.dart';
import 'package:paypad/ui/auth.dart';
import 'package:paypad/ui/login_page.dart';
import 'package:paypad/ui/verify_page.dart';
import 'package:paypad/ui/dashboard/navigation.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn, verification }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus =
            userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    });
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildWidget;
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        buildWidget = new LoginPage(
          title: 'Flutter Login',
          auth: widget.auth,
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
          onVerification: () => _updateAuthStatus(AuthStatus.verification),
        );
        break;
      case AuthStatus.signedIn:
        buildWidget = new Navigation(
            auth: widget.auth,
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn));
        break;
      case AuthStatus.verification:
        buildWidget = new VerifyPage(
            auth: widget.auth,
            onVerify: () => _updateAuthStatus(AuthStatus.signedIn));
        break;
    }
    return buildWidget;
  }
}

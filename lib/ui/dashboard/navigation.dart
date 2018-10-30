import 'package:flutter/material.dart';
import 'package:paypad/ui/dashboard/history/history_page.dart';
import 'package:paypad/ui/dashboard/home/homepage.dart';
import 'package:paypad/ui/dashboard/profile/profile_page.dart';
import 'package:paypad/ui/auth.dart';

class Navigation extends StatefulWidget {
  Navigation({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;

  @override
  _NavigationPageState createState() => new _NavigationPageState();
}

class _NavigationPageState extends State<Navigation> {
  int _curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _curIndex,
          onTap: (index) {
            _curIndex = index;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(_curIndex == 0
                  ? 'assets/img/ico_home_selected.png'
                  : 'assets/img/ico_home.png'),
              title: Text(
                'Home',
                style: TextStyle(color: Colors.black),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(_curIndex == 1
                  ? 'assets/img/ico_history_selected.png'
                  : 'assets/img/ico_history.png'),
              title: Text(
                'History',
                style: TextStyle(color: Colors.black),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(_curIndex == 2
                  ? 'assets/img/ico_profile_selected.png'
                  : 'assets/img/ico_profile.png'),
              title: Text(
                'Account',
                style: TextStyle(color: Colors.black),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(_curIndex == 3
                  ? 'assets/img/ico_chat_selected.png'
                  : 'assets/img/ico_chat.png'),
              title: Text(
                'Communication',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ]),
      body: new Center(
        child: _getWidget(),
      ),
    );
  }

  Widget _getWidget() {
    switch (_curIndex) {
      case 0:
        return Container(
          color: Colors.red,
          child: HomePage(auth: widget.auth, onSignOut: widget.onSignOut),
        );
        break;
      case 1:
        return Container(
          child: HistoryPage(auth: widget.auth),
        );
        break;
      case 2:
        return Container(
          child: ProfilePage(auth: widget.auth),
        );
        break;
      default:
        return Container(
          child: ProfilePage(),
        );
        break;
    }
  }
}

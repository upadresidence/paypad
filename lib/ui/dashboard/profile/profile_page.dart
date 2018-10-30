import 'package:flutter/material.dart';
import 'package:paypad/model/tenants_model.dart';
import 'package:paypad/ui/widgets/bank_card.dart';
import 'package:paypad/ui/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.auth});
  final BaseAuth auth;

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  TenantsModel tenant;

  final List<BankCardModel> cards = [
    BankCardModel('assets/img/bg_red_card.png', 'Hoang Cuu Long',
        '4221 5168 7464 2283', '08/20', 10000000),
    BankCardModel('assets/img/bg_blue_circle_card.png', 'Hoang Cuu Long',
        '4221 5168 7464 2283', '08/20', 10000000),
    BankCardModel('assets/img/bg_purple_card.png', 'Hoang Cuu Long',
        '4221 5168 7464 2283', '08/20', 10000000),
    BankCardModel('assets/img/bg_blue_card.png', 'Hoang Cuu Long',
        '4221 5168 7464 2283', '08/20', 10000000),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.auth.currentUser().then((userId) {
      Firestore.instance
          .collection('tenants')
          .document(userId)
          .snapshots()
          .listen((data) {
        setState(() {
          String firstName = data['firstName'];
          String lastName = data['lastName'];
          String email = data['email'];
          String roomNo = data['roomId'];
          String cellNo = data['cellNo'];

          tenant = new TenantsModel(
              userId, firstName, lastName, email, roomNo, cellNo);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (tenant == null) {
      return Scaffold(
          backgroundColor: Color(0xFFF4F4F4),
          body: SpinKitFadingFour(
            color: Colors.grey,
            size: 50.0,
          ));
    } else {
      return Scaffold(
        backgroundColor: Color(0xFFF4F4F4),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
                child: Text(
                  'My Account',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 20.0),
                ),
              ),
              Container(
                child: Expanded(
                  child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Container(
                            margin: EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 30.0),
                                                child: Text(
                                                  'Room:',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  tenant.roomNo,
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 30.0),
                                                child: Text(
                                                  'Name:',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  tenant.firstName +
                                                      ' ' +
                                                      tenant.lastName,
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 30.0),
                                                child: Text(
                                                  'Phone:',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  tenant.cellNo,
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 30.0),
                                                child: Text(
                                                  'Email:',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  tenant.email,
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          //return _userBankCardsWidget();
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

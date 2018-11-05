import 'package:flutter/material.dart';
import 'package:paypad/ui/dashboard/pay_bills/pay_bills_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paypad/ui/auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:paypad/model/tenants_model.dart';
import 'package:paypad/model/history_model.dart';
import 'package:intl/intl.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  double screenWidth = 0.0;
  DateTime _currentDate = DateTime.now();

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  TenantsModel _tenantsModel;
  List<DateTime> _markedDates;
  List<HistoryModel> _billings;

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    widget.auth.currentUser().then((userId) {
      Firestore.instance
          .collection('tenants')
          .document(userId)
          .snapshots()
          .listen((data) {
        setState(() {
          _tenantsModel = TenantsModel(
              userId,
              data['firstName'],
              data['lastName'],
              data['email'],
              data['roomId'],
              data['cellNo'],
              data['signatoryAddress']);
        });
      });

      Firestore.instance
          .collection('billings')
          .where('tenantId', isEqualTo: userId)
          .where('status', isEqualTo: 'unpaid')
          .snapshots()
          .listen((data) {
        setState(() {
          if (_markedDates == null) {
            _markedDates = new List();
            _billings = new List();
          }

          data.documents.forEach((doc) {
            DateTime date = doc['endDate'];
            String amount = doc['amount'];
            String reading;
            String billType = doc['billType'];
            String historyAssetPath;

            switch (doc['billType']) {
              case 'Water':
                historyAssetPath = 'assets/img/ico_pay_water.png';
                reading = doc['reading'] + " cm³";
                break;
              case 'Electricity':
                historyAssetPath = 'assets/img/ico_pay_elect.png';
                reading = doc['reading'] + " kWh";
                break;
              case 'Rent':
                historyAssetPath = 'assets/img/ico_pay_rent.png';
                reading = " ";
                break;
            }

            _billings.add(new HistoryModel(
                date, amount, reading, billType, historyAssetPath));
            _markedDates.add(date);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    if (_tenantsModel == null && _markedDates == null) {
      return Scaffold(
          backgroundColor: Color(0xFFF4F4F4),
          body: SpinKitFadingFour(
            color: Colors.grey,
            size: 50.0,
          ));
    } else {
      return Scaffold(
        backgroundColor: Color(0xFFF4F4F4),
        body: ListView.builder(
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _userInfoWidget();
              } else if (index == 1) {
                return _calendar();
              } else {
                return _utilitesSectionWidget();
              }
            }),
      );
    }
  }

  Widget _calendar() {
    List<HistoryModel> billing;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: CalendarCarousel(
        onDayPressed: (DateTime date) {
          this.setState(() {
            _currentDate = date;
          });

          if (_markedDates.contains(_currentDate)) {
            setState(() {
              billing = new List();

              _billings.forEach((item) {
                if (item.date == _currentDate) {
                  billing.add(item);
                }
              });

              showDialog(
                  context: context,
                  child: new AlertDialog(
                    title: new Text(
                        DateFormat('MMM. dd, yyyy')
                            .format(_currentDate)
                            .toString(),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w900,
                            fontSize: 30.0),
                        textAlign: TextAlign.center),
                    content: _billWidget(billing),
                    actions: <Widget>[
                      FlatButton(
                          child: const Text('Return',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17.0)),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      FlatButton(
                          child: const Text('Pay Now',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17.0)),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                SendMoneyPageRoute(
                                    widget.auth, billing[0].billType));
                          })
                    ],
                  ));
            });
          }
        },
        thisMonthDayBorderColor: Colors.grey,
        height: 350.0,
        selectedDateTime: _currentDate,
        daysHaveCircularBorder: false,
        markedDates: _markedDates,
        markedDateWidget: Positioned(
            child: Container(color: Colors.red, height: 10.0, width: 10.0),
            top: 1.0,
            right: 1.0),
      ),
    );
  }

  Widget _billWidget(List<HistoryModel> billings) {
    return Container(
        height: 120.0,
        margin: EdgeInsets.only(bottom: 0.0, left: 0.0, right: 0.0),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
                itemCount: billings.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Image.asset(
                          billings[index].historyAssetPath,
                          height: 40.0,
                          width: 40.0,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                billings[index].billType,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              Text(billings[index].reading)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Charge',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '₱ ${billings[index].amount.toString()}',
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                })));
  }

  Widget _userInfoWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                child: Text(_tenantsModel.firstName[0]),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 4.0),
                child: Text(
                  'Hello, ' + _tenantsModel.firstName + '!',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w900,
                      fontSize: 17.0),
                ),
              )
            ],
          )),
          Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new IconButton(
                icon: Image.asset('assets/img/ico_logout.png'),
                onPressed: () => showDialog(
                    context: context,
                    child: new AlertDialog(
                      title: new Text("Are you sure?"),
                      content: new Text("Do you wish to signout?"),
                      actions: <Widget>[
                        FlatButton(
                            child: const Text('NO'),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        FlatButton(
                            child: const Text('YES'),
                            onPressed: () {
                              Navigator.pop(context);
                              _signOut();
                            })
                      ],
                    )),
                tooltip: 'Signout',
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _utilitesSectionWidget() {
    var smallItemPadding = EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0);
    if (screenWidth <= 320) {
      smallItemPadding = EdgeInsets.only(left: 10.0, right: 10.0, top: 12.0);
    }
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Utilities',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 80.0,
            child: Card(
              color: Colors.white70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                      onTapUp: (tapDetail) {
                        Navigator.push(
                            context, SendMoneyPageRoute(widget.auth, 'Water'));
                      },
                      child: Padding(
                        padding: smallItemPadding,
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/img/ico_pay_water.png',
                              height: 26.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('Water',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15.0)),
                            )
                          ],
                        ),
                      )),
                  GestureDetector(
                      onTapUp: (tapDetail) {
                        Navigator.push(context,
                            SendMoneyPageRoute(widget.auth, 'Electricity'));
                      },
                      child: Padding(
                        padding: smallItemPadding,
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/img/ico_pay_elect.png',
                              height: 26.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Electricity',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15.0),
                              ),
                            )
                          ],
                        ),
                      )),
                  GestureDetector(
                      onTapUp: (tapDetail) {
                        Navigator.push(
                            context, SendMoneyPageRoute(widget.auth, 'Rent'));
                      },
                      child: Padding(
                        padding: smallItemPadding,
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/img/ico_pay_rent.png',
                              height: 26.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('Rent',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15.0)),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignOut();
    } catch (e) {
      print(e);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:paypad/ui/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:paypad/Theme.dart' as Theme;

class SendMoneyPageRoute extends PageRouteBuilder {
  SendMoneyPageRoute(BaseAuth auth, String billType)
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return SendMoneyPage(auth: auth, billType: billType);
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: new SlideTransition(
                position: new Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-1.0, 0.0),
                ).animate(secondaryAnimation),
                child: child,
              ),
            );
          },
        );
}

class SendMoneyPage extends StatefulWidget {
  SendMoneyPage({this.auth, this.billType});

  final String billType;
  final BaseAuth auth;

  @override
  SendMoneyPageState createState() => SendMoneyPageState();
}

class SendMoneyPageState extends State<SendMoneyPage> {
  final TextEditingController amountController = TextEditingController();

  int selectedCardIndex = 0;

  DateTime endDate;
  DateTime currentDate = DateTime.now();
  String reading;
  String date;
  double previousCharge;
  double currentCharge;
  double totalCharge;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    previousCharge = 0.00;
    currentCharge = 0.00;

    widget.auth.currentUser().then((userId) {
      Firestore.instance
          .collection('billings')
          .where('tenantId', isEqualTo: userId)
          .where('status', isEqualTo: 'unpaid')
          .snapshots()
          .listen((data) {
        setState(() {
          data.documents.forEach((doc) {
            endDate = doc['endDate'];

            if (doc['billType'] == widget.billType) {
              if (currentDate.isBefore(endDate)) {
                currentCharge = double.parse(doc['amount']);
              } else {
                previousCharge += double.parse(doc['amount']);
              }
              date = DateFormat('MMM. dd, yyyy').format(endDate);

              switch (doc['billType']) {
                case 'Electricity':
                  reading = 'Reading: ' + doc['reading'] + ' kWh';
                  break;
                case 'Water':
                  reading = 'Reading: ' + doc['reading'] + ' cm³';
                  break;
                case 'Rent':
                  reading = " ";
                  break;
              }
              totalCharge = previousCharge + currentCharge;
            }
            if (previousCharge == 0.00 && currentCharge == 0) {
              totalCharge = -1.00;
            }
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (totalCharge == null) {
      return Scaffold(
          backgroundColor: Color(0xFFF4F4F4),
          body: SpinKitFadingFour(
            color: Colors.grey,
            size: 50.0,
          ));
    } else if (totalCharge == -1.00) {
      return Scaffold(
          backgroundColor: Color(0xFFF4F4F4),
          body: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 16.0, right: 16.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Text(
                          widget.billType,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20.0),
                        ),
                      ],
                    )),
                Container(
                    alignment: Alignment(0.0, 0.0),
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("assets/img/ico_smile.png"),
                        fit: BoxFit.none,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 360.0, left: 16.0, right: 16.0),
                      child: Text(
                        'You are good! All current balances are paid!',
                        style: TextStyle(
                            color: Colors.green,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 25.0),
                        textAlign: TextAlign.center,
                      ),
                    ))
              ])));
    } else {
      return Scaffold(
        backgroundColor: Color(0xFFF4F4F4),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      Text(
                        widget.billType,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20.0),
                      ),
                    ],
                  )),
              Expanded(
                child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return _getSection(index);
                    }),
              ),
//            _getReceiverSection(this.widget.receiver),
//            _getEnterAmountSection()
            ],
          ),
        ),
      );
    }
  }

  Widget _getSection(int index) {
    switch (index) {
      case 0:
        return _getBalance();
      case 1:
        return _getTotal();
      case 2:
        return _getBankCardSection();
      default:
        return _getSendSection();
    }
  }

  Widget _getBalance() {
    Color previousChargeColor = previousCharge == 0
        ? Theme.Colors.goodColor
        : Theme.Colors.warningColor;

    return Container(
      height: 90.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(11.0))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0),
                      child: Text(
                        'Previous Charges',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            '\₱',
                            style: TextStyle(
                                color: previousChargeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                previousCharge.toString(),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                    color: previousChargeColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
            Expanded(
                child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(11.0))),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0),
                      child: Text(
                        'Current Charges',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            '\₱',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                currentCharge.toString(),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ]),
    );
  }

  Widget _getTotal() {
    return Container(
        height: 90.0,
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(11.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 8.0),
                        child: Text(
                          'Total Amount Due',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 0.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  '\₱ ' + totalCharge.toString(),
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              Expanded(
                  child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(11.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 8.0),
                        child: Text(
                          'Due Date: ' + date,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 8.0),
                        child: Text(
                          reading,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.0),
                        ),
                      )
                    ],
                  ),
                ),
              ))
            ]));
  }

  Widget _getBankCardSection() {
    return Container(
//      color: Colors.yellow,
      margin: EdgeInsets.all(16.0),
//      height: 200.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Payment Methods',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Card(
            margin: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(11.0))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return _getBankCard(index);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBankCard(int index) {
    String path;
    String number;
    switch (index) {
      case 1:
        path = 'assets/img/ico_logo_red.png';
        break;
      case 2:
        path = 'assets/img/ico_logo_blue.png';
        break;
      case 3:
        break;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Image.asset(path),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('XXXX XXXX XXXX 9898'),
          )),
          Radio(
            activeColor: Color(0xFF65D5E3),
            value: index,
            groupValue: selectedCardIndex,
            onChanged: (value) {
              selectedCardIndex = value;
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  Widget _getSendSection() {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: GestureDetector(
          onTapUp: (tapDetail) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                  color: Theme.Colors.appBarGradientStart,
                  borderRadius: BorderRadius.all(Radius.circular(11.0))),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Text(
                'PAY NOW',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:paypad/ui/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paypad/model/history_model.dart';
import 'package:intl/intl.dart';
import 'package:paypad/Theme.dart' as Theme;

class HistoryAllPageRoute extends PageRouteBuilder {
  HistoryAllPageRoute(BaseAuth auth)
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return HistoryAllPage(auth: auth);
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

class HistoryAllPage extends StatefulWidget {
  HistoryAllPage({this.auth});

  final BaseAuth auth;

  @override
  HistoryAllPageState createState() => HistoryAllPageState();
}

class HistoryAllPageState extends State<HistoryAllPage> {
  final TextEditingController amountController = TextEditingController();
  List<HistoryModel> historiesWater = new List();
  List<HistoryModel> historiesElect = new List();
  List<HistoryModel> historiesRent = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.auth.currentUser().then((userId) {
      Firestore.instance
          .collection('billings')
          .where('tenantId', isEqualTo: userId)
          .where('status', isEqualTo: 'paid')
          .orderBy('paidDate', descending: true)
          .snapshots()
          .listen((data) {
        setState(() {
          historiesWater = new List();
          historiesRent = new List();
          historiesElect = new List();

          data.documents.forEach((doc) {
            DateTime date = doc['paidDate'];
            String amount = doc['amount'];
            String reading;
            String billType = doc['billType'];
            String historyAssetPath;

            switch (doc['billType']) {
              case 'Water':
                historyAssetPath = 'assets/img/ico_pay_water.png';
                reading = doc['reading'] + " cm³";
                historiesWater.add(new HistoryModel(
                    date, amount, reading, billType, historyAssetPath));
                break;
              case 'Electricity':
                historyAssetPath = 'assets/img/ico_pay_elect.png';
                reading = doc['reading'] + " kWh";
                historiesElect.add(new HistoryModel(
                    date, amount, reading, billType, historyAssetPath));
                break;
              case 'Rent':
                historyAssetPath = 'assets/img/ico_pay_rent.png';
                reading = " ";
                historiesRent.add(new HistoryModel(
                    date, amount, reading, billType, historyAssetPath));
                break;
            }
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.Colors.appBarTitle,
                  bottom: TabBar(
                    tabs: [
                      Tab(
                          icon: Image.asset('assets/img/ico_pay_water.png',
                              height: 30.0)),
                      Tab(
                          icon: Image.asset('assets/img/ico_pay_elect.png',
                              height: 30.0)),
                      Tab(
                          icon: Image.asset('assets/img/ico_pay_rent.png',
                              height: 30.0)),
                    ],
                  ),
                  title: Text(
                    'Payment History',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0),
                  ),
                  leading: IconButton(
                    tooltip: 'Previous choice',
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    _historyWidget(historiesWater),
                    _historyWidget(historiesElect),
                    _historyWidget(historiesRent)
                  ],
                ))));
  }

  Widget _historyCards(HistoryModel history) {
    return Container(
//      height: 100.0,
      margin: EdgeInsets.only(top: 5.0, left: 16.0, right: 16.0),
      child: Card(
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.asset(
                  history.historyAssetPath,
                  height: 40.0,
                  width: 40.0,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '₱ ${history.amount.toString()}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                        textAlign: TextAlign.left,
                      ),
                      Text(history.reading)
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Payment Date: \n ' +
                                  DateFormat('MMM. dd, yyyy')
                                      .format(history.date)
                                      .toString(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _historyWidget(List<HistoryModel> history) {
    if (history == null) {
      return Container(
          child: SpinKitFadingFour(
        color: Colors.grey,
        size: 50.0,
      ));
    } else {
      return Container(
        child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (BuildContext context, int index) {
              return _historyCards(history[index]);
            }),
      );
    }
  }
}

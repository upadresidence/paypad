import 'package:flutter/material.dart';
import 'package:paypad/model/history_model.dart';
import 'package:paypad/ui/auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paypad/ui/dashboard/history/history_all.dart';
import 'package:paypad/Theme.dart' as Theme;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({this.auth});
  final BaseAuth auth;

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  List<HistoryModel> waterList;
  List<HistoryModel> elecList;
  List<charts.Series> seriesList;

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
          waterList = new List();
          elecList = new List();
          seriesList = new List();
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
                if (waterList.length <= 6) {
                  waterList.add(new HistoryModel(
                      date, amount, reading, billType, historyAssetPath));
                }
                break;
              case 'Electricity':
                historyAssetPath = 'assets/img/ico_pay_elect.png';
                reading = doc['reading'] + " kWh";
                if (elecList.length <= 6) {
                  elecList.add(new HistoryModel(
                      date, amount, reading, billType, historyAssetPath));
                }
                break;
              default:
                break;
            }
          });
          seriesList = _populateChart();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (waterList == null && elecList == null) {
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
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
                      child: Text(
                        'My History',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50.0, left: 50.0),
                      child: Image.asset(
                        'assets/img/ico_pay_elect.png',
                        height: 26.0,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 50.0, left: 15.0),
                        child: Text('_____',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w900,
                                color: Colors.yellow))),
                    Padding(
                      padding: EdgeInsets.only(top: 50.0, left: 15.0),
                      child: Image.asset(
                        'assets/img/ico_pay_water.png',
                        height: 26.0,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 50.0, left: 15.0),
                        child: Text('_____',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w900,
                                color: Colors.blue))),
                  ]),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                    height: 420.0,
                    child: new charts.TimeSeriesChart(
                      seriesList,
                      animate: true,
                      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
                      // should create the same type of [DateTime] as the data provided. If none
                      // specified, the default creates local date time.
                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                    )),
              ),
              _getSendSection()
            ],
          ),
        ),
      );
    }
  }

  Widget _getSendSection() {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: GestureDetector(
          onTapUp: (tapDetail) {
            Navigator.push(context, HistoryAllPageRoute(widget.auth));
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
                'VIEW PAYMENT HISTORY',
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

  List<charts.Series<HistoryModel, DateTime>> _populateChart() {
    return [
      new charts.Series<HistoryModel, DateTime>(
        id: 'Water',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (HistoryModel waterHistory, _) => waterHistory.date,
        measureFn: (HistoryModel waterHistory, _) =>
            double.parse(waterHistory.amount),
        data: waterList,
      ),
      new charts.Series<HistoryModel, DateTime>(
        id: 'Electricity',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (HistoryModel electHistory, _) => electHistory.date,
        measureFn: (HistoryModel electHistory, _) =>
            double.parse(electHistory.amount),
        data: elecList,
      )
    ];
  }
}

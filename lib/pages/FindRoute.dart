import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_01/providers/FilterRouteModel.dart';
import 'package:ps3_01/providers/RouteTrainModel.dart';
import 'package:ps3_01/utils/BoxCustom.dart';
import 'package:ps3_01/utils/Loading.dart';
import 'package:ps3_01/utils/SelectPlace.dart';
import 'package:ps3_01/widgets/AppBottomNavigationBar.dart';
import 'package:ps3_01/widgets/StationPicker.dart';

import 'ChooseRoute.dart';

class FindRoute extends StatefulWidget {
  @override
  _FindRouteState createState() => _FindRouteState();
}

class _FindRouteState extends State<FindRoute> {
  @override
  void initState() {
    super.initState();
  }

  void _showModal(context, {isPickSource = true}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.transparent,
        builder: (context) => StationPicker(isPickSource));
  }

  void _handlePickDepartureDay() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now().add(Duration(days: 1)),
            firstDate: DateTime.now().add(Duration(days: 1)),
            lastDate: DateTime.now().add(Duration(days: 30)))
        .then((value) {
      if (value == null) {
        return;
      }
      Provider.of<FilterRouteModal>(context, listen: false)
          .setDepartureDay(value);
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: AppBottomNavigationBar(),
      body: Consumer<FilterRouteModal>(
        builder: (_, filterRouteModal, __) => Stack(
          children: <Widget>[
            Positioned(
                child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/train_bg_app_ps3.png'),
                    fit: BoxFit.cover),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                ),
              ),
            )),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 110),
              padding: EdgeInsets.symmetric(horizontal: 36, vertical: 20),
              color: Colors.transparent,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      BoxCustom(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            SelectPlace(context,
                                leading: Text(
                                  'Form: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                value: filterRouteModal.sourceName, onTab: () {
                              _showModal(context);
                            }),
                            Divider(),
                            SelectPlace(context,
                                leading: Text(
                                  'To: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                value: filterRouteModal.destinationName,
                                onTab: () {
                              _showModal(context, isPickSource: false);
                            })
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BoxCustom(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: SelectPlace(
                              context,
                              leading: Icon(Icons.date_range,
                                  color: Theme.of(context).accentColor),
                              value: filterRouteModal.departureDayString,
                              onTab: _handlePickDepartureDay,
                            ),
                          ))
                    ],
                  ),
                  Positioned(
                      top: 115,
                      right: -20,
                      child: FloatingActionButton(
                        child: Icon(Icons.search),
                        onPressed: () {
                          // Scaffold.of(context).showSnackBar(SnackBar(
                          //     content: Text('Please fill out the form')));
                          return _handleSearch(filterRouteModal);
                        },
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSearch(filterRouteModal) async {
    if (filterRouteModal.source == null ||
        filterRouteModal.destination == null ||
        filterRouteModal.departureDay == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Please fill out the form',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    var fetch = Provider.of<RouteTrainModel>(context, listen: false)
        .getRouteTrains(
            filterRouteModal.source.id, filterRouteModal.destination.id);

    var value = await Loading.show(context, fetch);

    if (value == null) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Not found route'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChooseRoute()));
    }
  }
}

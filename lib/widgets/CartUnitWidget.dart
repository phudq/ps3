import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_01/models/SeatDetail.dart';
import 'package:ps3_01/providers/SeatDetailModel.dart';
import 'package:ps3_01/service/Global.dart';

class CartUnitWidget extends StatelessWidget {
  final SeatDetail seatDetail;
  final DateTime expiredAt;
  CartUnitWidget(this.seatDetail, this.expiredAt);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                          children: [
                            TextSpan(text: 'Form '),
                            TextSpan(
                              text: seatDetail.source.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' to '),
                            TextSpan(
                              text: seatDetail.destination.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' in '),
                            TextSpan(
                              text: seatDetail.departureDay,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              children: [
                                TextSpan(text: 'Train \n'),
                                TextSpan(
                                  text: seatDetail.trainCode,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              children: [
                                TextSpan(text: 'Class \n'),
                                TextSpan(
                                  text: seatDetail.trainCar.trainCarType,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              children: [
                                TextSpan(text: 'Coach \n'),
                                TextSpan(
                                  text: seatDetail.trainCar.indexNumber
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              children: [
                                TextSpan(text: 'Seat \n'),
                                TextSpan(
                                  text: seatDetail.seat.seatNo.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Remove this item?'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            RaisedButton(
                              onPressed: () {
                                Provider.of<SeatDetailModal>(context,
                                        listen: false)
                                    .remove(seatDetail);
                                Global.batchDelete([seatDetail.key]);
                                Navigator.of(context).pop();
                              },
                              color: Theme.of(context).accentColor,
                              child: Text('Ok'),
                            )
                          ],
                        );
                      },
                    );
                  })
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Theme.of(context).accentColor),
                  children: [
                    TextSpan(text: 'Price: '),
                    TextSpan(
                      text: '${seatDetail.seat.price.toString()}\$',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Countdown(expiredAt)
            ],
          ),
        ],
      ),
    );
  }
}

class Countdown extends StatefulWidget {
  final DateTime expiredAt;
  Countdown(this.expiredAt);
  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer timer;
  int count;

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 10), (a) {
      setState(() {
        count = widget.expiredAt.difference(DateTime.now()).inSeconds;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      count = widget.expiredAt.difference(DateTime.now()).inSeconds;
    });
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int mn = (count / 60).floor();
    String txt = 'Expires in $mn minutes';
    if (mn <= 0) {
      txt = 'Expires in less than 1 minute';
    }
    return Text(
      txt,
      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.redAccent),
    );
  }
}

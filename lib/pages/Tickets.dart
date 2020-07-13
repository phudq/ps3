import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:ps3_01/config/AppConfig.dart';
import 'package:ps3_01/models/Ticket.dart';
import 'package:ps3_01/pages/TicketDetail.dart';
import 'package:ps3_01/utils/Loading.dart';
import 'package:ps3_01/utils/custom_icon_icons.dart';
import 'package:ps3_01/widgets/AppBottomNavigationBar.dart';
import 'package:ps3_01/widgets/CustomAppBar.dart';

class Tickets extends StatelessWidget {
  String code;
  String identityNumber;
  String departureDay;

  var _formKey = GlobalKey<FormState>();
  var departureDayContl = TextEditingController();
  Future<Ticket> _getTicket(
      {@required String code,
      @required String identityNumber,
      @required String departureDay}) async {
    var uri = Uri.http(AppConfig.domain, '/api/tickets', {
      'Code': code,
      'IdentityNumber': identityNumber,
      'DepartureDay': departureDay
    });

    final response = await http.get(uri);

    try {
      if (response.statusCode != 200 || response.body == 'null') {
        throw Exception('Failed to load ticket');
      }
      final colection = json.decode(response.body);
      Ticket ticket = Ticket.fromJson(colection);
      return ticket;
    } catch (e) {
      return null;
    }
  }

  void _handleSearchTicket(
      {@required context,
      @required String code,
      @required String identityNumber,
      @required String departureDay}) async {
    Future fetch = _getTicket(
        code: code, identityNumber: identityNumber, departureDay: departureDay);

    var value = await Loading.show(context, fetch);
    if (value == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ticket not found!'),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              )
            ],
          );
        },
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return TicketDetail(value);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: AppBottomNavigationBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title: 'Ticket',
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Code'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the code';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        code = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Identity number'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter identity number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        identityNumber = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      readOnly: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please choose departure day';
                        }
                        return null;
                      },
                      onTap: () async {
                        DateTime date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2010),
                            lastDate: DateTime(2021));
                        if (date == null) {
                          return;
                        }
                        departureDayContl.text =
                            DateFormat('dd-MM-yyyy').format(date);
                      },
                      decoration: InputDecoration(
                          labelText: 'Departure day',
                          prefixIcon: Icon(Icons.date_range)),
                      controller: departureDayContl,
                      onSaved: (value) {
                        departureDay = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            color: Colors.white,
                            icon: Icon(
                              CustomIcon.qrcode,
                            ),
                            onPressed: () async {
                              var result = await BarcodeScanner.scan();
                              if (result.rawContent.isEmpty) {
                                return;
                              }
                              var data = json.decode(result.rawContent);
                              _handleSearchTicket(
                                context: context,
                                code: data['code'],
                                identityNumber: data['identityNumber'],
                                departureDay: data['departureDay'],
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            color: Colors.white,
                            icon: Icon(
                              Icons.search,
                            ),
                            onPressed: () async {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                              _formKey.currentState.save();
                              _handleSearchTicket(
                                  context: context,
                                  code: code,
                                  identityNumber: identityNumber,
                                  departureDay: departureDay);
                            },
                          ),
                        ),
                        // RaisedButton(
                        //   onPressed: () {
                        //     var test = {
                        //       "Id": 1,
                        //       "Code": "QEzJyajzWAEj",
                        //       "TrainCarIndex": 1,
                        //       "TrainCartype": "First Class",
                        //       "SeatNumber": 1,
                        //       "SourceName": "A",
                        //       "DestinationName": "B",
                        //       "IdObjectPassenger": 1,
                        //       "ObjectPassengerName": "Adult",
                        //       "Price": 75000.00,
                        //       "DepartureDay": "10-07-2020",
                        //       "Status": 1
                        //     };
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder: (context) {
                        //           return TicketDetail(
                        //             new Ticket(
                        //                 1,
                        //                 "QEzJyajzWAEj",
                        //                 1,
                        //                 "First Class",
                        //                 1,
                        //                 "A",
                        //                 "B",
                        //                 1,
                        //                 "Adult",
                        //                 "10-07-2020",
                        //                 75.0,
                        //                 StatusTicket.done),
                        //           );
                        //         },
                        //       ),
                        //     );
                        //   },
                        //   child: Text('Test'),
                        // )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

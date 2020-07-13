import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ps3_01/config/AppConfig.dart';
import 'package:ps3_01/models/Seat.dart';

class SeatModel with ChangeNotifier {
  List<Seat> seats = [];

  Future getSeats({
    @required int idTrainCar,
    @required int startStation,
    @required int endStation,
    @required DateTime departureDay,
    bool noti = true,
  }) async {
    try {
      String departureDayString =
          new DateFormat('dd-MM-yyyy').format(departureDay).toString();
      var uri = Uri.http(AppConfig.domain, '/api/seats', {
        'IdTrainCar': idTrainCar.toString(),
        'StartStation': startStation.toString(),
        'EndStation': endStation.toString(),
        'DepartureDay': departureDayString
      });
      final response = await http.get(uri);
      List collection = json.decode(response.body);
      seats = collection.map((e) => Seat.fromJson(e)).toList();
      if (noti) {
        notifyListeners();
      }
      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

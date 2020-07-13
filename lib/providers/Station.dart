import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ps3_01/config/AppConfig.dart';
import 'package:ps3_01/models/Station.dart';
import 'package:http/http.dart' as http;

class StationModel extends ChangeNotifier {
  List<Station> stations = [];
  StationModel(this.stations);

  static Future<StationModel> fetch() async {
    var uri = Uri.http(AppConfig.domain, '/api/stations/all');
    final response = await http.get(uri);
    List collection = json.decode(response.body);
    return StationModel(collection.map((e) => Station.fromJson(e)).toList());
  }
}

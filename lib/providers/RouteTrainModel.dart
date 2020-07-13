import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ps3_01/config/AppConfig.dart';
import 'package:ps3_01/models/RouteTrain.dart';

class RouteTrainModel with ChangeNotifier {
  List<RouteTrain> routesTrain = [];
  int idCurrent;

  void setCurrent(value) {
    idCurrent = value;
    notifyListeners();
  }

  Future getRouteTrains(idSource, idDestination) async {
    var uri = Uri.http(AppConfig.domain, '/api/routes', {
      'StartStation': idSource.toString(),
      'EndStation': idDestination.toString()
    });
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List collection = json.decode(response.body);
        routesTrain = collection.map((e) => RouteTrain.fromJson(e)).toList();
        if (routesTrain.length <= 0) {
          return null;
        }
        idCurrent = routesTrain.first.trainId;
        notifyListeners();
        return routesTrain.first;
      } else {
        throw Exception('Failed to load route');
      }
    } catch (e) {
      print(e);
    }
  }
}

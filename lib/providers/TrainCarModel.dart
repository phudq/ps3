import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ps3_01/config/AppConfig.dart';
import 'package:ps3_01/models/RouteTrain.dart';
import 'package:ps3_01/models/TrainCar.dart';

class TrainCarModel with ChangeNotifier {
  int idTrain;
  String trainCode;
  List<TrainCar> trainCars = [];
  TrainCar currentTrainCar;

  void setCurrentTrainCar(value) {
    currentTrainCar = value;
    notifyListeners();
  }

  Future getTrainCars({@required RouteTrain train}) async {
    try {
      var uri = Uri.http(AppConfig.domain, '/api/traincars',
          {'IdTrain': train.trainId.toString()});
      final response = await http.get(uri);
      List collection = json.decode(response.body);
      trainCars = collection.map((e) => TrainCar.fromJson(e)).toList();
      currentTrainCar = trainCars.first;
      idTrain = train.trainId;
      trainCode = train.trainCode;
      notifyListeners();
      return trainCars.first;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:ps3_01/models/Seat.dart';
import 'package:ps3_01/models/Station.dart';
import 'package:ps3_01/models/TrainCar.dart';

class SeatDetail {
  final String key;
  final int idTrain;
  final String trainCode;
  final Seat seat;
  final TrainCar trainCar;
  final String departureDay;
  final Station source;
  final Station destination;
  SeatDetail(
      {@required this.seat,
      @required this.idTrain,
      @required this.trainCode,
      @required this.trainCar,
      @required this.source,
      @required this.destination,
      @required this.departureDay})
      : key = '${trainCar.id}-${seat.id}-$departureDay';

  @override
  bool operator ==(Object o) =>
      o is SeatDetail &&
      seat.id == o.seat.id &&
      trainCar.id == o.trainCar.id &&
      departureDay == o.departureDay &&
      source.id == o.source.id &&
      destination.id == o.destination.id;
  @override
  int get hashCode => seat.id.hashCode ^ trainCar.id.hashCode;

  Map<String, dynamic> toJson() => {
        'idSeat': this.seat.id,
        'idTrain': this.idTrain,
        'trainCode': this.trainCode,
        'idTrainCar': this.trainCar.id,
        'idSource': this.source.id,
        'idDestination': this.destination.id,
        'departureDay': this.departureDay
      };
}

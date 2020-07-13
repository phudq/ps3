import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ps3_01/models/RouteTrain.dart';
import 'package:ps3_01/models/Station.dart';

class FilterRouteModal extends ChangeNotifier {
  Station source;
  Station destination;
  DateTime departureDay;
  RouteTrain routeTrain;

  void setSource(Station value) {
    source = value;
    notifyListeners();
  }

  void setRouteTrain(RouteTrain value) {
    routeTrain = value;
  }

  String get sourceName {
    return source != null ? source.name : '';
  }

  String get destinationName {
    return destination != null ? destination.name : '';
  }

  String get departureDayString {
    return departureDay != null
        ? DateFormat('dd-MM-yyyy').format(departureDay)
        : '';
  }

  void setDestination(Station value) {
    destination = value;
    notifyListeners();
  }

  void setDepartureDay(DateTime value) {
    departureDay = value;
    notifyListeners();
  }
}

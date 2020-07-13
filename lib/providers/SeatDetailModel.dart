import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ps3_01/models/SeatDetail.dart';
import 'package:ps3_01/models/TrainCar.dart';
import 'package:ps3_01/service/Global.dart';

class SeatDetailModal extends ChangeNotifier {
  Set<SeatDetail> seatsSelected = new Set();
  List<String> chosenSeats = [];
  List<Timer> listTimers = [];
  SeatDetail seatFocus;

  @override
  void dispose() {
    Global.batchDelete(chosenSeats);
    super.dispose();
  }

  void add(Duration duration, SeatDetail seatDetail) {
    Timer a = Timer(duration, () {
      seatsSelected.remove(seatDetail);
      Global.chosenSeats.document(seatDetail.key).delete().then((value) {
        // Scaffold.of(context).showSnackBar(SnackBar(content: Text('ok')));
      });
      notifyListeners();
    });
    listTimers.add(a);
  }

  bool addSeat(SeatDetail seatDetail) {
    if (seatsSelected.length > 10) {
      return false;
    } else {
      seatsSelected.add(seatDetail);
      notifyListeners();
      return true;
    }
  }

  void removeSeat(SeatDetail seatDetail) {
    if (seatsSelected.contains(seatDetail)) {
      seatsSelected.remove(seatDetail);
      notifyListeners();
    }
  }

  void deleteMany(List<String> keys) {
    if (keys.length > 0) {
      seatsSelected.removeWhere((element) => keys.contains(element.key));
      // notifyListeners();
    }
  }

  bool trainCarHasSeatSelected(TrainCar trainCar) {
    return seatsSelected.any((SeatDetail seatDetail) {
      return seatDetail.trainCar.isEq(trainCar);
    });
  }

  void addSeatFocus(SeatDetail seatDetail) {
    seatFocus = seatDetail;
    notifyListeners();
  }

  void removeSeatFocus() {
    seatFocus = null;
    notifyListeners();
  }

  bool focusToSeatSelected() {
    return seatsSelected.contains(seatFocus);
  }

  void remove(SeatDetail seatDetail) {
    seatsSelected.remove(seatDetail);
    notifyListeners();
  }

  void clear() {
    seatsSelected = new Set();
  }
}

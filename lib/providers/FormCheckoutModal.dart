import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ps3_01/config/AppConfig.dart';
import 'package:ps3_01/models/ObjectPassenger.dart';
import 'package:ps3_01/models/SeatDetail.dart';
import 'package:http/http.dart' as http;

class FormCheckoutModal extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  String name;
  String email;
  String phone;
  int typePayment = 1;
  Map<String, ItemFormPassenger> passengers = new Map();

  void handleSave(int idSeat, int idTranCar, String key, dynamic value,
      [bool noti = false]) {
    passengers.update(
      '${idSeat.toString()}-${idTranCar.toString()}',
      (itemFormPassenger) {
        switch (key) {
          case 'name':
            itemFormPassenger.newName = value;
            break;
          case 'identityNumber':
            itemFormPassenger.newIdentityNumber = value;
            break;
          case 'idObject':
            itemFormPassenger.newIdObject = value;
            itemFormPassenger.identityNumber = '';
            break;
          default:
        }
        return itemFormPassenger;
      },
    );
    if (noti) {
      notifyListeners();
    }
  }

  void setInit(Set<SeatDetail> seatDetails, ObjectPassenger objectPassenger) {
    Map<String, ItemFormPassenger> newPassengers = Map.fromIterable(seatDetails,
        key: (e) => '${e.seat.id.toString()}-${e.trainCar.id.toString()}',
        value: (e) => ItemFormPassenger(e, objectPassenger.id));
    Map<String, ItemFormPassenger> a = {};
    passengers = a..addAll(passengers)..addAll(newPassengers);
  }

  void setName(value) {
    name = value;
  }

  void setEmail(value) {
    email = value;
  }

  void setPhone(value) {
    phone = value;
  }

  void setTypePayment(value) {
    typePayment = value;
    notifyListeners();
  }

  String validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      List<ItemFormPassenger> listPassenger = new List();
      passengers.forEach((key, value) {
        listPassenger.add(value);
      });
      final data = {
        'name': name,
        'email': email,
        'phone': phone,
        'typePayment': typePayment,
        'tickets': listPassenger
      };
      return json.encode(data);
    } else {
      return null;
    }
  }

  Future submit(data) async {
    var uri = Uri.http(AppConfig.domain, '/api/orders');
    try {
      final response = await http.post(uri,
          headers: {'Content-type': 'application/json'}, body: data);
      if (response.statusCode != 200) {
        throw Exception('ALo');
      }
      return response.body;
    } catch (e) {
      print(e);
    }
  }
}

class ItemFormPassenger {
  SeatDetail seatDetail;
  String name;
  String identityNumber;
  int idObject;

  ItemFormPassenger(this.seatDetail, this.idObject);

  set newName(String value) {
    name = value;
  }

  set newIdentityNumber(String value) {
    identityNumber = value;
  }

  set newIdObject(int value) {
    idObject = value;
  }

  Map<String, dynamic> toJson() => {
        'idSeat': this.seatDetail.seat.id,
        'idTrainCar': this.seatDetail.trainCar.id,
        'idSource': this.seatDetail.source.id,
        'idDestination': this.seatDetail.destination.id,
        'departureDay': this.seatDetail.departureDay,
        'name': this.name,
        'identityNumber': this.identityNumber,
        'idObject': this.idObject
      };
}

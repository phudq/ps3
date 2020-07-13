import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_01/models/SeatDetail.dart';
import 'package:ps3_01/models/TrainCar.dart';
import 'package:ps3_01/providers/FilterRouteModel.dart';
import 'package:ps3_01/providers/SeatDetailModel.dart';
import 'package:ps3_01/providers/SeatModal.dart';
import 'package:ps3_01/service/Global.dart';

import 'SeatWidget.dart';

class ListSeat extends StatelessWidget {
  final TrainCar trainCar;
  final int idTrain;
  final String trainCode;
  final String departureDay;
  final int startIndex;
  final int endIndex;
  ListSeat(
      {this.trainCar,
      this.idTrain,
      this.trainCode,
      this.departureDay,
      this.startIndex,
      this.endIndex});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Global.chosenSeats
          .where('departureDay', isEqualTo: departureDay)
          .where('idTrainCar', isEqualTo: trainCar.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        List<String> listChosenSeat =
            (snapshot.data.documents as List<DocumentSnapshot>)
                .where((e) {
                  var start = e.data['startIndex'];
                  var end = e.data['endIndex'];
                  return start < endIndex && end > start;
                })
                .map((e) => e.documentID)
                .toList();

        return Consumer3<SeatModel, SeatDetailModal, FilterRouteModal>(
          builder: (
            BuildContext context,
            SeatModel seatModel,
            SeatDetailModal seatDetailModal,
            FilterRouteModal filterRouteModal,
            Widget child,
          ) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Wrap(
                  runSpacing: 20,
                  spacing: 9,
                  children: seatModel.seats.map(
                    (seat) {
                      SeatDetail seatDetail = new SeatDetail(
                          seat: seat,
                          idTrain: idTrain,
                          trainCode: trainCode,
                          trainCar: trainCar,
                          source: filterRouteModal.source,
                          destination: filterRouteModal.destination,
                          departureDay: filterRouteModal.departureDayString);
                      bool isSelected =
                          seatDetailModal.seatsSelected.contains(seatDetail);
                      bool isFocus = seatDetailModal.seatFocus == seatDetail;
                      bool isChosen = listChosenSeat.contains(seatDetail.key);
                      return FractionallySizedBox(
                        widthFactor: 0.22,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: SeatWidget(seat, isSelected, isFocus, isChosen,
                              () {
                            if (seatDetailModal.seatFocus == seatDetail) {
                              Provider.of<SeatDetailModal>(context,
                                      listen: false)
                                  .removeSeatFocus();
                            } else {
                              Provider.of<SeatDetailModal>(context,
                                      listen: false)
                                  .addSeatFocus(seatDetail);
                            }
                          }, key: UniqueKey()),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

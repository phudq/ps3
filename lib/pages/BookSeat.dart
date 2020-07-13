import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_01/models/SeatDetail.dart';
import 'package:ps3_01/models/TrainCar.dart';
import 'package:ps3_01/providers/FilterRouteModel.dart';
import 'package:ps3_01/providers/SeatDetailModel.dart';
import 'package:ps3_01/providers/SeatModal.dart';
import 'package:ps3_01/providers/TrainCarModel.dart';
import 'package:ps3_01/service/Global.dart';
import 'package:ps3_01/widgets/CustomAppBar.dart';
import 'package:ps3_01/widgets/ListSeat.dart';
import 'package:ps3_01/widgets/SeatFocused.dart';
import 'package:ps3_01/widgets/TrainCarWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookSeat extends StatelessWidget {
  const BookSeat({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _handleAddSeat(
        FilterRouteModal filterRouteModal, SeatDetail seatDetail) {
      bool check = Provider.of<SeatDetailModal>(context, listen: false)
          .addSeat(seatDetail);
      if (!check) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Min 10')));
      }

      Duration duration = Duration(minutes: 10);

      Global.chosenSeats.document(seatDetail.key).setData({
        'idTrainCar': seatDetail.trainCar.id,
        'idSeat': seatDetail.seat.id,
        'departureDay': seatDetail.departureDay,
        'startIndex': filterRouteModal.routeTrain.startIndex,
        'endIndex': filterRouteModal.routeTrain.endIndex,
        'expiredAt': DateTime.now().add(duration),
      });
      Provider.of<SeatDetailModal>(context, listen: false)
          .add(duration, seatDetail);
    }

    void _handleRemoveSeat(SeatDetail seatDetail) {
      Provider.of<SeatDetailModal>(context, listen: false).remove(seatDetail);
      Global.chosenSeats.document(seatDetail.key).delete();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomAppBar(
              showCart: true,
              title: 'Choose seat',
            ),
            _info(),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child:
                  Consumer3<FilterRouteModal, TrainCarModel, SeatDetailModal>(
                builder: (context, filterRouteModal, trainCarModel,
                        seatDetailModal, __) =>
                    Stack(
                  children: <Widget>[
                    Container(
                      color: Color.fromRGBO(228, 231, 236, 1),
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 8,
                            child: ListSeat(
                              trainCar: trainCarModel.currentTrainCar,
                              idTrain: trainCarModel.idTrain,
                              trainCode: trainCarModel.trainCode,
                              departureDay: filterRouteModal.departureDayString,
                              startIndex:
                                  filterRouteModal.routeTrain.startIndex,
                              endIndex: filterRouteModal.routeTrain.startIndex,
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: _trainCars(filterRouteModal, trainCarModel,
                                seatDetailModal),
                          )
                        ],
                      ),
                    ),
                    SeatFocused(
                      seatFocused: seatDetailModal.seatFocus,
                      isFocusToSeatSelected:
                          seatDetailModal.focusToSeatSelected(),
                      onAddSeat: () => _handleAddSeat(
                          filterRouteModal, seatDetailModal.seatFocus),
                      onRemoveSeat: () =>
                          _handleRemoveSeat(seatDetailModal.seatFocus),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _seatFocus(SeatDetail seatDetail) {}

  Widget _trainCars(FilterRouteModal filterRouteModal,
      TrainCarModel trainCarModel, SeatDetailModal seatDetailModal) {
    return Container(
      margin: EdgeInsets.only(left: 26),
      child: ListView.builder(
        itemCount: trainCarModel.trainCars.length,
        itemBuilder: (context, index) {
          TrainCar trainCar = trainCarModel.trainCars[index];
          bool isCurrentTrainCar = trainCar.isEq(trainCarModel.currentTrainCar);
          bool hasSeatSelect =
              seatDetailModal.trainCarHasSeatSelected(trainCar);
          return TrainCarWidget(
            trainCar,
            isCurrentTrainCar,
            hasSeatSelect,
            () {
              final trainCarModel =
                  Provider.of<TrainCarModel>(context, listen: false);

              trainCarModel.setCurrentTrainCar(trainCar);
              Provider.of<SeatModel>(context, listen: false).getSeats(
                idTrainCar: trainCar.id,
                startStation: filterRouteModal.source.id,
                endStation: filterRouteModal.destination.id,
                departureDay: filterRouteModal.departureDay,
              );
            },
            key: UniqueKey(),
          );
        },
      ),
    );
  }

  Widget _info() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        {
          'color': Color.fromRGBO(236, 236, 237, 1),
          'title': 'Not available',
          'border': false
        },
        {'color': Colors.white, 'title': 'Available', 'border': true},
        {
          'color': Color.fromRGBO(50, 70, 88, 1),
          'title': 'Selected',
          'border': false
        }
      ]
          .map<Widget>(
            (e) => Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: e['color'],
                    border: e['border']
                        ? Border.all(
                            color: Color.fromRGBO(228, 230, 234, 1),
                          )
                        : null,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  width: 20,
                  height: 20,
                ),
                Text(
                  e['title'],
                )
              ],
            ),
          )
          .toList(),
    );
  }
}

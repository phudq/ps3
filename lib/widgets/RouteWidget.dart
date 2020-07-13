import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_01/models/RouteTrain.dart';
import 'package:ps3_01/models/TrainCar.dart';
import 'package:ps3_01/pages/BookSeat.dart';
import 'package:ps3_01/providers/SeatModal.dart';
import 'package:ps3_01/providers/TrainCarModel.dart';
import 'package:ps3_01/utils/Loading.dart';
import 'package:ps3_01/utils/cusom_color.dart';
import 'package:ps3_01/widgets/TimeLineRoute.dart';
import 'package:ps3_01/providers/FilterRouteModel.dart';
import 'package:ps3_01/utils/ExpandedSection.dart';

class RouteWidget extends StatefulWidget {
  final RouteTrain routeTrain;
  RouteWidget(this.routeTrain);
  @override
  _RouteWidgetState createState() => _RouteWidgetState();
}

class _RouteWidgetState extends State<RouteWidget> {
  bool expand = false;

  void _handleChoose(context, filterRouteModal) async {
    final trainCarModel = Provider.of<TrainCarModel>(context, listen: false);
    final seatModel = Provider.of<SeatModel>(context, listen: false);

    Future fetch() async {
      TrainCar trainCar =
          await trainCarModel.getTrainCars(train: widget.routeTrain);
      await seatModel.getSeats(
        idTrainCar: trainCar.id,
        startStation: filterRouteModal.source.id,
        endStation: filterRouteModal.destination.id,
        departureDay: filterRouteModal.departureDay,
        noti: false,
      );
    }

    Provider.of<FilterRouteModal>(context, listen: false)
        .setRouteTrain(widget.routeTrain);

    await Loading.show(context, fetch());

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BookSeat()));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterRouteModal>(
        builder: (context, filterRouteModal, child) {
      return GestureDetector(
        onTap: () {
          setState(() {
            expand = !expand;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 16,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.routeTrain.trainCode,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Theme.of(context).accentColor),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.routeTrain.startTime,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    filterRouteModal.sourceName,
                                    style: TextStyle(),
                                  ),
                                ],
                              ),
                              Text('----'),
                              Column(
                                children: <Widget>[
                                  Text(widget.routeTrain.travelTimeString),
                                  Text(
                                    widget.routeTrain.distanceString + ' km',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black45,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                              Text('----'),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.routeTrain.endTime,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    filterRouteModal.destinationName,
                                    style: TextStyle(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              expand
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 8,
                    child: _buttonChosseSeat(context, filterRouteModal),
                  ),
                ],
              ),
              ExpandedSection(
                expand: expand,
                child: TimeLineRoute(widget.routeTrain.points),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buttonChosseSeat(
      BuildContext context, FilterRouteModal filterRouteModal) {
    return RaisedButton(
      color: CustomColor.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: () {
        _handleChoose(context, filterRouteModal);
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (_) => BookSeat()));
      },
      child: Text(
        'Seats',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

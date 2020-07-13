import 'package:flutter/material.dart';
import 'package:ps3_01/models/TrainCar.dart';

class TrainCarWidget extends StatelessWidget {
  final TrainCar trainCar;
  final bool isCurrentTrainCar;
  final bool hasSeatSelect;
  final Function onChange;
  const TrainCarWidget(
      this.trainCar, this.isCurrentTrainCar, this.hasSeatSelect, this.onChange,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChange,
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            height: 90,
            decoration: BoxDecoration(
                color: isCurrentTrainCar
                    ? Color.fromRGBO(50, 70, 88, 1)
                    : Colors.white,
                border: Border.all(color: Color.fromRGBO(173, 178, 187, 1)),
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Text(
                trainCar.indexNumber.toString(),
                style: TextStyle(
                    fontSize: 20,
                    color: isCurrentTrainCar ? Colors.white : Colors.black),
              ),
            ),
          ),
          Positioned(
            top: 4,
            child: hasSeatSelect
                ? Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}

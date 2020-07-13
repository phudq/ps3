import 'package:flutter/material.dart';
import 'package:ps3_01/models/Seat.dart';
import 'package:ps3_01/utils/cusom_color.dart';

class SeatWidget extends StatelessWidget {
  final Seat seat;
  final bool isSelected;
  final bool isFocus;
  final bool isChosen;
  final Function onSelect;
  const SeatWidget(
      this.seat, this.isSelected, this.isFocus, this.isChosen, this.onSelect,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: seat.emptySeat && (!isChosen || isSelected) ? onSelect : null,
      child: Container(
        decoration: _boxDecoration(),
        child: Center(
          child: Text(seat.seatNo.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: isSelected ? Colors.white : Colors.black)),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    var style = {
      'color': Colors.white,
      'border': CustomColor.porcelain,
      'boxShadow': [BoxShadow(color: Colors.grey.withOpacity(0))]
    };

    if (!seat.emptySeat) {
      style['color'] = CustomColor.porcelain;
    }

    if (isFocus) {
      style['boxShadow'] = [
        BoxShadow(
          color: Colors.white.withOpacity(0.8),
          offset: Offset(-6.0, -6.0),
          blurRadius: 16.0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: Offset(6.0, 6.0),
          blurRadius: 16.0,
        ),
      ];

      style['border'] = Colors.amberAccent;
    }

    if (isChosen) {
      style['color'] = Colors.blueGrey;
    }

    if (isSelected) {
      style['color'] = CustomColor.ebonyClay;
    }

    var boxDecoration = BoxDecoration(
        color: style['color'],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: style['border'],
        ),
        boxShadow: style['boxShadow']);

    return boxDecoration;
  }
}

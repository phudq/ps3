import 'package:flutter/material.dart';
import 'package:ps3_01/models/SeatDetail.dart';
import 'package:ps3_01/utils/cusom_color.dart';

class SeatFocused extends StatefulWidget {
  final SeatDetail seatFocused;
  final bool isFocusToSeatSelected;
  final Function onAddSeat;
  final Function onRemoveSeat;
  SeatFocused(
      {this.seatFocused,
      this.isFocusToSeatSelected,
      this.onAddSeat,
      this.onRemoveSeat});
  @override
  _SeatFocusedState createState() => _SeatFocusedState();
}

class _SeatFocusedState extends State<SeatFocused>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    super.initState();
  }

  @override
  void didUpdateWidget(SeatFocused oldWidget) {
    if (widget.seatFocused == oldWidget.seatFocused) {
      return;
    }
    if (widget.seatFocused == null) {
    } else {
      _controller.reset();
      _controller.forward();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SeatDetail s = widget.seatFocused
    if (widget.seatFocused == null) {
      return Container();
    }
    return Positioned(
      bottom: 10,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset(0, 2), end: Offset.zero)
            .animate(_controller),
        child: FadeTransition(
          opacity: animation,
          child: Container(
            // height: 50,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 0), // change
                  )
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _itemInfo(
                  key: 'Coach',
                  value: widget.seatFocused?.trainCar?.indexNumber?.toString(),
                ),
                _itemInfo(
                  key: 'Seat',
                  value: widget.seatFocused?.seat?.seatNo?.toString(),
                ),
                _itemInfo(
                  key: 'Price',
                  value: '${widget.seatFocused?.seat?.price?.toString()}\$',
                ),
                widget.isFocusToSeatSelected
                    ? ButtonTheme(
                        height: 30,
                        child: RaisedButton(
                          onPressed: widget.onRemoveSeat,
                          child: Text(
                            'Remove',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : ButtonTheme(
                        minWidth: 60,
                        height: 30,
                        child: RaisedButton(
                          onPressed: widget.onAddSeat,
                          child: Text('Add',
                              style: TextStyle(color: Colors.white)),
                          color: CustomColor.green,
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemInfo({String key = '', String value = ''}) {
    if (value == null) {
      value = '';
    }
    return Column(
      children: <Widget>[
        Text(
          key,
          style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).accentColor),
        ),
        Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
      ],
    );
  }
}

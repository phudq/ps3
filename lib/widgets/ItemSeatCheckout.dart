import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ps3_01/models/ObjectPassenger.dart';
import 'package:ps3_01/models/SeatDetail.dart';
import 'package:ps3_01/providers/FormCheckoutModal.dart';

class ItemPassengerCheckout extends StatelessWidget {
  final SeatDetail seatDetail;
  final List<ObjectPassenger> objectPassengers;
  ItemPassengerCheckout(this.seatDetail, this.objectPassengers);

  @override
  Widget build(BuildContext context) {
    Future _setValue(String key, newValue, bool noti) async {
      return Provider.of<FormCheckoutModal>(context, listen: false).handleSave(
          seatDetail.seat.id, seatDetail.trainCar.id, key, newValue, noti);
    }

    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Consumer<FormCheckoutModal>(
        builder: (context, formCheckoutModal, child) {
          ItemFormPassenger itemFormPassenger = formCheckoutModal.passengers[
              '${seatDetail.seat.id.toString()}-${seatDetail.trainCar.id.toString()}'];
          bool isChildPassenger = itemFormPassenger.idObject == 2;
          var _dobCtrol =
              TextEditingController(text: itemFormPassenger.identityNumber);
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: objectPassengers
                    .map(
                      (ObjectPassenger e) => FlatButton(
                        onPressed: () {
                          _setValue('idObject', e.id, true);
                        },
                        child: Text(
                          e.name,
                          style: TextStyle(
                            decoration: e.id == itemFormPassenger.idObject
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            fontWeight: e.id == itemFormPassenger.idObject
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name passenger',
                  contentPadding: EdgeInsets.all(16),
                ),
                initialValue: itemFormPassenger.name,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _setValue('name', newValue, false);
                },
              ),
              SizedBox(
                width: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(16),
                    prefixIcon:
                        isChildPassenger ? Icon(Icons.date_range) : null,
                    labelText: 'Identity number of passenger'),
                onChanged: (value) {
                  _setValue('identityNumber', value, false);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please add identity number';
                  }
                  return null;
                },
                onTap: isChildPassenger
                    ? () async {
                        DateTime date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.utc(2008),
                            lastDate: DateTime.now());
                        if (date == null) {
                          return;
                        }
                        String dob = DateFormat('dd/MM/yyy').format(date);
                        _setValue('identityNumber', dob, false);
                        if (isChildPassenger) {
                          _dobCtrol.text = dob;
                        }
                      }
                    : null,
                controller: _dobCtrol,
              ),
              SizedBox(
                height: 20,
              ),
              _infor(context, seatDetail),
            ],
          );
        },
      ),
    );
  }
}

Widget _infor(context, SeatDetail seatDetail) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: TextStyle(color: Theme.of(context).accentColor),
            children: [
              TextSpan(text: 'Form '),
              TextSpan(
                text: seatDetail.source.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' to '),
              TextSpan(
                text: seatDetail.destination.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' in '),
              TextSpan(
                text: seatDetail.departureDay,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: TextStyle(color: Theme.of(context).accentColor),
                children: [
                  TextSpan(text: 'Train \n'),
                  TextSpan(
                    text: seatDetail.trainCode,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Theme.of(context).accentColor),
                children: [
                  TextSpan(text: 'Class \n'),
                  TextSpan(
                    text: seatDetail.trainCar.trainCarType,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Theme.of(context).accentColor),
                children: [
                  TextSpan(text: 'Coach \n'),
                  TextSpan(
                    text: seatDetail.trainCar.indexNumber.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Theme.of(context).accentColor),
                children: [
                  TextSpan(text: 'Seat \n'),
                  TextSpan(
                    text: seatDetail.seat.seatNo.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Theme.of(context).accentColor),
            children: [
              TextSpan(text: 'Price: '),
              TextSpan(
                text: '${seatDetail.seat.price.toString()}\$',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

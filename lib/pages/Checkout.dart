import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_01/models/ObjectPassenger.dart';
import 'package:ps3_01/models/SeatDetail.dart';
import 'package:ps3_01/providers/FilterRouteModel.dart';
import 'package:ps3_01/providers/FormCheckoutModal.dart';
import 'package:ps3_01/providers/NavigationModal.dart';
import 'package:ps3_01/providers/SeatDetailModel.dart';
import 'package:ps3_01/utils/Loading.dart';
import 'package:ps3_01/widgets/CustomAppBar.dart';
import 'package:ps3_01/widgets/ItemSeatCheckout.dart';
import 'package:url_launcher/url_launcher.dart';

class Checkout extends StatefulWidget {
  final Set<SeatDetail> seatsSelected;
  final FilterRouteModal filterRouteModal;
  final List<ObjectPassenger> objectPassengers;
  Checkout(this.seatsSelected, this.filterRouteModal, this.objectPassengers);
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  void initState() {
    Provider.of<FormCheckoutModal>(context, listen: false)
        .setInit(widget.seatsSelected, widget.objectPassengers?.first);
    super.initState();
  }

  void _createOrderSuccess() {
    Provider.of<SeatDetailModal>(context, listen: false).clear();
    Provider.of<NavigationModal>(context, listen: false)
        .changePage(context, '/tickets');
  }

  void _onSubmit() async {
    final formCheckoutModal =
        Provider.of<FormCheckoutModal>(context, listen: false);
    String dataJson = formCheckoutModal.validate();
    if (dataJson == null) {
      return;
    }
    var result =
        await Loading.show(context, formCheckoutModal.submit(dataJson));
    if (result != null) {
      try {
        await launch(result.replaceAll('"', ''));
      } catch (e) {
        print(e);
      }
    }
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create order successfull'),
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            )
          ],
        );
      },
    );
    _createOrderSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title: 'Checkout',
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Consumer<FormCheckoutModal>(
                  builder: (context, formCheckoutModal, child) {
                    return Form(
                      key: formCheckoutModal.formKey,
                      child: SingleChildScrollView(
                        child: MyFormItems(formCheckoutModal),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget MyFormItems(FormCheckoutModal formCheckoutModal) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16),
            hintText: "Name",
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please add name';
            }
            return null;
          },
          onSaved: (value) {
            Provider.of<FormCheckoutModal>(context, listen: false)
                .setName(value);
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16),
            hintText: "Email",
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            bool validEmail = validateEmail(value);
            return validEmail ? null : 'Not a valid email';
          },
          onSaved: (value) {
            Provider.of<FormCheckoutModal>(context, listen: false)
                .setEmail(value);
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16),
            hintText: "Phone",
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please add phone';
            }
            return null;
          },
          onSaved: (value) {
            Provider.of<FormCheckoutModal>(context, listen: false)
                .setPhone(value);
          },
        ),
        Divider()
      ]
        ..addAll(
          widget.seatsSelected.map((SeatDetail seatDetail) {
            return ItemPassengerCheckout(seatDetail, widget.objectPassengers);
          }).toList(),
        )
        ..add(Column(
          children: <Widget>[
            RadioListTile<int>(
              title: const Text('Pay later'),
              value: 1,
              groupValue: formCheckoutModal.typePayment,
              onChanged: (int value) {
                Provider.of<FormCheckoutModal>(context, listen: false)
                    .setTypePayment(value);
              },
            ),
            RadioListTile<int>(
              title: const Text('PayPal'),
              value: 2,
              groupValue: formCheckoutModal.typePayment,
              onChanged: (int value) {
                // setState(() {
                Provider.of<FormCheckoutModal>(context, listen: false)
                    .setTypePayment(value);
              },
            ),
          ],
        ))
        ..add(
          ButtonTheme(
            minWidth: MediaQuery.of(context).size.width * 0.8,
            height: 46,
            child: RaisedButton(
              onPressed: _onSubmit,
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
    );
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }
}

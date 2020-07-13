import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_01/models/ObjectPassenger.dart';
import 'package:ps3_01/models/SeatDetail.dart';
import 'package:ps3_01/pages/Checkout.dart';
import 'package:ps3_01/providers/FilterRouteModel.dart';
import 'package:ps3_01/providers/NavigationModal.dart';
import 'package:ps3_01/providers/ObjectPassengerModal.dart';
import 'package:ps3_01/providers/SeatDetailModel.dart';
import 'package:ps3_01/service/Global.dart';
import 'package:ps3_01/widgets/CartunitWidget.dart';
import 'package:ps3_01/widgets/CustomAppBar.dart';

class Carts extends StatelessWidget {
  void _handleClickBtnCheckout({
    BuildContext context,
    Set<SeatDetail> seatsSelected,
    List<ObjectPassenger> objectPassengers,
    FilterRouteModal filterRouteModal,
  }) {
    if (seatsSelected.length <= 0) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Nothing in the cart'),
        action: SnackBarAction(
          label: 'Find route',
          // textColor: ,
          onPressed: () {
            Provider.of<NavigationModal>(context, listen: false)
                .changePage(context, '/');
          },
        ),
      ));
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Checkout(
          seatsSelected,
          filterRouteModal,
          objectPassengers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            Consumer3<SeatDetailModal, FilterRouteModal, ObjectPassengerModal>(
          builder: (context, seatDetailModal, filterRouteModal,
              objectPassengerModal, child) {
            Set<SeatDetail> seatsSelected = seatDetailModal.seatsSelected;
            List<String> keys = seatsSelected.map((e) => e.key).toList();

            return Column(
              children: <Widget>[
                CustomAppBar(
                  title: 'Cart',
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: keys.length > 0
                        ? _listCart(seatsSelected, keys)
                        : Container(),
                  ),
                ),
                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  height: 46,
                  child: RaisedButton(
                    onPressed: () => _handleClickBtnCheckout(
                      context: context,
                      seatsSelected: seatsSelected,
                      filterRouteModal: filterRouteModal,
                      objectPassengers: objectPassengerModal.objectPassengers,
                    ),
                    child: Text(
                      'Checkout',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    color: Theme.of(context).accentColor,
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _listCart(Set<SeatDetail> seatsSelected, List<String> keys) {
    return FutureBuilder(
      future:
          Global.chosenSeats.where('__name__', whereIn: keys).getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        List<String> needDelete = [];
        Map<String, DateTime> timers = new Map();

        (snapshot.data.documents as List<DocumentSnapshot>).forEach((element) {
          DateTime expiredAt = element.data['expiredAt'].toDate();
          if (expiredAt.isBefore(DateTime.now())) {
            needDelete.add(element.documentID);
          }
          timers[element.documentID] = expiredAt;
        });

        if (needDelete.length > 0) {
          Provider.of<SeatDetailModal>(context).deleteMany(keys);
          Global.batchDelete(needDelete).then((value) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('${needDelete.length} seat expired!'),
            ));
          });
        }

        return ListView.builder(
          itemCount: seatsSelected.length,
          itemBuilder: (context, index) {
            SeatDetail seatDetail = seatsSelected.elementAt(index);
            return CartUnitWidget(seatDetail, timers[seatDetail.key]);
          },
        );
      },
    );
  }
}

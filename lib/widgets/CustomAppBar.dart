import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_01/pages/Carts.dart';
import 'package:ps3_01/providers/SeatDetailModel.dart';

class CustomAppBar extends StatelessWidget {
  final bool showCart;
  final String title;

  CustomAppBar({this.showCart = false, this.title = ''});
  @override
  Widget build(BuildContext context) {
    bool canPop = Navigator.of(context).canPop();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          canPop
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
              : Container(
                  width: 30,
                ),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          showCart
              ? Stack(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return Carts();
                          },
                        ));
                      },
                    ),
                    Consumer<SeatDetailModal>(
                      builder: (context, seatDetailModal, child) {
                        int count = seatDetailModal.seatsSelected.length;
                        return Positioned(
                          right: 10,
                          top: 10,
                          child: Visibility(
                            visible: count > 0,
                            child: Container(
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                count.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                )
              : Container(
                  width: 30,
                ),
        ],
      ),
    );
  }
}

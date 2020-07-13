import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ps3_01/models/RouteTrain.dart';
import 'package:ps3_01/providers/FilterRouteModel.dart';
import 'package:ps3_01/providers/RouteTrainModel.dart';
import 'package:ps3_01/widgets/AppBottomNavigationBar.dart';
import 'package:ps3_01/widgets/CustomAppBar.dart';
import 'package:ps3_01/widgets/RouteWidget.dart';

class ChooseRoute extends StatelessWidget {
  const ChooseRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: AppBottomNavigationBar(),
      body: SafeArea(
        child: Consumer2<RouteTrainModel, FilterRouteModal>(
          builder: (context, routeTrainModel, filterRouteModal, child) {
            return Column(
              children: <Widget>[
                CustomAppBar(
                  showCart: true,
                  title: 'Choose route',
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: routeTrainModel.routesTrain.length,
                    itemBuilder: (context, index) {
                      RouteTrain routeTrain =
                          routeTrainModel.routesTrain[index];
                      return RouteWidget(routeTrain);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// FlatButton(

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_01/pages/Carts.dart';
import 'package:ps3_01/pages/FindRoute.dart';
import 'package:ps3_01/pages/Tickets.dart';
import 'package:ps3_01/providers/FilterRouteModel.dart';
import 'package:ps3_01/providers/FormCheckoutModal.dart';
import 'package:ps3_01/providers/NavigationModal.dart';
import 'package:ps3_01/providers/ObjectPassengerModal.dart';
import 'package:ps3_01/providers/RouteTrainModel.dart';
import 'package:ps3_01/providers/SeatDetailModel.dart';
import 'package:ps3_01/providers/SeatModal.dart';
import 'package:ps3_01/providers/Station.dart';
import 'package:flutter/services.dart';
import 'package:ps3_01/providers/TrainCarModel.dart';

void main() => runApp(App());
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<NavigationModal>(
            create: (context) => NavigationModal(),
          ),
          ChangeNotifierProvider<FilterRouteModal>(
              create: (_) => FilterRouteModal()),
          ChangeNotifierProvider<RouteTrainModel>(
              create: (_) => RouteTrainModel()),
          ChangeNotifierProvider<TrainCarModel>(create: (_) => TrainCarModel()),
          ChangeNotifierProvider<SeatModel>(create: (_) => SeatModel()),
          ChangeNotifierProvider<SeatDetailModal>(
              create: (_) => SeatDetailModal()),
          ChangeNotifierProvider<FormCheckoutModal>(
            create: (context) => FormCheckoutModal(),
          ),
          FutureProvider<ObjectPassengerModal>(
            create: (context) => ObjectPassengerModal.fetchObjectPassengers(),
          ),
          FutureProvider<StationModel>(
            lazy: false,
            initialData: StationModel([]),
            create: (context) => StationModel.fetch(),
          )
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              // brightness: Brightness.light,
              accentColor: Color.fromRGBO(50, 70, 88, 1),
              primarySwatch: Colors.blueGrey,
            ),
            navigatorObservers: [routeObserver],
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return PageRouteBuilder(
                    pageBuilder: (_, __, ___) => FindRoute(),
                    transitionsBuilder: (_, anim, __, child) {
                      return FadeTransition(opacity: anim, child: child);
                    },
                  );
                case '/tickets':
                  return PageRouteBuilder(
                      pageBuilder: (_, __, ___) => Tickets(),
                      transitionsBuilder: (_, anim, __, child) {
                        return FadeTransition(opacity: anim, child: child);
                      });
                case '/carts':
                  return PageRouteBuilder(
                      pageBuilder: (_, __, ___) => Carts(),
                      transitionsBuilder: (_, anim, __, child) {
                        return FadeTransition(opacity: anim, child: child);
                      });
                default:
                  return MaterialPageRoute(
                      builder: (_) => Scaffold(
                            body: Center(
                                child: Text(
                                    'No route defined for ${settings.name}')),
                          ));
              }
            }));
  }
}

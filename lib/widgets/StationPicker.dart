import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_01/models/Station.dart';
import 'package:ps3_01/providers/FilterRouteModel.dart';
import 'package:ps3_01/providers/Station.dart';
import 'package:ps3_01/utils/cusom_color.dart';
import 'package:ps3_01/utils/custom_icon_icons.dart';

class StationPicker extends StatefulWidget {
  final bool isPickSource;
  // final void Function(Station) handlePick;
  StationPicker(this.isPickSource);
  @override
  _StationPickerState createState() => _StationPickerState();
}

class _StationPickerState extends State<StationPicker> {
  String searchValue = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.isPickSource ? 'From' : 'To',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_forward),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(14),
                  hintText: "Search station ...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Consumer<StationModel>(
                builder: (context, stationModel, child) {
                  List<Station> stations = stationModel.stations.where((e) {
                    bool check = e.name.toLowerCase().contains(
                          searchValue.toLowerCase(),
                        );
                    return check;
                  }).toList();
                  return ListView.builder(
                    itemCount: stations.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            // color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            CustomIcon.train_1,
                            color: Theme.of(context).accentColor,
                            size: 20,
                          ),
                        ),
                        title: Text('${stations[index].name}'),
                        onTap: () {
                          final filterRouteModal =
                              Provider.of<FilterRouteModal>(context,
                                  listen: false);
                          if (widget.isPickSource) {
                            filterRouteModal.setSource(stations[index]);
                          } else {
                            filterRouteModal.setDestination(stations[index]);
                          }
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

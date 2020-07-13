import 'package:flutter/material.dart';
import 'package:ps3_01/models/Ticket.dart';
import 'package:ps3_01/widgets/CustomAppBar.dart';

class TicketDetail extends StatelessWidget {
  final Ticket ticket;
  TicketDetail(this.ticket);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomAppBar(),
            Column(
              children: <Widget>[
                // Container(
                //   padding: EdgeInsets.all(20),
                //   child: Text(ticket.toJson().toString()),
                // ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Table(
                    children: [
                      _myRow('Code', ticket.code),
                      _myRow('Passenger', 'Passenger'),
                      _myRow('Object passenger ', ticket.objectPassengerName),
                      _myRow('From', ticket.sourceName),
                      _myRow('To', ticket.destinationName),
                      _myRow('Departure day', ticket.departureDay),
                      _myRow('Class', ticket.trainCartype),
                      _myRow('Coach', ticket.trainCarIndex.toString()),
                      _myRow('Seat', ticket.seatNumber.toString()),
                      _myRow('Price', ticket.price.toString()),
                      _myRow('Status', ticket.statusString),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _myRow(String key, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              key,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ),
        TableCell(
          child: Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

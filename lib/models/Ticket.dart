class Ticket {
  final int id;
  final String code;
  final int trainCarIndex;
  final String trainCartype;
  final int seatNumber;
  final String sourceName;
  final String destinationName;
  final int idObjectPassenger;
  final String objectPassengerName;
  final double price;
  final String departureDay;
  final StatusTicket status;

  Ticket(
      this.id,
      this.code,
      this.trainCarIndex,
      this.trainCartype,
      this.seatNumber,
      this.sourceName,
      this.destinationName,
      this.idObjectPassenger,
      this.objectPassengerName,
      this.departureDay,
      this.price,
      this.status);

  String get statusString {
    switch (status) {
      case StatusTicket.cancel:
        return 'Cancel';
      case StatusTicket.pending:
        return 'Pending';
      case StatusTicket.done:
        return 'Done';
      default:
        return '';
    }
  }

  Ticket.fromJson(Map<String, dynamic> json)
      : id = json['Id'] as int,
        code = json['Code'] as String,
        trainCarIndex = json['TrainCarIndex'] as int,
        trainCartype = json['TrainCartype'] as String,
        seatNumber = json['SeatNumber'] as int,
        sourceName = json['SourceName'] as String,
        destinationName = json['DestinationName'] as String,
        idObjectPassenger = json['IdObjectPassenger'] as int,
        objectPassengerName = json['ObjectPassengerName'] as String,
        departureDay = json['DepartureDay'] as String,
        price = json['Price'] as double,
        status = StatusTicketExtension.byInt(json['Status']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'trainCarIndex': trainCarIndex,
        'trainCartype': trainCartype,
        'seatNumber': seatNumber,
        'sourceName': sourceName,
        'destinationName': destinationName,
        'idObjectPassenger': idObjectPassenger,
        'objectPassengerName': objectPassengerName,
        'departureDay': departureDay,
        'price': price,
        'status': status,
      };
}

enum StatusTicket { cancel, pending, done }

extension StatusTicketExtension on StatusTicket {
  int get name {
    switch (this) {
      case StatusTicket.cancel:
        return 0;
      case StatusTicket.pending:
        return 1;
      case StatusTicket.done:
        return 2;
      default:
        return null;
    }
  }

  static StatusTicket byInt(int number) {
    switch (number) {
      case 0:
        return StatusTicket.cancel;
        break;
      case 1:
        return StatusTicket.pending;
        break;
      case 2:
        return StatusTicket.done;
        break;
      default:
        return null;
    }
  }
}

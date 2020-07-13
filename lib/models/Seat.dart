class Seat {
  final int id;
  final bool emptySeat;
  final int seatNo;
  final double price;

  Seat(this.id, this.seatNo, this.emptySeat, this.price);

  Seat.fromJson(Map<String, dynamic> json)
      : id = json['Id'] as int,
        emptySeat = json['EmptySeat'] as bool,
        seatNo = json['SeatNo'] as int,
        price = json['Price'] as double;
}

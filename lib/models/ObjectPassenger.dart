class ObjectPassenger {
  final int id;
  final String name;
  final int pricePercent;

  ObjectPassenger(this.id, this.name, this.pricePercent);

  ObjectPassenger.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        name = json['Name'],
        pricePercent = json['PricePercent'];
}

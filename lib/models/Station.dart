class Station {
  final int id;
  final String name;
  Station(this.id, this.name);
  Station.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        name = json['Name'];
}

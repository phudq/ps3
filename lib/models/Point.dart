class Point {
  final int id;
  final int arrivalTime;
  final String nameStation;
  final int distancePreStation;

  Point(this.id, this.arrivalTime, this.nameStation, this.distancePreStation);

  Point.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        arrivalTime = json['ArrivalTime'],
        nameStation = json['NameStation'],
        distancePreStation = json['DistancePreStation'];

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'arrivalTime': this.arrivalTime,
        'nameStation': this.nameStation,
        'distancePreStation': this.distancePreStation
      };
}

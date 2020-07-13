class TrainCar {
  final int id;
  final int indexNumber;
  final int idTrainCarType;
  final String trainCarType;
  TrainCar(this.id, this.indexNumber, this.idTrainCarType, this.trainCarType);

  bool isEq(TrainCar o) {
    return o != null && o.id == this.id;
  }

  TrainCar.fromJson(Map<String, dynamic> json)
      : id = json['Id'] as int,
        indexNumber = json['IndexNumber'] as int,
        idTrainCarType = json['IdTrainCarType'] as int,
        trainCarType = json['TrainCarType'] as String;
}

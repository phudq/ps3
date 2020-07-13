import 'package:ps3_01/models/Point.dart';

class RouteTrain {
  final int trainId;
  final String trainCode;
  final int travelTime;
  final int startIndex;
  final int endIndex;
  final List<Point> points;

  String get distanceString {
    int distanceTemp =
        points.skip(1).fold(0, (pre, e) => pre + e.distancePreStation);
    return (distanceTemp / 1000).round().toString();
  }

  String get startTime {
    Duration a = Duration(milliseconds: points.first?.arrivalTime);
    return formatTime(a);
  }

  String get endTime {
    Duration a = Duration(milliseconds: points.last?.arrivalTime);
    return formatTime(a);
  }

  String get travelTimeString {
    Duration duration = Duration(milliseconds: travelTime);
    String s = '';
    if (duration.inDays > 0) {
      s += duration.inDays.toString() + 'days ';
    }
    if (duration.inHours > 0) {
      s += duration.inHours.remainder(24).toString() + 'h ';
    }

    if (duration.inMinutes > 0) {
      s += duration.inMinutes.remainder(60).toString() + 'm';
    }
    return s;
  }

  String formatTime(Duration duration) {
    return [duration.inDays, duration.inHours, duration.inMinutes]
        .where((e) => e > 0)
        .map((seg) {
      return seg.remainder(60).toString().padLeft(2, '0');
    }).join(':');
  }

  RouteTrain(this.trainId, this.trainCode, this.startIndex, this.endIndex,
      this.travelTime, this.points);

  RouteTrain.fromJson(Map<String, dynamic> json)
      : trainId = json['TrainId'] as int,
        trainCode = json['TrainCode'] as String,
        startIndex = json['StartIndex'] as int,
        endIndex = json['EndIndex'] as int,
        travelTime = json['TravelTime'] as int,
        points = (json['Points'] as List)
            ?.map((e) =>
                e == null ? null : Point.fromJson(e as Map<String, dynamic>))
            .toList();
}

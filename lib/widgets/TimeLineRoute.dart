import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ps3_01/models/Point.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimeLineRoute extends StatelessWidget {
  final List<Point> points;
  TimeLineRoute(this.points);

  List<Step> get _steps {
    List<Step> steps = new List();
    for (var i = 0; i < points.length; i++) {
      Point current = points[i];
      steps.add(Step.A(current.nameStation, current.arrivalTime));

      if (points.asMap().containsKey(i + 1)) {
        Point next = points[i + 1];
        steps.add(Step.B(
            next.arrivalTime - current.arrivalTime, next.distancePreStation));
      }
    }
    return steps;
  }

  Color _getColor(bool isFirst, bool isLast) {
    if (isFirst) {
      return Colors.blue;
    } else if (isLast) {
      return Colors.blue;
    } else {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: _steps
            .asMap()
            .map(
              (i, Step step) {
                bool isFirst = i == 0;
                bool isLast = i == _steps.length - 1;
                return MapEntry(
                  i,
                  step.isStopPoint
                      ? CustomTimeLineTile(
                          isStopPoint: true,
                          isFirst: isFirst,
                          isLast: isLast,
                          leftChild: Text(
                            step.arrivalTime.toString(),
                            style:
                                TextStyle(fontSize: 12, color: Colors.black45),
                          ),
                          rightChild: Container(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(step.nameStation),
                          ),
                          color: _getColor(isFirst, isLast),
                        )
                      : CustomTimeLineTile(
                          isStopPoint: false,
                          rightChild: Container(
                            padding: EdgeInsets.all(4.0),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontStyle: FontStyle.italic),
                                children: [
                                  TextSpan(
                                    text: step.distance.toString() + ' ',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  TextSpan(
                                    text: 'km',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          leftChild: Container(
                            height: step.distance.toDouble() * 0.6,
                          ),
                        ),
                );
              },
            )
            .values
            .toList(),
      ),
    );
  }
}

class CustomTimeLineTile extends TimelineTile {
  final bool isStopPoint;
  final bool isFirst;
  final bool isLast;
  final Widget rightChild;
  final Widget leftChild;
  final Widget indicator;
  final Color color;

  CustomTimeLineTile({
    this.isStopPoint = false,
    this.rightChild,
    this.isFirst = false,
    this.isLast = false,
    this.leftChild,
    this.indicator,
    this.color = Colors.grey,
  }) : super(
          alignment: TimelineAlign.manual,
          hasIndicator: isStopPoint,
          isFirst: isFirst,
          isLast: isLast,
          indicatorStyle: IndicatorStyle(
            color: color,
            width: isFirst || isLast ? 16 : 10,
            indicator: indicator,
          ),
          lineX: 0.16,
          rightChild: rightChild,
          leftChild: leftChild,
          topLineStyle: LineStyle(
            color: Colors.black12,
            width: 2,
          ),
        );
}

class Step {
  bool isStopPoint;
  String nameStation;
  String arrivalTime;
  String travelTime;
  int distance;

  static String formatTime(int time) {
    Duration duration = Duration(milliseconds: time);
    return [duration.inDays, duration.inHours, duration.inMinutes]
        .where((e) => e > 0)
        .map((seg) {
      return seg.remainder(60).toString().padLeft(2, '0');
    }).join(':');
  }

  Step.A(this.nameStation, int arrivalTime)
      : isStopPoint = true,
        this.arrivalTime = formatTime(arrivalTime);

  Step.B(int travelTime, int distance)
      : isStopPoint = false,
        this.travelTime = formatTime(travelTime),
        this.distance = (distance / 1000).round();

  Map<String, dynamic> toJson() => {
        'isStopPoint': isStopPoint,
        'nameStation': nameStation,
        'arrivalTime': arrivalTime,
        'travelTime': travelTime,
        'distance': distance,
      };
}

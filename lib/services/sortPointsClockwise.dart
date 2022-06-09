import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SortPointsClockwise {
  static sortClockwise(List<LatLng> points) {
    Pair ptCenter = Pair(0, 0);
    for (var pt in points) {
      ptCenter.x += pt.longitude;
      ptCenter.y += pt.latitude;
    }
    ptCenter.x /= points.length;
    ptCenter.y /= points.length;
    for (int i = 0; i < points.length; i++) {
      points[i] = LatLng(points.elementAt(i).longitude - ptCenter.x, points.elementAt(i).latitude - ptCenter.y);
    }
    points.sort((pt1, pt2) {
      return _comparePoints(pt1, pt2);
    });
    for (int i = 0; i < points.length; i++) {
      points[i] = LatLng(points.elementAt(i).longitude + ptCenter.x, points.elementAt(i).latitude + ptCenter.y);
    }
    return points;
  }

  static int _comparePoints(LatLng pt1, LatLng pt2) {
    double angle1 = _getAngle(Pair(0, 0), pt1);
    double angle2 = _getAngle(Pair(0, 0), pt2);
    if (angle1 < angle2) {
      return 1;
    }
    double d1 = _getDistance(const LatLng(0, 0), pt1);
    double d2 = _getDistance(const LatLng(0, 0), pt2);
    if (angle1 == angle2 && d1 < d2) {
      return 1;
    }
    return 0;
  }

  static double _getAngle(Pair ptCenter, LatLng pt) {
    double x = pt.longitude - ptCenter.x;
    double y = pt.latitude - ptCenter.y;
    double angle = atan2(y, x);
    if (angle <= 0) {
      angle = 2 * pi + angle;
    }
    return angle;
  }

  static double _getDistance(LatLng pt1, LatLng pt2) {
    double x = pt1.longitude - pt2.longitude;
    double y = pt1.latitude - pt2.latitude;
    return sqrt(x * x + y * y);
  }
  
}

class Pair {
  double x;
  double y;

  Pair(this.x, this.y);

  @override
  String toString() => 'Pair[$x, $y]';
}
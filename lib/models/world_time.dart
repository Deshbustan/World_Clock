import 'package:intl/intl.dart';

class WorldTime {
  String location;
  String url;
  DateTime? dateTime;
  bool isDayTime = true;

  WorldTime({
    required this.location,
    required this.url,
    this.dateTime,
  });

  // This factory no longer needs to handle lat/lng
  factory WorldTime.fromZoneJson(Map<String, dynamic> json) {
    String url = json['zoneName'];
    String location = url.split('/').last.replaceAll('_', ' ');
    return WorldTime(location: location, url: url);
  }

  void updateTime(String formattedTimeString) {
    dateTime = DateTime.parse(formattedTimeString);
    isDayTime = (dateTime!.hour > 6 && dateTime!.hour < 20);
  }

  String get time {
    if (dateTime != null) {
      // We use a ticking clock on the home screen, so we need to update the time
      DateTime nowInZone = DateTime.now().toUtc().add(dateTime!.timeZoneOffset);
      return DateFormat.jm().format(nowInZone);
    }
    return 'Loading...';
  }
}
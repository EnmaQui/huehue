// ignore: file_names
class PlaceDayTimeModel {
  int day;
  String time;

  PlaceDayTimeModel({required this.day, required this.time});

  factory PlaceDayTimeModel.fromJson(Map<String, dynamic> json) {
    return PlaceDayTimeModel(
      day: json['day'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() => {
    'day': day,
    'time': time,
  };
}
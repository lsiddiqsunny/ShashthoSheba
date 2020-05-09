class Schedule {
  final String id;
  final int weekDay;
  final DateTime start;
  final DateTime end;
  final double fee;
  static Map<int, String> _map = {
    1:'Monday',
    2:'Tuesday',
    3:'Wednesday',
    4:'Thursday',
    5:'Friday',
    6:'Saturday',
    7:'Sunday'
  };

  Schedule({this.id, this.weekDay, this.start, this.end, this.fee});

  static double _parseDouble(dynamic value) {
    if (value is int) {
      return value + .0;
    }
    return value;
  }

  String get day => _map[weekDay];

  Schedule.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        weekDay = json['day'],
        start = DateTime.parse(json['time_start']),
        fee = _parseDouble(json['fee']),
        end = DateTime.parse(json['time_end']);
}

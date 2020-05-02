import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:collection';

import '../../models/schedule.dart';
import '../../api.dart' as api;

enum Status { loading, completed, error }

class ScheduleModel extends ChangeNotifier {
  List<Schedule> _schedules = [];
  Status _status = Status.loading;

  ScheduleModel(String mobileNo) {
    _fetchSchedules(mobileNo);
  }

  UnmodifiableListView<Schedule> get schedules => UnmodifiableListView(_schedules);

  Status get status => _status;

  bool toShow(int weekDay) {
    for (var index = 0; index < _schedules.length; index++) {
      if (_schedules[index].weekDay == weekDay) {
        return true;
      }
    }
    return false;
  }

  DateTime initialDate() {
    DateTime date = DateTime.now();
    while(!toShow(date.weekday)) {
      date = date.add(Duration(days:1));
    }
    return date;
  }

  List<Map<String, DateTime>> times(int weekDay) {
    List<Map<String, DateTime>> times = [];
    for (var index = 0; index < _schedules.length; index++) {
      if (_schedules[index].weekDay == weekDay) {
        times.add({
          'start': _schedules[index].start,
          'end': _schedules[index].end,
        });
      }
    }
    return times;
  }

  void _fetchSchedules(String mobileNo) async {
    if(_status != Status.loading) {
      _status = Status.loading;
      notifyListeners();
    }
    List<Schedule> newList = await _getList(mobileNo);
    _status = Status.completed;
    _schedules = newList;
    notifyListeners();
  }
}

Future<List<Schedule>> _getList(String mobileNo) async {
  http.Response response = await api.fetchSchedules({'mobile_no': mobileNo});
  if (response.statusCode == 200) {
    return compute(_parseSchedule, response.body);
  } else {
    print(response.statusCode);
    return [];
  }
}

List<Schedule> _parseSchedule(String responseBody) {
  final data = jsonDecode(responseBody);
  return data.map<Schedule>((json) {
    return Schedule.fromJson(json);
  }).toList();
}

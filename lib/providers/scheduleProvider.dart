import 'package:flutter/foundation.dart';
import 'dart:collection';

import '../models/schedule.dart';
import '../networking/api.dart' as api;

enum Status { loading, completed, error }

class ScheduleProvider extends ChangeNotifier {
  List<Schedule> _schedules = [];
  Status _status = Status.loading;
  String _mobileNo;

  ScheduleProvider(this._mobileNo) {
    // _fetchSchedules(mobileNo);
  }

  UnmodifiableListView<Schedule> get schedules =>
      UnmodifiableListView(_schedules);

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
    while (!toShow(date.weekday)) {
      date = date.add(Duration(days: 1));
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

  void fetchSchedules() async {
    if (_status != Status.loading) {
      _status = Status.loading;
      notifyListeners();
    }
    List<Schedule> newList = await _getList(_mobileNo);
    _status = Status.completed;
    _schedules = newList;
    notifyListeners();
  }
}

Future<List<Schedule>> _getList(String mobileNo) async {
  try {
    final data = await api.fetchSchedules(mobileNo);
    return data.map<Schedule>((json) {
      return Schedule.fromJson(json);
    }).toList();
  } catch (e) {
    print(e.toString());
    return [];
  }
}

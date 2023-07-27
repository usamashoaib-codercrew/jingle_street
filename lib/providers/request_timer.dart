import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  Map<String, int> timerMap = {};

  void startTimer(String itemId, int updatedAtInMillis) {
    if (!timerMap.containsKey(itemId)) {
      final updatedAtInSeconds = (updatedAtInMillis ~/ 1000).toInt();
      final currentTimeInSeconds = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();
      final timeDifference = currentTimeInSeconds - updatedAtInSeconds;

      if (timeDifference >= 60) {
        timerMap[itemId] = 0; // Timer already expired
        return;
      }

      timerMap[itemId] = 60 - timeDifference;

      Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (timerMap[itemId] == 0) {
          timer.cancel();
          // Call your function here when the timer reaches 0
        } else {
          timerMap[itemId] = (timerMap[itemId] ?? 0) - 1;
          notifyListeners();
        }
      });
    }
  }

  String getTimeString(String itemId) {
    final seconds = timerMap[itemId] ?? 0;
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}



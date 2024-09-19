import 'package:flutter/material.dart';

class MyDateTime {
  // Function to convert millisecondsSinceEpoch to formatted time string
  static String formatMilliseconds(BuildContext context, String milliseconds) {
    // Convert millisecondsSinceEpoch to DateTime
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(milliseconds));

    // Format the DateTime to a readable time string
    return TimeOfDay.fromDateTime(dateTime).format(context);
  }
}

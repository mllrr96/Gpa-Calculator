import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/course_model.dart';

extension ListCourseExtension on List<Course> {
  bool get shouldNotReset {
    return length == 1 &&
        this[0].credit == 0 &&
        (this[0].courseName == null || this[0].courseName!.isEmpty) &&
        this[0].grade == null;
  }
}

extension BuildContextExtension on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < 600;
  // bool get isDesktop => MediaQuery.of(this).size.width >= 1200;
  bool get isDarkMode =>
      MediaQuery.of(this).platformBrightness == Brightness.dark;

  Future<void> showGpaDialog(String gpa) async {
    await showDialog(
      context: this,
      builder: (context) {
        return AlertDialog(
          title: Text('GPA'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your GPA is $gpa'),
              TextButton(
                child: Icon(Icons.copy),
                onPressed: () {
                  final data = ClipboardData(text: gpa);
                  Clipboard.setData(data);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('GPA copied to clipboard'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> showConfirmResetDialog() async {
    bool result = false;
    await showDialog(
      context: this,
      builder: (context) {
        return AlertDialog(
          title: Text('Reset'),
          content: Text('Are you sure you want to reset?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                result = true;
              },
              child: Text('Reset', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
    return result;
  }

  void unfocus() => FocusScope.of(this).unfocus();
}

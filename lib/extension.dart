import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension BuildContextExtension on BuildContext {
  void showGpaDialog(String gpa) {
    showDialog(
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

  void unfocus() {
    FocusScope.of(this).unfocus();
  }
}

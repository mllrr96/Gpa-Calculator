import 'package:flutter/material.dart';
import 'package:gpa_calculator/models/course_model.dart';

import 'course_card.dart';

class DesktopWidget extends StatelessWidget {
  const DesktopWidget({super.key, required this.courses, required this.isMBA, this.onDelete});

  final List<Course> courses;
  final void Function(int)? onDelete;
  final bool isMBA;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: courses.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return CourseCard(
          courses[index],
          isMBA: isMBA,
          onDelete: () {
            onDelete?.call(index);
          },
        );
      },
    );
  }
}

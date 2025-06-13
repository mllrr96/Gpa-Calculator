import 'package:flutter/cupertino.dart';

import 'course_grade_enum.dart';

class Course {
  TextEditingController? courseNameController;
  String? courseName;
  int credit;
  CourseGrade? grade;

  Course({
    required this.courseName,
    required this.credit,
    required this.grade,
    required this.courseNameController,
  });

  Course.empty()
    : courseName = '',
      credit = 0,
      grade = null,
      courseNameController = TextEditingController();

  double totalPoints({bool isMBA = false}) {
    if (grade == null) return 0.0;
    final int credit = isMBA ? 2 : this.credit;
    return grade!.gradePoint * credit;
  }

  Map<String, dynamic> toJson() => {
    'courseName': courseName,
    'credit': credit,
    'grade': grade?.toString(),
  };

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    courseName: json['courseName'],
    credit: json['credit'],
    grade: CourseGrade.values.firstWhere(
      (g) => g.toString() == json['grade'],
      orElse: () => CourseGrade.A,
    ),
    courseNameController: TextEditingController(text: json['courseName']),
  );
}

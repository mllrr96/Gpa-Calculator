import 'course_grade_enum.dart';

class Course {
  String? courseName;
  int credit;
  CourseGrade? grade;

  Course({required this.courseName, required this.credit, required this.grade});

  Course.empty() : courseName = '', credit = 0, grade = null;

  double totalPoints({bool isMBA = false}) {
    if (grade == null) return 0.0;
    final int credit = isMBA ? 2 : this.credit;
    return grade!.gradePoint * credit;
  }
}

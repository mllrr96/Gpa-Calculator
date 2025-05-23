import 'course_grade_enum.dart';

class Course {
  String? courseName;
  int credit;
  CourseGrade? grade;

  Course({required this.courseName, required this.credit, required this.grade});

  Course.empty() : courseName = '', credit = 0, grade = null;

  double get totalPoints {
    if (grade == null) return 0.0;
    return grade!.gradePoint * credit;
  }
}

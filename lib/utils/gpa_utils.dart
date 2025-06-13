import 'package:gpa_calculator/models/course_model.dart';
import 'package:gpa_calculator/models/gpa_result.dart';

double calculateNewCGPA({
  required double currentCGPA,
  required int earnedCredits,
  required double newPoints,
  required double newCredits,
}) {
  final totalPoints = currentCGPA * earnedCredits + newPoints;
  final totalCredits = earnedCredits + newCredits;

  return totalPoints / totalCredits;
}

GpaResult calculateGpa(List<Course> courses, {required bool isMBA}) {
  double totalPoints = 0;
  double totalCredits = 0;

  for (var course in courses) {
    if ((course.credit == 0 && !isMBA) || course.grade == null) continue;
    final credits = isMBA ? 2 : course.credit;
    totalPoints += course.totalPoints(isMBA: isMBA);
    totalCredits += credits;
  }

  return GpaResult(totalPoints, totalCredits);
}

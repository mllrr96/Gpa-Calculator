import 'package:flutter_test/flutter_test.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:gpa_calculator/models/course_grade_enum.dart';
import 'package:gpa_calculator/utils/gpa_utils.dart';

void main() {
  group('GPA Calculation', () {
    test('UG: calculates totalPoints and GPA correctly', () {
      final courses = [
        // credit 3 and grade A = 3 * 4 = 12 points
        Course(
          courseName: 'Math',
          credit: 3,
          grade: CourseGrade.A,
          courseNameController: null,
        ),
        // credit 4 and grade B = 4 * 3 = 12 points
        Course(
          courseName: 'English',
          credit: 4,
          grade: CourseGrade.B,
          courseNameController: null,
        ),
        // credit 2 and grade C = 2 * 2 = 4 points
        Course(
          courseName: 'History',
          credit: 2,
          grade: CourseGrade.C,
          courseNameController: null,
        ),
      ];

      final result = calculateGpa(courses, isMBA: false);
      expect(result.totalCredits, 9);
      expect(result.totalPoints.toStringAsFixed(1), '28.0');
      expect(result.gpa.toStringAsFixed(2), '3.11');
    });

    test('MBA: fixed credit (2 per course)', () {
      final courses = [
        Course(
          courseName: 'Leadership',
          credit: 0,
          grade: CourseGrade.A,
          courseNameController: null,
        ),
        Course(
          courseName: 'Marketing',
          credit: 0,
          grade: CourseGrade.B,
          courseNameController: null,
        ),
        Course(
          courseName: 'Finance',
          credit: 0,
          grade: CourseGrade.C,
          courseNameController: null,
        ),
      ];

      final result = calculateGpa(courses, isMBA: true);
      expect(result.totalCredits, 6); // 3 courses * 2 credits each
      expect(result.totalPoints.toStringAsFixed(1), '18.0'); // (4+3+2)*2
      expect(result.gpa.toStringAsFixed(2), '3.00');
    });

    test('ignores null grades and UG courses with 0 credit', () {
      final courses = [
        Course(
          courseName: 'Null Grade',
          credit: 3,
          grade: null,
          courseNameController: null,
        ),
        Course(
          courseName: 'Zero Credit',
          credit: 0,
          grade: CourseGrade.A,
          courseNameController: null,
        ),
      ];

      final result = calculateGpa(courses, isMBA: false);
      expect(result.totalCredits, 0);
      expect(result.gpa.toStringAsFixed(2), '0.00');
    });

    test('GPA Calculation with all grade types (UG)', () {
      final grades = CourseGrade.values;
      final courses = grades.map((grade) {
        return Course(
          courseName: grade.displayName,
          credit: 1,
          grade: grade,
          courseNameController: null,
        );
      }).toList();

      final result = calculateGpa(courses, isMBA: false);

      final expectedPoints = grades.fold<double>(
        0,
            (sum, grade) => sum + grade.gradePoint,
      );

      expect(result.totalCredits, grades.length);
      expect(result.totalPoints.toStringAsFixed(2), expectedPoints.toStringAsFixed(2));
      expect(result.gpa.toStringAsFixed(2), (expectedPoints / grades.length).toStringAsFixed(2));
    });
  });
}

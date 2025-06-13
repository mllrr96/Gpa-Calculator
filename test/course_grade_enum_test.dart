import 'package:flutter_test/flutter_test.dart';
import 'package:gpa_calculator/models/course_grade_enum.dart';

void main() {
  group('CourseGrade', () {
    test('gradePoint values are correct', () {
      expect(CourseGrade.A.gradePoint, 4.0);
      expect(CourseGrade.aMinus.gradePoint, 3.7);
      expect(CourseGrade.bPlus.gradePoint, 3.3);
      expect(CourseGrade.B.gradePoint, 3.0);
      expect(CourseGrade.bMinus.gradePoint, 2.7);
      expect(CourseGrade.cPlus.gradePoint, 2.3);
      expect(CourseGrade.C.gradePoint, 2.0);
      expect(CourseGrade.cMinus.gradePoint, 1.7);
      expect(CourseGrade.dPlus.gradePoint, 1.3);
      expect(CourseGrade.D.gradePoint, 1.0);
      expect(CourseGrade.F.gradePoint, 0.0);
    });

    test('displayName values are correct', () {
      expect(CourseGrade.A.displayName, 'A');
      expect(CourseGrade.aMinus.displayName, 'A-');
      expect(CourseGrade.bPlus.displayName, 'B+');
      expect(CourseGrade.B.displayName, 'B');
      expect(CourseGrade.bMinus.displayName, 'B-');
      expect(CourseGrade.cPlus.displayName, 'C+');
      expect(CourseGrade.C.displayName, 'C');
      expect(CourseGrade.cMinus.displayName, 'C-');
      expect(CourseGrade.dPlus.displayName, 'D+');
      expect(CourseGrade.D.displayName, 'D');
      expect(CourseGrade.F.displayName, 'F');
    });
  });
}

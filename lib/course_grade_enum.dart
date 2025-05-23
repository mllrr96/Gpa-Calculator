enum CourseGrade {
  A,
  aMinus,
  bPlus,
  B,
  bMinus,
  cPlus,
  C,
  cMinus,
  dPlus,
  D,
  F;

  double get gradePoint {
    switch (this) {
      case CourseGrade.A:
        return 4.0;
      case CourseGrade.aMinus:
        return 3.7;
      case CourseGrade.bPlus:
        return 3.3;
      case CourseGrade.B:
        return 3.0;
      case CourseGrade.bMinus:
        return 2.7;
      case CourseGrade.cPlus:
        return 2.3;
      case CourseGrade.C:
        return 2.0;
      case CourseGrade.cMinus:
        return 1.7;
      case CourseGrade.dPlus:
        return 1.3;
      case CourseGrade.D:
        return 1.0;
      case CourseGrade.F:
        return 0.0;
    }
  }

  String get displayName {
    switch (this) {
      case CourseGrade.A:
        return 'A';
      case CourseGrade.aMinus:
        return 'A-';
      case CourseGrade.bPlus:
        return 'B+';
      case CourseGrade.B:
        return 'B';
      case CourseGrade.bMinus:
        return 'B-';
      case CourseGrade.cPlus:
        return 'C+';
      case CourseGrade.C:
        return 'C';
      case CourseGrade.cMinus:
        return 'C-';
      case CourseGrade.dPlus:
        return 'D+';
      case CourseGrade.D:
        return 'D';
      case CourseGrade.F:
        return 'F';
    }
  }
}

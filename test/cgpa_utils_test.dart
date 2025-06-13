import 'package:flutter_test/flutter_test.dart';
import 'package:gpa_calculator/utils/gpa_utils.dart';

void main() {
  group('calculateNewCGPA', () {
    test('calculates correctly with normal values', () {
      final result = calculateNewCGPA(
        currentCGPA: 3.5,
        earnedCredits: 40,
        newPoints: 36.0, // e.g., GPA = 3.0 with 12 credits
        newCredits: 12.0,
      );

      final expected = ((3.5 * 40) + 36.0) / (40 + 12);
      expect(result.toStringAsFixed(4), expected.toStringAsFixed(4));
    });

    test('returns correct value when currentCGPA is 0', () {
      final result = calculateNewCGPA(
        currentCGPA: 0.0,
        earnedCredits: 0,
        newPoints: 36.0,
        newCredits: 12.0,
      );

      expect(result, 3.0);
    });

    test('returns currentCGPA if no new points are added', () {
      final result = calculateNewCGPA(
        currentCGPA: 3.2,
        earnedCredits: 30,
        newPoints: 0.0,
        newCredits: 0.0,
      );

      expect(result, 3.2);
    });

    test('returns new GPA if there are no previous credits', () {
      final result = calculateNewCGPA(
        currentCGPA: 0.0,
        earnedCredits: 0,
        newPoints: 16.0,
        newCredits: 4.0,
      );

      expect(result, 4.0);
    });

    test('handles decimal precision correctly', () {
      final result = calculateNewCGPA(
        currentCGPA: 3.25,
        earnedCredits: 50,
        newPoints: 30.0,
        newCredits: 10.0,
      );

      expect(
        result.toStringAsFixed(2),
        ((3.25 * 50 + 30) / 60).toStringAsFixed(2),
      );
    });
  });
}

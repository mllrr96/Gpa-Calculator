class GpaResult {
  final double totalPoints;
  final double totalCredits;

  GpaResult(this.totalPoints, this.totalCredits);

  double get gpa => totalCredits == 0 ? 0 : totalPoints / totalCredits;
}
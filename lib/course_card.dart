import 'package:flutter/material.dart';
import 'package:gpa_calculator/course_model.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    this.onSelectCredit,
    this.onSelectGrade,
  });

  final Course course;
  final void Function(int)? onSelectCredit;
  final void Function(CourseGrade)? onSelectGrade;

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration = InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey),
      ),
    );
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    maxLength: 30,
                    onChanged: (val){
                      course.courseName = val;
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Course Name',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (course.totalPoints != 0)
                  Text(course.totalPoints.toStringAsFixed(2)),
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<int>(
                    decoration: decoration.copyWith(
                      labelText: 'Credit',
                      isDense: true,
                    ),
                    value: course.credit == 0 ? null : course.credit,
                    items:
                        List.generate(4, (index) => index + 1).map((
                          int credit,
                        ) {
                          return DropdownMenuItem<int>(
                            value: credit,
                            child: Text(credit.toString()),
                          );
                        }).toList(),
                    onChanged: (credit) {
                      if (credit == null) return;
                      onSelectCredit?.call(credit);
                    },
                  ),
                ),
                Flexible(child: SizedBox.shrink()),
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<CourseGrade>(
                    decoration: decoration.copyWith(
                      labelText: 'Grade',
                      isDense: true,
                    ),
                    value: course.grade,
                    items:
                        CourseGrade.values.map((CourseGrade grade) {
                          return DropdownMenuItem<CourseGrade>(
                            value: grade,
                            child: Text(grade.displayName),
                          );
                        }).toList(),
                    onChanged: (grade) {
                      if (grade == null) return;
                      onSelectGrade?.call(grade);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

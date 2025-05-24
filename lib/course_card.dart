import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gpa_calculator/course_model.dart';

import 'course_grade_enum.dart';

class CourseCard extends StatelessWidget {
  const CourseCard(this.course, {super.key, this.isMBA = false});

  final Course course;
  final bool isMBA;

  @override
  Widget build(BuildContext context) {
    const allowedMBA = {
      CourseGrade.A,
      CourseGrade.aMinus,
      CourseGrade.bPlus,
      CourseGrade.B,
      CourseGrade.bMinus,
      CourseGrade.cPlus,
      CourseGrade.C,
      CourseGrade.F,
    };

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
                    textCapitalization: TextCapitalization.words,
                    onChanged: (val) => course.courseName = val,
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Course Name',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (course.totalPoints(isMBA: isMBA) != 0)
                  Text(course.totalPoints(isMBA: isMBA).toStringAsFixed(2)),
              ],
            ),
          ),
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
                    value:
                        isMBA
                            ? 2
                            : course.credit == 0
                            ? null
                            : course.credit,
                    items:
                        List.generate(4, (index) => index + 1)
                            .map(
                              (int credit) => DropdownMenuItem<int>(
                                value: credit,
                                child: Text(credit.toString()),
                              ),
                            )
                            .toList(),
                    onChanged:
                        isMBA
                            ? null
                            : (credit) {
                              if (credit == null) return;
                              course.credit = credit;
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
                        CourseGrade.values
                            .where(
                              (grade) => !isMBA || allowedMBA.contains(grade),
                            ) // filter first
                            .map((CourseGrade grade) {
                              return DropdownMenuItem<CourseGrade>(
                                value: grade,
                                child: Text(grade.displayName),
                              );
                            })
                            .toList(),
                    onChanged: (grade) {
                      if (grade == null) return;
                      course.grade = grade;
                    },
                  ),
                ),
              ],
            ),
          ),
          Gap(12),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:gpa_calculator/utils/extension.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../models/course_grade_enum.dart';

class CourseCard extends StatelessWidget {
  const CourseCard(this.course, {super.key, this.isMBA = false, this.onDelete});

  final Course course;
  final bool isMBA;
  final void Function()? onDelete;

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
    return SizedBox(
      height: 110,
      child: Stack(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(
                mainAxisAlignment: !context.isMobile ? MainAxisAlignment.spaceEvenly: MainAxisAlignment.start,
                children: [
                  Row(
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
                  Flexible(
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
                                [1, 2, 3, 4, 6]
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
                ],
              ),
            ),
          ),
          if(!context.isMobile)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(LucideIcons.x),
              onPressed: onDelete,
            ),
          ),

        ],
      ),
    );
  }
}

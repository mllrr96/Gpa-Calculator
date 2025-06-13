import 'package:flutter/material.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:gpa_calculator/utils/extension.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(
                mainAxisAlignment:
                    !context.isMobile
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Skeleton.shade(
                          child: TextField(
                            autocorrect: false,
                            controller: course.courseNameController,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (val) => course.courseName = val,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              counterText: '',
                              hintText: 'Course Name',
                            ),
                          ),
                        ),
                      ),
                      if (course.totalPoints(isMBA: isMBA) != 0)
                        Text(
                          course.totalPoints(isMBA: isMBA).toStringAsFixed(2),
                        ),
                    ],
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Skeleton.shade(
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Credit',
                                isDense: context.isMobile,
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
                        ),
                        Flexible(child: SizedBox.shrink()),
                        Flexible(
                          flex: 2,
                          child: Skeleton.shade(
                            child: DropdownButtonFormField<CourseGrade>(
                              decoration: InputDecoration(
                                labelText: 'Grade',
                                isDense: context.isMobile,
                              ),
                              value: course.grade,
                              items:
                                  CourseGrade.values
                                      .where(
                                        (grade) =>
                                            !isMBA || allowedMBA.contains(grade),
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!context.isMobile)
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

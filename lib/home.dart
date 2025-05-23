import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gpa_calculator/course_card.dart';
import 'package:gpa_calculator/course_model.dart';
import 'package:gpa_calculator/extension.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Course> courses = [Course.empty()];

  void calculateGPA() {
    double totalPoints = 0;
    double totalCredits = 0;

    for (var course in courses) {
      if (course.credit == 0 || course.grade == null) continue;
      int credits = course.credit;
      totalPoints += course.totalPoints;
      totalCredits += credits;
    }

    if (totalCredits == 0) {
      return;
    }

    final gpa = (totalPoints / totalCredits).toStringAsFixed(2);

    context.showGpaDialog(gpa);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: context.unfocus,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          backgroundColor:
              isDarkMode
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary,
          title: Text(widget.title, style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              padding: EdgeInsets.all(16.0),
              icon: Icon(LucideIcons.info, color: Colors.white),
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'GPA Calculator',
                  applicationVersion: '1.0.0',
                  applicationIcon: Icon(LucideIcons.calculator),
                  children: [Text('This app helps you calculate your GPA.')],
                );
              },
            ),
          ],
        ),
        body: SlidableAutoCloseBehavior(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 150),
            itemCount: courses.length + 1,
            itemBuilder: (context, index) {
              if (index == courses.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SizedBox(
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          courses.add(Course.empty());
                        });
                      },
                      child: Icon(LucideIcons.plus, size: 30),
                    ),
                  ),
                );
              }
              final course = courses[index];

              return Slidable(
                key: ValueKey(index),
                endActionPane: ActionPane(
                  extentRatio: 0.25,
                  motion: const BehindMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        setState(() => courses.removeAt(index));
                      },
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.red,
                      icon: LucideIcons.trash2,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ],
                ),
                child: CourseCard(
                  course: course,
                  onSelectCredit: (credit) {
                    setState(() => courses[index].credit = credit);
                  },
                  onSelectGrade: (grade) {
                    setState(() => courses[index].grade = grade);
                  },
                ),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: 10),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                if (courses.length == 1 &&
                    courses[0].credit == 0 &&
                    courses[0].courseName == null &&
                    courses[0].grade == null) {
                  return;
                }
                // show dialog to confirm reset
                if (await context.showConfirmResetDialog()) {
                  courses.clear();
                  await Future.delayed(const Duration(milliseconds: 50));
                  courses.add(Course.empty());
                  if (context.mounted) {
                    context.unfocus();
                  }
                }
              },
              child: Icon(LucideIcons.rotateCcw),
            ),
            SizedBox(width: 10),
            FloatingActionButton.extended(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPressed: calculateGPA,
              tooltip: 'Calculate GPA',
              label: Text('Calculate', style: TextStyle(color: Colors.white)),
              icon: const Icon(LucideIcons.calculator, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

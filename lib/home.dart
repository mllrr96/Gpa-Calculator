import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:gpa_calculator/course_card.dart';
import 'package:gpa_calculator/course_model.dart';
import 'package:gpa_calculator/extension.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return GestureDetector(
      onTap: context.unfocus,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          backgroundColor:
              context.isDarkMode
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
                  applicationVersion: '1.0.1',
                  applicationIcon: Icon(
                    LucideIcons.calculator,
                    color: Color(0xFFC89601),
                  ),
                  children: [
                    Text('This app helps you calculate your GPA.'),
                    Divider(),
                    InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () {
                        try {
                          launchUrl(
                            Uri.parse(
                              'https://github.com/mllrr96/Gpa-Calculator',
                            ),
                          );
                        } catch (_) {}
                      },
                      child: Ink(
                        child: Row(
                          children: [
                            Lottie.asset(
                              context.isDarkMode
                                  ? 'assets/lottie/github-light.json'
                                  : 'assets/lottie/github-dark.json',
                              width: 40,
                              height: 40,
                            ),
                            Gap(10),
                            Flexible(
                              child: Text('Made with love by Mohammed Ragheb'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                        setState(() => courses.add(Course.empty()));
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
                      onPressed: (_) => setState(() => courses.removeAt(index)),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.red,
                      icon: LucideIcons.trash2,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ],
                ),
                child: CourseCard(course),
              );
            },
            separatorBuilder: (_, _) => const Gap(10),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                if (courses.shouldNotReset) {
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
            Gap(10),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:gpa_calculator/widgets/course_card.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:gpa_calculator/utils/extension.dart';
import 'package:gpa_calculator/widgets/info_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Course> courses = [Course.empty()];
  int selectedSegment = 0;

  bool get isMBA => selectedSegment == 1;

  void calculateGPA() {
    double totalPoints = 0;
    double totalCredits = 0;

    for (var course in courses) {
      if ((course.credit == 0 && !isMBA) || course.grade == null) continue;
      int credits = isMBA ? 2 : course.credit;
      totalPoints += course.totalPoints(isMBA: isMBA);
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
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.primary,
          title: Text('GPA Calculator', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              padding: EdgeInsets.all(16.0),
              icon: Icon(LucideIcons.info, color: Colors.white),
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'GPA Calculator',
                  applicationVersion: '1.0.2',
                  applicationIcon: Icon(
                    LucideIcons.calculator,
                    color: Color(0xFFC89601),
                  ),
                  children: [InfoWidget()],
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: SegmentedButton(
                expandedInsets: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                segments: <ButtonSegment>[
                  ButtonSegment(value: 0, label: Text('UG')),
                  ButtonSegment(value: 1, label: Text('MBA')),
                ],
                selected: {selectedSegment},
                onSelectionChanged: (newSelection) {
                  if (newSelection.isEmpty ||
                      selectedSegment == newSelection.first) {
                    return;
                  }
                  courses.clear();
                  courses.add(Course.empty());
                  selectedSegment = newSelection.first;
                  setState(() {});
                  context.unfocus();
                },
              ),
            ),
            Expanded(
              child: SlidableAutoCloseBehavior(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 150),
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
                            onPressed:
                                (_) => setState(() => courses.removeAt(index)),
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.red,
                            icon: LucideIcons.trash2,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ],
                      ),
                      child: CourseCard(course, isMBA: isMBA),
                    );
                  },
                  separatorBuilder: (_, _) => const Gap(10),
                ),
              ),
            ),
          ],
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
                if (courses.isEmpty || await context.showConfirmResetDialog()) {
                  courses.clear();
                  await Future.delayed(const Duration(milliseconds: 50));
                  courses.add(Course.empty());
                  if (context.mounted) {
                    context.unfocus();
                  }
                  setState(() {});
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

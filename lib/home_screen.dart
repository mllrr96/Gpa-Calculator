import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:gpa_calculator/result_screen.dart';
import 'package:gpa_calculator/utils/app_constant.dart';
import 'package:gpa_calculator/utils/gpa_utils.dart';
import 'package:gpa_calculator/widgets/course_card.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:gpa_calculator/utils/extension.dart';
import 'package:gpa_calculator/widgets/desktop_buttons.dart';
import 'package:gpa_calculator/widgets/desktop_widget.dart';
import 'package:gpa_calculator/widgets/info_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Course> courses = [Course.empty()];
  int selectedSegment = 0;

  bool get isMBA => selectedSegment == 1;
  bool loading = false;

  Future<void> calculateGPA() async {
    final result = calculateGpa(courses, isMBA: isMBA);

    if (result.totalCredits == 0) {
      return;
    }

    await saveCoursesAndMode(courses, isMBA);

    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder:
              (context) => ResultScreen(
                totalPoints: result.totalPoints,
                totalCredits: result.totalCredits,
              ),
        ),
      );
    }
  }

  Future<void> clearCourses() async {
    if (courses.shouldNotReset) {
      return;
    }
    // show dialog to confirm reset
    if (courses.isEmpty || await context.showConfirmResetDialog()) {
      for (var course in courses) {
        course.courseNameController?.dispose();
      }
      try {
        final pref = await SharedPreferences.getInstance();
        pref.remove(AppConstant.savedCoursesKey);
      } catch (_) {}
      // Clear saved courses and mode
      courses.clear();
      await Future.delayed(const Duration(milliseconds: 50));
      courses.add(Course.empty());
      if (mounted) {
        context.unfocus();
      }
      setState(() {});
    }
  }

  void addCourse() {
    setState(() => courses.add(Course.empty()));
  }

  void showInfoDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'GPA Calculator',
      applicationVersion: '1.0.4',
      applicationIcon: Icon(LucideIcons.calculator, color: Color(0xFFC89601)),
      children: [InfoWidget()],
    );
  }

  Future<void> saveCoursesAndMode(List<Course> courses, bool isMBA) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save course list
      final courseList = courses.map((course) => course.toJson()).toList();
      final encodedCourses = jsonEncode(courseList);
      await prefs.setString(AppConstant.savedCoursesKey, encodedCourses);

      // Save mode
      await prefs.setBool(AppConstant.isMBAKey, isMBA);
    } catch (_) {}
  }

  Future<void> loadCoursesAndMode() async {
    try {
      setState(() => loading = true);
      final prefs = await SharedPreferences.getInstance();

      // Load courses
      final encoded = prefs.getString(AppConstant.savedCoursesKey);
      List<Course> courses = [];
      if (encoded != null) {
        final List<dynamic> decoded = jsonDecode(encoded);
        courses = decoded.map((json) => Course.fromJson(json)).toList();
      }

      // Load mode
      final isMBA = prefs.getBool(AppConstant.isMBAKey) ?? false;
      if (courses.isEmpty && !isMBA) {
        setState(() => loading = false);
        return;
      }

      this.courses = courses.isNotEmpty ? courses : [Course.empty()];
      selectedSegment = isMBA ? 1 : 0;
      setState(() => loading = false);
    } catch (_) {}
  }

  @override
  void initState() {
    // Load saved courses and mode
    loadCoursesAndMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.unfocus,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: !context.isMobile,
          surfaceTintColor: Colors.transparent,
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
            if (context.isMobile)
              IconButton(
                padding: EdgeInsets.all(16.0),
                icon: Icon(LucideIcons.info, color: Colors.white),
                onPressed: showInfoDialog,
              ),
          ],
        ),
        body: Skeletonizer(
          enabled: loading,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  SizedBox(
                    width: context.isMobile ? double.infinity : 500,
                    child: Skeleton.shade(
                      child: SegmentedButton(
                        expandedInsets: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        segments: <ButtonSegment>[
                          ButtonSegment(value: 0, label: Text('UG')),
                          ButtonSegment(value: 1, label: Text('MBA')),
                        ],
                        style: ButtonStyle(
                          padding:
                              context.isMobile
                                  ? null
                                  : WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 30,
                                    ),
                                  ),
                        ),
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
                  ),
                  if (!context.isMobile)
                    Expanded(
                      child: DesktopWidget(
                        courses: courses,
                        isMBA: isMBA,
                        onDelete: (index) {
                          setState(() => courses.removeAt(index));
                        },
                      ),
                    ),
                  if (context.isMobile)
                    Expanded(
                      child: SlidableAutoCloseBehavior(
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 150),
                          itemCount: courses.length + 1,
                          itemBuilder: (context, index) {
                            if (index == courses.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                child: SizedBox(
                                  height: 70,
                                  child: Tooltip(
                                    message: 'Add Course',
                                    child: ElevatedButton(
                                      onPressed: addCourse,
                                      child: Icon(LucideIcons.plus, size: 30),
                                    ),
                                  ),
                                ),
                              );
                            }
                            final course = courses[index];

                            return Slidable(
                              key: ValueKey(course.courseNameController),
                              endActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const BehindMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) {
                                      course.courseNameController?.dispose();
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
                                key: ValueKey(course.courseNameController),
                                course,
                                isMBA: isMBA,
                              ),
                            );
                          },
                          separatorBuilder: (_, _) => const Gap(10),
                        ),
                      ),
                    ),
                  if (!context.isMobile)
                    DesktopButtons(
                      onAddCourse: addCourse,
                      onClearCourses: clearCourses,
                      onCalculateGPA: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        await calculateGPA();
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton:
            context.isMobile
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: 'addCourse',
                      onPressed: clearCourses,
                      tooltip: 'Clear Courses',
                      foregroundColor: context.isDarkMode ? null : Colors.black,
                      child: Icon(LucideIcons.rotateCcw),
                    ),
                    Gap(10),
                    FloatingActionButton.extended(
                      // heroTag: 'calculateGPA',
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        await calculateGPA();
                      },
                      tooltip: 'Calculate GPA',
                      label: Text('Calculate'),
                      icon: const Icon(
                        LucideIcons.calculator,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
                : FloatingActionButton(
                  onPressed: showInfoDialog,
                  child: Icon(LucideIcons.info),
                ),
      ),
    );
  }
}

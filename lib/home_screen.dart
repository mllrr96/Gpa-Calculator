import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:gpa_calculator/database.dart';
import 'package:gpa_calculator/result_screen.dart';
import 'package:gpa_calculator/utils/app_constant.dart';
import 'package:gpa_calculator/utils/gpa_utils.dart';
import 'package:gpa_calculator/widgets/course_card.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:gpa_calculator/utils/extension.dart';
import 'package:gpa_calculator/widgets/desktop_buttons.dart';
import 'package:gpa_calculator/widgets/desktop_widget.dart';
import 'package:gpa_calculator/widgets/home_fab.dart';
import 'package:gpa_calculator/widgets/info_widget.dart';
import 'package:gpa_calculator/widgets/ug_mba_segmented_button.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final DatabaseRepository dbRepo;
  List<Course> ugCourses = [Course.empty()];
  List<Course> mbaCourses = [Course.empty()];

  List<Course> get courses => isMBA ? mbaCourses : ugCourses;
  int selectedSegment = 0;

  bool get isMBA => selectedSegment == 1;
  bool loading = false;

  Future<void> calculateGPA() async {
    final result = GpaUtils.calculateGpa(courses, isMBA: isMBA);

    if (result.totalCredits == 0) {
      return;
    }

    await saveCourses(courses, isMBA);

    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder:
              (context) => ResultScreen(
                totalPoints: result.totalPoints,
                totalCredits: result.totalCredits,
                isMBA: isMBA,
              ),
        ),
      );
    }
  }

  Future<void> clearCourses() async {
    if (isMBA ? courses.shouldNotReset : courses.shouldNotReset) {
      return;
    }
    // show dialog to confirm reset
    if (courses.isEmpty || await context.showConfirmResetDialog()) {
      for (var course in courses) {
        course.courseNameController?.dispose();
      }
      dbRepo.remove(AppConstant.savedCoursesKey);
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
    setState(
      () =>
          isMBA
              ? mbaCourses.add(Course.empty())
              : ugCourses.add(Course.empty()),
    );
  }

  void showInfoDialog() {
    showAboutDialog(
      context: context,
      applicationName: AppConstant.appName,
      applicationVersion: AppConstant.appVersion,
      applicationIcon: Icon(LucideIcons.calculator, color: Color(0xFFC89601)),
      children: [InfoWidget()],
    );
  }

  Future<void> saveCourses(List<Course> courses, bool isMBA) async {
    final courseList = courses.map((course) => course.toJson()).toList();
    final encodedCourses = jsonEncode(courseList);
    await dbRepo.set<String>(
      isMBA ? AppConstant.savedMbaCoursesKey : AppConstant.savedCoursesKey,
      encodedCourses,
    );
  }

  Future<void> saveMode(bool isMBA) async =>
      await dbRepo.set<bool>(AppConstant.isMBAKey, isMBA);

  Future<void> loadCoursesAndMode() async {
    setState(() => loading = true);

    // Load courses
    final encodedCourses = dbRepo.get<String>(AppConstant.savedCoursesKey);
    final encodedMbaCourses = dbRepo.get<String>(
      AppConstant.savedMbaCoursesKey,
    );
    List<Course> courses = [];
    List<Course> mbaCourses = [];

    if (encodedCourses != null) {
      final List<dynamic> decoded = jsonDecode(encodedCourses);
      courses = decoded.map((json) => Course.fromJson(json)).toList();
    }
    if (encodedMbaCourses != null) {
      final List<dynamic> decoded = jsonDecode(encodedMbaCourses);
      mbaCourses = decoded.map((json) => Course.fromJson(json)).toList();
    }

    // Load mode
    final isMBA = dbRepo.get<bool>(AppConstant.isMBAKey) ?? false;
    if (courses.isEmpty && !isMBA) {
      setState(() => loading = false);
      return;
    }

    ugCourses = courses.isNotEmpty ? courses : [Course.empty()];
    this.mbaCourses = mbaCourses.isNotEmpty ? mbaCourses : [Course.empty()];
    selectedSegment = isMBA ? 1 : 0;
    setState(() => loading = false);
  }

  Future<void> initDb() async {
    dbRepo = DatabaseRepository(await SharedPreferences.getInstance());
  }

  @override
  void initState() {
    initDb().then((_) {
      loadCoursesAndMode();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: context.unfocus,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: !context.isMobile,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: theme.scaffoldBackgroundColor,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          backgroundColor:
              context.isDarkMode
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.primary,
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
                      child: UgMbaSegmentedButton(
                        selectedSegment: selectedSegment,
                        onSegmentSelected: (newSelection) {
                          if (newSelection.isEmpty ||
                              selectedSegment == newSelection.first) {
                            return;
                          }
                          selectedSegment = newSelection.first;
                          setState(() {});
                          saveMode(newSelection.first == 1);
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
        floatingActionButton: HomeFab(
          clearCourses: clearCourses,
          calculateGPA: calculateGPA,
        ),
      ),
    );
  }
}

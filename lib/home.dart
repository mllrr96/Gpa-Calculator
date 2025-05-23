import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gpa_calculator/course_model.dart';
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
      double credits = course.credit.toDouble();
      totalPoints += course.totalPoints;
      totalCredits += credits;
    }

    if (totalCredits == 0) {
      return;
    }

    final gpa = (totalPoints / totalCredits).toStringAsFixed(2);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('GPA'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your GPA is $gpa'),
              TextButton(
                child: Icon(Icons.copy),
                onPressed: () {
                  final data = ClipboardData(text: gpa);
                  Clipboard.setData(data);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('GPA copied to clipboard'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
            // padding: const EdgeInsets.symmetric(
            //   horizontal: 24.0,
            //   vertical: 18.0,
            // ),
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
                        setState(() {
                          courses.removeAt(index);
                        });
                      },
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.red,
                      icon: LucideIcons.trash2,
                      // label: '',
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ],
                ),
                child: Card(
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
                                value:
                                    course.credit == 0 ? null : course.credit,
                                // hint: Text('Credit'),
                                items:
                                    List.generate(4, (index) => index + 1).map((
                                      int credit,
                                    ) {
                                      return DropdownMenuItem<int>(
                                        value: credit,
                                        child: Text(credit.toString()),
                                      );
                                    }).toList(),
                                onChanged: (newValue) {
                                  if (newValue == null) return;
                                  setState(() {
                                    course.credit = newValue;
                                  });
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
                                onChanged: (newValue) {
                                  if (newValue == null) return;
                                  setState(() {
                                    course.grade = newValue;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: 10),
          ),
        ),
        floatingActionButton: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              // backgroundColor: isDarkMode ? null : Theme.of(context).colorScheme.primary,
              onPressed: () {
                if (courses.length == 1 &&
                    courses[0].credit == 0 &&
                    courses[0].grade == null) {
                  return;
                }

                // show dialog to confirm reset
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Reset'),
                      content: Text('Are you sure you want to reset?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              courses = [Course.empty()];
                            });
                            FocusScope.of(context).unfocus();
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(LucideIcons.rotateCcw),
            ),
            SizedBox(width: 10),
            FloatingActionButton.extended(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPressed: calculateGPA,
              tooltip: 'Increment',
              label: Text('Calculate', style: TextStyle(color: Colors.white)),
              icon: const Icon(LucideIcons.calculator, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

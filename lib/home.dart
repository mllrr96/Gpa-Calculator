import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gpa_calculator/course_model.dart';

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
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(widget.title, style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              padding: EdgeInsets.all(16.0),
              icon: Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'GPA Calculator',
                  applicationVersion: '1.0.0',
                  applicationIcon: Icon(Icons.calculate_outlined),
                  children: [Text('This app helps you calculate your GPA.')],
                );
              },
            ),
          ],
        ),
        body: SlidableAutoCloseBehavior(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 18.0,
            ),
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
                      child: Icon(Icons.add, size: 30),
                    ),
                  ),
                );
              }
              final course = courses[index];

              return Slidable(
                key: ValueKey(index),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        setState(() {
                          courses.removeAt(index);
                        });
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_forever_outlined,
                      label: 'Delete',
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
              onPressed: () {
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
              child: Icon(Icons.restart_alt),
            ),
            SizedBox(width: 10),
            FloatingActionButton.extended(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPressed: calculateGPA,
              tooltip: 'Increment',
              label: Text('Calculate', style: TextStyle(color: Colors.white)),
              icon: const Icon(Icons.calculate_outlined, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

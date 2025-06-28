import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gpa_calculator/utils/app_constant.dart';
import 'package:gpa_calculator/utils/extension.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'info_widget.dart';

class HomeFab extends StatelessWidget {
  const HomeFab({
    super.key,
    required this.clearCourses,
    required this.calculateGPA,
  });

  final void Function() clearCourses;
  final void Function() calculateGPA;

  @override
  Widget build(BuildContext context) {
    return context.isMobile
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
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPressed: calculateGPA,
              tooltip: 'Calculate GPA',
              label: Text('Calculate'),
              icon: const Icon(LucideIcons.calculator, color: Colors.white),
            ),
          ],
        )
        : FloatingActionButton(
          onPressed: () {
            showAboutDialog(
              context: context,
              applicationName: AppConstant.appName,
              applicationVersion: AppConstant.appVersion,
              applicationIcon: Icon(
                LucideIcons.calculator,
                color: Color(0xFFC89601),
              ),
              children: [InfoWidget()],
            );
          },
          child: Icon(LucideIcons.info),
        );
  }
}

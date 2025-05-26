import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DesktopButtons extends StatelessWidget {
  const DesktopButtons({super.key, required this.onAddCourse, required this.onClearCourses, required this.onCalculateGPA});
  final void Function() onAddCourse;
  final void Function() onClearCourses;
  final void Function() onCalculateGPA;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          SizedBox(
            height: 70,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAddCourse,
              icon: const Icon(Icons.add),
              label: const Text('Add Course', style: TextStyle(fontSize:  20),),
            ),
          ),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onClearCourses,
                    child: const Icon(LucideIcons.rotateCcw, size: 24),
                    // label: const Text('Clear Courses'),
                  ),
                ),
              ),
              const Gap(10),
              Flexible(
                flex: 2,
                child: SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onCalculateGPA,
                    icon: const Icon(LucideIcons.calculator),
                    label: const Text('Calculate GPA', style: TextStyle(fontSize:  20),),
                  ),
                ),
              ),
            ],
          ),
          const Gap(40),
        ],
      ),
    );
  }
}

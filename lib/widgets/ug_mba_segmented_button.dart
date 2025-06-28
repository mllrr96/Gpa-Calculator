import 'package:flutter/material.dart';
import 'package:gpa_calculator/utils/extension.dart';
import 'package:lucide_icons/lucide_icons.dart';

class UgMbaSegmentedButton extends StatelessWidget {
  const UgMbaSegmentedButton({
    super.key,
    required this.selectedSegment,
    required this.onSegmentSelected,
  });

  final int selectedSegment;
  final void Function(Set<int>) onSegmentSelected;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      showSelectedIcon: false,
      expandedInsets: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      segments: <ButtonSegment<int>>[
        ButtonSegment(
          value: 0,
          label: Text('UG'),
          icon: Icon(LucideIcons.graduationCap),
          tooltip: 'Undergraduate',
        ),
        ButtonSegment(
          value: 1,
          label: Text('MBA'),
          icon: Icon(LucideIcons.briefcase),
          tooltip: 'MBA',
        ),
      ],
      style: ButtonStyle(
        padding:
            context.isMobile
                ? null
                : WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                ),
      ),
      selected: {selectedSegment},
      onSelectionChanged: onSegmentSelected,
    );
  }
}

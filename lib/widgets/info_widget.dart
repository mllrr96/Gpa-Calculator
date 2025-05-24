import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gpa_calculator/utils/extension.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('This app helps AUIS students calculate their GPA.'),
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
            padding:  const EdgeInsets.all(8.0),
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
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gpa_calculator/utils/app_constant.dart';
import 'package:gpa_calculator/utils/extension.dart';
import 'package:gpa_calculator/widgets/copy_button.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.totalPoints,
    required this.totalCredits,
  });

  final double totalPoints;

  final double totalCredits;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final cgpaCtrl = TextEditingController();
  final earnedCreditsCtrl = TextEditingController();
  late String gpa;
  String? cGPA;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    gpa = (widget.totalPoints / widget.totalCredits).toStringAsFixed(2);
    loadSavedData();
    super.initState();
  }

  @override
  void dispose() {
    cgpaCtrl.dispose();
    earnedCreditsCtrl.dispose();
    super.dispose();
  }

  Future<void> loadSavedData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      double? savedCGPA = prefs.getDouble(AppConstant.currentCGPAKey);
      int? savedCredits = prefs.getInt(AppConstant.earnedCreditsKey);
      if (savedCGPA != null && savedCredits != null) {
        cgpaCtrl.text = savedCGPA.toString();
        earnedCreditsCtrl.text = savedCredits.toString();
        calculateCGPA();
      }
    } catch (_) {}
  }

  Future<void> calculateCGPA() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final cgpa = double.tryParse(cgpaCtrl.text);
    final earnedCredits = int.tryParse(earnedCreditsCtrl.text);

    if (cgpa == null || earnedCredits == null || earnedCredits <= 0) {
      setState(() {
        cGPA = 'Invalid input';
      });
      return;
    }

    final totalPoints = cgpa * earnedCredits + widget.totalPoints;
    final totalCredits = earnedCredits + widget.totalCredits;

    setState(() {
      cGPA = (totalPoints / totalCredits).toStringAsFixed(2);
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(AppConstant.currentCGPAKey, cgpa);
      await prefs.setInt(AppConstant.earnedCreditsKey, earnedCredits);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          context.isDarkMode
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
      child: GestureDetector(
        onTap: context.unfocus,
        child: Scaffold(
          floatingActionButtonLocation:
              context.isMobile
                  ? null
                  : FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: calculateCGPA,
            label: Text('Calculate CGPA'),
            icon: const Icon(LucideIcons.calculator, size: 20),
          ),
          resizeToAvoidBottomInset: false,
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 0, 0),
                      child: Row(
                        children: [
                          IconButton(
                            padding: const EdgeInsets.all(16.0),
                            icon: const Icon(LucideIcons.x, size: 24),
                            onPressed: () {
                              ScaffoldMessenger.of(
                                context,
                              ).removeCurrentSnackBar();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: IconButton(
                                padding: const EdgeInsets.all(16.0),
                                icon: Icon(LucideIcons.copy),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: gpa));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('GPA copied to clipboard'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Gap(14),
                              const Text(
                                'Your GPA is:',
                                style: TextStyle(fontSize: 24),
                              ),
                              const Gap(14),
                              Text(
                                gpa, // Replace with actual GPA calculation
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 0),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              const Gap(14),
                              Text(
                                'Calculate CGPA',
                                style: TextStyle(fontSize: 24),
                              ),
                              Gap(24),
                              Form(
                                key: formKey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          controller: cgpaCtrl,
                                          decoration: InputDecoration(
                                            isDense: context.isMobile,
                                            labelText: 'Current CGPA',
                                            suffixIcon: CopyButton(
                                              AppConstant.cGPAInfoMessage,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return '';
                                            }
                                            final cgpa = double.tryParse(value);
                                            if (cgpa == null ||
                                                cgpa < 0 ||
                                                cgpa > 4.0) {
                                              return 'Please enter a valid CGPA';
                                            }
                                            return null;
                                          },
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                decimal: true,
                                              ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d{0,2}'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(12),
                                      Flexible(
                                        child: TextFormField(
                                          controller: earnedCreditsCtrl,
                                          decoration: InputDecoration(
                                            isDense: context.isMobile,
                                            labelText: 'Earned credits',
                                            suffixIcon: CopyButton(
                                              AppConstant
                                                  .earnedCreditsInfoMessage,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return '';
                                            }
                                            return null;
                                          },
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (cGPA != null)
                            Expanded(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(16.0),
                                        icon: Icon(LucideIcons.copy),
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(text: gpa),
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'CGPA copied to clipboard',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Your new CGPA is:',
                                        style: TextStyle(fontSize: 24),
                                      ),
                                      const Gap(14),
                                      Text(
                                        cGPA!,
                                        style: const TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (context.isMobile) Gap(25),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

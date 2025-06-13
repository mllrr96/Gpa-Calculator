import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gpa_calculator/utils/app_constant.dart';
import 'package:gpa_calculator/utils/extension.dart';
import 'package:gpa_calculator/utils/gpa_utils.dart';
import 'package:gpa_calculator/widgets/info_button.dart';
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
  bool showCGPA = false;

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
      }
    } catch (_) {}
  }

  Future<void> calculateCGPA() async {
    bool skipValidation = false;
    if (!showCGPA) {
      skipValidation = true;
      setState(() => showCGPA = true);
    }
    if (!skipValidation) {
      if (!formKey.currentState!.validate()) {
        return;
      }
    }
    final cgpa = double.tryParse(cgpaCtrl.text);
    final earnedCredits = int.tryParse(earnedCreditsCtrl.text);

    if (cgpa == null || earnedCredits == null || earnedCredits <= 0) {
      return;
    }

    final newCGPA = calculateNewCGPA(
      currentCGPA: cgpa,
      earnedCredits: earnedCredits,
      newPoints: widget.totalPoints,
      newCredits: widget.totalCredits,
    );

    setState(() {
      cGPA = newCGPA.toStringAsFixed(2);
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
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: context.unfocus,
        child: Scaffold(
          floatingActionButtonLocation:
              context.isMobile
                  ? null
                  : FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor:
                context.isDarkMode
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.primary,
            onPressed: calculateCGPA,
            label: Text('Calculate CGPA'),
            icon: const Icon(LucideIcons.calculator, size: 20),
          ),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              'GPA Result',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            backgroundColor:
                context.isDarkMode
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.primary,
            leading: IconButton(
              padding: const EdgeInsets.all(16.0),
              icon: const Icon(LucideIcons.x, size: 24, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Builder(
            builder: (context) {
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            height:
                                showCGPA
                                    ? context.usableBodyHeight * 0.3
                                    : context.usableBodyHeight,
                            child: CurrentGpaWidget(gpa: gpa),
                          ),
                          AnimatedSize(
                            duration: Duration(milliseconds: 400),
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: showCGPA ? 1.0 : 0.0,
                              child: Form(
                                key: formKey,
                                child: SizedBox(
                                  height: context.usableBodyHeight * 0.7,
                                  child: CgpaWidget(
                                    cgpaCtrl: cgpaCtrl,
                                    earnedCreditsCtrl: earnedCreditsCtrl,
                                    cGPA: cGPA,
                                    gpa: gpa,
                                    height: context.usableBodyHeight * 0.7,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // if (context.isMobile) Gap(25),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CgpaWidget extends StatelessWidget {
  const CgpaWidget({
    super.key,
    required this.cgpaCtrl,
    required this.earnedCreditsCtrl,
    required this.cGPA,
    required this.gpa,
    required this.height,
  });

  final TextEditingController cgpaCtrl;
  final TextEditingController earnedCreditsCtrl;
  final String? cGPA;
  final String gpa;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        children: [
          Divider(height: 0),
          Column(
            children: [
              const Gap(14),
              Text('Calculate CGPA', style: TextStyle(fontSize: 24)),
              Gap(24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: cgpaCtrl,
                        decoration: InputDecoration(
                          isDense: context.isMobile,
                          labelText: 'Current CGPA',
                          suffixIcon: InfoButton(AppConstant.cGPAInfoMessage),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          final cgpa = double.tryParse(value);
                          if (cgpa == null || cgpa < 0 || cgpa > 4.0) {
                            return 'Please enter a valid CGPA';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(
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
                          suffixIcon: InfoButton(
                            AppConstant.earnedCreditsInfoMessage,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (cGPA != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Your new CGPA is:',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Gap(14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(16)),
                        Text(
                          cGPA!,
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          padding: const EdgeInsets.all(16.0),
                          icon: Icon(LucideIcons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: gpa));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('CGPA copied to clipboard'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Gap(40),
        ],
      ),
    );
  }
}

class CurrentGpaWidget extends StatelessWidget {
  const CurrentGpaWidget({super.key, required this.gpa});

  final String gpa;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Gap(14),
        const Text('Current semester GPA is:', style: TextStyle(fontSize: 24)),
        const Gap(14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.all(16)),
            Text(
              gpa, // Replace with actual GPA calculation
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            IconButton(
              padding: const EdgeInsets.all(16.0),
              icon: Icon(LucideIcons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: gpa));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('GPA copied to clipboard')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

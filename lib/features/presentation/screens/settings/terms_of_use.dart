import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/material.dart';

class TermsOfUseScreen extends ConsumerStatefulWidget {
  final String title;
  final String summery;
  const TermsOfUseScreen(
      {super.key, required this.title, required this.summery});

  @override
  ConsumerState<TermsOfUseScreen> createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends ConsumerState<TermsOfUseScreen> {
  @override
  Widget build(BuildContext context) {
    final plainText = appFunctions.parseHtmlToPlainText(widget.summery);
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title, //tr("terms_of_use"),
        isBack: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 90.h),
              Text(
                plainText,
                style:
                    TextStyle(fontSize: 11.8.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 90.h),
            ],
          ),
        ),
      ),
    );
  }
}

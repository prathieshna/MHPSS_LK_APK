import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/material.dart';

class SignupScreen extends ConsumerStatefulWidget {
  final bool isBack;
  const SignupScreen({super.key, this.isBack = true});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.textBlueColor,
    );
  }
}

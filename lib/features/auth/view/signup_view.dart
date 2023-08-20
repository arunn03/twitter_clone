import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/auth/widgets/widgets.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/theme/theme.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpView(),
      );

  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() {
    return _SignUpViewState();
  }
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final _appBar = UIConstants.appBar();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void onSignUp() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      ref.read(authControllerProvider.notifier).signup(
            email: _email,
            password: _password,
            context: context,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: _appBar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Twitter Sign Up',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: 32,
                                  ),
                        ),
                        const SizedBox(height: 40),
                        AuthField(
                          hintText: 'Email Address',
                          inputType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                        const SizedBox(height: 24),
                        AuthField(
                          hintText: 'Password',
                          hideText: true,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.length < 6) {
                              return 'Password must be at least 6 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.centerRight,
                          child: RoundedSmallButton(
                            label: 'Done',
                            onTap: onSignUp,
                            backgroundColor: Pallete.whiteColor,
                            textColor: Pallete.backgroundColor,
                          ),
                        ),
                        const SizedBox(height: 40),
                        RichText(
                          text: TextSpan(
                            text: 'Already have an account?',
                            style: const TextStyle(fontSize: 16),
                            children: [
                              TextSpan(
                                text: ' Login',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Pallete.blueColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pop(context);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

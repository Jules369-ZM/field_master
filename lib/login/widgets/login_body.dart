import 'package:field_master/login/cubit/cubit.dart';
import 'package:field_master/register/register.dart';
import 'package:field_master/utils/utils.dart';
import 'package:field_master/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template login_body}
/// Body of the LoginPage.
///
/// Add what it does
/// {@endtemplate}
class LoginBody extends StatefulWidget {
  /// {@macro login_body}
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _formKey = GlobalKey<FormState>();
  final password = TextEditingController();
  final _email = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      _email.text = 'jaiemfiv@gmail.com';
      password.text = 'password@1';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state.status == CurrentStatus.error) {
          await EasyLoadingService.error(text: state.message);
        }
        if (state.status == CurrentStatus.success && state.message.isNotEmpty) {
          await EasyLoadingService.success(text: state.message);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Form(
            key: _formKey,
            child: AppListViewPage(
              paddingVertical: 0,
              children: [
                // displayLogoPng(width: double.maxFinite, height: 100),
                const SizedBox(height: 16),
                const Text(
                  'Welcome',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                ),
                const SizedBox(height: 16),
                Text(
                  'Login to continue',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 32),
                buildFeildHeader('Email'),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _email,
                  textInputAction: TextInputAction.next,
                  validator: (value) => validateTxtFiled(value: value),
                  decoration: kTextFieldDecoration,
                ),
                const SizedBox(height: 16),
                buildFeildHeader('Password'),
                PasswordField(password),
                const SizedBox(height: 32),
                if (state.status == CurrentStatus.loading)
                  const LoadingButton()
                else
                  PrimaryButton(
                    title: 'Login',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        FocusManager.instance.primaryFocus!.unfocus();
                        context.read<LoginCubit>().signInWithEmailAndPassword(
                              _email.text.toLowerCase(),
                              password.text,
                            );
                      }
                    },
                  ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Dont have an account?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        RegisterPage.route(),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

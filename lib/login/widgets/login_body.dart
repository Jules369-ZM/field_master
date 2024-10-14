import 'package:field_master/login/cubit/cubit.dart';
import 'package:field_master/register/register.dart';
import 'package:field_master/utils/utils.dart';
import 'package:field_master/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template login_body}
/// Body of the LoginPage.
///
/// Updated design with consistent spacing and Material 3 components.
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),
                    Center(
                      child: Text(
                        'Welcome Back!',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Align(
                      child: Image.asset(
                        'assets/field_master.png',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Login to continue',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                            ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      textInputAction: TextInputAction.next,
                      validator: (value) => validateTxtFiled(value: value),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 16),
                    PasswordField(password),
                    const SizedBox(height: 24),
                    if (state.status == CurrentStatus.loading)
                      const Center(child: CircularProgressIndicator())
                    else
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              context
                                  .read<LoginCubit>()
                                  .signInWithEmailAndPassword(
                                    _email.text.toLowerCase(),
                                    password.text,
                                  );
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
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
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import '../cubit/cubit.dart';
import '../widgets/widgets.dart';

/// {@template register_page}
/// A description for RegisterPage
/// {@endtemplate}
class RegisterPage extends StatelessWidget {
  /// {@macro register_page}
  const RegisterPage({super.key});

  /// The static route for RegisterPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(
        repo: context.read(),
        sRepo: context.read(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: const RegisterView(),
      ),
    );
  }
}

/// {@template register_view}
/// Displays the Body of RegisterView
/// {@endtemplate}
class RegisterView extends StatelessWidget {
  /// {@macro register_view}
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterBody();
  }
}

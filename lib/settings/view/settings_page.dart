import 'package:flutter/material.dart';
import 'package:field_master/settings/cubit/cubit.dart';
import 'package:field_master/settings/widgets/settings_body_new.dart';

/// {@template settings_page}
/// A description for SettingsPage
/// {@endtemplate}
class SettingsPage extends StatelessWidget {
  /// {@macro settings_page}
  const SettingsPage({super.key});

  /// The static route for SettingsPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const SettingsPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(context.read(), context.read()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: const SettingsView(),
      ),
    );
  }
}

/// {@template settings_view}
/// Displays the Body of SettingsView
/// {@endtemplate}
class SettingsView extends StatelessWidget {
  /// {@macro settings_view}
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsScreen();
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:field_master/auth/authentication.dart';
import 'package:field_master/home/home.dart';
import 'package:field_master/main/cubit/cubit.dart';
import 'package:field_master/settings/view/settings_page.dart';
import 'package:field_master/stats/stats.dart';
import 'package:field_master/utils/cubit/firebase_cubit.dart';

/// {@template main_body}
/// Body of the MainPage.
///
/// Add what it does
/// {@endtemplate}
class MainBody extends StatefulWidget {
  /// {@macro main_body}
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const StatsPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    getToken();
    appCheck.onTokenChange.listen(setEventToken);
    super.initState();
  }

  Future<void> getToken() async {
    try {
      if (cachedAppCheckToken != null) {
        // return cachedAppCheckToken;
      } else {
        cachedAppCheckToken = await appCheck.getToken(true);
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  void setMessage(String message0) {
    if (mounted) {
      setState(() {
        message = message0;
      });
    }
  }

  void setEventToken(String? token) {
    if (mounted) {
      setState(() {
        eventToken = token ?? 'not yet';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthBloc>().state;
    return SafeArea(
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          return Scaffold(
            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: 'Statistics',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          );
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    // Update the state when a tab is tapped
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}

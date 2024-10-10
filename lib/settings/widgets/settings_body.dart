import 'package:flutter/material.dart';
import 'package:field_master/auth/authentication.dart';
import 'package:field_master/settings/cubit/cubit.dart';
import 'package:field_master/utils/size_config.dart';

/// {@template settings_body}
/// Body of the SettingsPage.
///
/// Add what it does
/// {@endtemplate}
class SettingsBody extends StatelessWidget {
  /// {@macro settings_body}
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(12),
            ),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              ListTile(
                dense: true,
                onTap: () async {
                  await showDialog<dynamic>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('Would you like to logout?'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  ).then((value) {
                    if (value != null) {
                      if (value == true) {
                        context
                            .read<AuthBloc>()
                            .add(AuthenticationLogoutRequested());
                      }
                    }
                  });
                },
                leading: const Icon(Icons.logout),
                title: const Text('Log out'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:field_master/auth/bloc/auth_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  String _defaultCategory = 'Electrical';

  final List<String> _languages = ['English', 'Spanish', 'French'];
  final List<String> _categories = ['Electrical', 'Plumbing', 'IT Support'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            _buildProfileSection(),
            const Divider(),
            _buildNotificationSettings(),
            const Divider(),
            _buildLanguageSettings(),
            const Divider(),
            _buildCategorySettings(),
            const Divider(),
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
                      if (context.mounted) {
                        context
                            .read<AuthBloc>()
                            .add(AuthenticationLogoutRequested());
                      }
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
      ),
    );
  }

  /// Build the user profile section
  Widget _buildProfileSection() {
    return ListTile(
      title: const Text('Profile'),
      subtitle: const Text('Manage your profile'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Navigate to profile management screen
      },
    );
  }

  /// Build the notification settings section
  Widget _buildNotificationSettings() {
    return SwitchListTile(
      title: const Text('Enable Notifications'),
      subtitle:
          const Text('Receive notifications for service requests and updates'),
      value: _notificationsEnabled,
      onChanged: (bool value) {
        setState(() {
          _notificationsEnabled = value;
        });
      },
    );
  }

  /// Build the language settings section
  Widget _buildLanguageSettings() {
    return ListTile(
      title: const Text('Language'),
      subtitle: const Text('Select app language'),
      trailing: DropdownButton<String>(
        value: _selectedLanguage,
        items: _languages.map((String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Text(language),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedLanguage = newValue!;
          });
        },
      ),
    );
  }

  /// Build the default service category settings section
  Widget _buildCategorySettings() {
    return ListTile(
      title: const Text('Default Service Category'),
      subtitle: const Text('Set the default category for new service requests'),
      trailing: DropdownButton<String>(
        value: _defaultCategory,
        items: _categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _defaultCategory = newValue!;
          });
        },
      ),
    );
  }
}

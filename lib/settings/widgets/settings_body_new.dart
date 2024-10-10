import 'package:field_master/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            _buildSectionDivider(),
            _buildNotificationSettings(),
            _buildSectionDivider(),
            _buildLanguageSettings(),
            _buildSectionDivider(),
            _buildCategorySettings(),
            _buildSectionDivider(),
            _buildLogoutTile(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return const Divider(
      thickness: 1,
      color: Colors.grey,
    );
  }

  /// Build the user profile section with enhanced visual styling
  Widget _buildProfileSection() {
    return ListTile(
      title: const Text(
        'Profile',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text('Manage your profile'),
      trailing: const Icon(Icons.arrow_forward_ios),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      onTap: () {
        // Navigate to profile management screen
      },
    );
  }

  /// Build the notification settings section with modern UI
  Widget _buildNotificationSettings() {
    return SwitchListTile(
      title: const Text(
        'Enable Notifications',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle:
          const Text('Receive notifications for service requests and updates'),
      value: _notificationsEnabled,
      onChanged: (bool value) {
        setState(() {
          _notificationsEnabled = value;
        });
      },
      activeColor: Theme.of(context).colorScheme.primary,
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  /// Build the language settings section with enhanced DropdownButton styling
  Widget _buildLanguageSettings() {
    return ListTile(
      title: const Text(
        'Language',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
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
        borderRadius: BorderRadius.circular(12),
        dropdownColor: Theme.of(context).colorScheme.surface,
      ),
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  /// Build the default service category settings section
  Widget _buildCategorySettings() {
    return ListTile(
      title: const Text(
        'Default Service Category',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
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
        borderRadius: BorderRadius.circular(12),
        dropdownColor: Theme.of(context).colorScheme.surface,
      ),
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  /// Build the logout tile with modern UI components and an AlertDialog
  Widget _buildLogoutTile(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: () async {
        await _showLogoutDialog(context);
      },
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Log out'),
      trailing: const Icon(Icons.arrow_forward_ios),
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: false, // user must tap button
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
      if (value != null && value == true && context.mounted) {
        context.read<AuthBloc>().add(AuthenticationLogoutRequested());
      }
    });
  }
}

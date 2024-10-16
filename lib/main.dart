import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  bool _areNotificationsEnabled = true;
  Locale _locale = Locale('en');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Settings Page',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      locale: _locale,
      home: SettingsPage(
        isDarkMode: _isDarkMode,
        areNotificationsEnabled: _areNotificationsEnabled,
        onThemeChanged: (bool value) {
          setState(() {
            _isDarkMode = value;
          });
        },
        onLanguageChanged: (Locale locale) {
          setState(() {
            _locale = locale;
          });
        },
        onNotificationsChanged: (bool value) {
          setState(() {
            _areNotificationsEnabled = value;
          });
        },
        onLogout: () {
          SystemNavigator.pop();
        },
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final bool areNotificationsEnabled;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<Locale> onLanguageChanged;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback onLogout;

  SettingsPage({
    required this.isDarkMode,
    required this.areNotificationsEnabled,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.onNotificationsChanged,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Account'),
            subtitle: Text('Privacy, security, and account info'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text('Manage notification settings'),
            trailing: Switch(
              value: areNotificationsEnabled,
              onChanged: onNotificationsChanged,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('Select your preferred language'),
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          SwitchListTile(
            value: isDarkMode,
            onChanged: onThemeChanged,
            title: Text('Dark Mode'),
            secondary: Icon(Icons.dark_mode),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Support'),
            subtitle: Text('FAQs, contact us'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final List<Locale> locales = [
      Locale('en', ''),
      Locale('ar', ''),
      Locale('fr', ''),
      Locale('es', ''),
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: locales.map((Locale locale) {
                return ListTile(
                  title: Text(locale.languageCode == 'en'
                      ? 'English'
                      : locale.languageCode == 'ar'
                      ? 'العربية'
                      : locale.languageCode == 'fr'
                      ? 'Français'
                      : 'Español'),
                  onTap: () {
                    onLanguageChanged(locale);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                onLogout();
              },
            ),
          ],
        );
      },
    );
  }
}

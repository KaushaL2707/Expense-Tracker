import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/mock_data.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';
import 'package:exp/provider/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Profile Section
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: const AssetImage('assets/images/user.png'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    mockUser.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mockUser.email,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Edit Profile Logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Settings Section
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.dark_mode,
                        color: Theme.of(context).iconTheme.color),
                    title: Text(
                      'Dark Mode',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Switch(
                      value: Provider.of<ThemeProvider>(context).isDarkMode,
                      onChanged: (value) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme();
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Divider(color: Theme.of(context).dividerColor, height: 1),
                  ListTile(
                    leading: Icon(Icons.notifications,
                        color: Theme.of(context).iconTheme.color),
                    title: Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Icon(Icons.chevron_right,
                        color: Theme.of(context).iconTheme.color),
                    onTap: () {},
                  ),
                  Divider(color: Theme.of(context).dividerColor, height: 1),
                  ListTile(
                    leading: Icon(Icons.security,
                        color: Theme.of(context).iconTheme.color),
                    title: Text(
                      'Privacy & Security',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Icon(Icons.chevron_right,
                        color: Theme.of(context).iconTheme.color),
                    onTap: () {},
                  ),
                  Divider(color: Theme.of(context).dividerColor, height: 1),
                  ListTile(
                    leading: Icon(Icons.help,
                        color: Theme.of(context).iconTheme.color),
                    title: Text(
                      'Help & Support',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Icon(Icons.chevron_right,
                        color: Theme.of(context).iconTheme.color),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  // Navigate back to Login Screen
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

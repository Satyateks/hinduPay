import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/theme_controller.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class ProfilePage extends StatelessWidget {
  // final User user; // Login ya Session se mila hua User model

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;
    // ThemeController ko Provider ya GetIt ke zariye access karein
    // Yeh depend karta hai aapne ThemeController ko kaise provide kiya hai (jaise Provider.of<ThemeController>(context))
    final themeController = context
        .watch<ThemeController>(); // Agar Provider use kar rahe hain

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- User Data Display Section ---
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  user!.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Name'),
              subtitle: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Mobile Number'),
              subtitle: Text(
                user.mobile,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),

            // --- Theme Change Section ---
            const Text(
              'App Theme Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Themes ke liye options
            DropdownButtonFormField<AppThemeMode>(
              value: themeController.themeMode,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: AppThemeMode.values.map((AppThemeMode mode) {
                return DropdownMenuItem<AppThemeMode>(
                  value: mode,
                  child: Text(mode.name.toUpperCase()), // light, dark, orange
                );
              }).toList(),
              onChanged: (AppThemeMode? newMode) {
                if (newMode != null) {
                  themeController.setTheme(newMode);
                }
              },
            ),

            const Spacer(),

            // Logout Button (Agar chaho toh)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSection extends StatelessWidget {
  const _ThemeSection();

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ...AppThemeMode.values.map((theme) {
              return RadioListTile<AppThemeMode>(
                value: theme,
                groupValue: themeController.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    themeController.setTheme(value);
                  }
                },
                title: Text(_themeName(theme)),
                secondary: Icon(_themeIcon(theme)),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _themeName(AppThemeMode theme) {
    switch (theme) {
      case AppThemeMode.light:
        return 'Light';

      case AppThemeMode.dark:
        return 'Dark';

      case AppThemeMode.orange:
        return 'Orange';
    }
  }

  IconData _themeIcon(AppThemeMode theme) {
    switch (theme) {
      case AppThemeMode.light:
        return Icons.light_mode;

      case AppThemeMode.dark:
        return Icons.dark_mode;

      case AppThemeMode.orange:
        return Icons.palette;
    }
  }
}


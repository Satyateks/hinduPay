import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/theme_controller.dart';
import '../../../features/auth/domain/entities/user.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_event.dart';

class ProfilePage extends StatelessWidget {
  final User user; // Login ya Session se mila hua User model

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // ThemeController ko Provider ya GetIt ke zariye access karein
    // Yeh depend karta hai aapne ThemeController ko kaise provide kiya hai (jaise Provider.of<ThemeController>(context))
    final themeController = context.watch<ThemeController>(); // Agar Provider use kar rahe hain

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
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
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Name'),
              subtitle: Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Mobile Number'),
              subtitle: Text(user.mobile, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            )

          ],
        ),
      ),
    );
  }
}



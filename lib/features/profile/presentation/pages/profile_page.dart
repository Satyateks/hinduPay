import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/theme_controller.dart';
import '../../../../core/di/injection.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_header.dart';

/*class ProfilePage extends StatelessWidget {
  // final User user; // Login ya Session se mila hua User model

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user  = context.read<AuthBloc>().state.user;
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
                  user!.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
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
*/

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => ProfileBloc(getUserProfile: context.read<GetUserProfile>())..add(LoadProfile()),
//       child: const _ProfileView(),
//     );
//   }
// }

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.red.shade400,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<ProfileBloc>().add(
                          GetProfileDetailsEvent(),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ProfileLoaded) {
            final user = state.user;

            final fullName = '${user.firstName} ${user.lastName}'.trim();

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(RefreshProfileEvent());

                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Profile Image
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 52,
                            backgroundColor: Colors.grey.shade100,
                            backgroundImage:
                                user.image != null && user.image!.isNotEmpty
                                ? NetworkImage(user.image!)
                                : null,
                            child: user.image == null || user.image!.isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: 55,
                                    color: Colors.grey.shade400,
                                  )
                                : null,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Name
                        Text(
                          fullName.isEmpty ? 'User' : fullName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Email
                        Text(
                          user.email,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  // Personal Information Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _ProfileInfoTile(
                          icon: Icons.person_outline,
                          title: 'Full Name',
                          value: fullName,
                        ),

                        const Divider(height: 1, indent: 70, endIndent: 16),

                        _ProfileInfoTile(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          value: user.email,
                        ),

                        const Divider(height: 1, indent: 70, endIndent: 16),

                        _ProfileInfoTile(
                          icon: Icons.phone_outlined,
                          title: 'Mobile',
                          value: user.phone,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Account Section
                  const Text(
                    'Account',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 4,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.edit_outlined,
                              color: Colors.blue.shade600,
                            ),
                          ),
                          title: const Text(
                            'Edit Profile',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text(
                            'Update your personal information',
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            // TODO: Navigate to edit profile
                          },
                        ),

                        const Divider(height: 1, indent: 70, endIndent: 16),

                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 4,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.lock_outline,
                              color: Colors.orange.shade600,
                            ),
                          ),
                          title: const Text(
                            'Change Password',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text('Update your account password'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                          },
                        ),
                      const _ThemeSection(), ],
                    ),
                  ),

                  // const SizedBox(height: 30),
                ],
              ),
            );
          }

          return const Center(child: Text('No profile data available'));
        },
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          value.isEmpty ? 'Not available' : value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return Center(child: Text(state.message));
          }

          if (state is ProfileLoaded) {
            final user = state.user;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(RefreshProfile());
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ProfileHeader(
                    name: user.firstName,
                    email: user.email,
                    imageUrl: user.image,
                  ),

                  const SizedBox(height: 24),

                  const _ThemeSection(),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ThemeSection extends StatelessWidget {
  const _ThemeSection();

  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();

    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return ListTile(
          leading: const Icon(
            Icons.palette_outlined,
          ),
          title: const Text('Theme'),
          subtitle: Text(
            _themeName(themeController.themeMode),
          ),
          trailing: const Icon(
            Icons.chevron_right,
          ),
          onTap: () {
            _showThemeSelector(
              context,
              themeController,
            );
          },
        );
      },
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

  void _showThemeSelector(
    BuildContext context,
    ThemeController themeController,
  ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Choose Theme',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ...AppThemeMode.values.map(
                (theme) {
                  final selected =
                      themeController.themeMode == theme;

                  return ListTile(
                    leading: Icon(
                      _themeIcon(theme),
                    ),
                    title: Text(
                      _themeName(theme),
                    ),
                    trailing: selected
                        ? const Icon(
                            Icons.check_circle,
                          )
                        : null,
                    onTap: () async {
                      await themeController.setTheme(
                        theme,
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
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

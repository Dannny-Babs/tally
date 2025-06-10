// settings_screen.dart
//
// This file implements a plug-and-play SettingsScreen for your app, matching the provided mockup and requirements.
//
// Structure:
// - One large Column inside SafeArea, wrapped in SingleChildScrollView with horizontal/vertical padding.
// - Profile header at the top: avatar, name, email, and "Edit profile" button.
// - Two card containers: "Accounts" (Savings, Gifts) and "Preferences" (Push notifications, Face ID, PIN Code, Logout).
// - Each card uses AppColors for background, border, and shadow, and AppTextStyles for all text.
// - All toggles and navigation are managed via BLoC (AccountsBloc, PreferencesBloc, AuthBloc). Minimal event/state classes are included below.
// - BottomNavigationBar at the bottom, using AppColors for background and icon colors.
// - All tap targets are at least 44x44 px, and the layout is responsive (max width 400 on large screens).
//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'bloc/accounts/accounts.dart';
import 'bloc/preferences/preferences.dart';
import 'repositories/repositories.dart';
import 'widgets/pin_code_modal.dart';

// --- BLoC Event/State Definitions ---
// Minimal event/state classes for demonstration. Replace with your actual implementations as needed.

// AuthBloc
abstract class AuthEvent {}

class LogoutRequested extends AuthEvent {}

class AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState());
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    // Implement logout logic
    yield state;
  }
}

// --- SettingsScreen Widget ---
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AccountsBloc(
            context.read<AccountsRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => PreferencesBloc(
            context.read<PreferencesRepository>(),
          ),
        ),
        BlocProvider(create: (_) => AuthBloc()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Profile',
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColors.textPrimaryLight,
                            fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                            fontSize: 22,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _ProfileHeader(
                                  name: 'Daniel Baker',
                                  email: 'daniel.baker@gmail.com',
                                  onEditProfile: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/edit_profile',
                                    );
                                  },
                                ),
                                const SizedBox(height: 32),
                                _AccountsCard(),
                                const SizedBox(height: 32),
                                _PreferencesCard(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Profile Header ---
class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onEditProfile;
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primary200,
          child: Icon(Icons.person, size: 48, color: AppColors.primary700),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          email,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.neutral700,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 9,
                spreadRadius: 1,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neutral900,
              foregroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: AppColors.neutral800),
              ),
              elevation: 0,
            ),
            onPressed: onEditProfile,
            child: Text(
              'Edit profile',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 14,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Accounts Card ---
class _AccountsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.neutral900 : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accounts',
          style: AppTextStyles.bodyMedium.copyWith(
            color: textSecondary,
            fontWeight: FontWeight.w500,

            fontSize: 14,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Column(
            children: [
              BlocBuilder<AccountsBloc, AccountsState>(
                builder: (context, state) {
                  return _SettingsListTile(
                    leading: Icon(HugeIconsStroke.savings, color: textPrimary),
                    title: 'Savings',
                    titleStyle: AppTextStyles.bodyMedium.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      letterSpacing: -0.2,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state.savingsCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.successDark,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              state.savingsCount.toString(),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                letterSpacing: -0.15,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Icon(
                          HugeIconsStroke.arrowRight01,
                          size: 16,
                          color: textSecondary,
                        ),
                      ],
                    ),
                    onTap: () => Navigator.pushNamed(context, '/savings'),
                  );
                },
              ),
              const SizedBox(height: 8),
              _SettingsDivider(),
              const SizedBox(height: 8),
              _SettingsListTile(
                leading: Icon(HugeIconsStroke.creditCard, color: textPrimary),
                title: 'Paybacks',
                titleStyle: AppTextStyles.bodyMedium.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: -0.15,
                ),
                trailing: Icon(
                  HugeIconsStroke.arrowRight01,
                  size: 16,
                  color: textSecondary,
                ),
                onTap: () => Navigator.pushNamed(context, '/paybacks'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- Preferences Card ---
class _PreferencesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.neutral900 : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferences',
          style: AppTextStyles.bodyMedium.copyWith(
            color: textSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: BlocBuilder<PreferencesBloc, PreferencesState>(
            builder: (context, state) {
              return Column(
                children: [
                  _SettingsListTile(
                    leading: Icon(
                      HugeIconsStroke.notification01,
                      color: textPrimary,
                    ),
                    title: 'Push notifications',
                    titleStyle: AppTextStyles.bodyMedium.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      letterSpacing: -0.15,
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: state.pushNotificationsEnabled,
                        onChanged:
                            (v) => context.read<PreferencesBloc>().add(
                              PushNotificationsToggled(v),
                            ),
                        activeColor: Colors.white,
                        inactiveThumbColor: AppColors.neutral400,
                        inactiveTrackColor: AppColors.neutral400,
                        activeTrackColor: AppColors.successDark,
                        trackOutlineWidth: WidgetStateProperty.all(0.0),
                        trackOutlineColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        thumbColor: WidgetStateProperty.all(Colors.white),
                        splashRadius: 12,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    onTap:
                        () => context.read<PreferencesBloc>().add(
                          PushNotificationsToggled(
                            !state.pushNotificationsEnabled,
                          ),
                        ),
                  ),
                  _SettingsDivider(),
                  _SettingsListTile(
                    leading: Icon(HugeIconsStroke.faceId, color: textPrimary),
                    title: 'Face ID',
                    titleStyle: AppTextStyles.bodyMedium.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      letterSpacing: -0.2,
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: state.faceIdEnabled,
                        onChanged:
                            (v) => context.read<PreferencesBloc>().add(
                              FaceIdToggled(v),
                            ),

                        activeColor: Colors.white,
                        inactiveThumbColor: AppColors.neutral300,
                        inactiveTrackColor: AppColors.neutral300,
                        activeTrackColor: AppColors.successDark,
                        trackOutlineColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        trackOutlineWidth: WidgetStateProperty.all(0.0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        thumbColor: WidgetStateProperty.all(Colors.white),
                        splashRadius: 12,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    onTap:
                        () => context.read<PreferencesBloc>().add(
                          FaceIdToggled(!state.faceIdEnabled),
                        ),
                  ),
                  _SettingsDivider(),
                  _SettingsListTile(
                    leading: Icon(HugeIconsStroke.pinCode, color: textPrimary),
                    title: 'PIN Code',
                    titleStyle: AppTextStyles.bodyMedium.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      letterSpacing: -0.2,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: textSecondary,
                    ),
                    onTap: () async {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder:
                            (context) => Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: const PinCodeModal(),
                            ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _SettingsDivider(),
                  const SizedBox(height: 8),
                  _SettingsListTile(
                    leading: const Icon(
                      HugeIconsStroke.logout03,
                      color: AppColors.error,
                    ),
                    title: 'Logout',
                    titleStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      letterSpacing: -0.2,
                    ),
                    trailing: const Icon(
                      HugeIconsStroke.arrowRight01,
                      color: AppColors.error,
                    ),
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              actionsAlignment: MainAxisAlignment.end,
                              alignment: Alignment.center,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.white,
                              title: Text(
                                'Confirm Logout',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              content: Text(
                                'Are you sure you want to log out? You will be logged out of your account and will need to log in again to continue.',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 14,
                                  color: AppColors.neutral800,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: Text(
                                    'Cancel',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.neutral800,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: Text(
                                    'Logout',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      );
                      if (confirmed == true) {
                        context.read<AuthBloc>().add(LogoutRequested());
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// --- Settings ListTile Helper ---
class _SettingsListTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final TextStyle titleStyle;
  final Widget trailing;
  final VoidCallback? onTap;
  const _SettingsListTile({
    required this.leading,
    required this.title,
    required this.titleStyle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.zero,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          constraints: const BoxConstraints(minHeight: 44),

          child: Row(
            children: [
              leading,
              const SizedBox(width: 16),
              Expanded(child: Text(title, style: titleStyle)),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

// --- Divider Helper ---
class _SettingsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Divider(color: dividerColor, height: 1, thickness: 1.5),
    );
  }
}

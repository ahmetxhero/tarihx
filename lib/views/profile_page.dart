import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/constants/legal_texts.dart';
import '../presenters/profile_presenter.dart';
import '../services/auth_service.dart';
import 'legal_detail_page.dart';
import 'widgets/auth_icons.dart';
import 'widgets/language_dropdown.dart';
import 'widgets/theme_mode_selector.dart';

class ProfilePage extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final bool localNotificationsEnabled;
  final ValueChanged<bool> onLocalNotificationsChanged;
  final TimeOfDay notificationTime;
  final ValueChanged<TimeOfDay> onNotificationTimeChanged;

  const ProfilePage({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.localNotificationsEnabled,
    required this.onLocalNotificationsChanged,
    required this.notificationTime,
    required this.onNotificationTimeChanged,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> implements ProfileView {
  late ProfilePresenter _presenter;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _presenter = ProfilePresenter(this);
  }

  @override
  void onSettingsLoaded({
    required ThemeMode themeMode,
    required bool notificationsEnabled,
    required bool localNotificationsEnabled,
    required TimeOfDay notificationTime,
  }) {}

  @override
  void onNotificationStatusChanged(bool enabled) {}

  @override
  void onLocalNotificationStatusChanged(bool enabled) {}

  @override
  void onNotificationTimeChanged(TimeOfDay time) {}

  @override
  void onThemeModeChanged(ThemeMode mode) {}

  @override
  void onAuthSuccess(User user) {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hoş geldiniz, ${user.displayName ?? user.email ?? ''}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void onAuthError(String message) {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  void onSignOut() {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 130),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF14161F) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? const Color(0xFF222533) : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withValues(alpha: 0.3) : const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF222533) : const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.person_rounded, color: isDark ? const Color(0xFFF8FAFC) : Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tr('settings_page'),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(height: 1, color: isDark ? const Color(0xFF222533) : const Color(0xFFE2E8F0)),
                const SizedBox(height: 20),

                // Account Section
                Text(
                  tr('account'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 10),
                StreamBuilder<User?>(
                  stream: AuthService.userChanges,
                  builder: (context, snapshot) {
                    final user = snapshot.data;
                    if (user != null) {
                      // Synchronize user profile on state load/change
                      _presenter.syncUserProfile(user, context.locale);
                      return _buildUserCard(user, isDark);
                    } else {
                      return _buildAuthButtons(isDark);
                    }
                  },
                ),

                const SizedBox(height: 24),
                Divider(height: 1, color: isDark ? const Color(0xFF222533) : const Color(0xFFE2E8F0)),
                const SizedBox(height: 20),

                // Theme Section
                Text(
                  tr('theme'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 10),
                ThemeModeSelector(
                  themeMode: widget.themeMode,
                  onChanged: widget.onThemeModeChanged,
                ),
                const SizedBox(height: 24),

                // Notifications Section
                Text(
                  tr('notifications'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 10),
                // FCM Push Notifications Toggle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B1E2B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isDark ? const Color(0xFF2A2E40) : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.notificationsEnabled ? tr('notifications_on') : tr('notifications_off'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                            color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Switch(
                        value: widget.notificationsEnabled,
                        onChanged: widget.onNotificationsChanged,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Local Daily Notifications Toggle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B1E2B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isDark ? const Color(0xFF2A2E40) : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.localNotificationsEnabled ? tr('daily_notifications_on') : tr('daily_notifications_off'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                            color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Switch(
                        value: widget.localNotificationsEnabled,
                        onChanged: widget.onLocalNotificationsChanged,
                      ),
                    ],
                  ),
                ),
                if (widget.localNotificationsEnabled) ...[
                  const SizedBox(height: 10),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: widget.notificationTime,
                          builder: (context, child) {
                            return Theme(
                              data: isDark
                                  ? ThemeData.dark().copyWith(
                                      colorScheme: const ColorScheme.dark(
                                        primary: Color(0xFFF8FAFC),
                                        onPrimary: Color(0xFF090A0E),
                                        surface: Color(0xFF14161F),
                                        onSurface: Color(0xFFF8FAFC),
                                      ),
                                    )
                                  : ThemeData.light().copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Color(0xFF0F172A),
                                        onPrimary: Colors.white,
                                        surface: Colors.white,
                                        onSurface: Color(0xFF0F172A),
                                      ),
                                    ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          widget.onNotificationTimeChanged(picked);
                        }
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1B1E2B) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isDark ? const Color(0xFF2A2E40) : const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tr('notification_time'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.5,
                                  color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF222533) : const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${widget.notificationTime.hour.toString().padLeft(2, '0')}:${widget.notificationTime.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Language Section
                Text(
                  tr('language'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 10),
                const LanguageDropdown(),

                const SizedBox(height: 24),
                Divider(height: 1, color: isDark ? const Color(0xFF222533) : const Color(0xFFE2E8F0)),
                const SizedBox(height: 20),

                // Legal & Information Section
                Text(
                  tr('legal_info'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  color: isDark ? const Color(0xFF1B1E2B) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? const Color(0xFF2A2E40) : const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.shield_outlined, color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
                        title: Text(
                          tr('privacy_policy'),
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                        onTap: () {
                          final lang = context.locale.languageCode;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LegalDetailPage(
                                title: tr('privacy_policy'),
                                content: LegalTexts.getPrivacyPolicy(lang),
                              ),
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, indent: 16, endIndent: 16, color: isDark ? const Color(0xFF2A2E40) : const Color(0xFFE2E8F0)),
                      ListTile(
                        leading: Icon(Icons.description_outlined, color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
                        title: Text(
                          tr('terms_of_use'),
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                        onTap: () {
                          final lang = context.locale.languageCode;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LegalDetailPage(
                                title: tr('terms_of_use'),
                                content: LegalTexts.getTermsOfUse(lang),
                              ),
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, indent: 16, endIndent: 16, color: isDark ? const Color(0xFF2A2E40) : const Color(0xFFE2E8F0)),
                      ListTile(
                        leading: Icon(Icons.info_outline_rounded, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                        title: Text(
                          tr('about_app'),
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                          ),
                        ),
                        trailing: Text(
                          tr('app_version'),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
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
      ),
    ),
    );
  }

  Widget _buildUserCard(User user, bool isDark) {
    final photoUrl = user.photoURL;
    final displayName = user.displayName?.isNotEmpty == true ? user.displayName! : (user.email?.split('@').first ?? 'Kullanıcı');
    final email = user.email ?? '';
    final langCode = context.locale.languageCode.toUpperCase();
    final platformName = Platform.isIOS ? 'iOS' : 'Android';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B1E2B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? const Color(0xFF2A2E40) : const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: isDark ? const Color(0xFF2A2E40) : const Color(0xFFCBD5E1),
                  backgroundImage: photoUrl != null && photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null || photoUrl.isEmpty
                      ? Icon(Icons.person_rounded, color: isDark ? Colors.white : const Color(0xFF0F172A), size: 28)
                      : null,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: -0.3,
                        color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (email.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _presenter.signOut(),
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22),
                tooltip: tr('sign_out'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: isDark ? const Color(0xFF2A2E40) : const Color(0xFFE2E8F0)),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF222533) : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? const Color(0xFF33374A) : const Color(0xFFDBEAFE)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.language_rounded,
                      size: 14,
                      color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      langCode,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF222533) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? const Color(0xFF33374A) : const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Platform.isIOS ? Icons.apple : Icons.android,
                      size: 14,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      platformName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuthButtons(bool isDark) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      children: [
        // Google Sign In Button
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            _presenter.signInWithGoogle(context.locale);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? const Color(0xFF1B1E2B) : Colors.white,
            foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
            elevation: 0,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: isDark ? const Color(0xFF2A2E40) : const Color(0xFFCBD5E1),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const GoogleLogoIcon(size: 20),
              const SizedBox(width: 10),
              Text(
                tr('sign_in_with_google'),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
              ),
            ],
          ),
        ),
        // Apple Sign In Button (iOS Only)
        if (Platform.isIOS) ...[
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _presenter.signInWithApple(context.locale);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.white : Colors.black,
              foregroundColor: isDark ? Colors.black : Colors.white,
              elevation: 0,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppleLogoIcon(
                  size: 20,
                  color: isDark ? Colors.black : Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  tr('sign_in_with_apple'),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'today_page.dart';
import 'tomorrow_page.dart';

class MainScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final bool localNotificationsEnabled;
  final ValueChanged<bool> onLocalNotificationsChanged;
  final TimeOfDay notificationTime;
  final ValueChanged<TimeOfDay> onNotificationTimeChanged;
  final int selectedTab;
  final ValueChanged<int> onTabSelected;

  const MainScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.localNotificationsEnabled,
    required this.onLocalNotificationsChanged,
    required this.notificationTime,
    required this.onNotificationTimeChanged,
    this.selectedTab = 0,
    required this.onTabSelected,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Widget> pages = [
      const TodayPage(),
      const TomorrowPage(),
      ProfilePage(
        themeMode: widget.themeMode,
        onThemeModeChanged: widget.onThemeModeChanged,
        notificationsEnabled: widget.notificationsEnabled,
        onNotificationsChanged: widget.onNotificationsChanged,
        localNotificationsEnabled: widget.localNotificationsEnabled,
        onLocalNotificationsChanged: widget.onLocalNotificationsChanged,
        notificationTime: widget.notificationTime,
        onNotificationTimeChanged: widget.onNotificationTimeChanged,
      ),
    ];
    return Scaffold(
      extendBody: true,
      body: pages[widget.selectedTab],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12, top: 4),
          child: Container(
            height: 66,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black.withValues(alpha: 0.5) : const Color(0xFF0F172A).withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF12141F).withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.6),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        index: 0,
                        label: tr('today'),
                        activeIcon: Icons.auto_stories_rounded,
                        inactiveIcon: Icons.auto_stories_outlined,
                        isDark: isDark,
                      ),
                      _buildNavItem(
                        index: 1,
                        label: tr('tomorrow'),
                        activeIcon: Icons.event_available_rounded,
                        inactiveIcon: Icons.event_available_outlined,
                        isDark: isDark,
                      ),
                      _buildNavItem(
                        index: 2,
                        label: tr('settings'),
                        activeIcon: Icons.person_rounded,
                        inactiveIcon: Icons.person_outline_rounded,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required bool isDark,
  }) {
    final isSelected = widget.selectedTab == index;
    return InkWell(
      onTap: () => widget.onTabSelected(index),
      borderRadius: BorderRadius.circular(24),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              size: 22,
              color: isSelected
                  ? (isDark ? const Color(0xFF090A0E) : Colors.white)
                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF090A0E) : Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

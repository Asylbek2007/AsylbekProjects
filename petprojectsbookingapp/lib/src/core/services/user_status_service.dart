import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

enum UserStatus { student, teacher, tutor }

class UserStatusService {
  static const String _userStatusKey = 'user_status';
  static UserStatusService? _instance;
  static UserStatusService get instance => _instance ??= UserStatusService._();

  UserStatusService._();

  Future<UserStatus> getUserStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statusString = prefs.getString(_userStatusKey);
      if (statusString != null) {
        return UserStatus.values.firstWhere(
          (status) => status.toString() == statusString,
          orElse: () => UserStatus.student,
        );
      }
    } catch (e) {
      // Error loading user status
    }
    return UserStatus.student; // Default to student
  }

  Future<void> setUserStatus(UserStatus status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userStatusKey, status.toString());
    } catch (e) {
      // Error saving user status
    }
  }

  String getStatusDisplayName(UserStatus status) {
    switch (status) {
      case UserStatus.student:
        return 'Student';
      case UserStatus.teacher:
        return 'Teacher';
      case UserStatus.tutor:
        return 'Tutor';
    }
  }

  String getStatusEmoji(UserStatus status) {
    switch (status) {
      case UserStatus.student:
        return '🎓';
      case UserStatus.teacher:
        return '👨‍🏫';
      case UserStatus.tutor:
        return '📚';
    }
  }

  Color getStatusColor(UserStatus status) {
    switch (status) {
      case UserStatus.student:
        return Color(0xFF4CAF50); // Green
      case UserStatus.teacher:
        return Color(0xFF2196F3); // Blue
      case UserStatus.tutor:
        return Color(0xFFFF9800); // Orange
    }
  }
}

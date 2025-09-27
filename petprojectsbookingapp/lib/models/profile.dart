import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petprojectsbookingapp/src/core/router/app_router.dart';
import 'package:petprojectsbookingapp/src/core/services/user_status_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserStatusService _userStatusService = UserStatusService.instance;
  UserStatus _currentStatus = UserStatus.student;

  @override
  void initState() {
    super.initState();
    _loadUserStatus();
  }

  Future<void> _loadUserStatus() async {
    final status = await _userStatusService.getUserStatus();
    if (mounted) {
      setState(() {
        _currentStatus = status;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showStatusSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Select Your Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                UserStatus.values.map((status) {
                  return ListTile(
                    leading: Text(
                      _userStatusService.getStatusEmoji(status),
                      style: TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      _userStatusService.getStatusDisplayName(status),
                    ),
                    selected: _currentStatus == status,
                    onTap: () async {
                      await _userStatusService.setUserStatus(status);
                      if (mounted) {
                        setState(() {
                          _currentStatus = status;
                        });
                        Navigator.of(dialogContext).pop();
                      }
                    },
                  );
                }).toList(),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final userName =
        user?.displayName?.split(' ').first ??
        user?.email?.split('@').first ??
        'User';
    final userEmail = user?.email ?? 'No email';

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF2A2A3E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 40),
            CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFF4A6CF7),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            SizedBox(height: 30),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2A2A3E),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      userEmail,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 20),
                    // User Status Section
                    InkWell(
                      onTap: _showStatusSelectionDialog,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _userStatusService
                              .getStatusColor(_currentStatus)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _userStatusService.getStatusColor(
                              _currentStatus,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _userStatusService.getStatusEmoji(_currentStatus),
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Status: ${_userStatusService.getStatusDisplayName(_currentStatus)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: _userStatusService.getStatusColor(
                                        _currentStatus,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Tap to change',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.edit,
                              color: _userStatusService.getStatusColor(
                                _currentStatus,
                              ),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 10),
                    _buildProfileOption(
                      'Change Status',
                      Icons.person_outline,
                      _showStatusSelectionDialog,
                    ),
                    _buildProfileOption('Edit Profile', Icons.edit, () {}),
                    _buildProfileOption('Settings', Icons.settings, () {}),
                    _buildProfileOption('Help & Support', Icons.help, () {}),
                    _buildProfileOption(
                      'Logout',
                      Icons.logout,
                      _showLogoutDialog,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: Color(0xFF4A6CF7), size: 24),
              SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: Color(0xFF2A2A3E)),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

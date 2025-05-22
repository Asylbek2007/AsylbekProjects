import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF2A2A3E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
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
                      'Асылбек',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2A2A3E),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'asylbek@example.com',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 10),
                    _buildProfileOption('Edit Profile', Icons.edit),
                    _buildProfileOption('Settings', Icons.settings),
                    _buildProfileOption('Help & Support', Icons.help),
                    _buildProfileOption('Logout', Icons.logout),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF4A6CF7), size: 24),
          SizedBox(width: 15),
          Text(title, style: TextStyle(fontSize: 16, color: Color(0xFF2A2A3E))),
          Spacer(),
          Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}
